#!/usr/bin/env ruby

lines = STDIN.read.split("\n")

# Strip leading and trailing whitespace. Turn any remaining
# whitespace into a newline
for line in lines do
	puts line.strip.gsub(/\s+/, "\n")
end

