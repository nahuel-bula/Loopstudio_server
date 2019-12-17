class HelloWorld < Job
  def action(socket, params)
    socket.puts "Hello World: #{params}"
    socket.print "\r\n"
  end
end
