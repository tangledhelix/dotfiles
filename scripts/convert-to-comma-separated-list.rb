#!/usr/bin/env ruby

lines = STDIN.read.split("\n")

for line in lines do
	line.chomp!
end

puts lines.join(",")

