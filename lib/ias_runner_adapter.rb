require 'rubygems'
require 'firewatir'
require 'firewatir_extension'
require 'hash_extension'

module Fluxy
  module IASRunner
    class Adapter
     attr_accessor :runner_object

      def browser
        @browser ||= FireWatir::Firefox.new
      end

      def execute_js(source)
        browser.execute_script source
      end
  
      def close_browser
        browser.close
      end
    end

    @@adapter ||= Adapter.new

    def self.browse(url)
      @@adapter.browser.goto url
    end

    def self.execute(selector, method, params)
      jssh_command = "#{runner_js_object}.execute('#{selector}', '#{method}', #{parse_params(params)}"
      @@adapter.execute_js jssh_command
    end

    def self.set_message(message)
       @@adapter.execute_js "#{runner_js_object}.setMessage('#{message}')"
    end
 
    def self.load_application(swf_url)
      @@adapter.execute_js "#{runner_js_object}.loadApplication('#{swf_url}')"   
    end

    def self.click(selector)
      @@adapter.execute_js "#{runner_js_object}.click(#{selector})"
    end

    def self.exit
      @@adapter.close_browser
    end

    protected
    def self.runner_js_object
      "document.getElementById('IASRunner')"
    end

    def parse_params(params)
      ret_params = ''
      params.each do |param|
        if param.is_a?(Array)
          ret_params << "[#{quotify_array(param).join(",")}]"
        elsif params.is_a?(Hash)
          ret_params << "{#{quotify_hash(param).join(",")}}"
        end
      end
      ret_params
    end

    def quotify_array(array)
      quotified = []
      array.each do |elem|
        case elem.class.name
          when /String/
            quotified << "'#{elem}'"
          when /Array/
            quotified << "[#{quotify_array(elem).join(",")}]"
          when /Hash/
            quotified << "{#{quotify_hash(elem)}}"
          else
            quotified << elem
        end
        quotified
      end
    end

    def quotify_hash(hash)
      quotified = {}
      hash.each_pair do |key, value|
        case value.class.name
          when /String/
            quotified[key] = "'#{value}'"
          when /Array/
            quotified[key] = "[#{quotify_array(value).join(",")}]"
          when /Hash/
            quotified[key] = "{#{quotify_hash(value).join(",")}}"
          else
            quotified[key] = value
        end
      end
      quotified
    end
  end
end
