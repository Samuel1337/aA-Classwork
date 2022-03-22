class Integer 
  # Integer#hash already implemented for you
end

# class Array
#   def hash 
#     h = 1
#     self.each_with_index do |el, i|
#       h *= (el + i)
#     end
#     h
#   end
# end
  
# class String
#   def hash
#     array = self.split("")
#     array.map! do |char|
#       char.to_sym.object_id
#     end
#     array.hash
#   end
# end

# class Hash
#   # This returns 0 because rspec will break if it returns nil
#   # Make sure to implement an actual Hash#hash method
#   def hash
#     self.values.sort.join("").hash
#   end
# end
  
