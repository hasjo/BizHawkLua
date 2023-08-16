# N64 Nightmare Script for BizHawk

## HOW DO I USE THIS
- Take the n64nightmare.lua script and **PLACE IT IN THE lua FOLDER IN YOUR BIZHAWK FOLDER**
- Take your roms and **PLACE THEM IN THE lua/roms FOLDER, YOU MAY NEED TO CREATE IT**
- start a n64 rom
- open the lua console by going to tools>lua console
- open the script by going to script>open script...
- The top left of your emulator should say "Press L to begin"
- Press L to begin

## Configuration
There's a section of the code that looks like
```
game_array = {}
game_array[1] = {}
game_array[1]['rompath'] = 'roms/mario-kart.z64'
game_array[1]['control'] = "P1 L"
```
for each game you are trying to run, make sure you add a game_array\[#\] for it as well as the corresponding rom path and control button

after you've configured the roms, make sure you update the run_count value to the number of games you're running

## REFERENCE VIDEOS
- Overview: https://youtu.be/Ms8zlPCjlbs
- Configuration Explanation: https://youtu.be/8LbaImGemXI
