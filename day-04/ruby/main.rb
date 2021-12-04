def file(path) = File.read(File.join(__dir__, path))

def parse(data)
  data.split("\n\n").yield_self do |chunks|
    [
      chunks.first.split(",").map(&:to_i),
      chunks[1..-1].map do |board|
        Board.new(board.split("\n").map { |row| row.strip.split(/\s+/).map(&:to_i) })
      end
    ]
  end
end

class Board
  attr_reader :board, :hits
  def initialize(board)
    @board = board
    @hits = Array.new(5) { Array.new(5) { false } }
  end

  def mark_num(num)
    @board.each_with_index do |row, y|
      row.each_with_index do |val, x|
        @hits[y][x] ||= val == num
      end
    end
  end

  def win?
    @hits.any?(&:all?) || @hits.transpose.any?(&:all?)
  end

  def score
    @board.map.with_index do |row, y|
      row.map.with_index do |val, x|
        @hits[y][x] ? 0 : val
      end.sum
    end.sum
  end
end

def part1(data)
  nums, boards = data

  nums.each do |num|
    boards.each { |board| board.mark_num(num) }
    winner = boards.find(&:win?)
    return winner.score * num if winner
  end
end

def part2(data)
  nums, boards = data
  won_boards = []

  nums.each do |num|
    boards.each { |board| board.mark_num(num) }
    boards -= (won_boards += boards.select(&:win?))
    return won_boards.last.score * num if boards.size.zero?
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
