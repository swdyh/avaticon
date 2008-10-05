# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{avaticon}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["swdyh"]
  s.autorequire = %q{}
  s.date = %q{2008-10-06}
  s.description = %q{A library for getting web service user icon.}
  s.email = %q{}
  s.extra_rdoc_files = ["README.rdoc", "ChangeLog"]
  s.files = ["README.rdoc", "ChangeLog", "Rakefile", "test/avaticon_test.rb", "test/html", "test/html/flickr_kusaker", "test/html/github_kzys", "test/html/hatena_swdyh", "test/html/lastfm_youpy", "test/html/nowa_yuiseki", "test/html/twitter_swdyh", "test/html/wassr_kotoriko", "test/test_helper.rb", "lib/avaticon.rb", "lib/siteinfo.json"]
  s.has_rdoc = true
  s.homepage = %q{http://avaticon.rubyforge.org}
  s.rdoc_options = ["--title", "avaticon documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{avaticon}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{A library for getting web service user icon.}
  s.test_files = ["test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.6"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.6"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.6"])
  end
end
