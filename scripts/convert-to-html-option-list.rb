#!/usr/bin/env ruby

lines = STDIN.read.split("\n")

for line in lines do
	line.chomp!
	puts "<option value=\"#{line}\">#{line}</option>"
end

