module Etest::ComparisonAssertions::Etest
  # I don't know how to test asserts. This, at least, give (fake) C0 coverage
  def test_comparision_assertions
    assert_lt 1, 2
    assert_le 1, 1
    assert_ge 2, 2
    assert_gt 2, 1
    assert_eq 2, 2
    assert_ne 1, 2
  end
end

module Etest::Assertions::Etest
  #
  # this actually tests the existance of an assertion and one successful
  # assertion, nothing less, and nothing more...
  def test_asserts
    assert_respond_to "nsn", :upcase
    assert respond_to?(:assert_invalid)
    assert respond_to?(:assert_valid)
  end

  class TestError < RuntimeError; end
  
  def test_assert_raises_kind_of
    assert_raises_kind_of RuntimeError do 
      raise TestError
    end
  end
  
  def test_assert_file_exist
    assert_file_exist __FILE__
  end
  
  def test_xml
    assert_valid_xml <<-XML
<root>
<p> lkhj </p>
</root>
XML
  
    assert_invalid_xml <<-XML
<root>
<p> lkhj </p>
XML
  end
end

