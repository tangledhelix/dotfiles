#!/usr/bin/env ruby

# Given a line or set of lines that have some block of multiple spaces in the
# middle, turn that chunk into one space.

lines = STDIN.read.split("\n")

for line in lines do
	puts line.gsub(/^(\s*\S+)\s{2,}(\S+.*)$/, "\\1 \\2")
end

