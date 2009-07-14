require 'rubygems'
#
#$: << "./gems/firewatir-1.6.2/lib"
$: << "./lib"
require 'firewatir'
require 'firewatir_extension'
require 'ias_runner'

include Fluxy

@url = "file:///#{File.expand_path(File.dirname(__FILE__))}/base_test.html"

@url = "http://localhost:3000/iasrunner/IASRunner.html"

IASRunner.browse @url
IASRunner.set_message "Set From Fluxy::IASRunner"

IASRunner.exit unless ENV["FLUXY_KEEP_OPEN"]
