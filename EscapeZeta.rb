#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*#
# ESCAPE FROM ZETA BASE ALPHA: A GAME #
#               by                    #
#          DEMIAN KRENTZ              #
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*#

# Set (or reset) the initial global variables
def clear_globals()
	# Player variables
	$name = "unknown"
	$inventory = ["Hairbrush"]

	# Content arrays
	$airlock1_contents = ["Spacesuit", "Clipboard", "Flashlight"]
	$science_lab_contents = ["Plasma Cutter", "Chemicals", "USB Drive"]
	$crew_quarters_contents = ["Footlocker", "Soap", "Blanket", "Toothbrush"]
	$footlocker_contents = ["Family Photos", "Underwear", "Keycard"]
	$mess_hall_contents = ["Rations", "Rags", "Bleach"]
	$launch_control_contents = ["Schematics", "First Aid Kit", "Coffee Mug", "Launch Dome Control"]
	$current_room_contents = []

	# Initial state of game variables
	$current_room = "nothing"
	$airlock1 = "closed"
	$airlock2 = "closed"
	$spacesuit = "off"
	$gamestart = "no"
	$previous_move = "nothing"
	$use = "nothing"
	$use_on = "nothing"
	$launch_dome = "closed"
end

### Global methods that can occur in almost any room
def prompt()
	print "--> "
end

def	room_actions() 
	if $next_move.include? "instructions"
		puts "-----Instructions-----"
		puts "To perform the action, type the words that follow it."
		puts "MOVE: 'up', 'down', 'left', 'right'"
		puts "INVENTORY: 'inventory'"
		puts "TAKE: 'take', then at the next prompt, type the item name"
		puts "DROP: 'drop', then at the next prompt, type the item name"
		puts "WEAR: 'wear', then at the next prompt, type the item name"
		puts "USE: 'use', then the item name, then the item on which you\nwant to use it."
		puts "LOOK: 'look'"
		puts
		puts "If you haven't already, start the game by typing 'start'."
		prompt; $next_move = gets.chomp()
		room_actions()
	elsif $next_move.include? "inventory"
		puts "You are carrying:"
		puts $inventory
		$next_move = "nothing"
		puts "---"
		current_room()
	elsif $next_move.include? "look"
		current_room()
	elsif $next_move.include? "name"
		puts "Your name is: #{$name}"
		prompt; $next_move = gets.chomp()
		room_actions()
	elsif $next_move.include? "take"
		take()
	elsif $next_move.include? "drop"
		drop()
	elsif $next_move.include? "wear"
		wear()
	elsif $next_move.include? "use"
		use()			
	elsif $next_move.any? { |x| ['up', 'down', 'left', 'right'].include?(x) }
		if $gamestart == "yes"
			current_room()
		else
			puts "You can't do that until you start the game. If you're ready, type 'start'."
			prompt; $next_move = gets.chomp()
			room_actions()
		end
	elsif $next_move.include? "start"
		if $gamestart == "yes"
			puts "You've already begun."
			$next_move = "nothing"
			room_actions()
		else
			puts "Here we go!"
			puts "-"
			puts "--"
			puts "---"
			puts "----"
			puts "-----"
			puts "------"
			puts "-------"
			puts "--------"
			puts "---------"
			puts "----------"
			puts "You slowly regain consciousness. Looking around you see..."
			airlock1()
		end
	else
		puts "I don't understand that."
		prompt; $next_move = gets.chomp()
		room_actions()
	end
end

def current_room()
	if $current_room == "airlock1"
		airlock1()
	elsif $current_room == "science_lab"
		science_lab()
	elsif $current_room == "mess_hall"
		mess_hall()
	elsif $current_room == "crew_quarters"
		crew_quarters()
	elsif $current_room == "launch_control"
		launch_control()
	elsif $current_room == "launch_pad"
		launch_pad()
	else
		puts "You are nowhere."
		prompt; $next_move = gets.chomp()
		room_actions()
	end
end

def take()
	if $gamestart == "yes"
		puts "What will you take?"
		take = gets.chomp()
		$inventory.push(take)
		$current_room_contents.delete(take)
		$footlocker_contents.delete(take)
		puts "---"
		puts "Your inventory now includes:"
		puts $inventory
		$next_move = "nothing"
		puts "---"
		current_room()
	else
		puts "The game hasn't begun yet. Type 'start' to begin."
		prompt; choice = gets.chomp()
		if choice == "start"
			airlock1()
		else
			$next_move = choice
			room_actions()
		end
	end
