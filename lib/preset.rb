# -*- encoding: utf-8 -*-
@plugins = Setting.instance.plugin_dir
@slides = Setting.instance.slide_dir
@chapters = "#{@slides}/chapters"
@chapters_rb = "#{@chapters}.rb"

# slides/chapters.rb必須

raise IOError, "can't find #{@chapters_rb}" unless File.exist?(@chapters_rb)

# プラグインの検索・plugins.rbに書き込み
File.open("tmp/plugins.rb", "w"){|f|
  Dir.glob("#{@plugins}/*.rb") { |filename|
    f.puts "require '#{filename.gsub(/\.rb\Z/, '')}'"
  }
}

# スライドの検索・requires.rbに書き込み
cnt = 0
File.open("tmp/requires.rb", "w"){|f|
  Dir.glob("#{@slides}/*.rb") { |filename|
    next if filename =~ /^#{@chapters_rb}/
    f.puts "require '#{filename.gsub(/\.rb\Z/, '')}'"
    cnt += 1
  }
  f.puts "require '#{@chapters}'"
}

raise IOError, "can't find chapter file!" unless cnt > 0
