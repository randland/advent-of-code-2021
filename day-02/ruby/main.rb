def file(path)
  File.read(File.join(File.dirname(__FILE__), path))
end

def parse(data)
  data.split("\n").map do |com|
    com.split(" ").yield_self { |op, dist| [op, dist.to_i] }
  end
end

EXAMPLE = parse file "example"
INPUT1 = parse file "input1"
INPUT2 = parse file "input2"

def part1(data)
  horiz = 0
  depth = 0

  data.each do |op, dist|
    case dist
    when "down"
      depth += dist
    when "up"
      depth -= dist
    else
      horiz += dist
    end
  end

  horiz * depth
end

def part2(data)
  horiz = 0
  depth = 0
  aim = 0

  data.each do |op, dist|
    case op
    when "down"
      aim += dist
    when "up"
      aim -= dist
    else
      horiz += dist
      depth += aim * dist
    end
  end

  horiz * depth
end

puts "*" * 80
puts "Example 1: #{part1 EXAMPLE}"
puts "Part 1: #{part1 INPUT1}"
puts "*" * 80
puts "Example 2: #{part2 EXAMPLE}"
puts "Part 2: #{part2 INPUT2}"
