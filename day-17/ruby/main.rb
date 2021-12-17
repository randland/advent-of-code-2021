require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

NUM_EX = /([0-9-]*)/
REGEX = /.*x=#{NUM_EX}..#{NUM_EX}, y=#{NUM_EX}..#{NUM_EX}/
def parse(data)
  data.match(REGEX).to_a.map(&:to_i).
    yield_self do |_matches, x_min, x_max, y_min, y_max|
      [(x_min..x_max), (y_min..y_max)]
    end
end

def y_needed(target_y)
  target_y.positive? ? target_y : -target_y - 1
  -target_y - 1
end

def hits_target?(xd, yd, data)
  x = 0
  y = 0

  until x > data[0].max || y < data[1].min
    x += xd
    y += yd
    return true if data[0].include?(x) && data[1].include?(y)

    xd -= 1 if xd > 0
    yd -= 1
  end

  false
end

def part1(data)
  (1..y_needed(data[1].min)).inject(:+)
end

def part2(data)
  max_y = [y_needed(data[1].min), y_needed(data[1].max)].max
  min_y = data[1].min
  max_x = data[0].max
  min_x = 1

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
