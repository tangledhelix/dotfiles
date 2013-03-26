#!/usr/bin/env ruby

lines = STDIN.read.split("\n")

for line in lines do
  puts line.strip.gsub(/\s+/, ' ')
end

