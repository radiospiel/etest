#
#
# Some assertions
module Etest::Assertions
  def assert_not_equal(unexpected, actual)
    assert unexpected != actual, "#{actual} equals #{unexpected}, when it shouldn't"
  end
    
  def assert_respond_to(obj, *args)
    raise ArgumentError, "Missing argument(s)" if args.length < 1
  
    args.reject! { |sym| obj.respond_to?(sym) }
    
    assert args.empty?, "#{obj.inspect} should respond to #{args.map(&:inspect).join(", ")}, but doesn't."
  end

  # returns a list of invalid attributes in a model, as symbols.
  def invalid_attributes(model)                                     #:nodoc:
    model.valid? ? [] : model.errors.instance_variable_get("@errors").keys.map(&:to_sym)
  end
  
  #
  # Verifies that a model is valid. Pass in some attributes to only
  # validate those attributes.
  def assert_valid(model, *attributes)
    if attributes.empty?
      assert(model.valid?, "#{model.inspect} should be valid, but isn't: #{model.errors.full_messages.join(", ")}.")
    else
      invalid_attributes = invalid_attributes(model) & attributes
      assert invalid_attributes.empty?,
        "Attribute(s) #{invalid_attributes.join(", ")} should be valid"
    end
  end

  #
  # Verifies that a model is invalid. Pass in some attributes to only
  # validate those attributes.
  def assert_invalid(model, *attributes)
    assert(!model.valid?, "#{model.inspect} should be invalid, but isn't.")
    
    return if attributes.empty?

    missing_invalids = attributes - invalid_attributes(model)

    assert missing_invalids.empty?,
      "Attribute(s) #{missing_invalids.join(", ")} should be invalid, but are not"
  end

  #
  #
  def assert_valid_xml(*args)
    return unless libxml_installed?
    args.push @response.body if args.empty?
    
    args.each do |xml|
      assert xml_valid?(xml), "XML is not valid: #{xml}"
    end
  end

  def assert_invalid_xml(*args)
    return unless libxml_installed?
    args.push @response.body if args.empty?
    
    args.each do |xml|
      assert !xml_valid?(xml), "XML should not be valid: #{xml}"
    end
  end

  def libxml_installed?
    return @libxml_installed unless @libxml_installed.nil?
    @libxml_installed = begin
      require "libxml"
      true
    rescue LoadError
      STDERR.puts "*** Skipping xml_validation. Please install the 'libxml' gem"
      false
    end
  end
  
  def xml_valid?(xml)
    LibXML::XML::Error.reset_handler
    
    LibXML::XML::Document.io StringIO.new(xml)
    true
  rescue LibXML::XML::Error
    false
  end
  
  def assert_route(uri_path, params)
    assert_recognizes params, uri_path
  end

  def catch_exception_on(&block)
    yield
    nil
  rescue Exception
    $!
  end
  
  def assert_raise(klass, msg=nil, &block)
    ex = catch_exception_on(&block)
    if ex.nil?
      assert false, msg || "Should raise a #{klass} exception, but didn't raise at all"
    else
      assert ex.class.name == klass.name, msg || "Should raise a #{klass} exception, but raised a #{ex.class.name} exception"
    end
  end
  
  def assert_nothing_raised(msg=nil, &block)
    ex = catch_exception_on(&block)
    assert ex.nil?, msg || "Should not raise an exception, but raised a #{ex.class.name} exception"
  end
  
  def assert_raises_kind_of(klass, msg=nil, &block)
    ex = catch_exception_on(&block)
    if ex.nil?
      assert false, msg || "Should raise a #{klass} exception, but didn't raise at all"
    else
      assert ex.is_a?(klass), msg || "Should raise a #{klass} exception, but raised a #{ex.class.name} exception"
    end
  end
  
  def assert_not_nil(v)
    assert !v.nil?, "Should be nil, but is an #{v.class.name} object"
  end

  def assert_file_exist(*paths)
    paths.flatten.each do |path|
      assert File.exist?(path), "Missing file: #{path}"
    end
  end
  
  def assert_file_doesnt_exist(*paths)
    paths.flatten.each do |path|
      assert !File.exist?(path), "File should not exist: #{path}"
    end
  end
  
  def assert_not_equal(unexpected, actual)
    assert unexpected != actual, "#{actual.inspect} should be != #{unexpected.inspect}"
  end

  def assert_not_nil(actual)
    assert !actual.nil?, "#{actual.inspect} should not be nil"
  end

  def assert_nil(actual)
    assert actual.nil?, "#{actual.inspect} should be nil"
  end
end

class MiniTest::Unit::TestCase
  include Etest::Assertions
end

unless defined?(ETEST_TEST)

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
end

