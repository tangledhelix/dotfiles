
task :default do
  puts 'Usage: rake install'
end

task :install do
  ignore_files = %w( README.md Rakefile ssh )
  $replace_all = false
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
        puts "=> Skipping ~/.#{file}"
      end
    end
  else
    link_file( file )
  end
end

def link_file( file )
  puts "=> Linking ~/.#{ file }..."
  system `ln -s "$PWD/#{ file }" "$HOME/.#{ file }"`
end

def replace_file( file )
  puts "=> Removing old ~/.#{ file }..."
  system `rm -f "$HOME/.#{ file }"`
  link_file( file )
end

