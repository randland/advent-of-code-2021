require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n").map do |line|
    line.split(" ").then do |op, ranges|
      x0, x1, y0, y1, z0, z1 = ranges.scan(/(-?\d+)/).flatten.map(&:to_i)
      [op, (x0..x1), (y0..y1), (z0..z1)]
    end
  end
end

def part1(data)
  result = Set.new
  data.each do |op, xr, yr, zr|
    next unless (-50..50).cover? xr
    coords = xr.to_a.product(yr.to_a).product(zr.to_a).map(&:flatten)
    case op
    when "on"
      result += coords
    else
      result -= coords
    end
  end
  result.count
end

class Cube
  attr_reader :xr, :yr, :zr

  def initialize(xr, yr, zr)
    @xr = xr
    @yr = yr
    @zr = zr
  end

  def size
    xr.size * yr.size * zr.size
  end

  def split_ranges(ranges, div, is_min)
    ranges.flat_map do |range|
      next range unless range.cover?(div)
      next range if is_min && range.min == div
      next range if !is_min && range.max == div
      return [(div..range.max)] if div == range.min

      [(range.min...div), (div..range.max)]
    end.compact
  end

  def splits_cube?(cube)
    xr.min <= cube.xr.max &&
      xr.max >= cube.xr.min &&
      yr.min <= cube.yr.max &&
      yr.max >= cube.yr.min &&
      zr.min <= cube.zr.max &&
      zr.max >= cube.zr.min
  end

  def split_cube(cube)
    return [cube] unless splits_cube?(cube)

    x_divs = [xr]
    x_divs = split_ranges(x_divs, cube.xr.min, true)
    x_divs = split_ranges(x_divs, cube.xr.max, false)

    y_divs = [yr]
    y_divs = split_ranges(y_divs, cube.yr.min, true)
    y_divs = split_ranges(y_divs, cube.yr.max, false)

    z_divs = [zr]
    z_divs = split_ranges(z_divs, cube.zr.min, true)
    z_divs = split_ranges(z_divs, cube.zr.max, false)

    x_divs.product(y_divs).product(z_divs).map(&:flatten).map do |new_xr, new_yr, new_zr|
      Cube.new(new_xr, new_yr, new_zr) unless cube.xr.cover?(new_xr) && cube.yr.cover?(new_yr) && cube.zr.cover?(new_zr)
    end.compact
  end
end

def part2(data)
  cubes = []
  data.each do |op, xr, yr, zr|
    puts "#{op} #{xr} #{yr} #{zr} (#{cubes.count})"
    new_cube = Cube.new(xr, yr, zr)
    cubes += cubes.map { |cube| cube.split_cube(new_cube) }.flatten
    cubes << new_cube if op == "on"
  end
  cubes.map(&:size).sum
end

puts <<~END

##########
# Part 1 #
##########
END
# puts "Example: #{part1 parse file "example"}"
# puts "Solution: #{part1 parse file "input"}"

puts <<~END

##########
# Part 2 #
##########
END
puts "Example: #{part2 parse file "example"}"
# puts "Solution: #{part2 parse file "input"}"
