class HelloMe < Job
  def action(socket, name)
    socket.puts "Hello #{name}"
    socket.print "\r\n"
  end
end