end

def drop()
	if $gamestart == "yes"
		puts "What will you drop?"
		drop = gets.chomp()
		$inventory.delete(drop)
		$current_room_contents.push(drop)
		puts "Your inventory now includes:"
		puts $inventory
		$next_move = "nothing"
		puts "---"
		current_room()
	else
		puts "The game hasn't begun yet. Type 'start' to begin."
		prompt; choice = gets.chomp()
		if choice == "start"
			airlock1()
		else
			$next_move = choice
			room_actions()
		end
	end
end

def wear()
	if $gamestart == "yes"
		puts "What will you wear?"
		wear = gets.chomp()
		if $inventory.include? "Spacesuit"
			$spacesuit = "on"
			$inventory.delete(wear)
			puts "You put on the spacesuit."
			$spacesuit = "on"
			$next_move = "nothing"
			puts "---"
			current_room()
		elsif $inventory.include? "Spacesuit" or true
			puts "You aren't carrying that item yet."
			$next_move = "nothing"
			puts "---"
			current_room()
		else
			puts "You can't wear the #{wear}."
			$next_move = "nothing"
			puts "---"
			current_room()
		end
	else
		puts "The game hasn't begun yet. Type 'start' to begin."
		prompt; choice = gets.chomp()
		if choice == "start"
			airlock1()
		else
			$next_move = choice
			room_actions()
		end
	end
end

def use()
	if $gamestart == "yes"
		puts "What will you use?"
		$use = gets.chomp()
		if $inventory.include? $use
			puts "On what will you use #{$use}?"
			$use_on = gets.chomp()
			if $current_room_contents.include? $use_on
				puts "You use the #{$use} on the #{$use_on}."
				use_result()
			else
				puts "That isn't here."
				$next_move = "nothing"
				puts "---"
				current_room()
			end
		else
			puts "You aren't carrying that."
			$next_move = "nothing"
			puts "---"
			current_room()
		end
	else
		puts "The game hasn't begun yet. Type 'start' to begin."
		prompt; choice = gets.chomp()
		if choice == "start"
			airlock1()
		else
			$next_move = choice
			room_actions()
		end
	end
end

def use_result()
	if $use == "Plasma Cutter" and $use_on == "Footlocker"
		puts "You cut open the footlocker, revealing:"
		puts $footlocker_contents
		$next_move = "nothing"
		current_room()
	elsif $use == "Keycard" and $use_on == "Launch Dome Control"
		puts "The Launch Dome opens."
		$launch_dome = "open"
		$next_move = "nothing"
		puts "---"
		current_room()
	else
		puts "Using the #{$use} on the #{$use_on} produces no useful result."
		$next_move = "nothing"
		puts "---"
		current_room()
	end
end			

def start()
	clear_globals()
	puts "Welcome traveler. What is your name?"
	prompt; $name = gets.chomp()
	puts "#{$name}, would you like to read the instructions? (y/n)"
	prompt; choice = gets.chomp()
	if choice == "y"
		$next_move = "instructions"
		room_actions()
	else
		$previous_move = "nothing"
		$next_move = "nothing"
		puts "Here we go!"
		puts "-"
		puts "--"
		puts "---"
		puts "----"
		puts "-----"
		puts "------"
		puts "-------"
		puts "--------"
		puts "---------"
		puts "----------"
		puts "You slowly regain consciousness. Looking around you see..."
		airlock1()
	end
end

def death()
	puts "#{$name}, you're dead. Would you like to start over? (y/n)"
	prompt; choice = gets.chomp()
	if choice == "y"
		start()
	else
		Exit.process()
	end
end

def win()
	puts "You blast off into space!\nCongratulations, #{$name}! You escaped Zeta Base Alpha!"
end

### Methods for the individual rooms
def airlock1()
	$gamestart = "yes"
	$current_room = "airlock1"
	$current_room_contents = $airlock1_contents
	
	puts "The airlock of a space station. It contains:"
	if $airlock1_contents.empty?
		puts "Nothing of interest."
	else
		puts $airlock1_contents
	end
	
	prompt; $next_move = gets.chomp()
	
	if $next_move.include? "up"
		science_lab()			
	elsif $next_move.any? { |x| ['down', 'left', 'right'].include?(x) }
		puts "You can't go that way."
		$next_move = "stop"
		airlock1()
	else
		room_actions()
	end
