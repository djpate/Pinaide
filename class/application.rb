class Application

	def initialize(project_dir)
		@project_dir = project_dir
		Gtk.init
		create_window
		create_inner_layout
		setupSignals
		@window.show_all
		Gtk.main
	end
	
	def create_window
		Gtk.init
		@window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
		@window.signal_connect( "destroy" ) { Gtk.main_quit }
		screen = @window.screen
		@window.set_default_size(screen.width,screen.height)
	end
	
	def create_inner_layout
		@pane = Gtk::HPaned.new
		@tree = TreeViewFile.new(@project_dir)
		
		@notebook = Gtk::Notebook.new
		@notebook.scrollable = true
		@pane.add(@tree.get)
		@pane.add(@notebook)
		@window.add(@pane)
	end
	
	def add_file(file)
		#file
		myFile = PinaideFile.new(file)
		#editor
		source = Gtk::SourceView.new
		lang = Gtk::SourceLanguageManager.new.get_language('php')
		source.buffer.language = lang
		source.set_show_line_numbers(true)
		source.buffer.highlight_syntax = true
		source.buffer.highlight_matching_brackets = true
		source.buffer.text = myFile.content
		#register autocomplete
		source.buffer.signal_connect("insert-text") do |buffer,iter,text,len|
			autocomplete(buffer,iter,text,len)
		end
		#label
		label = Gtk::Label.new
		label.set_text(file)
		scrolledWindow = Gtk::ScrolledWindow.new
		scrolledWindow.add(source)
		@notebook.append_page(scrolledWindow,label)
		@window.show_all
	end
	
	def setupSignals
		#tree
		@tree.get.signal_connect("cursor-changed") do
			if iter = @tree.get.selection.selected
				path = iter[0]
				loop = 1
				while loop == 1
					iter = iter.parent()
					if(iter!=nil)
						path = iter[0] + "/" + path
					else 
						loop = 0
					end
				end
				filename = @project_dir + "/" + path
				if !File.directory? filename
					add_file(filename);
				end
			end
		end
	end
	
	def autocomplete(buffer,iter,text,length)
		
	end
	
end
