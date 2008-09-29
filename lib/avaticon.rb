require 'open-uri'
require 'rubygems'
require 'hpricot'

class Avaticon

  SITEINFO = [
              {
                :name => 'twitter',
                :url => '^http://twitter\.com/([^./]+)',
                :iconPageUrl => 'http://twitter.com/{user_id}',
                :iconImageElement => '//img[@id="profile-image"]',
                :exampleUrl => 'http://twitter.com/swdyh',
                :exampleImageUrl => 'http://s3.amazonaws.com/twitter_production/profile_images/51990802/IMAG8174_bigger.JPG'
              },
              {
                :name => 'wassr',
                :url => '^http://wassr\.jp/user/([^./]+)',
                :iconPageUrl => 'http://wassr.jp/user/{user_id}',
                :iconImageElement => '//div[@class="image"]/a/img',
                :exampleUrl => 'http://wassr.jp/user/kotoriko',
                :exampleImageUrl => 'http://wassr.jp/user/kotoriko/profile_img.png.128.1212746583',
              },
              {
                :name => 'hatena',
                :url => '^http://[^.]+\.hatena.ne\.jp/([^./]+)',
                :iconPageUrl => 'http://www.hatena.ne.jp/{user_id}/',
                :iconImageElement => '//img[@class="profile-image"]',
                :exampleUrl => 'http://www.hatena.ne.jp/swdyh/',
                :exampleImageUrl => 'http://www.hatena.ne.jp/users/sw/swdyh/profile.gif',
              },
              {
                :name => 'nowa',
                :url => '^http://([^./]+)\.nowa\.jp/profile/',
                :iconPageUrl => 'http://{user_id}.nowa.jp/profile/',
                :iconImageElement => '//div[@class="basic-information"]/img',
                :exampleUrl => 'http://yuiseki.nowa.jp/profile/',
                :exampleImageUrl => 'http://image.nowa.jp/icon/00000011c1be13a9decc002ed6f1505814cae91870a1759-o.jpg',
              },
              {
                :name => 'lastfm',
                :url => '^http://www\.lastfm\.jp/user/([^./]+)',
                :iconPageUrl => 'http://www.lastfm.jp/user/{user_id}',
                :iconImageElement => '//span[@class="userImage"]/img',
                :exampleUrl => 'http://www.lastfm.jp/user/youpy',
                :exampleImageUrl => 'http://userserve-ak.last.fm/serve/126/936583.jpg',
              },
              {
                :name => 'flickr',
                :url => '^http://www\.flickr\.com/people/([^./]+)/',
                :iconPageUrl => 'http://www.flickr.com/people/{user_id}/',
                :iconImageElement => '//td[@class="Buddy"]/a/img',
                :exampleUrl => 'http://www.flickr.com/people/kusaker/',
                :exampleImageUrl => 'http://farm1.static.flickr.com/128/buddyicons/39255132@N00.jpg?1169585056#39255132@N00',
              },
              {
                :name => 'github',
                :url => '^http://github\.com/([^./]+)',
                :iconPageUrl => 'http://github.com/{user_id}',
                :iconImageElement => '//div[@class="identity"]/img',
                :exampleUrl => 'http://github.com/kzys',
                :exampleImageUrl => 'http://www.gravatar.com/avatar/7828b45f8396aa361d85cead01fd99ca?s=50&d=http%3A%2F%2Fgithub.com%2Fimages%2Fgravatars%2Fgravatar-50.png',
              },
=begin
              {
                :name => '',
                :url => '',
                :iconPageUrl => '',
                :iconImageElement => '',
                :exampleUrl => '',
                :exampleImageUrl => '',
              },
=end
             ]

  def self.get_icon service, user_id
    info = SITEINFO.find { |i| i[:name] == service }
    if info
      url = info[:iconPageUrl].gsub('{user_id}', user_id)
      icon = Hpricot(open(url)).at(info[:iconImageElement])
      if icon
        path2url url, icon['src']
      end
    end
  end

  def self.search_by_url url
    SITEINFO.each do |i|
      m = Regexp.new(i[:url]).match(url)
      if m
        return get_icon(i[:name], m.to_a[1])
      end
    end
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

  def self.services
    SITEINFO.map{ |i| i[:name] }
  end
end

