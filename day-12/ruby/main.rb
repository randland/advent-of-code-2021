require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map { |row| row.split("-") }
end

class Cave
  attr_reader :graph

  def initialize(nodes)
    @graph = {}
    nodes.each do |a, b|
      connect(make_node(a), make_node(b))
    end
  end

  def make_node(name)
    @graph[name] ||= Node.new(name)
  end

  def connect(a, b)
    a.connect_to(b)
    b.connect_to(a)
  end

  def [](key)
    graph[key]
  end
end

class Node
  attr_reader :name, :small, :connections
  def initialize(name)
    @name = name
    @small = name == name.downcase
    @connections = Set.new
  end

  def connect_to(node)
    @connections << node
  end

  def inspect
    name
  end
end

class PathFinder
  def self.call(data, start_node, small_max_count)
    new(data, start_node, small_max_count).call
  end

  def call
    find_paths([start_node])
    paths
  end

  private

  attr_reader :start_node, :small_max_count, :paths

  def initialize(data, start_node, small_max_count)
    cave = Cave.new(data)
    @start_node = cave.graph[start_node]
    @small_max_count = small_max_count
    @paths = Set.new
  end

  def find_paths(path)
    @paths << path and return if path.last.name == "end"

    path.last.connections.each do |node|
      new_path = path.clone << node
      next if node.name == "start"

      small_counts = new_path.select(&:small).group_by(&:name).values.map(&:count).sort.reverse
      next if small_counts[0] > small_max_count
      next if (small_counts[1] || 0) > 1

      find_paths(new_path)
    end
  end
end

def part1(data)
  PathFinder.(data, "start", 1).count
end

def part2(data)
  PathFinder.(data, "start", 2).count
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
