def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  ([0] * 9).tap do |fish_count|
    data.split(",").map(&:to_i).each { |age| fish_count[age] += 1 }
  end
end

def spawn(fish)
  fish[7] += fish[9] = fish[0]
  fish.shift
end

def part1(fish)
  80.times { spawn(fish) }
  fish.sum
end

def part2(fish)
  256.times { spawn(fish) }
  fish.sum
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
