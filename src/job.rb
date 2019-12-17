class Job
  def handle_request(socket, method, params, pool, jobs, tries)
    if method.eql? 'perform_now'
      pool.jobid +=1
      self.perform_now(socket, pool.jobid, params, pool, jobs, tries)
    elsif method.eql? 'perform_later'
      self.perform_later(socket, params, pool, jobs, tries) 
    else
      socket.puts "method #{method} not found"
    end  
  end

  def perform_now(socket, jobid, params, pool, jobs, tries)
    begin       
      if !pool.postpone[jobid].nil? 
        socket.puts "Job #{jobid} is waiting #{seconds = pool.postpone[jobid]} seconds to run"
        sleep(seconds)
        pool.postpone.delete(jobid)
      end
      sleep_time = rand(10)
      sleep(sleep_time)
      self.action(socket, params)
      puts "Job #{jobid} with sleep time #{sleep_time}, finished by server"
    rescue
      # Count the number of times that the job has failed
      tries +=1
      if tries<3
        socket.puts "Job #{jobid} failed #{tries} times, executing again in 60 seconds"
        sleep(60)
        jobs << [socket, jobid, self, params, pool, tries]
      else
        socket.puts "Job #{jobid} failed #{tries} times, discarding.."
      end
    end
  end

  def perform_later(socket, params, pool, jobs, tries)
    pool.jobid += 1
    jobid = pool.jobid
    jobs << [socket, jobid, self, params, pool, tries]    
    socket.puts "Job #{jobid} scheduled"
  end

  def perform_in(socket, params, seconds, pool, jobs, tries)
    socket.puts "The job will be scheduled in #{seconds} seconds"
    sleep(seconds)
    perform_later(socket, params, pool, jobs, tries)
  end
end
