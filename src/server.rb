require 'socket'
require_relative 'thread_pool.rb'
require_relative 'job.rb'
require_relative 'hello_world.rb'
require_relative 'hello_me.rb'
require_relative 'raise_exception.rb'

PORT = 2000
puts "Listening on #{ PORT }...\n"

class Server
  def initialize
    server = TCPServer.open(PORT)
    @jobs = Queue.new
    pool=ThreadPool.new(@jobs)
    loop do
      Thread.start(server.accept) do |socket|
        puts "client connected"
        until socket.closed? do 
          request = socket.gets 
          method, entry2, entry3, entry4 = request.split        
          if method.eql? 'exit'
            socket.puts 'closing..'
            puts "client disconnected"
            socket.close()
          elsif method.eql? 'postpone_job'
            pool.postpone_job(entry2.to_i, entry3.to_i, socket)
          else
            case entry2
              #when is number
              when /^[0-9]+$/
                params = entry4
                seconds = entry2
                jobclass = entry3
                case jobclass
                  when 'HelloWorld'
                    job = HelloWorld.new()
                  when 'HelloMe'
                    job = HelloMe.new()
                  when 'RaiseException'
                    job = RaiseException.new()
                else
                    socket.puts 'Job not found'
                end
              when 'HelloWorld'
                job = HelloWorld.new()
                jobclass = entry2
                params = entry3
              when 'HelloMe'
                job = HelloMe.new()
                jobclass = entry2
                params = entry3
              when 'RaiseException'
                job = RaiseException.new()
                jobclass = entry2
                params = entry3
            else
                job = nil
                socket.puts 'Job not found'          
            end

            if seconds.nil?
              job.handle_request(socket, method, params, pool, @jobs, 0) unless job.nil?
            elsif method.eql? 'perform_in'
              job.perform_in(socket, params, seconds.to_i, pool, @jobs, 0) unless job.nil?
            else
              socket.puts "method #{method} not valid, try perform_in instead"
            end
            seconds = nil
          end
        end
      end
    end
  end
end
