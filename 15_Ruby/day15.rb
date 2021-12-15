require_relative 'priority_queue'

class Location
  attr_reader :weight, :x, :y
  def initialize(weight, x, y)
    @weight = weight
    @x = x
    @y = y
  end

  def get_neighbors(grid, distances)
    return [[0, -1], [-1, 0], [1, 0], [0, 1]].map { |delta| [delta[0] + @x, delta[1] + @y]}
      .select { |point| inGrid(point[0], point[1]) }
      .map { |point| Location.new(distances[@x][@y] + grid[point[0]][point[1]], point[0], point[1])}
  end

  def to_s
    "(#{@weight}, (#{@x}, #{@y}))"
  end
end

def inGrid(x, y) 
  return x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT
end


# PART 1
grid = File.read(ARGV[0]).lines.map{ |line| line.strip.split("").map(&:to_i) }
width = grid.length
height = grid[0].length

# PART 2 - expand input
grid = Array.new(width*5) { |x|
  Array.new(height*5) { |y|
      weight = grid[x % width][y % height] + x/width + y/height
      weight % 10 + weight/10
  }
}
WIDTH = grid.length
HEIGHT = grid[0].length
INFINITY = 1 << 64

priority_queue = PriorityQueue.new
priority_queue << Location.new(0, 0, 0) # Add start location
distances = Array.new(WIDTH){Array.new(HEIGHT, INFINITY)}
distances[0][0] = 0 # set weight of start point to 0

while priority_queue.elements.length > 0
  current = priority_queue.pop
  # Early stopping if end of the cave is reached
  if current == nil || (current.x == WIDTH && current.y == HEIGHT)
    break
  end
  # Creates list of neighbor locations of current with weight equal to distance through current
  current.get_neighbors(grid, distances).each do |neighbor|
    if distances[neighbor.x][neighbor.y] > neighbor.weight
      distances[neighbor.x][neighbor.y] = neighbor.weight
      priority_queue << neighbor
    end
  end
end

puts distances.map { |x| x.join(' ') }
puts "result: #{distances[WIDTH-1][HEIGHT-1]}"