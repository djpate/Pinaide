require 'bootstrap.rb'

if ARGV.size == 0
	puts "Please input project location as argument"
else
	if File.directory? ARGV[0]
		app = Application.new(ARGV[0])
	else
		puts ARGV[0]+" is not a directory"
	end
end
