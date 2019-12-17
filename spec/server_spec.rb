require 'socket'
require 'spec_helper.rb'
require_relative '../src/server.rb'

Thread.new do
  Server.new
end
describe 'Server class' do
  let(:socket) { TCPSocket.new 'localhost', 2000 }

  context 'Initializing server' do

    context 'Client connects' do

      subject do
        socket
        sleep(1)
      end

      it 'Returns client connected' do
        expect{ subject }.to output(/client connected/).to_stdout
        socket.puts('exit')
        sleep(1)
      end

      context 'Client disconnects' do

        subject do
          socket.puts('exit')
          sleep(1)
        end

        it 'Returns client disconnected' do
          expect{ subject }.to output(/client disconnected/).to_stdout
          socket.puts('exit')
          sleep(1)        
        end
      end
    end
  end
end