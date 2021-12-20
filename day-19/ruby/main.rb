require "matrix"
require "pry"

def file(path)
  File.read(File.join(__dir__, path))
end

def parse(data)
  data.split("\n\n").map do |chunk|
    chunk.split("\n")[1..].map do |line|
      line.split(",").map(&:to_i)
    end.map(&Vector.method(:new))
  end
end

  def rotations(coords)
    3.times.flat_map do |axis|
      xyz = coords.to_a .rotate(axis)
      [
        [ xyz[0], xyz[1], xyz[2] ],
        [ xyz[0], xyz[2], -xyz[1] ],
        [ xyz[0], -xyz[2], xyz[1] ],
        [ xyz[0], -xyz[1], -xyz[2] ],
        [ -xyz[0], xyz[2], xyz[1] ],
        [ -xyz[0], xyz[1], -xyz[2] ],
        [ -xyz[0], -xyz[1], xyz[2] ],
        [ -xyz[0], -xyz[2], -xyz[1] ],
      ].map(&Vector.method(:new))
    end
  end

class Scanner
  attr_reader :beacons, :dists

  def initialize(beacon_data = [])
    @beacons = []
    @dists = []
    beacons = beacon_data.map(&Beacon.method(:new)).each(&method(:add_beacon))
  end

  def add_beacon(beacon)
    return if beacons.map(&:coords).include?(beacon.coords)
    beacons << beacon
    dists.each_index do |idx|
      dists[idx] << beacon.dist_to(beacons[idx])
    end
    dists << beacons.map { |b2| beacon.dist_to(b2) }
  end

  def to_s
    beacons.each_with_index do |b, idx|
      "#{b.coords}: #{dists[idx].join(", ")}"
    end
  end

  def find_common_beacons(scanner)
    Hash[dists.flat_map.with_index do |self_dists, self_idx|
      scanner.dists.map.with_index do |other_dists, other_idx|
        [[self_idx, other_idx], self_dists & other_dists - [0.0] ]
      end
    end].transform_values(&:count).sort_by(&:last).last.yield_self do |val|
      return nil if val.last < 11
      val.first
    end
  end

  def to_s
    "Scanner:\n" + beacons.map { |b| "  #{b.inspect}" }.join("\n")
  end

  def inspect
    "Scanner:\n" + beacons.map { |b| "  #{b.inspect}" }.join("\n")
  end

  def rotated_scanners
    beacons.map(&:rotated_beacons).transpose.map do |rot_beacons|
      self.class.new.tap do |result|
        rot_beacons.map(&result.method(:add_beacon))
      end
    end
  end
end

class Beacon
  attr_reader :coords

  def initialize(coords)
    @coords = coords
  end

  def shift(offset)
    @coords += Vector[*offset]
  end

  def -(beacon)
    coords - beacon.coords
  end

  def dist_to(beacon)
    (self - beacon).magnitude.round(2)
  end

  def to_s
    "Beacon[#{3.times.map { |n| coords[n].to_s }.join(", ")}]"
  end

  def inspect
    "Beacon[#{3.times.map do |n|
      coords[n].to_s
    end.join(", ")}]"
  end

  def rotated_beacons
    rotations(coords.to_a).map { |coords| self.class.new(coords) }
  end
end

class ScannerScanner
  attr_reader :scanners, :offsets

  def initialize(scanners)
    @scanners = scanners
    @offsets = [Vector[0, 0, 0]]
  end

  def scan_scanners
    scanners.each do |a|
      merge_scanners(a)
    end while scanners.count > 1
  end

  def merge_scanners(a)
    a_idx = b_idx = b_scan_idx = b_rot_idx = nil
    b = scanners.find.with_index do |b, idx|
      next false if b == a
      b_scan_idx = idx
      a_idx, b_idx = a.find_common_beacons(b)
    end

    return nil if b.nil?

    a_dists = a.dists[a_idx]
    b_dists = b.dists[b_idx]
    shared = (a_dists & b_dists).first { |n| n > 0 }
    a_shared_idx = a_dists.index(shared)
    b_shared_idx = b_dists.index(shared)

    b_rot = b.rotated_scanners.find.with_index do |b_rot, idx|
      offset = a.beacons[a_idx] - b_rot.beacons[b_idx]
      b_rot_idx = idx
      offset == a.beacons[a_shared_idx] - b_rot.beacons[b_shared_idx]
    end

    return nil if b_rot.nil?

    offsets << a.beacons[a_idx] - b_rot.beacons[b_idx]
    b_rot.beacons.each do |beacon|
      beacon.shift(offsets.last)
      a.add_beacon(beacon)
    end

    scanners.delete(b)
  end

  def max_man_dist
    offsets.repeated_combination(2).map do |a, b|
      (a - b).map(&:abs).inject(:+)
    end.max
  end
end

def part1(data)
  ScannerScanner.new(data.map(&Scanner.method(:new))).tap(&:scan_scanners).scanners.first.beacons.count
end

def part2(data)
  ScannerScanner.new(data.map(&Scanner.method(:new))).tap(&:scan_scanners).max_man_dist
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
# puts "Solution: #{part2 parse file "input"}"
