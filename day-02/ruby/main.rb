def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map do |com|
    com.split(" ").yield_self do |op, dist|
      [op.to_sym, dist.to_i]
    end
  end
end

EXAMPLE = parse file "example"
INPUT = parse file "input"

PART1 = {
  up: ->(d) { [0, -d] },
  down: ->(d) { [0, d] },
  forward: ->(d) { [d, 0] }
}.freeze

PART2 = {
  up: ->(d) { @a -= d; [0, 0] },
  down: ->(d) { @a += d; [0, 0] },
  forward: ->(d) { [d, @a * d] }
}.freeze

def part1(data)
  data.inject([0,0]) do |mem, (op, dist)|
    mem.zip(PART1[op].call(dist)).map(&:sum)
  end.inject(:*)
end

def part2(data)
  @a = 0
  data.inject([0,0]) do |mem, (op, dist)|
    mem.zip(PART2[op].call(dist)).map(&:sum)
  end.inject(:*)
end

puts "*" * 80
puts "Example 1: #{part1 EXAMPLE}"
puts "Part 1: #{part1 INPUT}"
puts "*" * 80
puts "Example 2: #{part2 EXAMPLE}"
puts "Part 2: #{part2 INPUT}"
