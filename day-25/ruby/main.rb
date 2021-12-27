require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map(&:chars)
end

class SeaCucumbers
  attr_reader :east, :south, :height, :width

  def initialize(map)
    @east = Set.new
    @south = Set.new
    @height = map.size
    @width = map.first.size

    map.each_with_index do |row, ri|
      row.each_with_index do |char, ci|
        case char
        when ">" then @east << [ri, ci]
        when "v" then @south << [ri, ci]
        end
      end
    end
  end

  def step
    move_east + move_south
  end

  def occupied?(coord)
    east.include?(coord) || south.include?(coord)
  end

  def move_east
    new_east = Set.new
    changes = 0
    east.each do |coord|
      if occupied?(east_of(coord))
        new_east << coord
      else
        new_east << east_of(coord)
        changes += 1
      end
    end

    @east = new_east
    changes
  end

  def move_south
    new_south = Set.new
    changes = 0
    south.each do |coord|
      if occupied?(south_of(coord))
        new_south << coord
      else
        new_south << south_of(coord)
        changes += 1
      end
    end

    @south = new_south
    changes
  end

  def east_of(coord)
    [coord[0], (coord[1] + 1) % width]
  end

  def south_of(coord)
    [(coord[0] + 1) % height, coord[1]]
  end
end

def part1(data)
  steps = 0
  SeaCucumbers.new(data).then do |cukes|
    changes = 1
    while changes > 0
      steps += 1
      changes = cukes.step
    end
  end
  steps
end

def part2(data)
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
# puts "Example: #{part2 parse file "example"}"
# puts "Solution: #{part2 parse file "input"}"
