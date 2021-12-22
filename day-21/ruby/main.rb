require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.scan(/ (\d+)$/).flatten.map(&:to_i)
end

class DeterministicDice
  def initialize(positions)
    @positions = positions
    @scores = [0, 0]
    @last_roll = 100
    @last_player = 1
    @rolls = 0
  end

  def roll_die
    @rolls += 1
    @last_roll = @last_roll % 100 + 1
  end

  def move_position(player, count)
  end

  def next_player
    (@last_player + 1) % 2
  end

  def take_turn
    rolls = 3.times.map { roll_die } 
    new_space = (@positions[next_player] + rolls.sum - 1) % 10 + 1
    @positions[next_player] = new_space
    @scores[next_player] += new_space

    @last_player = next_player
  end

  def game_over?
    @scores.each_index.find { |idx| @scores[idx] >= 1000 }
  end

  def part1_score
    @rolls * @scores[next_player]
  end
end

class DiracDice
  ROLLS = { 3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1 }.freeze

  def initialize(pos0, pos1)
    @states = { [[pos0, pos1], [0, 0]] => 1 }
    @wins = [0, 0]
  end

  def run
    [0, 1].cycle do |player|
      break if @states.empty?
      step(player)
    end

    @wins.max
  end

  def step(player)
    new_states = Hash.new { 0 }

    @states.each do |(pos, score), state_count|
      ROLLS.each do |roll, roll_count|
        new_pos = pos.clone
        new_pos[player] = (new_pos[player] + roll - 1) % 10 + 1
        new_score = score.clone
        new_score[player] += new_pos[player]
        if new_score[player] >= 21
          @wins[player] += state_count * roll_count
        else
          new_states[[new_pos, new_score]] += state_count * roll_count
        end
      end
    end

    @states = new_states
  end
end

def part1(data)
  DeterministicDice.new(data).tap do |game|
    game.take_turn until game.game_over?
  end.part1_score
end

def part2(data)
  DiracDice.new(*data).run
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
