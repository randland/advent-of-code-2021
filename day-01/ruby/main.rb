def file(path) File.read(File.join(__dir__, path)); end

def parse(data)
  data.split("\s").map &:to_i
end

def count_inc(data, delta)
  (delta...data.size).count { |i| data[i] > data[i - delta] }
end

def part1(data)
  count_inc(data, 1)
end

def part2(data)
  count_inc(data, 3)
end

EXAMPLE = parse file "example"
INPUT = parse file "input"

puts <<~END
##########
# Part 1 #
##########
Example: #{part1 EXAMPLE}
Solution: #{part1 INPUT}

##########
# Part 2 #
##########
Example: #{part2 EXAMPLE}
Solution: #{part2 INPUT}

END
