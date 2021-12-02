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

class Sub1
  def initialize
    @horiz = 0
    @depth = 0
  end

  def forward(x)
    @horiz += x
  end

  def down(x)
    @depth += x
  end

  def up(x)
    down(-x)
  end

  def loc
    @horiz * @depth
  end
end

class Sub2 < Sub1
  def initialize
    super
    @aim = 0
  end

  def forward(x)
    @horiz += x
    @depth += @aim * x
  end

  def down(x)
    @aim += x
  end
end

def part1(data)
  Sub1.new.tap { |sub| data.each { |op, dist| sub.send(op, dist) } }.loc
end

def part2(data)
  Sub2.new.tap { |sub| data.each { |op, dist| sub.send(op, dist) } }.loc
end

EXAMPLE = parse file "example"
INPUT = parse file "input"

puts <<~PART1
##########
# Part 1 #
##########
Example: #{part1 EXAMPLE}
Solution: #{part1 INPUT}

PART1

puts <<~PART2
##########
# Part 2 #
##########
Example: #{part2 EXAMPLE}
Solution: #{part2 INPUT}

PART2
