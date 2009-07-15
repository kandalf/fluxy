require 'socket'

module Fluxy
  class Console
    attr_accessor :address, :port

    def initialize(address = "0.0.0.0", port = 9999)
      @descriptors = Array.new
      self.open(@address, @port) 
    end

    def open(address = "0.0.0.0", port = 9999)
      @address = address
      @port = 9999
      @server_socket = TCPServer.new(@address, @port)
      @descriptors << @server_socket
    end

    def close
      @server_socket.close
    end

    def run
      while 1
        #select method waits for events for read, write, exceptions and returns an array of arrays with IO objects where the event ocurred
        sockets = select(@descriptors, nil, nil)
        
        sockets.first.each do |socket|
          #the socket that received data was the server
          if socket == @server_socket
            accept_connection
          else
            #client disconnected
            if socket.eof?
              puts "Client disconnected #{socket.peeraddr[2]} #{socket.peeraddr[1]}"
              socket.close
              @descriptors.delete(socket)
            else
              msg = socket.gets.chomp
              if (msg == "exit_fluxy_console")
                close_connection(socket)
              else
                puts "Message from #{socket.peeraddr[2]}: #{msg}"
                socket.puts "Fluxy Console: I don't care what you say!\n\n"
              end
            end
          end
        end

      end
    end

    protected
    def accept_connection
      client_socket = @server_socket.accept
      puts "Client connected #{client_socket.peeraddr[2]} #{client_socket.peeraddr[1]}"
      @descriptors << client_socket
    end

    def close_connection(socket)
      socket.puts "Disconnecting by request #{socket.peeraddr[2]}"
      socket.close
      @descriptors.delete(socket)
    end
  end
end
