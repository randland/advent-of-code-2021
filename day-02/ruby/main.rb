def file(path) = File.read(File.join(__dir__, path))

def parse(data) = data.split("\n").map { |row| row.split(" ") }

class Sub1
  def initialize(commands)
    @horiz = 0
    @depth = 0
    run(commands)
  end

  def run(commands) = commands.each { |op, dist| send(op, dist.to_i) }
  def loc = @horiz * @depth

  def down(x) = @depth += x
  def forward(x) = @horiz += x
  def up(x) = down(-x)
end

class Sub2 < Sub1
  def initialize(commands)
    @aim = 0
    super
  end

  def down(x) = @aim += x
  def forward(x) = super && @depth += @aim * x
end

def part1(data) = Sub1.new(data).loc
def part2(data) = Sub2.new(data).loc

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
