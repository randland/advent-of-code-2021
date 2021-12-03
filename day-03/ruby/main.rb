def file(path) = File.read(File.join(__dir__, path))

def parse(data) = data.split("\n").map { |row| row.chars.map(&:to_i) }

def part1(data)
  data.transpose.map(&:sum).map do |sum|
    sum >= (data.size + 1) / 2 ? 1 : 0
  end.yield_self do |num|
    num.map(&:to_s).join.to_i(2) *
      num.map(&:to_s).map { |c| c == "1" ? "0" : "1" }.join.to_i(2)
  end
end

def oxy_filter(data, idx)
  groups = data.group_by { |row| row[idx] }
  return groups.values.first if groups.size == 1

  groups[0].size > groups[1].size ? groups[0] : groups[1]
end

def co2_filter(data, idx)
  groups = data.group_by { |row| row[idx] }
  return groups.values.first if groups.size == 1

  groups[0].size <= groups[1].size ? groups[0] : groups[1]
end

def part2(data)
  data.length.times.inject([data, data]) do |( oxy, co2 ), idx|
    [oxy_filter(oxy, idx), co2_filter(co2, idx)]
  end.map { |row| row.first.map(&:to_s).join.to_i(2) }.inject(:*)
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
