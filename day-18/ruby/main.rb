require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n")
end

def split_string(str)
  str.scan(/[\[\],]{1}|\d+/).map do |el|
    el =~ /\d+/ ? el.to_i : el
  end
end

def find_deep_start(split_str)
  depth = 0
  split_str.each_with_index do |char, idx|
    depth += 1 if char == "["
    depth -= 1 if char == "]"
    return idx if depth >= 5
  end
  nil
end

def find_big_num(str)
  str.each_with_index do |el, idx|
    return idx if el.is_a?(Integer) && el > 9
  end
  nil
end

def mag(arr)
  return arr if arr.is_a? Integer
  3 * mag(arr[0]) + 2 * mag(arr[1])
end

def explode!(str, idx)
  start = str[0...idx].reverse
  x = str[idx + 1]
  start.each_index do |idx|
    if start[idx].is_a? Integer
      start[idx] += x
      break
    end
  end
  start = start.reverse
  rest = str[idx + 5..]
  y = str[idx + 3]
  rest.each_index do |idx|
    if rest[idx].is_a? Integer
      rest[idx] += y
      break
    end
  end
  [
    start,
    0,
    rest
  ].flatten
end

def split!(str, idx)
  start = str[0...idx]
  rest = str[idx + 1..]
  val = str[idx] / 2.0

  [
    start,
    "[", val.floor.to_i, ",", val.ceil.to_i, "]",
    rest
  ].flatten
end

def reduce!(str)
  if deep = find_deep_start(str)
    return explode!(str, deep)
  elsif big = find_big_num(str)
    return split!(str, big)
  end

  str
end

def add(lhs, rhs)
  result = [ "[", lhs, ",", rhs, "]"].flatten

  test = reduce!(result)
  while test != result
    result = test
    test = reduce!(result)
  end

  result
end

def part1(data)
  val = eval(data.map(&method(:split_string)).inject do |lhs, rhs|
    add(lhs, rhs)
  end.join)
  mag val
end

def part2(data)
  data.map(&method(:split_string)).permutation(2).map do |a, b|
    add(a, b)
  end.map do |str|
    mag(eval(str.join))
  end.max
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
