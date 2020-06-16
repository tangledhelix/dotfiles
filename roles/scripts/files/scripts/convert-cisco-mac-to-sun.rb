#!/usr/bin/env ruby

abort 'missing argument' unless ARGV[0]

n = []
index = 0

for atom in ARGV[0].split('.') do
  a = atom[0, 2]
  if a[0, 1] == '0'
    a = a[1, 1]
  end

  b = atom[2, 2]
  if b[0, 1] == '0'
    b = b[1, 1]
  end

  n[index] = "#{a}:#{b}"
  index += 1
end

puts "#{n[0]}:#{n[1]}:#{n[2]}"

