require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.chars.map { |char| "%04d" % char.to_i(16).to_s(2) }.join
end

class Packet
  attr_reader :data, :values

  def initialize(data)
    @data = data
  end

  def self.type(data)
    data[3, 3].to_i(2)
  end

  def self.from(data)
    case type(data)
    when 4
      Literal.new(data)
    else
      if data[6] == "0"
        BitLengthOperator.new(data)
      else
        SubPacketsOperator.new(data)
      end
    end
  end

  def version
    data[0, 3].to_i(2)
  end

  def type
    self.class.type(data)
  end

  def length
    prefix_length + values.map(&:length).sum
  end

  def get_packet_at(idx)
    self.class.from(data[idx..])
  end
end

class Literal < Packet
  def prefix_length
    3 + 3
  end

  def length
    (prefix_length...data.length).step(5).find { |n| data[n] == "0" } + 5
  end

  def values
    @values ||= (prefix_length...length).step(5).map { |n| data[n + 1, 4] }.join.to_i(2)
  end

  def version_agg
    version
  end
end

class BitLengthOperator < Packet
  def prefix_length
    3 + 3 + 1 + 15
  end

  def values
    return @values if defined? @values

    idx = prefix_length
    length = prefix_length + data[7, 15].to_i(2)

    @values = []
    until idx + 11 > length || data[idx..length].to_i(2).zero?
      @values << get_packet_at(idx)
      idx += @values.last.length
    end 

    @values
  end

  def version_agg
    version + values.map(&:version_agg).sum
  end
end

class SubPacketsOperator < Packet
  def prefix_length
    3 + 3 + 1 + 11
  end

  def values
    return @values if defined? @values

    idx = prefix_length
    packet_count = data[7, 11].to_i(2)

    @values = packet_count.times.map do
      get_packet_at(idx).tap do |packet|
        idx += packet.length
      end
    end
  end

  def version_agg
    version + values.map(&:version_agg).sum
  end
end

def packet_processor(packet)
  return packet.values if packet.is_a? Literal

  values = packet.values.map(&method(:packet_processor))
  case packet.type
  when 0 then values.inject(:+)
  when 1 then values.inject(:*)
  when 2 then values.min
  when 3 then values.max
  when 5 then values[0] > values[1] ? 1 : 0
  when 6 then values[0] < values[1] ? 1 : 0
  when 7 then values[0] == values[1] ? 1 : 0
  end
end

def part1(data)
  Packet.from(data).version_agg
end

def part2(data)
  packet_processor(Packet.from(data))
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
