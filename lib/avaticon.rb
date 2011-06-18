require 'open-uri'
require 'rubygems'
require 'nokogiri'
require 'json'

class Avaticon
  BASE_PATH = File.dirname(__FILE__)
  DEFAULT_SITEINFO_PATH = File.join(BASE_PATH, 'siteinfo.json')
  attr_accessor :siteinfo

  def initialize opt = {}
    @siteinfo = []
    @tw_id = opt[:tw_id]
    @tw_pw = opt[:tw_pw]
    (opt[:siteinfo_path] || DEFAULT_SITEINFO_PATH).split(/\n/).each do |i|
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
      html = Avaticon.get_html(url, :tw_id => @tw_id, :tw_pw => @tw_pw)
      icon = Nokogiri::HTML(html).at(info['iconImageElement'])
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
      # url + path
      tmp = url.split('/')
      (tmp[0..(tmp.size - 2)] << path).join('/')
    end
  end

  def self.get_html url, opt = {}
    open(url).read
#     if /twitter.com/ === url
#       Avaticon.get_tw_html url, opt
#     else
#       open(url).read
#     end
  end

  def self.get_tw_html url, opt = {}
    require 'mechanize'
    agent = WWW::Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    page = agent.get'http://twitter.com/login'
    login_form = page.forms.find { |i|
      i.action == 'https://twitter.com/sessions'
    }
    login_form.fields.find { |i| i.name == 'session[username_or_email]'}.value = opt[:tw_id]
    login_form.fields.find { |i| i.name == 'session[password]'}.value = opt[:tw_pw]
    login_form.submit
    agent.get(url).body
  end
end

