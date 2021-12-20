require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n\n").then do |alg, img|
    [
      alg.chars.map { |v| v == "#" ? 1 : 0 },
      img.split("\n").map do |row|
        row.chars.map { |v| v == "#" ? 1 : 0 }
      end
    ]
  end
end

class Image
  attr_reader :image

  def initialize(image)
    @image = image
    @outer = [0]
  end

  def apply(alg)
    new_image = Array.new(image.size + 2) { Array.new(image.first.size + 2) { @outer.first } }
    new_image.each_with_index do |row, ri|
      row.each_with_index do |pixel, ci|
        row[ci] = alg[extract_pixel_val(ri - 1, ci - 1)]
      end
    end

    if alg[0] == 1 && image[0][0] == 0
      @outer = [1]
    elsif alg[511] == 0 && image[0][0] == 1
      @outer = [0]
    end

    @image = new_image
  end

  def extract_pixel_val(r, c)
    result = ""
    (-1..1).to_a.repeated_permutation(2).map do |ro, co|
      ri = r + ro
      ci = c + co
      next @outer unless (0...image.size).cover?(ri) && (0...image.first.size).cover?(ci)

      @image[ri][ci]
    end.join.to_i(2)
  end

  def output_image
    image.map { |r| r.map { |c| c == 1 ? "#" : "." }.join }
  end

  def pixels
    image.sum(&:sum)
  end
end

def part1(data)
  alg, raw_img = data
  Image.new(raw_img).tap { |image| 2.times { image.apply(alg) } }.pixels
end

def part2(data)
  alg, raw_img = data
  Image.new(raw_img).tap { |image| 50.times { image.apply(alg) } }.pixels
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
