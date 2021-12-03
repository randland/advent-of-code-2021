def file(path) = File.read(File.join(__dir__, path))

def parse(data) = data.split("\n")

def sorted_by_idx(data, idx)
  data.group_by { |row| row[idx] }.
    to_a.sort_by { |char, rows| [rows.size, char.to_i] }
end

def sparse_val(data, idx) = sorted_by_idx(data, idx).first.first
def sparse_rows(data, idx) = sorted_by_idx(data, idx).first.last
def common_val(data, idx) = sorted_by_idx(data, idx).last.first
def common_rows(data, idx) = sorted_by_idx(data, idx).last.last

def calc_result(vals) = vals.map { |v| v.join.to_i(2) }.inject(:*)

def part1(data)
  data.first.size.times.each_with_object([[], []]) do |idx, (gam, eps)|
    gam << common_val(data, idx)
    eps << sparse_val(data, idx)
  end.yield_self(&method(:calc_result))
end

def part2(data)
  data.first.size.times.inject([data, data]) do |(o2, co2), idx|
    [common_rows(o2, idx), sparse_rows(co2, idx)]
  end.yield_self(&method(:calc_result))
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
