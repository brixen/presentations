require "benchmark"
require "link"

def report
  puts `ps -p #{Process.pid} -o rss=''`
end

def chain(left, right)
  left.right = right
  right.left = left
end

def work
  tail = Link.new

  100_000_000.times do |i|
    link = Link.new

    if i % 100 == 0
      chain tail, link
      tail = link
    end

    report if i % 10_000_000 == 0
  end
end

Benchmark.bmbm do |x|
  x.report do
    work
  end
end
