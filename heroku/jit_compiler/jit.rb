def find_all(array)
  array.select { |x| x > 5 }
end

array = Array.new(100) { |i| rand(i) }

20_000.times do
  find_all array
end
