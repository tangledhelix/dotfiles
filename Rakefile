require 'erb'
require 'yaml'

task :default do
  puts 'Usage: rake [ install | force ]'
  puts '    install   : ask first before overwriting'
  puts '    force     : just do it, no questions'
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
  ignore_files = %w(README.md Rakefile gitconfig.erb install.sh)
  Dir['*'].each do |file|
    next if ignore_files.include?(file) or file =~ /.*~$/
    determine_action(file)
  end
  gitconfig_installer
end

def determine_action(file)
  if File.exist?(File.join(ENV['HOME'], ".#{file}"))
    if $replace_all
      replace_file(file)
    else
      print "Overwrite ~/.#{file}? [yNaq] "
      case STDIN.gets.chomp
      when 'a'
        $replace_all = true
        replace_file(file)
      when 'y'
        replace_file(file)
      when 'q'
        exit
      else
        puts "    skipping ~/.#{file}"
      end
    end
  else
    link_file(file)
  end
end

def link_file(file)
  puts "    linking ~/.#{file}"
  system `ln -s "$PWD/#{file}" "$HOME/.#{file}"`
end

def replace_file(file)
  puts "    removing old ~/.#{file}"
  system `rm -f "$HOME/.#{file}"`
  link_file(file)
end

# The ~/.gitconfig file is generated dynamically so that I can have my
# GitHub API token configured in it without putting my token into my GitHub
# dotfiles repo, which is publicly visible.

def gitconfig_installer
  template_file = 'gitconfig.erb'
  output_file = ENV['HOME'] + '/.gitconfig'
  cache_file = output_file + '.cache'
  gitconfig_params = Hash.new

  # If we find an older install with the symlink in place,
  # clean that up first
  if File.symlink?(output_file)
    File.unlink(output_file)
    puts "    deleted symlink #{output_file}"
  end

  unless File.exists?(cache_file)

    puts '    creating ~/.gitconfig.cache'
    puts ''
    puts 'Enter .gitconfig data'
    puts '(press enter to leave a value blank.)'
    puts ''

    print 'Name: '
    gitconfig_params['git_name'] = STDIN.gets.chomp

    print 'Email address: '
    gitconfig_params['git_email'] = STDIN.gets.chomp

    print 'GitHub username: '
    gitconfig_params['github_username'] = STDIN.gets.chomp

    print 'GitHub API token: '
    gitconfig_params['github_api_token'] = STDIN.gets.chomp

    File.open(cache_file, 'w') do |out|
      YAML.dump(gitconfig_params, out)
    end

    ret = File.chmod(0600, cache_file)
    if ret != 1
      puts "WARN: chmod of #{cache_file} failed!"
    end
  end

  puts '    generating ~/.gitconfig'

  $template_vars = YAML.load_file(cache_file)

  template = ERB.new(File.read(template_file), nil, '<>')
  File.open(output_file, 'w') do |f|
    f.write(template.result())
  end

  ret = File.chmod(0600, output_file)
  if ret != 1
    puts "WARN: chmod of #{output_file} failed!"
  end

end

