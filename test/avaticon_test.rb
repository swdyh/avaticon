require File.dirname(__FILE__) + '/test_helper.rb'

require "test/unit"
require 'mocha'

REMOTE_TEST = ENV['REMOTE_TEST'] == 'true'
MOCK_HTML_DIR = File.join 'test', 'html'

class AvaticonTest < Test::Unit::TestCase

  def prepare_stubs service, user_id
    unless REMOTE_TEST
      path = File.join(MOCK_HTML_DIR, [service, user_id].join('_'))
      OpenURI.stubs(:open_uri).returns(IO.read(path))
    end
  end

  def test_siteinfo_example_url
    Avaticon::SITEINFO.each do |s|
      m = Regexp.new(s[:url]).match(s[:exampleUrl])
      assert m
      assert_equal 2, m.to_a.size
    end
  end

  def test_get_icon
    Avaticon::SITEINFO.each do |s|
      m = Regexp.new(s[:url]).match(s[:exampleUrl])
      service = s[:name]
      user_id = m.to_a[1]
      prepare_stubs service, user_id
      icon_url = Avaticon.get_icon service, user_id
      assert_equal s[:exampleImageUrl], icon_url
    end
  end

  def test_search_by_url
    s = Avaticon::SITEINFO[0]
    m = Regexp.new(s[:url]).match(s[:exampleUrl])
    user_id = m.to_a[1]
    prepare_stubs s[:name], user_id
    assert_equal s[:exampleImageUrl], Avaticon.search_by_url(s[:exampleUrl])
  end
end

