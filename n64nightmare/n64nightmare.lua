-- This is the minumum seconds before a save or a load
MINIMUM_SECONDS = 5
-- This is the maximum seconds before a save or a load
MAXIMUM_SECONDS = 30

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
uppress = false
upact = false
downpress = false
downact = false

state = "hold"
run_frames = 0
run_count = 7
run_array = {}
current_save = 1
remaining_runs = run_count
opened = false

game_array = {}
game_array[1] = {}
game_array[2] = {}
game_array[3] = {}
game_array[4] = {}
game_array[5] = {}
game_array[6] = {}
game_array[7] = {}
game_array[1]['rompath'] = 'roms/mario-kart.z64'
game_array[2]['rompath'] = 'roms/mario-tennis.z64'
game_array[3]['rompath'] = 'roms/super-mario-64.z64'
game_array[4]['rompath'] = 'roms/mario-party-2.z64'
game_array[5]['rompath'] = 'roms/pokemon-stadium.z64'
game_array[6]['rompath'] = 'roms/kirby64.z64'
game_array[7]['rompath'] = 'roms/banjo-kazooie.z64'
game_array[1]['control'] = "P1 L"
game_array[2]['control'] = "P1 L"
game_array[3]['control'] = "P1 L"
game_array[4]['control'] = "P1 L"
game_array[5]['control'] = "P1 Z"
game_array[6]['control'] = "P1 Z"
game_array[7]['control'] = "P1 L"

while true do
	joytable = joypad.get()
	control_string = game_array[current_save]['control']
	run_frames = run_frames + 1
	lact, lpress = checkpress(control_string, joytable, lpress)
	upact, uppress = checkpress("P1 DPad U", joytable, uppress)
	downact, downpress = checkpress("P1 DPad D", joytable, downpress)
	control_button = string.gsub(control_string, "P1 ", "")
	
	if state == "hold" then
		gui.text(0,15, "Press "..control_button.." to begin!")
		if lact == true then
			state = "setup"
			lact = false
		end
	end
	
	if state == "setup" and current_save <= run_count then
		if opened == false then
			opened = client.openrom(game_array[current_save]['rompath'])
		end
		if opened == true then
			gui.text(0,15, "Please find your starting point and press "..control_button)
			gui.text(0,30, "Game "..current_save.." of "..run_count)
			if lact == true then
				run_array[current_save] = current_save
				savestate.saveslot(1)
				opened = false
				current_save = current_save + 1
				if current_save > run_count then
					state = "run"
					run_frames = 0
					current_save = 1
					client.openrom(game_array[current_save]['rompath'])
					savestate.loadslot(1)
				end
				lact = false
			end
		end
	end
	
	if state == "run" then
		if run_frames >= next_frame_action and remaining_runs > 1 then
			
			tarsave = random_save(current_save, run_array, run_count)
			savestate.saveslot(1)
			client.openrom(game_array[tarsave]['rompath'])
			savestate.loadslot(1)
			current_save = tarsave
			run_frames = 0
			next_frame_action = math.random(min_frames, max_frames)
			print("NEXT ACTION "..next_frame_action)
		end
		if lact == true and remaining_runs > 1 then
			run_array[current_save] = false
			tarsave = random_save(current_save, run_array, run_count)
			savestate.saveslot(1)
			client.openrom(game_array[tarsave]['rompath'])
			savestate.loadslot(1)
			current_save = tarsave
			run_frames = 0
			remaining_runs = remaining_runs - 1
		elseif lact == true and remaining_runs == 1 then
			remaining_runs = 0
		end
		if remaining_runs == 0 then
			gui.text(0,15, "CONGRATULATIONS! YOU DID IT!")
		else
			gui.text(0,15, "Running, remaining games - "..remaining_runs)
			gui.text(0,30, control_button.." to complete this run")
		end
	end
	
	emu.frameadvance();
end
