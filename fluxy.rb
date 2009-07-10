require 'rubygems'
#
#$: << "./gems/firewatir-1.6.2/lib"
require 'firewatir'
require 'lib/firewatir_extension'

include FireWatir

@browser = Firefox.new
@browser.goto("file:///#{File.expand_path(File.dirname(__FILE__))}/base_test.html")

#sleep(3)

puts @browser.execute_script "document.getElementById('testDiv').innerHTML = 'set from ruby';"

puts @browser.execute_script("testCall()")
@browser.close unless ENV["FLUXY_KEEP_OPEN"]
