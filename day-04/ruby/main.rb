def file(path) = File.read(File.join(__dir__, path))

def parse(data)
  data.split("\n\n").yield_self do |chunks|
    [
      chunks.first.split(",").map(&:to_i),
      chunks[1..-1].map do |board|
        board.split("\n").map do |row|
          row.strip.split(/\s+/).map(&:to_i)
        end
      end.map(&Board.method(:new))
    ]
  end
end

class Board
  def initialize(board)
    @board = board
    @hits = Array.new(5) { Array.new(5) }
  end

  def mark(num)
    map_vals { |val, y, x| @hits[y][x] ||= val == num }
  end

  def won?
    @hits.any?(&:all?) || @hits.transpose.any?(&:all?)
  end

  def score
    map_vals { |val, y, x| @hits[y][x] ? 0 : val }.flatten.sum
  end

  private

  def map_vals
    @board.map.with_index { |row, y| row.map.with_index { |val, x| yield val, y, x } }
  end
end

def part1(data)
  nums, boards = data

  nums.each do |num|
    boards.each { |board| board.mark(num) }
    winner = boards.find(&:won?)
    return winner.score * num if winner
  end
end

def part2(data)
  nums, boards = data
  won_boards = []

  nums.each do |num|
    boards.each { |board| board.mark(num) }
    boards -= (won_boards += boards.select(&:won?))
    return won_boards.last.score * num if boards.empty?
  end
end

EXAMPLE = parse file "example"
INPUT = parse file "input"

puts <<~PART1
##########
# Part 1 #
##########
Example: #{part1 EXAMPLE}
Solution: #{part1 INPUT}

PART1

puts <<~PART2
##########
# Part 2 #
##########
Example: #{part2 EXAMPLE}
Solution: #{part2 INPUT}

PART2
