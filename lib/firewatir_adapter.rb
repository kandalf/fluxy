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
  end
end

