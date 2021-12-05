def file(path) = File.read(File.join(__dir__, path))

def parse(data)
  data.split("\n").map do |row|
    row.split(" -> ").map do |tuple|
      tuple.split(",").map(&:to_i)
    end
  end.map(&Vent.method(:new))
end

class Vent
  def initialize(coords)
    @xs, @ys = coords.sort_by(&:first).transpose
  end

  def max_x = @max_x ||= @xs[1]
  def max_y = @max_y ||= @ys.max
  def x_vals = @x_vals ||= @xs[0].step(@xs[1], 1).to_a
  def y_vals = @y_vals ||= @ys[0].step(@ys[1], @ys[0] < @ys[1] ? 1 : -1).to_a

  def vals
    return [] unless @xs.inject(:==) || @ys.inject(:==)

    vals2
  end

  def vals2
    if x_vals.size == 1
      y_vals.map { |y| [x_vals[0], y] }
    elsif y_vals.size == 1
      x_vals.map { |x| [x, y_vals[0]] }
    else
      x_vals.zip(y_vals)
    end
  end
end

def part1(data)
  width = data.map(&:max_x).max + 1
  height = data.map(&:max_y).max + 1

  map = Array.new(height) { Array.new(width) { 0 } }
  data.map(&:vals).compact.flatten(1).each { |x, y| map[y][x] += 1 }
  map.flatten.count { |n| n > 1 }
end

def part2(data)
  width = data.map(&:max_x).max + 1
  height = data.map(&:max_y).max + 1

  map = Array.new(height) { Array.new(width) { 0 } }
  data.map(&:vals2).compact.flatten(1).each { |x, y| map[y][x] += 1 }
  map.flatten.count { |n| n > 1 }
end

EXAMPLE = parse file "example"
INPUT = parse file "input"

puts <<~PART1
##########
# Part 1 #
##########
Example: #{part1 EXAMPLE}
Solution: #{part1 INPUT}

PART1

puts <<~PART2
##########
# Part 2 #
##########
Example: #{part2 EXAMPLE}
Solution: #{part2 INPUT}

PART2
