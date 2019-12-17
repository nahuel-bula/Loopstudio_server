require 'socket'
require 'spec_helper.rb'
require_relative '../src/job.rb'
require_relative '../src/hello_world.rb'
require_relative '../src/hello_me.rb'
require_relative '../src/raise_exception.rb'
require_relative '../src/thread_pool.rb'
require_relative '../src/server.rb'

Thread.new do
  Server.new
end
describe 'Job class' do
  let(:socket) { TCPSocket.new 'localhost', 2000 }
  let(:jobs) { Queue.new }
  let(:pool) { ThreadPool.new(jobs) }
  let(:tries) { 0 }

  context 'With HelloWorldJob and param Hello' do

    let!(:job)    { HelloWorld.new }
    let(:params) { 'Hello' }

    context 'With method perform_now' do

      let(:method) { 'perform_now' }
      subject do
        job.handle_request(socket, method, params, pool, jobs, tries)
      end

      it 'Increments jobid count' do
        expect{ subject }.to change{ pool.jobid }
      end

      it 'Returns Job X with sleep time Z, finished by server' do
        expect{ subject }.to output(/Job [0-9]+ with sleep time [0-9]+, finished by server/).to_stdout
      end
      
    end
    
    context 'With method perform_later' do
      let!(:method) { 'perform_later' }
      subject do
        job.handle_request(socket, method, params, pool, jobs, tries)
      end

      it 'Increments jobid count' do
        expect{ subject }.to change{ pool.jobid }
      end

      it 'Enqueue the job' do
        expect{ subject }.to change{ jobs.size }
      end
    end

    context 'With method perform_in 5' do
      let(:seconds) { 5 }
      subject do
        job.perform_in(socket, params, seconds, pool, jobs, tries)
      end

      it 'Increments jobid count' do
        expect{ subject }.to change{ pool.jobid }
      end

      it 'Enqueue the job' do
        expect{ subject }.to change{ jobs.size }
      end

      it 'Have been waiting 5 seconds' do
        allow_any_instance_of(HelloWorld).to receive(:sleep)
        subject
        expect(job).to have_received(:sleep).with(5)
      end
    end
    
  end

  context 'With HelloMeJob and param Nahuel' do

    let(:job)     { HelloMe.new }
    let(:params) { 'Nahuel' }

    context 'With method perform_now' do

      let(:method) { 'perform_now' }
      subject do
        job.handle_request(socket, method, params, pool, jobs, tries)
      end

      it 'Increments jobid count' do
        expect{ subject }.to change{ pool.jobid }
      end

      it 'Returns Job X with sleep time Z, finished by server' do
        expect{ subject }.to output(/Job [0-9]+ with sleep time [0-9]+, finished by server/).to_stdout
      end
      
    end
    
    context 'With method perform_later' do
      let(:method) { 'perform_later' }
      subject do
        job.handle_request(socket, method, params, pool, jobs, tries)
      end

      it 'Increments jobid count' do
        expect{ subject }.to change{ pool.jobid }
      end

      it 'Enqueue the job' do
        expect{ subject }.to change{ jobs.size }
      end
    end

    context 'With method perform_in 5' do
      let(:seconds) { 5 }

      subject do
        job.perform_in(socket, params, seconds, pool, jobs, tries)
      end

      it 'Increments jobid count' do
        expect{ subject }.to change{ pool.jobid }
      end

      it 'Enqueue the job' do
        expect{ subject }.to change{ jobs.size }
      end

      it 'Have been waiting 5 seconds' do
        allow_any_instance_of(HelloMe).to receive(:sleep)
        subject
        expect(job).to have_received(:sleep).with(5)
      end
    end

  end

  context 'With RaiseException job' do
    let(:job)     { RaiseException.new }
    let(:params) { '' }

    context 'With method perform_now' do

      let(:method) { 'perform_now' }
      subject do
        job.handle_request(socket, method, params, pool, jobs, tries)
      end

      it 'Increments jobid count' do
        expect{ subject }.to change{ pool.jobid }
      end

      it 'Have been waiting 60 seconds' do
        allow_any_instance_of(RaiseException).to receive(:sleep)
        subject
        expect(job).to have_received(:sleep).with(60)
      end
    end
    
    context 'With method perform_later' do
      let(:method) { 'perform_later' }

      subject do
        job.handle_request(socket, method, params, pool, jobs, tries)
      end

      it 'Increments jobid count' do
        expect{ subject }.to change{ pool.jobid }
      end

      it 'Enqueue the job' do
        expect { subject }.to change{ jobs.size }
      end
    end

    context 'With method perform_in 5' do
      let(:seconds) { 5 }

      subject do
        job.perform_in(socket, params, seconds, pool, jobs, tries)
      end

      it 'Increments jobid count' do
        expect{ subject }.to change{ pool.jobid }
      end

      it 'Enqueue the job' do
        expect{ subject }.to change{ jobs.size }
      end

      it 'Have been waiting 5 seconds' do
        allow_any_instance_of(RaiseException).to receive(:sleep)
        subject
        expect(job).to have_received(:sleep).with(5)
      end
    end

  end
end
