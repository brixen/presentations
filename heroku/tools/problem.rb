class Problem
  def big(a)
    a * 2
  end

  def small(a)
    a ** 2
  end
end

x = Problem.new
puts x.big(3) > x.small(3)
