require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map { |row| row.chars.map(&:to_i) }
end

class Octos
  attr_reader :grid, :flashes, :steps

  def initialize(grid)
    @grid = grid
    @flashes = 0
    @steps = 0
  end

  def step
    flashed = Set.new
    new_grid = grid.map(&:clone)

    new_grid.each_with_index do |row, ri|
      row.each_with_index do |energy, ci|
        new_grid[ri][ci] += 1
      end
    end

    until (new_10s = find_10s(new_grid) - flashed.to_a).empty? do
      new_10s.each do |ri, ci|
        neighbors(ri, ci).each { |r, c| new_grid[r][c] += 1 }
      end
      flashed += new_10s
    end

    flashed.each { |r, c| new_grid[r][c] = 0 }

    @flashes += flashed.count
    @grid = new_grid
    @steps += 1
  end

  def synched?
    val = grid[0][0]
    grid.all? { |row| row.all? { |el| el == val } }
  end

  def to_s
    "Flashes: #{flashes}\n#{grid.map { |row| row.map(&:to_s).join }.join("\n")}"
  end

  def neighbors(ri, ci)
    (-1..1).map do |ro|
      (-1..1).map { |co| [ri + ro, ci + co] }.
        select do |r, c|
          (0..9).include?(r) && (0..9).include?(c)
        end
    end.flatten(1)
  end

  def find_10s(grid)
    grid.each_index.map do |ri|
      grid.each_index.map do |ci|
        [ri, ci] if grid[ri][ci] >= 10
      end
    end.flatten(1).compact
  end
end

def part1(data)
  Octos.new(data).yield_self do |octo|
    100.times { octo.step }
    octo.flashes
  end
end

def part2(data)
  Octos.new(data).yield_self do |octo|
    until octo.synched? do
      puts octo
      octo.step
    end
    octo.steps
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
