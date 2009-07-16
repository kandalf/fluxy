require 'socket'

module Fluxy
  class Receiver
    attr_accessor :address, :port, :running

    def initialize(address = "0.0.0.0", port = 9999)
      @descriptors = Array.new
      @ias_messages = {}
      @running = false
      @address = address
      @port = port
    end

 
    def start
      self.open(@address, @port)
      @running = true
      run
      #loop do  
        #Thread.start(@server_socket.accept) do |s|  
          #print(s, " is accepted\n")  
          #s.write(Time.now)  
          
          #while !s.eof? && l = s.gets 
            #puts l
          #end

          #print(s, " is gone\n")  
          ##s.close  
        #end  
      #end  
    end

    def stop
      @running = false
      close
    end

    protected
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
      while @running
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
              puts msg
              #@console.log "[RECEIVER - #{Time.now}] Received Message: #{msg}"
              max_bytes = msg.split(": ")[1]
              content = ''
              socket.flush
              socket.read(max_bytes.to_i, content)
              puts "Content: #{content}"
              socket.puts "<ack />"
              close_connection(socket)
            end
          end
        end

      end
    end

    def accept_connection
      client_socket = @server_socket.accept
      puts "Client connected #{client_socket.peeraddr[2]} #{client_socket.peeraddr[1]}"
      @descriptors << client_socket
    end

    def close_connection(socket, message = nil)
      msg = "Disconnecting by request #{socket.peeraddr[2]}" unless message
      #socket.puts msg
      socket.flush
      socket.close
      @descriptors.delete(socket)
    end

    def process_message(msg)
      puts "Message: #{msg}"
    end
  end
end
