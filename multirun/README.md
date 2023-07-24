# The Multirun Script for BizHawk

## What's this do?

This script makes you juggle multiple runs of the game of your choosing.
This can be done from a varied start point or a static start point depending on how you change the variable in the code.
The idea of this is that it's more exciting to change between simultaneously happening games because it causes sudden changes in game state which is disorienting.

## How do I start it?

Download multirun.lua from this directory and load it into your emulator by going to Tools>Lua Console and then drop the file in or open the script.

## Running the script

When you start this script, it prompts you for how many runs you want to do simultaneously.
Starting from 1 and maxing out at 10, you use the **D-Pad** to input the desired value.
When you're ready to go, pressing the **Left Shoulder Button** will save where the game currently is and use that as the starting point for either all of the runs or the selection of the start point process

### Varied start process

Once you've pressed the **Left Shoulder Button** to define the amount of runs you will be performing, the state will be saved and you will be prompted for the start position of the first run.
Get to the starting point of run one and press the **Left Shoulder Button** and the state will be saved and reverted back to the start state.
From there, select the start point of the rest of the runs and once they are all selected, the runs will begin starting with save 1.

## In game

Once the games start running, you will see a message in the top left telling you how many runs you have left.
Once you've completed a run, press the **Left Shoulder Button** and the runs remaining counter will decrease by 1.
When the counter gets to 0, congratulations, you've completed the script!
Good Job!

## VIDEOS

Introduction Video - 

Code Review Video -
