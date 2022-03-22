require "byebug"

class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val 
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    self.next.prev = self.prev 
    self.prev.next = self.next
  end
end

class LinkedList
  include Enumerable

  attr_accessor :head, :tail

  def initialize
    @head = Node.new(nil, nil)
    @tail = Node.new(nil, nil)
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    self.each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    return head.next if head.next != tail
    nil
  end

  def last
    return tail.prev if tail.prev != head
    nil
  end

  def empty?
    tail.prev == head && head.next == tail
  end

  def get(key)
    self.each { |node| return node.val if node.key == key }
    nil
  end
  
  def include?(key)
    !get(key).nil?
  end
  
  def append(key, val)
    node = Node.new(key,val)
    pointer = tail.prev
    tail.prev = node
    node.prev = pointer
    node.next = tail
    pointer.next = node
    
  end
  
  def update(key, val)
    self.each { |node| node.val = val if !node.nil? && node.key == key }
  end

  def remove(key)
    current_node = nil
    self.each { |node| current_node = node if !node.nil? && node.key == key }
    current_node.remove
  end

  def each(&prc)
    node = head
    until node == last
      node = node.next
      prc.call(node)
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    self.inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end