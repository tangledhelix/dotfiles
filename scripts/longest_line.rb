#!/usr/bin/env ruby

filename = ARGV[0]
if not filename
	puts "missing argument"
	exit
end

file = File.open(filename, "r")
longest = 0

while line = file.gets
	if line.length > longest
		longest = line.length
	end
end

puts "#{longest} #{filename}"

