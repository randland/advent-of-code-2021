def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\s").map &:to_i
end

EXAMPLE = parse file "example"
INPUT = parse file "input"

def count_inc(data, res)
  (res...data.size).count { |i| data[i] > data[i - res] }
end

def part1(data)
  count_inc(data, 1)
end

def part2(data)
  count_inc(data, 3)
end

puts "*" * 80
puts "Example 1: #{part1 EXAMPLE}"
puts "Part 1: #{part1 INPUT}"
puts "*" * 80
puts "Example 2: #{part2 EXAMPLE}"
puts "Part 2: #{part2 INPUT}"
