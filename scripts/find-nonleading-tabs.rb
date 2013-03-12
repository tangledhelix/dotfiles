#!/usr/bin/env ruby

line_count = 0

File.foreach(ARGV[0]) do |line|
	line_count += 1
	if line =~ /^[ \t]+$/
		puts line_count.to_s + ": Warning: Useless whitespace"
		next
	end
	line.gsub!(/^\t+/, "")
	if line =~ /\t/
		puts line_count.to_s + ": " + line
	end
end

