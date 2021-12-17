require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.scan(/[0-9-]+/).map(&:to_i).then do |x_min, x_max, y_min, y_max|
    { x: (x_min..x_max), y: (y_min..y_max) }
  end
end

class TargetArea
  attr_reader :x_range, :y_range

  def initialize(data)
    @x_range, @y_range = data
  end

  def hit?(x, y)
    x_range.include?(x) &&
      y_range.include?(y)
  end

  def below_level?
    y_range.min <= 0
  end
end

class Probe
  attr_reader :x, :x_delta, :y, :y_delta

  def initialize(x_delta, y_delta)
    @x_delta = x_delta
    @y_delta = y_delta
    @x = 0
    @y = 0
  end

  def step
    @x += x_delta
    @y += y_delta
    @x_delta -= 1 if @x_delta > 0
    @y_delta -= 1
  end

  def coords
    [x, y]
  end
end

class Targeter
  def initialize(data)
    @target_area = TargetArea.new(data.values)
  end

  def solutions
    (min_x..max_x).map do |x|
      (min_y..max_y).select do |y|
        trajectory_hits?(x, y)
      end
    end.flatten(1)
  end

  def max_y
    return target_area.y_range.max unless target_area.below_level?

    -target_area.y_range.min - 1
  end

  private

  attr_reader :target_area

  def min_x
    0
  end

  def max_x
    target_area.x_range.max
  end

  def min_y
    target_area.y_range.min
  end

  def trajectory_hits?(x, y)
    probe = Probe.new(x, y)
    until past_target?(probe)
      probe.step
      return true if target_area.hit?(*probe.coords)
    end
    false
  end

  def past_target?(probe)
    x_past_target?(probe) || y_past_target?(probe)
  end

  def x_past_target?(probe)
    probe.x > target_area.x_range.max
  end

  def y_past_target?(probe)
    probe.y < target_area.y_range.min &&
      (target_area.below_level? || probe.y_delta.negative?)
  end
end

def part1(data)
  Targeter.new(data).max_y.then { |y| y * (y + 1) / 2 }
end

def part2(data)
  Targeter.new(data).solutions.count
end

puts <<~END

##########
# Part 1 #
##########
END
puts "Example: #{part1 parse file "example"}"
puts "Solution: #{part1 parse file "input"}"

puts <<~END

##########
# Part 2 #
##########
END
puts "Example: #{part2 parse file "example"}"
puts "Solution: #{part2 parse file "input"}"

def hit?(xd, yd, data)
  x = y = 0

  until x > data[:x].max || y < data[:y].min
    x += xd
    y += yd
    return true if data[:x].cover?(x) && data[:y].cover?(y)
    xd -= 1 if xd > 0
    yd -= 1
  end

  false
end

def golf1(data)
  (-data[:y].min - 1).then { |y| y * (y + 1) / 2 }
end

def golf2(data)
  (0..data[:x].max).map { |x| (data[:y].min..-data[:y].min - 1).select { |y| [x, y] if hit?(x, y, data) } }.flatten(1).count
end

puts <<~END

##########
# Golf 1 #
##########
END
puts "Example: #{golf1 parse file "example"}"
puts "Solution: #{golf1 parse file "input"}"

puts <<~END

##########
# Golf 2 #
##########
END
puts "Example: #{golf2 parse file "example"}"
puts "Solution: #{golf2 parse file "input"}"
