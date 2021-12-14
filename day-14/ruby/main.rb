require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n\n").map { |chunk| chunk.split("\n") }.yield_self do |formula, rules|
    [
      formula.first,
      rules.inject({}) do |rule_hash, raw_rule|
        raw_rule.split(" -> ").yield_self do |outer, inner|
          rule_hash.merge(outer => [outer[0] + inner, inner + outer[1]])
        end
      end
    ]
  end
end

class Formula
  attr_reader :last_char, :rules, :counts

  def initialize(formula, rules)
    @last_char = formula[-1]
    @rules = rules
    @counts = Hash.new(0)

    formula.chars.each_cons(2).map(&:join).each { |pair| counts[pair] += 1 }
  end

  def step
    new_counts = Hash.new(0)
    counts.each do |pair, count|
      rules[pair].each do |new_pair|
        new_counts[new_pair] += count
      end
    end
    @counts = new_counts
  end

  def char_counts
    Hash.new(0).tap do |count_hash|
      count_hash[last_char] = 1
      counts.each { |pair, count| count_hash[pair[0]] += count }
    end.values
  end

  def score
    char_counts.max - char_counts.min
  end
end

def part1(data)
  Formula.new(*data).yield_self do |formula|
    10.times { formula.step }
    formula.score
  end
end

def part2(data)
  Formula.new(*data).yield_self do |formula|
    40.times { formula.step }
    formula.score
  end
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
