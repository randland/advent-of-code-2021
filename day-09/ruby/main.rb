def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map { |row| row.chars.map(&:to_i) }
end

def get_val(data, r, c)
  return 9 if r.negative? || c.negative?

  (data[r] || [])[c] || 9
end

def get_adj(data, r, c)
  {
    [r-1, c] => get_val(data, r-1, c),
    [r+1, c] => get_val(data, r+1, c),
    [r, c-1] => get_val(data, r, c-1),
    [r, c+1] => get_val(data, r, c+1)
  }
end

def expand_group(data, group)
  group.each do |r, c|
    get_adj(data, r, c).each do |cell, val|
      next if val == 9
      next if group.include?(cell)

      group << cell
    end
  end
end

def low_spots(data)
  data.each_index.map do |r|
    data.first.each_index.select do |c|
      val = data[r][c]
      get_adj(data, r, c).values.all? { |v| val < v }
    end.map { |c| [r, c] }
  end.flatten(1)
end

def part1(data)
  low_spots(data).map { |r, c| data[r][c] + 1 }.sum
end

def part2(data)
  low_spots(data).map do |low_spot|
    [low_spot].tap do |group|
      while(group != expand_group(data, group)); end
    end.count
  end.sort.last(3).inject(:*)
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
