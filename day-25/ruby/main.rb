require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n\n")
end

def part1(data)
  data
end

def part2(data)
end

puts <<~END

##########
# Part 1 #
##########
END
puts "Example: #{part1 parse file "example"}"
# puts "Solution: #{part1 parse file "input"}"

puts <<~END

##########
# Part 2 #
##########
END
# puts "Example: #{part2 parse file "example"}"
# puts "Solution: #{part2 parse file "input"}"
