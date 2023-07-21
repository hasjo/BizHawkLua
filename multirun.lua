-- This is the minumum seconds before a save or a load
MINIMUM_SECONDS = 5
-- This is the maximum seconds before a save or a load
MAXIMUM_SECONDS = 30
-- Set this to true for different run start locations
VARIED = false

function checkpress (button, joytable, pressed)
	if joytable[button] == true then
		if pressed == false then
			print(button.." PRESSED")
			return true, true
		elseif pressed == true then
			return false, true
		end
	elseif joytable[button] == false then
		if pressed == true then
			print(button.." RELEASED")
		end
		return false, false
	end
end

function random_save (currentsave, run_array, run_count)
	good = false
	while good == false do
		pick = math.random(1,run_count)
		if run_array[pick] == false or pick == currentsave then
			good = false
		else
			return pick
		end
		print(pick)
	end
end

math.randomseed(os.time())
min_frames = MINIMUM_SECONDS * 60
max_frames = MAXIMUM_SECONDS * 60
next_frame_action = math.random(min_frames, max_frames)

lpress = false
lact = false
leftpress = false
leftact = false
rightpress = false
rightact = false

state = "start"
frame_count = 0
run_frames = 0
run_count = 1
array_count = 1
run_array = {}
current_save = 0
remaining_runs = 1

while true do
	joytable = joypad.get()
	frame_count = frame_count + 1
	run_frames = run_frames + 1
	
	lact, lpress = checkpress("P1 L", joytable, lpress)
	leftact, leftpress = checkpress("P1 DPad L", joytable, leftpress)
	rightact, rightpress = checkpress("P1 DPad R", joytable, rightpress)
	
	if state == "start" then
		gui.text(0,15, "How Many Runs?")
		gui.text(0,30, run_count)
		if leftact == true then
			if run_count > 1 then
				run_count = run_count - 1
			end
		elseif rightact == true then
			if run_count < 10 then
				run_count = run_count + 1
			end
		end
		if lact == true then
			state = "setup_run"
			gui.cleartext()
			remaining_runs = run_count
			lact = false
		end
	end
	
	if state == "setup_run" then
		if VARIED == true then
			if current_save == 0 then
				savestate.save("startspot")
				current_save = 1
			end
			gui.text(0, 15, "FIND STARTING POINT FOR "..current_save)
			if lact == true then
				savestate.saveslot(current_save)
				current_save = current_save + 1
				savestate.load("startspot")
			end
			if current_save > run_count then
				savestate.loadslot(1)
				state = "running"
				run_frames = 0
				print("STARTING, NEXT ACTION "..next_frame_action)
				current_save = 1
			end
		else
			savestate.save("startspot")
			current_save = 1
			for i=1, run_count do
				savestate.load("startspot")
				savestate.saveslot(i)
				run_array[i] = i
			end
			savestate.loadslot(1)
			state = "running"
			run_frames = 0
			print("STARTING, NEXT ACTION "..next_frame_action)
		end
	end
	
	if state == "running" then
		if run_frames >= next_frame_action and remaining_runs > 1 then
			tarsave, remaining = random_save(current_save, run_array, run_count)
			savestate.saveslot(current_save)
			savestate.loadslot(tarsave)
			current_save = tarsave
			run_frames = 0
			next_frame_action = math.random(min_frames, max_frames)
			print("NEXT ACTION "..next_frame_action)
		end
		if lact == true and remaining_runs > 1 then
			run_array[current_save] = false
			tarsave = random_save(current_save, run_array, run_count)
			savestate.saveslot(current_save)
			savestate.loadslot(tarsave)
			current_save = tarsave
			remaining_runs = remaining_runs - 1
		elseif lact == true and remaining_runs == 1 then
			remaining_runs = 0
		end
		
		if remaining_runs == 0 then
			gui.text(0,15, "CONGRATULATIONS! YOU DID IT!")
		else
			gui.text(0,15, "REMAINING RUNS - "..remaining_runs)
		end
		
	end
	emu.frameadvance();
end