module FireWatir
  class Firefox
    def execute_script(js_source)
      jssh_command = "var win_all = getWindows(); var target_win = win_all[win_all.length - 1]; target_win.content.#{js_source}"
      js_eval jssh_command
    end
  end
end
