require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map do |line|
    line.split(" ").then do |op, ranges|
      x0, x1, y0, y1, z0, z1 = ranges.scan(/(-?\d+)/).flatten.map(&:to_i)
      [op == "on", [x0, x1], [y0, y1], [z0, z1]]
    end
  end
end

class CubeRange
  attr_reader :min, :max
  def initialize(min, max)
    @min = min
    @max = max
  end

  def edges
    [min, max]
  end

  def size
    max - min
  end

  def trim!(abs_min, abs_max)
    @min = [min, abs_min].max
    @max = [max, abs_max + 1].min
    size.positive?
  end

  def overlaps?(other)
    other.min < max && min < other.max
  end

  def overlaps_fully?(other)
    min <= other.min && other.max <= max
  end

  def split!(other)
    return [self] unless overlaps?(other)

    (edges + seams_from(other)).sort.each_cons(2).map do |min, max|
      self.class.new(min, max)
    end
  end

  private

  def seams_from(other)
    other.edges.select { |edge| (min+1..max-1).cover?(edge) }
  end
end

class Cube
  attr_reader :xr, :yr, :zr
  def initialize(xr, yr, zr)
    @xr = xr
    @yr = yr
    @zr = zr
  end

  def self.from_data(xin, yin, zin)
    Cube.new(CubeRange.new(xin[0], xin[1] + 1),
             CubeRange.new(yin[0], yin[1] + 1),
             CubeRange.new(zin[0], zin[1] + 1))
  end

  def ranges
    [xr, yr, zr]
  end

  def size
    ranges.map(&:size).inject(:*)
  end

  def split!(other)
    return [self] unless overlaps?(other)

    range_pairs(other)
      .map { |range, other_range| range.split!(other_range) }
      .inject(:product).map(&:flatten)
      .map { |ranges| self.class.new(*ranges) }
      .reject { |range| other.overlaps_fully?(range) }
  end

  def trim!(abs_min, abs_max)
    ranges.all? { |range| range.trim!(abs_min, abs_max) }
  end

  def overlaps?(other)
    range_pairs(other)
      .all? { |range, other_range| range.overlaps?(other_range) }
  end

  def overlaps_fully?(other)
    range_pairs(other)
      .all? { |range, other_range| range.overlaps_fully?(other_range) }
  end

  private

  def range_pairs(other)
    ranges.zip(other.ranges)
  end
end

def part1(data)
  cubes = []
  data.each do |on, xs, ys, zs|
    new_cubes = []
    new_cube = Cube.from_data(xs, ys, zs)
    next unless new_cube.trim!(-50, 50)

    cubes.each do |cube|
      new_cubes += cube.split!(new_cube)
    end

    new_cubes << new_cube if on
    cubes = new_cubes
  end
  cubes.map(&:size).sum
end

def part2(data)
  cubes = []
  data.each do |on, xs, ys, zs|
    new_cubes = []
    new_cube = Cube.from_data(xs, ys, zs)

    cubes.each do |cube|
      new_cubes += cube.split!(new_cube)
    end

    new_cubes << new_cube if on
    cubes = new_cubes
  end
  cubes.map(&:size).sum
end

puts <<~END

##########
# Part 1 #
##########
END
puts "Example: #{part1 parse file "example1"}"
puts "Solution: #{part1 parse file "input"}"

puts <<~END

##########
# Part 2 #
##########
END
puts "Example: #{part2 parse file "example2"}"
puts "Solution: #{part2 parse file "input"}"
