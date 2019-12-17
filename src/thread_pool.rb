class ThreadPool
  attr_accessor :jobid, :postpone

  def initialize(jobs)
    self.jobid = 0
    self.postpone = Hash.new
    # 5 threads are created to manage the execution of the jobs in the queue.
    5.times do
      thread = Thread.new do
        catch(:exit) do
          loop do
            socket, jobid, job, params, pool, tries = jobs.pop
            job.perform_now(socket, jobid, params, pool, jobs, tries)
          end 
        end
      end    
    end
    # another thread is created to wait until the user types exit.
    # when the user types exit, it close all threads and close the server.
    Thread.new do
      Thread.each(&exit) if gets('exit')
    end
  end

  def postpone_job(jobid, seconds, socket)
    self.postpone[jobid] = seconds
    socket.puts "Job #{jobid} postponed #{seconds} seconds"
  end
end
