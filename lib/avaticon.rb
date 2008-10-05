require 'open-uri'
require 'rubygems'
require 'hpricot'
require 'json'

class Avaticon
  BASE_PATH = File.dirname(__FILE__)
  DEFAULT_SITEINFO_PATH = File.join(BASE_PATH, 'siteinfo.json')
  attr_accessor :siteinfo

  def initialize opt = {}
    @siteinfo = []
    (opt[:siteinfo_path] || DEFAULT_SITEINFO_PATH).each do |i|
      load_siteinfo i
    end
  end

  def load_siteinfo path
    JSON.parse(open(path).read).each do |i|
      # 1.9 feature
      # index = @siteinfo.index { |j| j['service_name'] == i['service_name']}
      index = nil
      @siteinfo.each_with_index do |j, ind|
        if j['service_name'] == i['service_name']
          index = ind
          break
        end
      end

      if index
        @siteinfo[index] = i
      else
        @siteinfo.push i
      end
    end
  end

  def get_icon service, user_id
    info = @siteinfo.find { |i| i['service_name'] == service }
    if info
      url = info['iconPageUrl'].gsub('{user_id}', user_id)
      icon = Hpricot(open(url)).at(info['iconImageElement'])
      if icon
        Avaticon.path2url url, icon['src']
      end
    end
  end

  def search_by_url url
    @siteinfo.each do |i|
      m = Regexp.new(i['url']).match(url)
      if m
        return get_icon(i['service_name'], m.to_a[1])
      end
    end
  end

  def services
    @siteinfo.map{ |i| i['service_name'] }
  end

  def self.path2url url, path
    #FIXME
    case path
    when /^http/
      path
    when /^\//
      u = URI.parse(url)
      u.path = path
      u.to_s
    else
      url + path
    end
  end
end

