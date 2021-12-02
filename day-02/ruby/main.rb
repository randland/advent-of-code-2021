def file(path)
  File.read(File.join(File.dirname(__FILE__), path))
end

def parse(data)
  data.split("\n").map { |com| com.split(" ") }
end

EXAMPLE = parse file "example"
INPUT1 = parse file "input1"
INPUT2 = parse file "input2"

def part1(data)
  x = 0
  y = 0

  data.each do |com, dist|
    idist = dist.to_i
    case com
    when "forward"
      x += idist
    when "up"
      y -= idist
    else
      y += idist
    end
  end

  x * y
end

def part2(data)
  x = 0
  y = 0
  a = 0

  data.each do |com, dist|
    idist = dist.to_i
    case com
    when "forward"
      x += idist
      y += a * idist
    when "up"
      a -= idist
    else
      a += idist
    end
  end

  x * y
end

puts "*" * 80
puts "Example 1: #{part1 EXAMPLE}"
puts "Part 1: #{part1 INPUT1}"
puts "*" * 80
puts "Example 2: #{part2 EXAMPLE}"
puts "Part 2: #{part2 INPUT2}"
