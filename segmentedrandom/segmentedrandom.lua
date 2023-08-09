-- This is the minumum seconds before a save or a load
MINIMUM_SECONDS = 5
-- This is the maximum seconds before a save or a load
MAXIMUM_SECONDS = 30

run_info = {}
run_info[1] = "Lakitu -> BoB = 1"
run_info[2] = "Whomps = 2-6"
run_info[3] = "CCM = 7-8"
run_info[4] = "Dark World = 8"
run_info[5] = "SSL = 9-10"
run_info[6] = "LLL = 11"
run_info[7] = "HMC = 12-15"
run_info[8] = "Mips -> DDD = 16"
run_info[9] = "Fire Sea = 16"
run_info[10] = "BLJs -> BITS = 16"

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
run_count = 10
run_array = {}
current_save = 1
remaining_runs = 10

while true do
	joytable = joypad.get()
	run_frames = run_frames + 1
	lact, lpress = checkpress("P1 L", joytable, lpress)
	upact, uppress = checkpress("P1 DPad U", joytable, uppress)
	downact, downpress = checkpress("P1 DPad D", joytable, downpress)
	
	if state == "hold" then
		gui.text(0,15, "Press L to begin!")
		if lact == true then
			state = "setup"
			lact = false
		end
	end
	
	if state == "setup" then
		gui.text(0,15, "SETTING UP STATES...")
		savestate.load('segmentstates/sm64-lakitu-chainchomp.State')
		savestate.saveslot(1)
		run_array[1] = 1
		savestate.load('segmentstates/sm64-whomps.State')
		savestate.saveslot(2)
		run_array[2] = 1
		savestate.load('segmentstates/sm64-ccm.State')
		savestate.saveslot(3)
		run_array[3] = 1
		savestate.load('segmentstates/sm64-darkworld.State')
		savestate.saveslot(4)
		run_array[4] = 1
		savestate.load('segmentstates/sm64-ssl.State')
		savestate.saveslot(5)
		run_array[5] = 1
		savestate.load('segmentstates/sm64-ssl.State')
		savestate.saveslot(5)
		run_array[5] = 1
		savestate.load('segmentstates/sm64-lll.State')
		savestate.saveslot(6)
		run_array[6] = 1
		savestate.load('segmentstates/sm64-hmc.State')
		savestate.saveslot(7)
		run_array[7] = 1
		savestate.load('segmentstates/sm64-mips-ddd.State')
		savestate.saveslot(8)
		run_array[8] = 1
		savestate.load('segmentstates/sm64-firesea.State')
		savestate.saveslot(9)
		run_array[9] = 1
		savestate.load('segmentstates/sm64-blj-bits.State')
		savestate.saveslot(10)
		run_array[10] = 1
		savestate.loadslot(1)
		current_save = 1
		remaining_runs = 10
		state = "run"
	end
	
	if state == "run" then
		
		if run_frames >= next_frame_action and remaining_runs > 1 then
			tarsave = random_save(current_save, run_array, run_count)
			savestate.saveslot(current_save)
			savestate.loadslot(tarsave)
			current_save = tarsave
			run_frames = 0
			next_frame_action = math.random(min_frames, max_frames)
			print("NEXT ACTION "..next_frame_action)
		end
		if upact == true then
			state = "setup"
			upact = false
		end
		if downact == true then
			state = "pause"
			downact = false
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
			gui.text(0,15, "RUNNING - "..run_info[current_save])
			gui.text(0,30, "REMAINING SEGMENTS - "..remaining_runs)
		end
	end
	
	if state == "pause" then
		run_frames = 0
		gui.text(0,15, "PAUSED")
		if downact == true then
			state = "run"
			downact = false
		end
	end
	
	emu.frameadvance();
end
