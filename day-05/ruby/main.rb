def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map do |row|
    row.split(" -> ").map do |tuple|
      tuple.split(",").map(&:to_i)
    end
  end.map(&Vent.method(:new))
end

class Vent
  attr_reader :x1, :x2, :y1, :y2

  def initialize(coords)
    (@x1, @y1), (@x2, @y2) = coords.sort_by(&:first)
  end

  def x_vals
    (x1..x2).to_a
  end

  def y_vals
    y1.step(y2, y1 < y2 ? 1 : -1).to_a
  end

  def vals
    return [] unless x1 == x2 || y1 == y2

    vals2
  end

  def vals2
    if x1 == x2
      y_vals.map { |y| [x1, y] }
    elsif y1 == y2
      x_vals.map { |x| [x, y1] }
    else
      x_vals.zip(y_vals)
    end
  end
end

def count_spikes(vent_coords, min_height = 2)
  Hash.new(0).tap do |height_map|
    vent_coords.each { |coord| height_map[coord] += 1 }
  end.values.count { |height| height >= min_height }
end

def part1(data)
  count_spikes(data.map(&:vals).compact.flatten(1))
end

def part2(data)
  count_spikes(data.map(&:vals2).compact.flatten(1))
end

puts <<~PART1
##########
# Part 1 #
##########
Example: #{part1 parse file "example"}
Solution: #{part1 parse file "input"}

PART1

puts <<~PART2
##########
# Part 2 #
##########
Example: #{part2 parse file "example"}
Solution: #{part2 parse file "input"}

PART2
