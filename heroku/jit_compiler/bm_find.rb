require "benchmark"

def find(array)
  100_000.times do
    array.select { |x| x > 5 }
  end
end

Benchmark.bmbm do |x|
  array = Array.new(100) { |i| rand(i) }

  x.report do
    find array
  end
end
