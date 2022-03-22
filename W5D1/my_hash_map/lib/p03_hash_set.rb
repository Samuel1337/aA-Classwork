require "byebug"

class HashSet
  attr_accessor :store, :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    i = key.hash % num_buckets
    @count += 1
    store[i] << key 
    resize! if count > num_buckets
  end
  
  def include?(key)
    store.each do |arr|
      return true if arr.include?(key)
    end
    false
  end
  
  def remove(key)
    i = key.hash % num_buckets
    if include?(key)
      store[i].delete(key)
      self.count -= 1
    end 
  end
  
  private
  
  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end
  
  def num_buckets
    @store.length
  end
  
  def resize!
    new_arr = Array.new(num_buckets*2) { Array.new }
    
    store.each do |item|
      i = item.hash % num_buckets
      new_arr[i] << item
    end

    self.store = new_arr
  end
end
