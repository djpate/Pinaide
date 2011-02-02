class Application

	def initialize(project_dir)
		@project_dir = project_dir
		@pinaide_dir = project_dir + "/.pinaide"
		reset_project_file
		@opened_files = Hash.new
		Gtk.init
		create_window
		create_inner_layout
		setupSignals
		@window.show_all
		Gtk.main
	end
	
	def reset_project_file
		if !File.directory? @pinaide_dir
			Dir.rmdir(@pinaide_dir)
		end
		if File.exist? @pinaide_dir+"/autocomplete.xml"
			File.delete(@pinaide_dir+"/autocomplete.xml")
		end
	end
	
	def create_window
		@window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
		@window.signal_connect( "destroy" ) {
			reset_project_file
			Gtk.main_quit 
		}
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
		if !@opened_files.has_key? file 
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
			source.buffer.signal_connect("changed") do |buffer|
				autocomplete(buffer)
			end
			#label
			label = Gtk::Label.new
			label.set_text(File.basename(file))
			scrolledWindow = Gtk::ScrolledWindow.new
			scrolledWindow.add(source)
			@notebook.append_page(scrolledWindow,label)
			@opened_files[file] = @notebook.n_pages - 1
			@window.show_all
		end
		open_tab @opened_files.fetch(file)
	end
	
	def open_tab(i)
		@notebook.page = i
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
	
	def autocomplete(buffer)
		#get the complete string to autocomplete by going back until we reach a space - new line etc
		text = buffer.get_text(buffer.get_iter_at_offset(buffer.cursor_position-1),buffer.get_iter_at_offset(buffer.cursor_position)).chomp
		if text != " " && text != ""
			offset = buffer.cursor_position-1
			loop = 1
			full_text = text
			while loop == 1
				current_char = buffer.get_text(buffer.get_iter_at_offset(offset-1),buffer.get_iter_at_offset(offset))
				if current_char != " " && current_char != "\n"
					full_text = current_char + full_text
					offset = offset - 1
				else
					loop = 0
				end
			end
			puts full_text
		end
	end
	
end
