
task :default do
	puts 'Usage: rake [ install | force ]'
	puts '    install : ask first before overwriting'
	puts '    force   : just do it, no questions'
end

task :install do
	$replace_all = false
	installer
end

task :force do
	$replace_all = true
	installer
end

def installer
	ignore_files = %w( README.md Rakefile ssh )
	Dir[ '*' ].each do |file|
		next if ignore_files.include? file or file =~ /.*~$/
		determine_action( file )
	end
	determine_action( 'ssh/config' )
end

def determine_action( file )
	if File.exist?( File.join( ENV[ 'HOME' ], ".#{ file }" ) )
		if $replace_all
			replace_file( file )
		else
			print "Overwrite ~/.#{file}? [yNaq] "
			case STDIN.gets.chomp
			when 'a'
				$replace_all = true
				replace_file( file )
			when 'y'
				replace_file( file )
			when 'q'
				exit
			else
				puts "    skipping ~/.#{file}"
			end
		end
	else
		link_file( file )
	end
end

def link_file( file )
	puts "    linking ~/.#{ file }..."
	system `ln -s "$PWD/#{ file }" "$HOME/.#{ file }"`
end

def replace_file( file )
	puts "    removing old ~/.#{ file }..."
	system `rm -f "$HOME/.#{ file }"`
	link_file( file )
end

