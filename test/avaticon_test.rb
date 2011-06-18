$LOAD_PATH.push '.' unless $LOAD_PATH.include? '.'

require File.dirname(__FILE__) + '/test_helper.rb'
require "test/unit"
require 'mocha'

REMOTE_TEST = ENV['REMOTE_TEST'] == 'true'
MOCK_HTML_DIR = File.join 'test', 'html'

class AvaticonTest < Test::Unit::TestCase

  def prepare_stubs service, user_id
    unless REMOTE_TEST
      path = File.join(MOCK_HTML_DIR, [service, user_id].join('_'))
      Avaticon.stubs(:get_html).returns(IO.read(path))
    end
  end

  def test_siteinfo_example_url
    avt = Avaticon.new
    avt.siteinfo.each do |s|
      m = Regexp.new(s['url']).match(s['exampleUrl'])
      assert m
      assert_equal 2, m.to_a.size
    end
  end

  def test_get_icon
    avt = Avaticon.new
    avt.siteinfo.each do |s|
      m = Regexp.new(s['url']).match(s['exampleUrl'])
      service = s['service_name']
      user_id = m.to_a[1]
      prepare_stubs service, user_id
      icon_url = avt.get_icon service, user_id
      assert_equal s['exampleImageUrl'], icon_url
    end
  end

  def test_search_by_url
    avt = Avaticon.new
    s = avt.siteinfo[0]
    m = Regexp.new(s['url']).match(s['exampleUrl'])
    user_id = m.to_a[1]
    prepare_stubs s['service_name'], user_id
    assert_equal s['exampleImageUrl'], avt.search_by_url(s['exampleUrl'])
  end
end

