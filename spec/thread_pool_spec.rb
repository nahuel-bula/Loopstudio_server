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
describe 'ThreadPool class' do
  let(:socket) { TCPSocket.new 'localhost', 2000 }
  let(:jobs) { Queue.new }
  let(:tries) { 0 }
  let(:pool)  { ThreadPool.new(jobs) }

  context 'Initialize the Thread pool' do

    subject do
      pool
    end

    it 'initializes jobid' do
      subject
      expect(pool.jobid).to_not be_nil
    end

    it 'initialize postpone hash' do
      subject
      expect(pool.postpone).to_not be_nil
    end

    context 'Adding job HelloMe, params Nahuel to the queue' do
      let(:job)     { HelloMe.new }
      let(:params)  { 'Nahuel' }
      let(:tries)   { 0 }
      let(:pool)  { ThreadPool.new(jobs) }

      subject do
        pool
        pool.jobid +=1
        jobs << [socket, pool.jobid, job, params, pool, tries]
        sleep(10)
      end

      it 'Executes the Job' do
        expect{ subject }.to output(/Job [0-9]+ with sleep time [0-9]+, finished by server/).to_stdout
      end
    end
  end

  context 'With method postpone_job' do
    let(:job)       { HelloMe.new }
    let(:params)    { 'Nahuel' }
    let(:tries)     { 0 }
    let(:jobid)     { 30 }
    let(:seconds)   { 5 }
    let(:pool)      { ThreadPool.new(jobs) }

    subject do
      pool
      pool.postpone_job(jobid,seconds,socket)
      jobs << [socket, jobid, job, params, pool, tries]
      sleep(15)
    end

    it 'Returns Job 30 with sleep time Z, finished by server' do
      expect{subject}.to output(/Job 30 with sleep time [0-9]+, finished by server/).to_stdout
    end

    it 'Have been waiting 5 seconds' do
      allow_any_instance_of(HelloMe).to receive(:sleep)
      subject
      expect(job).to have_received(:sleep).at_least(:once)
    end
  end  
end
