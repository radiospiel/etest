module Etest::ComparisonAssertions
  def assert_lt(p1, p2)
    assert(p1 < p2, "#{p1.inspect} should be less than #{p2.inspect} but is not")
  end

  def assert_le(p1, p2)
    assert(p1 <= p2, "#{p1.inspect} should be less than or equal #{p2.inspect} but is not")
  end

  def assert_ge(p1, p2)
    assert(p1 >= p2, "#{p1.inspect} should be greater than or equal #{p2.inspect} but is not")
  end

  def assert_gt(p1, p2)
    assert(p1 > p2, "#{p1.inspect} should be greater than #{p2.inspect} but is not")
  end

  # for reasons of API completeness and orthogonality only.

  def assert_eq(p1, p2)
    assert_equal(p1, p2)
  end

  def assert_ne(p1, p2)
    assert_not_equal(p1, p2)
  end
end

class MiniTest::Unit::TestCase
  include ::Etest::ComparisonAssertions
end
