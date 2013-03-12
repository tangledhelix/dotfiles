#!/usr/bin/env ruby
#
# Filter to convert my text status reports to wikitext.

skip = false

STDIN.read.strip.split("\n").each do |line|

	if skip
		skip = false
		next
	end

	case line

	# Lines to just drop
	when /^Status Report \d{2}-\d{2}-\d{4}/
		skip = true
	when /^\s+Line items with quick descriptions./
	when /^\s+a\) 'Yellow Flags'/
	when /^\s+upcoming work/
	when /^\s+b\) 'Red Flags'/
	when /^\s+current or almost current work/
	when /^\s+c\) etc - other issues that impact you/
	when /^\s+in the next week, or in near future/
	when /^\s+multi-week project./
	when /^\s+a\) Vacations \/ Travel/
	when /^\s+be gone$/
	when /^\s+b\) On Call - if you're on call soon/
	when /^\s+c\) Misc: anything not a & b, such as/
	when /^\s+I'm getting 43 root canals/

	when /^1.\s+Accomplishments - big thing/
		puts '__NOTOC__'
		puts '==Accomplishments=='
	when /^2.\s+Difficulties:/
		puts '==Difficulties=='
	when /^3.\s+Upcoming \(projected\) Milestones/
		puts '==Upcoming Milestones=='
	when /^4.\s+Calendar/
		puts '==Calendar=='
	when /\.\s+/
		puts line.gsub!(/\.\s+/, ". ")
	when /^\s*$/
		puts ""
	else
		puts line
	end

end

