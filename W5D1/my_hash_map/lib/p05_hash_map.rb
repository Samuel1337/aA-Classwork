require_relative 'p04_linked_list'
require "byebug"

class HashMap
include Enumerable
  attr_accessor :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    store.each do |bucket| 


      return true if !bucket.first.nil? && bucket.include?(key)
    end
    false
  end

  def set(key, val)
    
  end

  def get(key)
    value = nil
    store.each do |bucket|
      if bucket.include?(key)
        value = bucket.get(key)
        break
      end
    end
    value
  end

  def delete(key)
  end

  def each
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
  end
end
