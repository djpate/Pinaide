class Application
	def initialize
		Gtk.init
		create_window
		create_inner_layout
		add_file("test")
		add_file("test2")
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
	    source = Gtk::SourceView.new
	    lang = Gtk::SourceLanguageManager.new.get_language('php')
	    source.buffer.language = lang
        source.buffer.highlight_syntax = true
        source.buffer.highlight_matching_brackets = true
	    label = Gtk::Label.new
	    label.set_text(file)
	    @notebook.append_page(source,label)
	end
	
end
