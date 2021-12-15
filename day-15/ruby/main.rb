require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map { |row| row.chars.map(&:to_i) }
end

class Pathfinder
  attr_reader :cost, :risk, :w, :h

  def initialize(risk)
    @risk = risk.map(&:freeze).freeze
    @cost = [[0]]
    @w = risk.first.size
    @h = risk.size
  end

  def calc
    needs_processing = calc_cost_from(0, 0)

    until needs_processing.empty?
      needs_processing = needs_processing.uniq.map(&method(:calc_cost_from)).flatten(1)
    end
  end

  def calc_cost_from(*coord)
    r, c = Array(coord).flatten
    needs_processing = []

    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |ro, co|
      ri = ro + r
      ci = co + c
      next unless (0...h).include? ri
      next unless (0...w).include? ci

      cost_from_here = cost[r][c] + risk[ri][ci]
      next if cost_at(ri, ci) < cost_from_here

      @cost[ri] ||= []
      @cost[ri][ci] = cost_from_here
      needs_processing << [ri, ci]
    end

    needs_processing
  end

  def cost_at(r, c)
    cost[r]&.[](c) || Float::INFINITY
  end
end

def part1(data)
  Pathfinder.new(data).tap(&:calc).cost.last.last
end

def part2(data)
  h = data.size
  w = data.first.size
  new_data = []

  (0...5).to_a.repeated_permutation(2).each do |x, y|
    data.each_with_index do |row, r|
      row.each_with_index do |val, c|
        ri = y * h + r
        ci = x * w + c
        new_data[ri] ||= []
        new_data[ri][ci] = (val + x + y - 1) % 9 + 1
      end
    end
  end

  Pathfinder.new(new_data).tap(&:calc).cost.last.last
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
