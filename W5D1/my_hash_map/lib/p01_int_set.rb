require "byebug"


class MaxIntSet 
  attr_reader :store, :max
  def initialize(max)
    @store = Array.new(max, false)
    @max = max
  end
  
  def insert(num)
    if is_valid?(num)
      store[num] = true
      return true
    end
    false
  end
  
  def remove(num)
    if is_valid?(num)
      store[num] = false
    end
  end
  
  def include?(num)
    if is_valid?(num)
      store[num] == true
    end
  end
  
  private
  
  def is_valid?(num)
    if !num.between?(0,max)
      raise 'Out of bounds'
      return false
    end
    true
  end
  
  def validate!(num)
  end
end



class IntSet
  attr_reader :store
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    i = num % store.length
    store[i] << num
  end

  def remove(num)
    i = num % store.length
    store[i].delete(num)
  end

  def include?(num)
    store.flatten.include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_accessor :count, :store

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    i = num % store.length
    if !store[i].include?(num)
      store[i] << num 
      @count += 1
      resize! if store.length <= count
    end
  end

  def remove(num)
    i = num % store.length
    if store[i].include?(num)
      store[i].delete(num)
      @count -= count
    end
  end

  def include?(num)
    store.flatten.include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end

  def resize!
    if store.length <= count
      new_size = store.length * 2
      new_store = Array.new(new_size) { Array.new }
      # debugger
      store.flatten.each do |item|
        i = item % new_store.length
        new_store[i] << item
      end
      self.store = new_store
    end
  end
end
