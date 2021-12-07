def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split(",").map(&:to_i)
end

def part1(data)
  (data.min..data.max).map { |i| data.map { |d| (d - i).abs }.sum }.min
end

def part2(data)
  (data.min..data.max).map do |i|
    data.map do |d|
      n = (d - i).abs
      n * (n + 1) / 2
    end.sum
  end.min
end

puts <<~END
##########
# Part 1 #
##########
Example: #{part1 parse file "example"}
Solution: #{part1 parse file "input"}

##########
# Part 2 #
##########
Example: #{part2 parse file "example"}
Solution: #{part2 parse file "input"}

END
