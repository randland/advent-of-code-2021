require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n\n").map { |chunk| chunk.split("\n") }.yield_self do |formula, rules|
    [formula.first, rules.map { |rule| rule.split(" -> ") }]
  end
end

class Formula
  attr_reader :last_char, :rules, :counts

  def initialize(formula, rules)
    @last_char = formula[-1]
    @rules = rules.inject({}) do |hash, (o, i)|
               hash.merge(o.chars => [o[0], i, o[1]].each_cons(2))
             end

    @counts = Hash.new(0).tap do |hash|
                formula.chars.each_cons(2).each { |pair| hash[pair] += 1 }
              end
  end

  def step
    @counts = Hash.new(0).tap do |hash|
      counts.each do |pair, count|
        rules[pair].each { |new_pair| hash[new_pair] += count }
      end
    end
  end

  def score
    Hash.new(0).tap do |hash|
      hash[last_char] = 1
      counts.each { |pair, count| hash[pair[0]] += count }
    end.values.yield_self do |char_counts|
      char_counts.max - char_counts.min
    end
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
