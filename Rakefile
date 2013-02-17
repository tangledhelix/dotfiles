require 'erb'
require 'yaml'

files = Hash.new
files[:zsh]  = %w(zlogin zlogout zshenv zshrc)
files[:vim]  = %w(vim vimrc)
files[:bash] = %w(bash bash_profile bashrc inputrc)
files[:git]  = %w(gitignore)
files[:misc] = %w(emacs hgrc ircrc pryrc screenrc tcshrc terminfo tmux.conf)

files_all = Array.new
[:zsh, :vim, :bash, :git, :misc].each { |symbol| files_all << files[symbol] }
files_all.flatten!.sort!

$vim_bundles = {
	'abolish'           => 'tpope/vim-abolish',
	'clam'              => 'sjl/clam.vim',
	'ctrlp'             => 'kien/ctrlp.vim',
	'easymotion'        => 'Lokaltog/vim-easymotion',
	'endwise'           => 'tangledhelix/vim-endwise',
	'fugitive'          => 'tpope/vim-fugitive',
	'gitv'              => 'gregsexton/gitv',
	'gundo'             => 'sjl/gundo.vim',
	'octopress'         => 'tangledhelix/vim-octopress',
	'pathogen'          => 'tpope/vim-pathogen',
	'perl'              => 'vim-perl/vim-perl',
	'powerline'         => 'Lokaltog/vim-powerline',
	'puppet'            => 'puppetlabs/puppet-syntax-vim',
	'quickrun'          => 'thinca/vim-quickrun',
	'repeat'            => 'tpope/vim-repeat',
	'snipmate'          => 'tangledhelix/vim-snipmate',
	'snipmate-snippets' => 'tangledhelix/snipmate-snippets',
	'solarized'         => 'altercation/vim-colors-solarized',
	'surround'          => 'tpope/vim-surround',
	'tabular'           => 'godlygeek/tabular',
	'tcomment'          => 'tomtom/tcomment_vim',
	'textobj-rubyblock' => 'nelstrom/vim-textobj-rubyblock',
	'textobj-user'      => 'kana/vim-textobj-user',
	'unimpaired'        => 'tpope/vim-unimpaired',
}

task 'default' do
	print_help
end

task 'install' do
	print_help
end

task 'install:all' do
	files_all.each { |file| determine_action file }
	gitconfig_installer
	vim_bundle_installer
	omz_cloner
end

task 'install:zsh' do
	files[:zsh].each { |file| determine_action file }
	omz_cloner
end

task 'install:omz' do
	omz_cloner
end

task 'install:vim' do
	files[:vim].each { |file| determine_action file }
	vim_bundle_installer
end

task 'update:vim' do
	vim_bundle_updater
end

task 'cleanup:vim' do
	vim_bundle_cleanup
end

task 'install:bash' do
	files[:bash].each { |file| determine_action file }
end

task 'install:git' do
	files[:git].each { |file| determine_action file }
	gitconfig_installer
end

def print_help
	puts 'Usage: rake <task>'
	puts
	puts '    install:all   - Install all dotfiles'
	puts
	puts '    install:bash  - Install bash files'
	puts '    install:git   - Install git files'
	puts '    install:zsh   - Install zsh files'
	puts
	puts '    install:vim   - Install vim files and bundles'
	puts '    update:vim    - Update vim bundles'
	puts '    cleanup:vim   - Clean up old vim bundles'
end

def determine_action(file)
	if File.exists? "#{ENV['HOME']}/.#{file}"
		if $replace_all
			replace_file file
		else
			print "Overwrite ~/.#{file}? [yNaq] "
			case STDIN.gets.chomp
			when 'a'
				$replace_all = true
				replace_file file
			when 'y'
				replace_file file
			when 'q'
				exit
			else
				puts "    skipping ~/.#{file}"
			end
		end
	else
		link_file file
	end
end

def link_file(file)
	puts "    linking ~/.#{file}"
	system "ln -s \"$PWD/#{file}\" \"$HOME/.#{file}\""
end

def replace_file(file)
	puts "    removing old ~/.#{file}"
	system "rm -f \"$HOME/.#{file}\""
	link_file file
end

# The ~/.gitconfig file is generated dynamically so that I can have my
# GitHub API token configured in it without putting my token into my GitHub
# dotfiles repo, which is publicly visible.

def gitconfig_installer
	template_file = 'gitconfig.erb'
	output_file = "#{ENV['HOME']}/.gitconfig"
	cache_file = "#{output_file}.cache"
	gitconfig_params = Hash.new

	# If we find an older install with the symlink in place,
	# clean that up first
	if File.symlink?(output_file)
		File.unlink output_file
		puts "    deleted symlink #{output_file}"
	end

	unless File.exists? cache_file

		puts '    creating ~/.gitconfig.cache'
		puts
		puts 'Enter .gitconfig data'
		puts '(press enter to leave a value blank.)'
		puts

		print 'Name: '
		gitconfig_params['git_name'] = STDIN.gets.chomp

		print 'Email address: '
		gitconfig_params['git_email'] = STDIN.gets.chomp

		print 'GitHub username: '
		gitconfig_params['github_username'] = STDIN.gets.chomp

		print 'GitHub API token: '
		gitconfig_params['github_api_token'] = STDIN.gets.chomp

		File.open(cache_file, 'w') { |out| YAML.dump(gitconfig_params, out) }

		ret = File.chmod(0600, cache_file)
		if ret != 1
			puts "WARN: chmod of #{cache_file} failed!"
		end
	end

	puts '    generating ~/.gitconfig'

	$template_vars = YAML.load_file cache_file

	template = ERB.new(File.read(template_file), nil, '<>')
	File.open(output_file, 'w') { |f| f.write template.result }

	ret = File.chmod(0600, output_file)
	if ret != 1
		puts "WARN: chmod of #{output_file} failed!"
	end

end

# clone my omz repository
def omz_cloner
	omz_path = "#{ENV['HOME']}/.oh-my-zsh"
	repo_url = 'https://github.com/tangledhelix/oh-my-zsh.git'
	if File.exists? omz_path
		puts '    ~/.oh-my-zsh already exists, skipping'
		puts 'To reinstall OMZ, rename or remove ~/.oh-my-zsh and try again.'
		return
	end
	system "git clone #{repo_url} #{omz_path}"
	system "cd #{omz_path} && git submodule update --init --recursive"
end

# install or update vim bundles
def vim_bundle_installer
	bundle_path = "#{ENV['HOME']}/.vim/bundle"
	unless File.exists? bundle_path
		mkdir bundle_path
	end
	$vim_bundles.each do |bundle, repo|
		this_bundle_path = "#{bundle_path}/#{bundle}"
		if File.exists? this_bundle_path
			if $vim_do_updates
				puts "    updating vim bundle #{bundle}"
				old_dir = Dir.pwd
				Dir.chdir this_bundle_path
				system 'git pull'
				Dir.chdir old_dir
			else
				puts "    skipping vim bundle #{bundle} (already exists)"
			end
		else
			puts "    cloning vim bundle #{bundle}"
			system "git clone https://github.com/#{repo}.git #{this_bundle_path}"
		end
	end
end

def vim_bundle_updater
	$vim_do_updates = true
	vim_bundle_installer
end

# clean out old vim bundles
def vim_bundle_cleanup
	bundle_path = "#{ENV['HOME']}/.vim/bundle"
	Dir["#{bundle_path}/*"].each do |d|
		unless $vim_bundles[File.basename d]
			puts "    cleaning up bundle #{File.basename d}"
			FileUtils.rm_rf d
		end
	end
end
