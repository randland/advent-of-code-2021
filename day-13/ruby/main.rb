require "set"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n\n").map { |chunk| chunk.split("\n") }.yield_self do |dots, folds|
    [
      dots.map { |dot| dot.split(",").map(&:to_i) }.to_set,
      folds.map { |fold| fold.split(" ").last.split("=") }.map do |dir, val|
        [dir, val.to_i]
      end
    ]
  end
end

class Paper
  attr_reader :dots

  def initialize(dots)
    @dots = dots
  end

  def fold_x(val)
    new_dots = Set.new
    dots.each do |x, y|
      new_x = x > val ? val * 2 - x : x
      new_dots << [new_x, y]
    end
    self.class.new(new_dots)
  end

  def fold_y(val)
    new_dots = Set.new
    dots.each do |x, y|
      new_y = y > val ? val * 2 - y : y
      new_dots << [x, new_y]
    end
    self.class.new(new_dots)
  end

  def to_s
    "\n" + (0..h).map do |y|
      (0..w).map do |x|
        dots.include?([x, y]) ? "#" : "."
      end.join
    end.join("\n") + "\nCount: #{dots.count}"
  end
end

def part1(data)
  data.yield_self do |paper, folds|
    Paper.new(paper).send("fold_#{folds.first.first}", folds.first.last)
  end
end

def part2(data)
  data.yield_self do |paper, folds|
    folds.inject(Paper.new(paper)) do |p, (dir, val)|
      p.send("fold_#{dir}", val)
    end
  end
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
