class Application
	def initialize
		Gtk.init
		create_window
		create_inner_layout
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
		b2 = Gtk::Button.new
		@pane.add(tree.get)
		@pane.add(b2)
		@window.add(@pane)
	end
	
end
