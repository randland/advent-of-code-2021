require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

WALL = "#"
EMPTY = "."
NL = "\n"

def parse(data)
  data.split(NL).map { |r| r.ljust(14).chars }.then do |map|
    hall = map[1]
    rooms = map.transpose[3..9].reject.with_index { |_, i| i.odd? }
    [
      [hall[1]] + hall[2..10].reject.with_index { |_, i| i.odd? } + [hall[11]],
      rooms.map { |r| r[2...r.rindex(WALL)] }
    ]
  end
end

class AmphidState
  attr_reader :hall, :rooms
  def initialize(state)
    @hall = state[0]
    @rooms = state[1]
  end

  def to_s
    WALL * 13 + NL +
      WALL + hall[0] + hall[1..5].join(EMPTY) + hall[6] + WALL + NL +
      WALL * 3 + rooms.transpose[0].join(WALL) + WALL * 3 + NL +
      (1...rooms.first.size).map do |idx|
        "  " + WALL + rooms.transpose[idx].join(WALL) + WALL + NL
      end.join +
      "  " + WALL * 9
  end

  COLOR_MULT = { "A" => 1, "B" => 10, "C" => 100, "D" => 1000 }
  ROOM_IDX = { "A" => 0, "B" => 1, "C" => 2, "D" => 3 } 

  ROOM2HALL_CHECK = [
    [[1],    [],     [],     [2],    (2..3), (2..4), (2..5)],
    [(1..2), [2],    [],     [],     [3],    (3..4), (3..5)],
    [(1..3), (2..3), [3],    [],     [],     [4],    (4..5)],
    [(1..4), (2..4), (3..4), [4],    [],     [],     [5]]
  ]

  ROOM2HALL_COST = [
    [3, 2, 2, 4, 6, 8, 9],
    [5, 4, 2, 2, 4, 6, 7],
    [7, 6, 4, 2, 2, 4, 5],
    [9, 8, 6, 4, 2, 2, 3]
  ]

  def done?
    rooms.map.with_index { |r, idx| r.all?(ROOM_IDX.keys[idx]) }.all?
  end

  def next_states
    move_in_states + move_out_states
  end

  def path_clear?(room_idx, hall_idx)
    ROOM2HALL_CHECK[room_idx][hall_idx].all? { |i| hall[i] == EMPTY }
  end

  def room_ready?(room_idx)
    expected = ROOM_IDX.keys[room_idx]
    rooms[room_idx].all? { |v| [expected, EMPTY].include? v }
  end

  def move_in_states
    hall.map.with_index do |val, hall_idx|
      next if val == EMPTY

      room_idx = ROOM_IDX[val]
      next unless path_clear?(room_idx, hall_idx)
      next unless room_ready?(room_idx)

      slot_idx = rooms[room_idx].rindex(EMPTY)
      new_cost = ROOM2HALL_COST[room_idx][hall_idx] + slot_idx
      new_hall = hall.clone.tap { |h| h[hall_idx] = EMPTY }
      new_rooms = rooms.map(&:clone).tap { |r| r[room_idx][slot_idx] = val }

      [[new_hall, new_rooms], new_cost * COLOR_MULT[val]]
    end.compact
  end

  def move_out_states
    rooms.flat_map.with_index do |room, room_idx|
      next if room_ready?(room_idx)

      slot_idx = (room.rindex(EMPTY) || -1) + 1

      hall.map.with_index do |dest, hall_idx|
        next unless dest == EMPTY
        next unless path_clear?(room_idx, hall_idx)

        val = room[slot_idx]
        new_cost = ROOM2HALL_COST[room_idx][hall_idx] + slot_idx
        new_hall = hall.clone.tap { |h| h[hall_idx] = val }
        new_rooms = rooms.map(&:clone).tap { |r| r[room_idx][slot_idx] = EMPTY }

        [[new_hall, new_rooms], new_cost * COLOR_MULT[val]]
      end
    end.compact
  end
end

class AmphidSolver
  attr_reader :costs, :prev, :queue
  def initialize(start)
    @costs = {start => 0}
    @prev = {start => nil}
    @queue = [Set.new([start])]
  end

  def min_cost_route
    (0..100_000).each do |cost|
      next if queue[cost].nil?

      queue[cost].each do |state|
        next if known_min_cost(state) < cost

        amph_state = AmphidState.new(state)
        return result_output(state, cost) if amph_state.done?

        amph_state.next_states.each do |next_state, next_cost|
          next if known_min_cost(next_state) < cost

          total_next_cost = cost + next_cost
          prev[next_state] = state
          costs[next_state] = total_next_cost
          queue[total_next_cost] ||= Set.new
          queue[total_next_cost] << next_state
        end
      end
    end
  end

  def known_min_cost(state)
    costs[state] || Float::INFINITY
  end

  def result_output(state, cost)
    last_state = state
    result = []

    while last_state
      result.unshift(AmphidState.new(last_state))
      last_state = prev[last_state]
    end

    [result.map(&:to_s).join(NL * 2), cost].join(NL * 2)
  end
end

def part1(data)
  AmphidSolver.new(data).min_cost_route
end

def part2(data)
  AmphidSolver.new(data).min_cost_route
end

puts <<~END

##########
# Part 1 #
##########

END
puts "Example:\n#{part1 parse file "example"}\n"
puts "Solution:\n#{part1 parse file "input1"}"

puts <<~END

##########
# Part 2 #
##########

END
puts "Solution:\n#{part2 parse file "input2"}"
