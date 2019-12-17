# Loopstudio multithread server

- The application supports multiple conections from clients, allowing them to execute jobs synchronously or in parallel. You can also set a minimum execution time for each job.

- The server can also be instructed to delay a job that is waiting to be executed (or was not created yet) for x seconds.

- Retry logic was also added, which allows a job, if it fails to execute (generates an exception), to be available to run again after 60 seconds, allowing to try to execute it up to 3 times before discarding it.

- The server implements two jobs and one extra job that raise an exception (to show the retry   logic funcionality).


## Starting the server

- To start the server you have to execute the start_server.rb file using ruby. For that, we type ruby src/start_server.rb in the terminal.

- It will show us "Listening on 2000" which indicates that it is available to accept client connections on port 2000.

- When a client connects/disconnects, it will show in the server log "client connected"/"client disconnected". When the execution of a job is finished, the job id and the time it took to execute will be displayed.

- To close the server type 'exit'.

## Jobs and jobs parameters

- Allowed jobs: HelloMe, HelloWorld and RaiseException (the one that raise an exception).

- The return of HelloMe job is "Hello job_params" and the return of HelloWorld job is "Hello World: job_params"

- The RaiseException job (and whatever job that raises an exeption) will return "Job idjob failed 1 times, retrying in 60 seconds.", 60 seconds later "Job idjob failed 2 times, retrying in 60 seconds.", and then in another 60 seconds "Job idjob failed 3 times, discarding.."

- The job params must be written without blank spaces. It can be empty 

## Client usage

- To connect to the server we type 'telnet localhost 2000' in the terminal.

- To perform one job in a synchronous way and return the result we type 'perform_now Job job_params'. This will cause the job to run immediately, without going through the execution queue.

- To enqueue one job to executing it later we type: 'perform_later Job job_params'. This will cause the job to enter an execution queue to wait to be executed by the server.

- To enqueue one job in x seconds to executing it later we type: 'perform_in x Job job_params'. This will cause the job to enter the execution queue after x seconds have passed.

- To postpone the execution of a job given its identifier for x seconds we type 'postpone_job idjob x'. This will make that when the work with the idjob identifier is going to be executed, first has to wait for x seconds.

- To disconnect from the server just type 'exit'.

- To run the tests type 'rspec' (with the server down)

## Other considerations

- Each job has a sleep time that simulates the execution time. This sleep time is a value between 0 and 10 seconds (it is randomly assigned).

- Some examples can fail in the job_spec.rb. They fail intermittently in cases that control that the job is added to the queue, since there are times when the job is very short in the queue and, at the time of controlling it, is no longer in the queue.
