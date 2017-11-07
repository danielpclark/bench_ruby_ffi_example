require 'test_helper'

class BasenameTest < Minitest::Test
  def setup
    @input = '/home/gumby/work/ruby.rb'
  end

  def test_basename_with_pure_input
    assert_equal FfiExample.basename_with_pure_input(@input), 'ruby.rb'
  end

  def test_basename_with_nil
    assert_equal FfiExample.basename_with_nil(@input), 'ruby.rb'
  end

  def test_file_basename
    assert_equal FfiExample.file_basename(@input), 'ruby.rb'
  end

  # TODO: Get past Ivalid Memory object 
  # def test_basename_with_auto_pointer
  #   assert_equal FfiExample.basename_with_auto_pointer(@input, ''), 'ruby.rb'
  # end

  def test_ruru_basename
    assert_equal RuruExample.allocate.basename(@input, ''), 'ruby.rb'
  end
end
