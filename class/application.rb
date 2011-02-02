class Application
	def initialize
		Gtk.init
		create_window
		create_inner_layout
		add_file("/var/www/fitizzy/trunk/kinaf")
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
		tree = TreeViewFile.new("/var/www/fitizzy/trunk")
		@notebook = Gtk::Notebook.new
		@pane.add(tree.get)
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
	    #label
	    label = Gtk::Label.new
	    label.set_text(file)
	    @notebook.append_page(source,label)
	end
	
end
