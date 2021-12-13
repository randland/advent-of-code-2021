require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  Cave.new(data.split("\n").map { |row| row.split("-") })
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
end

class Node
  attr_reader :name, :upper, :connections
  def initialize(name)
    @name = name
    @upper = name == name.upcase
    @connections = Set.new
  end

  def connect_to(node)
    @connections << node
  end

  def inspect
    to_s
  end

  def to_s
    name
  end
end

def trails(graph, trail)
  return trail if trail.last.name == "end"

  graph[trail.last.name].connections.map do |node|
    next if !node.upper && trail[0..-2].include?(node)

    trails(graph, trail.clone << node)
  end.compact
end

def part1(data)
  trails(data.graph, [data.graph["start"]]).flatten.map(&:name).count("end")
end

def trails2(graph, trail, visited)
  return trail if trail.last.name == "end"

  graph[trail.last.name].connections.map do |node|
    new_trail = trail.clone << node
    next if node.name == "start"
    smalls = trail.reject(&:upper).group_by(&:to_s).values.map(&:count)
    next if smalls.any? { |v| v > 2 }
    next if smalls.count { |v| v == 2 } >= 2

    trails2(graph, trail.clone << node, visited || trail.count(trail.last) > 1)
  end.compact
end

def part2(data)
  trails2(data.graph, [data.graph["start"]], false).flatten.map(&:name).count("end")
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
