def file(path) = File.read(File.join(__dir__, path))

def parse(data)
  data.split("\n\n").then do |chunks|
    draws = chunks.first.split(",").map(&:to_i)
    boards = chunks[1..-1].map do |board|
               board.split("\n").map do |row|
                 row.strip.split(/\s+/).map(&:to_i)
               end
             end

    { draws: draws, boards: boards }
  end
end

class Board
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def mark(draw)
    board.each { |row| (hit = row.index(draw)) && row[hit] = nil }
  end

  def won?
    board.any?(&:none?) || board.transpose.any?(&:none?)
  end

  def score
    board.flatten.compact.sum
  end
end

def part1(data)
  draws = data[:draws]
  boards = data[:boards].map { |b| Board.new(b) }

  draws.each do |draw|
    boards.each { |board| board.mark(draw) }
    winner = boards.find(&:won?)
    return winner.score * draw if winner
  end
end

def part2(data)
  draws = data[:draws]
  boards = data[:boards].map { |b| Board.new(b) }
  wins = []

  draws.each do |draw|
    boards.each { |board| board.mark(draw) }
    boards -= (wins += boards.select(&:won?))
    return wins.last.score * draw if boards.empty?
  end
end

puts <<~PART1
##########
# Part 1 #
##########
Example: #{part1 parse file "example"}
Solution: #{part1 parse file "input"}

PART1

puts <<~PART2
##########
# Part 2 #
##########
Example: #{part2 parse file "example"}
Solution: #{part2 parse file "input"}

PART2
