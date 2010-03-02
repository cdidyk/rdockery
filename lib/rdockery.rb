require 'rubygems'
require 'hpricot'

module Rdockery
  def self.megadoc rdoc_root
    megadoc = Megadoc.new rdoc_root
    megadoc.generate
    megadoc
  end

  class Megadoc
    def initialize rdoc_root
      @rdoc_root = rdoc_root
    end

    def generate
      File.open "#{@rdoc_root}/megadoc.html", "w" do |f|
        f.puts opening
        f.puts content_from('files')
        f.puts content_from('classes')
        f.puts closing
      end
    end

    def contents
      File.exists?("#{@rdoc_root}/megadoc.html") ? File.read("#{@rdoc_root}/megadoc.html") : nil
    end

    def content_from dir
      Dir.glob("#{@rdoc_root}/app/#{dir}/**/*.html").inject("") do |output, entry|
        File.open entry do |f|
          doc = Hpricot(f)
          (doc/"body > div:not(#validator-badges)").each do |content|
            output << content.to_html
          end
          output
        end
      end
    end

    def opening
      <<-HERE
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title>Rails Application Document</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link rel="stylesheet" href="app/rdoc-style.css" type="text/css" media="screen" />
</head>
<body>
HERE
    end

    def closing
      <<-HERE
</body>
</html>
HERE
    end
  end
end
