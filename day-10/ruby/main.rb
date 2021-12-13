def file(path)
  File.read(File.join(__dir__, path))
end

PAIRS = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}.freeze

FAIL_SCORES = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

PASS_SCORES = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}

def parse(data)
  data.split("\n").map(&:chars).map(&Expression.method(:new))
end

class Expression
  attr_reader :exp, :ops, :fail_score

  def initialize(exp)
    @exp = exp
    @ops = []
    @fail_score = 0

    valid?
  end

  def valid?
    return @valid if defined? @valid

    exp.each do |char|
      if close = PAIRS[char]
        ops.unshift close
      elsif ops[0] == char
        ops.shift
      else
        @fail_score = FAIL_SCORES[char]
        break
      end
    end

    @valid = @fail_score == 0
  end

  def pass_score
    return @pass_score if defined? @pass_score
    return nil if fail_score > 0

    @pass_score = 0

    ops.each do |op|
      @pass_score = @pass_score * 5 + PASS_SCORES[op]
    end

    @pass_score
  end
end

def part1(data)
  data.map(&:fail_score).sum
end

def part2(data)
  list = data.map(&:pass_score).compact.sort
  list[list.count / 2]
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
