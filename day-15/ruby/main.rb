require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map { |row| row.chars.map(&:to_i) }
end

class Graph
  NEIGHBOR_OFFSETS = [[-1, 0], [0, -1], [1, 0], [0, 1]]
  attr_reader :height, :width

  def initialize(cells)
    @cells = cells
    @height = cells.size
    @width = cells.first.size
  end

  def get(*coord)
    x, y = Array(coord).flatten
    cells[y][x]
  end

  def set(*coord, val)
    x, y = Array(coord).flatten
    cells[y][x] = val
  end

  def neighbors(*coord)
    x, y = Array(coord).flatten
    NEIGHBOR_OFFSETS.map do |xo, yo|
      neighbor = [x + xo, y + yo]
      neighbor if in_grid?(neighbor)
    end.compact
  end

  private

  attr_reader :cells

  def in_grid?(*coord)
    x, y = Array(coord).flatten
    (0...width).include?(x) && (0...height).include?(y)
  end
end

class MinGraph < Graph
  def set(*coord, val)
    return false if val >= get(coord)

    super
  end
end

class PathFinder
  def initialize(risks)
    @risks = Graph.new(risks)
    @width = @risks.width
    @height = @risks.height
    @costs = MinGraph.new(
      Array.new(height) { Array.new(width) { Float::INFINITY } }
    )
  end

  def calc_costs
    costs.set([0, 0], 0)
    queue = Set.new
    queue << [0, 0]

    while queue.any?
      queue.delete(coord = queue.first)
      queue.merge(calc_costs_from(coord))
    end
  end

  def final_cost
    costs.get(width - 1, height - 1)
  end

  private

  attr_reader :costs, :risks, :height, :width

  def calc_costs_from(*coord)
    costs.neighbors(coord).map do |neighbor|
      neighbor if costs.set(neighbor, costs.get(coord) + risks.get(neighbor))
    end.compact
  end
end

def part1(data)
  PathFinder.new(data).tap(&:calc_costs).final_cost
end

def expand_graph(data)
  h = data.size
  w = data.first.size
  [].tap do |new_data|
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
  end
end

def part2(data)
  PathFinder.new(expand_graph(data)).tap(&:calc_costs).final_cost
end

puts <<~END
##########
# Part 1 #
##########
END
puts "Example: #{part1 parse file "example"}"
puts "Solution: #{part1 parse file "input"}"

puts <<~END
##########
# Part 2 #
##########
END
puts "Example: #{part2 parse file "example"}"
puts "Solution: #{part2 parse file "input"}"
