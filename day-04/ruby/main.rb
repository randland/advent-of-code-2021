def file(path) = File.read(File.join(__dir__, path))

def parse(data)
  data.split("\n\n").yield_self do |chunks|
    [
      chunks.first.split(",").map(&:to_i),
      chunks[1..-1].map do |board|
        board.split("\n").map { |row| row.strip.split(/\s+/).map(&:to_i) }
      end
    ]
  end
end

class Board
  attr_reader :board, :hits
  def initialize(board)
    @board = board
    @hits = 5.times.map { [false] * 5 }
  end

  def mark_num(num)
    @board.each_with_index do |row, y|
      row.each_with_index do |val, x|
        @hits[y][x] = true if val == num
      end
    end
  end

  def win?
    @hits.any? { |row| row.inject(:&) } ||
      @hits.transpose.any? { |row| row.inject(:&) }
  end

  def score
    @board.map.with_index do |row, y|
      row.map.with_index do |val, x|
        @hits[y][x] ? 0 : val
      end.sum
    end.sum
  end

  def to_s
    @board.map { |row| puts row.inspect }
    @hits.map { |row| puts row.inspect }
  end
end

def part1(data)
  nums, raw_boards = data
  boards = raw_boards.map(&Board.method(:new))

  nums.each do |num|
    boards.each { |board| board.mark_num(num) }
    winner = boards.select(&:win?).first
    return winner.score * num if winner
  end
end

def part2(data)
  nums, raw_boards = data
  won_boards = []
  boards = raw_boards.map(&Board.method(:new))

  nums.each do |num|
    boards.each { |board| board.mark_num(num) }
    won_boards += boards.select(&:win?)
    boards -= won_boards
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
