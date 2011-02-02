class PinaideFile
    def initialize(file)
        @file = file
        if File.exist? @file
            read_file
        end
    end
    
    def read_file
        @filecontent = ''
        f = File.open(@file, "r") 
        f.each_line do |line|
            @filecontent += line
        end
    end
    
    def content
        return @filecontent
    end
end
