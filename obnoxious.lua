-- This is the minumum seconds before a save or a load
MINIMUM_SECONDS = 5
-- This is the maximum seconds before a save or a load
MAXIMUM_SECONDS = 30
-- This makes a load more likely every save the higher the number
LOAD_RATCHETING = 0
-- This is the button to watch for controlling activity
CONTROL_BUTTON = "P1 L"

frame_count = 0
wait_count = 0
max_random = 2
min_frames = MINIMUM_SECONDS * 60
max_frames = MAXIMUM_SECONDS * 60
math.randomseed(os.time())
next_frame_action = math.random(min_frames, max_frames)
print("NEXT HAPPENING:"..next_frame_action)
savestate.saveslot(1)
ACTIVE = false
l_pressed = false
while true do

	-- controlling the script with the L button
	joytable = joypad.get()
	if joytable[CONTROL_BUTTON] == true then
	    if l_pressed == false then
			l_pressed = true
			ACTIVE = not ACTIVE
			print(ACTIVE)
		end
	elseif joytable[CONTROL_BUTTON] == false and l_pressed == true then
		l_pressed = false
	end
	
	-- run the actual stuff
	if ACTIVE == true then
		frame_count = frame_count + 1
		if frame_count >= next_frame_action then
			action = math.random(max_random)
			if action == 1 then
				print("SAVING")
				max_random = max_random + LOAD_RATCHETING
				savestate.saveslot(1)
			elseif action >= 2 then
				print("LOADING")
				savestate.loadslot(1)
				max_random = 2
			end
	    
			next_frame_action = math.random(min_frames,max_frames)
			print("NEXT HAPPENING:"..next_frame_action)
			frame_count = 0
		end
		if frame_count % 120 == 0 then
			gui.addmessage("RUNNING")
		end
	else
		wait_count = wait_count + 1
		if wait_count % 120 == 0 then
			gui.addmessage("NOT RUNNING")
			wait_count = 0
		end
	end
	emu.frameadvance();
end
