# Tron Game

## Description
We propose to design and implement a full two player 2D game based on the classic arcade game Tron. This includes sound, multiplayer interaction, more complicated animations, and AI. We will use the FPGA to offload heavy computational as well as intensive tasks such as graphics, sound, and AI logic. Most of the game logic that would be a heavier load would also be implemented through the FPGA. We will use NIOS II to handle the keyboard inputs and parts of the game logic that aren’t intensive. We will animate sprites by alternating sprites drawn from what is considered a sprite sheet. This would include small explosions, laser trail, and motorbike sprites. They will be stored in the SRAM to be accessed by our Color Mapper. The movements of the sprites and other interactive aspects of the game would be handled by the VGA Controller using the keyboard inputs from NIOS II to drive the controller actions. Given time, we can also make the game feel more complete with a home game screen, options, etc. 

Expanding more on the hardware side, we will use essential components from System Verilog such as the System Bus, RAM, VGA Display, Keyboard, and Audio Drivers. We can use the Avalon Interface to coordinate data from the AI logic and game logic implemented on hardware to the NIOS II CPU. We will likely use AI algorithms from other Tron games with our own implementation of it to suit our version of the game. Depending on the situation, we can also implement our own algorithm. This project can vary in difficulty depending on how much is actually implemented via hardware over software and the level of completeness we can reach. The final demo shouldn’t require extra hardware other than a VGA Monitor and a Keyboard. One possible extra hardware would also be a speaker for audio. At the end, we should be able to demonstrate a full playable Tron game rendered on a VGA monitor controlled through keyboard inputs.

## Features
#### Baseline features:
- Rendered Bikes and Map
- A light trail that exists at places you have been
- Collision detection between the bike and the light trails and the play area
- Be able to control 2 bikes for local multiplayer
- A life tracker for PvP

#### Basic Features:
- Powerups that can be used (teleportation, jumping, etc)
- Moving/Static Obstacles that randomly spawn at the start of every round
- Added animation for visual appeal
- Basic AI for PvC (basic collision avoidance)

#### Advanced Features:
- Different playing fields (not just a square)
- Audio and different effects upon collision, spawn, etc
- Advanced AI (plans ahead)

## Timeline
Week 1: Be able to render and display background, and control bike movements and be able to render the light trails behind them.

Week 2: Implement collision detection and start/end menu, add multiplayer support. Add power ups if time permits

Week 3: Continue implementing basic features: Animations, Obstacles, Basic AI.

Week 4: Finish implementing basic features, Implement sounds and different playing fields, attempt to make stronger AI.


## Sprites needed

- Tron bike, 4 directions
- background
- light trails (1 for color replacement or multiple different colors)
- effects
- menu
- life, score, etc

