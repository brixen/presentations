require 'link'


def chain(tail, i)
  link = Link.new
  if i % 1_000 == 0
    link.chain tail
    tail = link
  end
  tail
end

Benchmark.bmbm do |x|
  x.report do
    tail = Link.new
    100_000_000.times do |i|
      tail = work(tail, i)
    end
  end
end
