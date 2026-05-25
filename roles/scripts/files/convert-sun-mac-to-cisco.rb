#!/usr/bin/env ruby

abort 'missing argument' unless ARGV[0]

n = []
index = 0

for atom in ARGV[0].split(':') do
  if atom.length < 2
    atom = "0#{atom}"
  end
  n[index] = atom
  index += 1
end

puts "#{n[0]}#{n[1]}.#{n[2]}#{n[3]}.#{n[4]}#{n[5]}"

