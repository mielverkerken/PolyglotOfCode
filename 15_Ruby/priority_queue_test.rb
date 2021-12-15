require 'minitest/autorun'
require_relative 'priority_queue'

class Location
    attr_reader :weight, :x, :y
    def initialize(weight, x, y)
      @weight = weight
      @x = x
      @y = y
    end
    def to_s
      "(#{@weight}, (#{@x}, #{@y}))"
    end
  end

class PriorityQueueTest < Minitest::Test
  def setup
    @priority_queue = PriorityQueue.new
  end

  def test_removes_top_element
    @priority_queue << Location.new(2, 0, 0)
    @priority_queue << Location.new(1, 0, 0)
    @priority_queue << Location.new(4, 0, 0)
    
    puts @priority_queue.elements
    assert_equal 1, @priority_queue.pop.weight
    @priority_queue << Location.new(3, 0, 0)

    puts @priority_queue.elements
    assert_equal 2, @priority_queue.pop.weight
    @priority_queue << Location.new(3, 0, 0)
    puts @priority_queue.elements
    assert_equal 3, @priority_queue.pop.weight
    puts @priority_queue.elements
    assert_equal 3, @priority_queue.pop.weight
    puts @priority_queue.elements
    assert_equal 4, @priority_queue.pop.weight
  end
end