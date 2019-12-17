require 'spec_helper.rb'
require 'socket'

Thread.new do
  Server.new
end
describe 'Client usage' do
  let(:job)     { HelloWorld.new }
  let(:socket) { TCPSocket.new 'localhost', 2000 }

  context 'Enter exit command' do
    
    subject! do
      socket.puts('exit')
    end
      

    it 'Return message closing..' do
      subject
      expect(socket.gets).to match /closing../
    end

  end

  context 'Enter postpone_job command' do

    context 'Postponing job 1 10 seconds' do

      subject do
        socket.puts('postpone_job 1 10')
      end

      it 'Returns Job 1 postponed 10 seconds, then performing the job' do
        subject
        expect(socket.gets).to match /Job 1 postponed 10 seconds/
        socket.puts('perform_now HelloWorld')
        expect(socket.gets).to match /Job 1 is waiting 10 seconds to run/
        expect(socket.gets).to match /Hello World:/
        socket.puts('exit')
      end
    end
      
  end

  context 'Enter perform_now command' do

    context 'With HelloWorld job' do

      context 'With params: Hello' do
    
        subject do
          socket.puts('perform_now HelloWorld Hello')
        end      

        it 'Returns Hello World: Hello' do
          subject
          expect(socket.gets).to match /Hello World: Hello/
          socket.puts('exit')
        end
      end

      context 'With params: Other_param' do
    
        subject do
          socket.puts('perform_now HelloWorld Other_param')
          end     

        it 'Returns Hello World: Other_param' do
          subject
          expect(socket.gets).to match /Hello World: Other_param/
          socket.puts('exit')
        end
      end

      context 'With no params' do
    
        subject do
          socket.puts('perform_now HelloWorld')
        end
      
        it 'Returns Hello World:' do
          subject
          expect(socket.gets).to match /Hello World:/
          socket.puts('exit')
        end
      end      
    end

    context 'With HelloMe job' do

      context 'With params: Nahuel' do
    
        subject do
          socket.puts('perform_now HelloMe Nahuel')
        end      

        it 'Returns Hello Nahuel' do
          subject
          expect(socket.gets).to match /Hello Nahuel/
          socket.puts('exit')
        end
      end

      context 'With params: Other_param' do
    
        subject do
          socket.puts('perform_now HelloMe Other_param')
        end

        it 'Returns Hello Other_param' do
          subject
          expect(socket.gets).to match /Hello Other_param/
          socket.puts('exit')
        end
      end

      context 'With no params' do
    
        subject do
          socket.puts('perform_now HelloMe')
        end      

        it 'Returns Hello World:' do
          subject
          expect(socket.gets).to match /Hello/
          socket.puts('exit')
        end
      end

      context 'With invalid job' do

        subject do
          socket.puts('perform_now invalid_job')
        end      
  
        it 'Returns Job not found' do
          subject
          expect(socket.gets).to match /Job not found/
          socket.puts('exit')
        end
      end
    end    
  end

  context 'Enter perform_later command' do

    context 'With HelloWorld job' do

      context 'With params: Hello' do
    
        subject do
          socket.puts('perform_later HelloWorld Hello')
        end      

        it 'Returns Job scheduled and later Hello World: Hello' do
          subject
          expect(socket.gets).to match /Job [0-9]+ scheduled/
          expect(socket.gets).to match /Hello World: Hello/
          socket.puts('exit')
        end
      end

      context 'With params: Other_param' do
    
        subject do
          socket.puts('perform_later HelloWorld Other_param')
        end      

        it 'Returns Job scheduled and later Hello World: Other_param' do
          subject
          expect(socket.gets).to match /Job [0-9]+ scheduled/
          expect(socket.gets).to match /Hello World: Other_param/
          socket.puts('exit')
        end
      end

      context 'With no params' do
    
        subject do
          socket.puts('perform_later HelloWorld')
        end      

        it 'Returns Job scheduled and later Hello World:' do
          subject
          expect(socket.gets).to match /Job [0-9]+ scheduled/
          expect(socket.gets).to match /Hello World:/
          socket.puts('exit')
        end
      end      
    end

    context 'With HelloMe job' do

      context 'With params: Nahuel' do
    
        subject do
          socket.puts('perform_later HelloMe Nahuel')
        end      

        it 'Returns Job scheduled and later Hello Nahuel' do
          subject
          expect(socket.gets).to match /Job [0-9]+ scheduled/
          expect(socket.gets).to match /Hello Nahuel/
          socket.puts('exit')
        end
      end

      context 'With params: Other_param' do
    
        subject do
          socket.puts('perform_later HelloMe Other_param')
        end      

        it 'Returns Job scheduled and later Hello Other_param' do
          subject
          expect(socket.gets).to match /Job [0-9]+ scheduled/
          expect(socket.gets).to match /Hello Other_param/
          socket.puts('exit')
        end
      end

      context 'With no params' do
    
        subject do
          socket.puts('perform_later HelloMe')
        end      

        it 'Returns Job scheduled and later Hello' do
          subject
          expect(socket.gets).to match /Job [0-9]+ scheduled/
          expect(socket.gets).to match /Hello/
          socket.puts('exit')
        end
      end  
    end

    context 'With invalid job' do

      subject do
        socket.puts('perform_later invalid_job')
      end

      it 'Returns Job not found' do
        subject
        expect(socket.gets).to match /Job not found/
        socket.puts('exit')
      end
    end
  end

  context 'Enter perform_in command' do

    context 'With no seconds parameter' do

      subject do
        socket.puts('perform_in HelloWorld Hello')
      end    

      it 'Returns method perform_in not found' do
        subject
        expect(socket.gets).to match /method perform_in not found/
        socket.puts('exit')
      end
    end

    context 'With valid seconds parameter' do

      context 'With HelloWorld job' do

        context 'With params: Hello' do
      
          subject do
            socket.puts('perform_in 5 HelloWorld Hello')
          end        

          it 'Returns The job will be scheduled in 5 seconds, then Job scheduled and later Hello World: Hello' do
            subject
            expect(socket.gets).to match /The job will be scheduled in 5 seconds/
            expect(socket.gets).to match /Job [0-9]+ scheduled/
            expect(socket.gets).to match /Hello World: Hello/
            socket.puts('exit')
          end
        end

        context 'With params: Other_param' do
      
          subject do
            socket.puts('perform_in 5 HelloWorld Other_param')
          end

          it 'Returns The job will be scheduled in 5 seconds, then Job scheduled and later Hello World: Other_param' do
            subject
            expect(socket.gets).to match /The job will be scheduled in 5 seconds/
            expect(socket.gets).to match /Job [0-9]+ scheduled/
            expect(socket.gets).to match /Hello World: Other_param/
            socket.puts('exit')
          end
        end

        context 'With no params' do
      
          subject do
            socket.puts('perform_in 5 HelloWorld')
          end

          it 'Returns The job will be scheduled in 5 seconds, then Job scheduled and later Hello World:' do
            subject
            expect(socket.gets).to match /The job will be scheduled in 5 seconds/
            expect(socket.gets).to match /Job [0-9]+ scheduled/
            expect(socket.gets).to match /Hello World:/
            socket.puts('exit')
          end
        end           
      end

      context 'With HelloMe job' do

        context 'With params: Nahuel' do
      
          subject do
            socket.puts('perform_in 5 HelloMe Nahuel')
          end

          it 'Returns The job will be scheduled in 5 seconds, then Job scheduled and later Hello Nahuel' do
            subject
            expect(socket.gets).to match /The job will be scheduled in 5 seconds/
            expect(socket.gets).to match /Job [0-9]+ scheduled/
            expect(socket.gets).to match /Hello Nahuel/
            socket.puts('exit')
          end
        end

        context 'With params: Other_param' do
      
          subject do
            socket.puts('perform_in 5 HelloMe Other_param')
          end

          it 'Returns The job will be scheduled in 5 seconds, then Job scheduled and later Hello Other_param' do
            subject
            expect(socket.gets).to match /The job will be scheduled in 5 seconds/
            expect(socket.gets).to match /Job [0-9]+ scheduled/
            expect(socket.gets).to match /Hello Other_param/
            socket.puts('exit')
          end
        end

        context 'With no params' do
      
          subject do
            socket.puts('perform_in 5 HelloMe')
          end        

          it 'Returns The job will be scheduled in 5 seconds, then Job scheduled and later Hello' do
            subject
            expect(socket.gets).to match /The job will be scheduled in 5 seconds/
            expect(socket.gets).to match /Job [0-9]+ scheduled/
            expect(socket.gets).to match /Hello/
            socket.puts('exit')
          end
        end
      end

      context 'With invalid job' do

        subject do
          socket.puts('perform_in 5 invalid_job')
        end      
  
        it 'Returns Job not found' do
          subject
          expect(socket.gets).to match /Job not found/
          socket.puts('exit')
        end
      end

      context 'With misspelled method perform_in' do

        subject do
          socket.puts('perform_inn 5 HelloMe')
        end

        it 'Returns method perform_inn not valid, try perform_in instead' do
          subject
          expect(socket.gets).to match /method perform_inn not valid, try perform_in instead/
          socket.puts('exit')
        end
      end
    end  
  end

  context 'With perform_now RaiseException job' do

    subject do
      socket.puts('perform_now RaiseException job')
    end

    it 'Fails 3 times and then discards the job' do
      subject
      expect(socket.gets).to match(/Job [0-9]+ failed 1 times, executing again in 60 seconds/)
      expect(socket.gets).to match(/Job [0-9]+ failed 2 times, executing again in 60 seconds/)
      expect(socket.gets).to match(/Job [0-9]+ failed 3 times, discarding../)
      socket.puts('exit')
    end
  end

  context 'With invalid method' do

    subject do
      socket.puts('perform HelloMe')
    end

    it 'Returns method perform not found' do
      subject
      expect(socket.gets).to match /method perform not found/
      socket.puts('exit')
    end
  end
end
