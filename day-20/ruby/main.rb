require "set"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n\n").then do |alg, img|
    [alg, img.split("\n").map { |row| row.chars }]
  end
end

class Image
  attr_reader :image, :max_iter, :pad

  def initialize(image, max_iter)
    w = image.first.size
    @max_iter = max_iter
    @pad = 3 * max_iter
    @image = [
      Array.new(pad) { ["."] * (pad * 2 + w) },
      image.map { |row| ["."] * pad + row + ["."] * pad },
      Array.new(pad) { ["."] * (pad * 2 + w)}
    ].flatten(1)
  end

  def apply(alg)
    new_image = Array.new(image.size) { Array.new(image.first.size) { "." } }
    new_image.each_with_index do |row, ri|
      row.each_with_index do |pixel, ci|
        row[ci] = alg[extract_pixel_val(ri, ci)]
      end
    end
    @image = new_image
  end

  def extract_pixel_val(r, c)
    result = ""
    (-1..1).to_a.repeated_permutation(2).map do |ro, co|
      ri = r + ro
      ci = c + co
      next "0" unless (0...image.size).cover?(ri) && (0...image.first.size).cover?(ci)

      @image[ri][ci] == "#" ? "1" : "0"
    end.join.to_i(2)
  end

  def output_image
    true_pad = pad - max_iter
    @image[true_pad...-true_pad].map { |row| row[true_pad...-true_pad] }
  end
end

def part1(data)
  alg, raw_img = data
  Image.new(raw_img, 2).tap do |image|
    2.times { image.apply(alg) }
  end.output_image.flatten.count("#")
end

def part2(data)
  alg, raw_img = data
  Image.new(raw_img, 50).tap do |image|
    50.times { image.apply(alg) }
  end.output_image.flatten.count("#")
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
