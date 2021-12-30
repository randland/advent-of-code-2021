require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map { |r| r.split(" ") }
end

class SolverConstraint
  attr_reader :a, :b, :n

  def initialize(a, b, n)
    @a, @b = n.positive? ? [a, b] : [b, a]
    @n = n.abs
  end

  def min_vals
    [[a, 1], [b, 1 + n]]
  end

  def max_vals
    [[a, 9 - n], [b, 9]]
  end

  def inspect
    "[#{a}] + #{n} == [#{b}]"
  end
end

class ModelNumSolver
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def inst
    return @inst if defined? @inst

    chunks = program.chunk.with_index { |_, i| i / 18 }.map(&:last)

    @inst = chunks.map do |c|
              push = c[4][2] == "1"
              [push, c[push ? 15 : 5][2].to_i]
            end
  end

  def constraints
    return @constraints if defined? @constraints

    @constraints = []
    queue = []
    inst.each.with_index do |(push, val), idx|
      next queue.push([idx, val]) if push

      a_idx, a_val = queue.pop
      @constraints << SolverConstraint.new(a_idx, idx, val + a_val)
    end

    @constraints
  end

  def max_num
    constraints.flat_map(&:max_vals).sort_by(&:first).map(&:last).join
  end

  def min_num
    constraints.flat_map(&:min_vals).sort_by(&:first).map(&:last).join
  end
end

def part1(program)
  ModelNumSolver.new(program).max_num
end

def part2(program)
  ModelNumSolver.new(program).min_num
end

puts <<~END

##########
# Part 1 #
##########
END
puts "Solution: #{part1 parse file "input"}"

puts <<~END

##########
# Part 2 #
##########
END
puts "Solution: #{part2 parse file "input"}"
