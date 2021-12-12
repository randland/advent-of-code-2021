def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map do |row|
    row.split(" | ").map do |group|
      group.split(" ").map(&:chars).map(&:sort)
    end
  end.map { |signal, output| Decode.new(signal, output) }
end

class Decode
  def initialize(signal, output)
    @signal = signal
    @output = output
    @known_wires = {}
    @known_nums = {}
  end

  def find_0
    set_known(0, signal_count(6) - [find_6, find_9])
  end

  def find_1
    set_known(1, signal_count(2))
  end

  def find_2
    set_known(2, signal_count(5) - [find_5, find_3])
  end

  def find_3
    set_known(3, signal_count(5).find { |el| (find_1 & (find_8 - el)).none? } )
  end

  def find_4
    set_known(4, signal_count(4))
  end

  def find_5
    set_known(5, signal_count(5).find { |el| (find_6 & el).count == 5 })
  end

  def find_6
    set_known(6, signal_count(6).find { |el| (find_1 & (find_8 - el)).any? } )
  end

  def find_7
    set_known(7, signal_count(3))
  end

  def find_8
    set_known(8, signal_count(7))
  end

  def find_9
    set_known(9, signal_count(6).find { |el| (find_3 & el).count == 5 })
  end

  def signal_count(num)
    @signal.select { |el| el.count == num }
  end

  def set_known(num, el)
    return @known_wires[num] if @known_wires[num]

    @known_wires[@known_nums[el.flatten] = num] = el.flatten
  end

  def part1
    @output.count { |el| [2,3,4,7].include? el.count }
  end

  def part2
    (0..9).each { |n| send("find_#{n}") }
    @output.map { |el| @known_nums[el] }.map(&:to_s).join.to_i
  end
end

def part1(data)
  data.map(&:part1).sum
end

def part2(data)
  data.map(&:part2).sum
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
