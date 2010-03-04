# Rdockery #

By Chris Didyk

Rdockery probably doesn't need to exist. It creates a single HTML file out of the rdoc files generated in a Rails app. Rdoc has a --one-file flag, but when I tried this, it didn't seem to add all of the content into that file (most notably Source). I was under a time crunch, so instead of wading into Rdoc (whose code I'm not familiar with), I wrote Rdockery.

Rdockery uses Hpricot, so you'll need that gem to use it.

## Usage ##

<pre><code>rdockery _path to rdoc file root_</code></pre>

_path to rdoc file root_ is usually the doc directory of your Rails root. Rdockery creates a file called <code>megadoc.html</code> in _path to rdoc file root_.