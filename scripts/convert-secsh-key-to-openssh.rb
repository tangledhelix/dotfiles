#!/usr/bin/env ruby

filename = "/tmp/sshconvert.temp"

File.open(filename, "w") do |file|
	STDIN.read.split("\n").each { |line| file.puts line }
end

puts `/usr/bin/ssh-keygen -f #{filename} -i`

File.unlink(filename)

