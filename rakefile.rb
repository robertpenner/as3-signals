require 'rubygems'
require 'sprout'
sprout 'as3'

mxmlc "bin/AS3SignalsRunner.swf" do |t|
  t.input = 'tests/AllTestsRunner.as'
  t.source_path << 'src'
  t.source_path << '../AsUnit4/as3/src'
  t.source_path << '../AsUnit4/as3/lib/as3reflection'
  #t.library_path << 'libs/asunit4-alpha.swc'
  t.gem_version = '3.3.1'
end

desc "Run the Test Harness"
flashplayer :test => 'bin/AS3SignalsRunner.swf'