end

def science_lab()
	$current_room = "science_lab"
	$current_room_contents = $science_lab_contents
	
	puts "You're in the science lab. It contains:"
	if $airlock1_contents.empty?
		puts "Nothing of interest."
	else
		puts $science_lab_contents
	end

	prompt; $next_move = gets.chomp()

	if $next_move == "down"
		$next_move = "nothing"
		airlock1()
	elsif $next_move == "up"
		$next_move = "nothing"
		mess_hall()
	elsif $next_move == "right"
		$next_move = "nothing"
		crew_quarters()
	elsif $next_move == "left"
		puts "You can't go that way."
		science_lab()
	else
		room_actions()
	end
end

def crew_quarters()
	$current_room = "crew_quarters"
	$current_room_contents = $crew_quarters_contents
	puts "You're in the crew quarters. It contains:"
	if $crew_quarters_contents.empty?
		puts "Nothing of interest."
	else
		puts $crew_quarters_contents
	end

	prompt; $next_move = gets.chomp()

	if $next_move == "down"
		puts "You can't go that way."
		crew_quarters()
	elsif $next_move == "up"
		$next_move = "nothing"
		launch_control()
	elsif $next_move == "right"
		puts "You can't go that way."
		crew_quarters()
	elsif $next_move == "left"
		$next_move = "nothing"
		science_lab()
	else
		room_actions()
	end
end

def mess_hall()
	$current_room = "mess_hall"
	$current_room_contents = $mess_hall_contents
	puts "You're in the mess hall. It contains:"
	if $mess_hall_contents.empty?
		puts "Nothing of interest."
	else
		puts $mess_hall_contents
	end

	prompt; $next_move = gets.chomp()

	if $next_move == "down"
		$next_move = "nothing"
		science_lab()
	elsif $next_move == "up"
		puts "You can't go that way."
		mess_hall()
	elsif $next_move == "right"
		$next_move = "nothing"
		launch_control()	
	elsif $next_move == "left"
		puts "You can't go that way."
		mess_hall()
	else
		room_actions()
	end
end

def launch_control()
	$current_room = "launch_control"
	$current_room_contents = $launch_control_contents
	puts "You're in the Launch Control. Through a window above you,
	you can see a gleaming space rocket sitting on a launch pad.
	A Launch Dome encloses it from the cold of space.
	The Launch Control also contains:"
	if $launch_control_contents.empty?
		puts "Nothing of interest."
	else
		puts $launch_control_contents
	end

	prompt; $next_move = gets.chomp()

	if $next_move == "down"
		$next_move = "nothing"
		crew_quarters()
	elsif $next_move == "up" and $spacesuit == "on"
		$next_move = "nothing"
		launch_pad()
	elsif $next_move == "up" and $spacesuit != "on"
		$next_move = "nothing"
		puts "You open the airlock door, releasing the room's atmosphere into space."
		death()									
	elsif $next_move == "right"
		$next_move = "nothing"
		puts "You can't go that way."
		launch_control()	
	elsif $next_move == "left"
		$next_move = "nothing"
		mess_hall()
	else
		room_actions()
	end
end

def launch_pad()
	$current_room = "launch_pad"
	puts "You're on the launch pad. A ladder leads up to the\nhatch of a space rocket."

	prompt; $next_move = gets.chomp()

	if $next_move == "down"
		$next_move = "nothing"
		launch_control()
	elsif $next_move == "up"
		$next_move = "nothing"
		rocket()
	elsif $next_move == "right"
		puts "You can't go that way."
		launch_pad()	
	elsif $next_move == "left"
		puts "You can't go that way."
		launch_pad()
	else
		room_actions()
	end
end

def rocket()
	puts "You enter the rocket and sit down at the controls. Press any button to launch."
	prompt; gets.chomp()
	if $launch_dome == "open" and $inventory.include? "Rations"
		win()
	elsif $launch_dome == "open" and ($inventory.include? "Rations" == false)
		puts "You blast off into space, but without rations,\nyou slowly die of starvation."
		death()			
	else
		puts "The rocket blasts off and crashes into\nthe closed launch dome a split second later."
		death()
	end
end


# Begin the game
start()