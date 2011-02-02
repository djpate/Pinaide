class TreeViewFile
	def initialize(dir)
		@dir = dir
		@treestore = Gtk::TreeStore.new(String)
		populate(dir)
		setRenderer
	end

	def setRenderer
		@renderer = Gtk::CellRendererText.new
		col = Gtk::TreeViewColumn.new("Project", @renderer, :text => 0)
		@tree.append_column(col)
	end
	
	def getDirectories(dir)
		directories = []
		Dir.entries(dir).each do |entry|
			if(!entry.start_with?("."))
				full_path = dir+"/"+entry
				if File.directory? full_path
					directories.push(full_path)
				end
			end
		end
		return directories.sort
	end
	
	def getFiles(dir)
		files = []
		Dir.entries(dir).each do |entry|
			if(!entry.start_with?("."))
				full_path = dir+"/"+entry
				if !File.directory? full_path
					files.push(full_path)
				end
			end
		end
		return files.sort
	end
	
	def populate(d, obj_parent = nil)
		directories = getDirectories(d)
		files = getFiles(d)
		
		directories.each_with_index do |dir,i|
			parent = @treestore.append(obj_parent)
			parent[0] = dir.gsub(File.dirname(dir)+"/","")
			populate(dir,parent)
		end
		
		files.each_with_index do |file,i|
			parent = @treestore.append(obj_parent)
			parent[0] = File.basename(file)
		end
		
		@tree = Gtk::TreeView.new(@treestore)
		
	end
	
	def get
		return @tree
	end
	
end
