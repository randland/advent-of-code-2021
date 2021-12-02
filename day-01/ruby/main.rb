def file(path) = File.read(File.join(__dir__, path))

def parse(data) = data.split("\s").map(&:to_i)
def count_inc(data, res) = (res...data.size).count { |i| data[i] > data[i - res] }

def part1(data) = count_inc(data, 1)
def part2(data) = count_inc(data, 3)

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
