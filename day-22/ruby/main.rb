require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map do |line|
    line.split(" ").then do |op, ranges|
      x0, x1, y0, y1, z0, z1 = ranges.scan(/(-?\d+)/).flatten.map(&:to_i)
      [
        op == "on",
        CubeRange.new(x0, x1 + 1),
        CubeRange.new(y0, y1 + 1),
        CubeRange.new(z0, z1 + 1)
      ]
    end
  end
end

def part1(data)
  result = Set.new
  mask = CubeRange.new(-50, 51)
  data.each do |on, xr, yr, zr|
    next unless mask.cover?(xr)
    coords = xr.to_a.product(yr.to_a).product(zr.to_a).map(&:flatten)
    if on
      result += coords
    else
      result -= coords
    end
  end
  result.count
end

class CubeRange
  attr_reader :min, :max

  def initialize(min, max)
    @min = min
    @max = max
  end

  def to_a
    (min...max).to_a
  end

  def size
    max - min
  end

  def edges
    [min, max]
  end

  def cover?(other)
    other.max > min && other.min < max
  end

  def overlaps_fully?(other)
    min >= other.min && max <= other.max
  end

  def split!(other)
    (edges + seams_from(other)).sort.each_cons(2).map do |min, max|
      self.class.new(min, max)
    end
  end

  def seams_from(other)
    other.edges.select { |edge| min < edge && edge < max }
  end

  def <=>(other)
    edges <=> other.edges
  end

  def to_s
    "(#{min}..#{max - 1})"
  end
end

class Cube
  attr_reader :xr, :yr, :zr

  def initialize(xr, yr, zr)
    @xr = xr
    @yr = yr
    @zr = zr
  end

  def size
    xr.size * yr.size * zr.size
  end

  def ranges
    [xr, yr, zr]
  end

  def <=>(other)
    ranges <=> other.ranges
  end

  def overlaps_fully?(other)
    xr.overlaps_fully?(other.xr) &&
      yr.overlaps_fully?(other.yr) &&
      zr.overlaps_fully?(other.zr)
  end

  def split!(other)
    return [self] unless split_by?(other)

    (xr.split!(other.xr)).map do |new_xr|
      (yr.split!(other.yr)).map do |new_yr|
        (zr.split!(other.zr)).map do |new_zr|
          next if (new_cube = self.class.new(new_xr, new_yr, new_zr)).overlaps_fully?(other)
          new_cube
        end.compact
      end
    end.flatten
  end

  def split_by?(other)
    ranges.zip(other.ranges).all? do |range, other_range|
      other_range.cover?(range)
    end
  end
end

def part2(data)
  cubes = []
  data.each do |on, xr, yr, zr|
    new_cube = Cube.new(xr, yr, zr)
    new_cubes = []
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
# puts "Example: #{part1 parse file "example"}"
# puts "Solution: #{part1 parse file "input"}"

puts <<~END

##########
# Part 2 #
##########
END
puts "Example: #{part2 parse file "example"}"
puts "Solution: #{part2 parse file "input"}"
