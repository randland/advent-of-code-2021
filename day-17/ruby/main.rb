require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.scan(/[0-9-]+/).map(&:to_i).yield_self do |x_min, x_max, y_min, y_max|
    { x: (x_min..x_max), y: (y_min..y_max) }
  end
end

def y_needed(target_y)
  target_y.positive? ? target_y : -target_y - 1
end

def hits_target?(xd, yd, data)
  x = y = 0

  until x > data[:x].max || y < data[:y].min
    x += xd
    y += yd
    return true if data[:x].include?(x) && data[:y].include?(y)

    xd -= 1 if xd > 0
    yd -= 1
  end

  false
end

def part1(data)
  (1..y_needed(data[:y].min)).inject(:+)
end

def part2(data)
  max_y = [y_needed(data[:y].min), y_needed(data[:y].max)].max
  min_y = data[:y].min
  max_x = data[:x].max
  min_x = 0

  (min_x..max_x).map do |x|
    (min_y..max_y).map do |y|
      hits_target?(x, y, data) ? [x, y] : nil
    end.compact
  end.flatten(1).count
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
