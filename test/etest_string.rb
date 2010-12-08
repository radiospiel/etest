module String::Etest
  def test_camelize
    assert_equal "x", "X".underscore
    assert_equal "xa_la_nder", "XaLaNder".underscore
  end

  def test_underscore
    assert_equal "X", "x".camelize
    assert_equal "XaLaNder", "xa_la_nder".camelize
  end
end
