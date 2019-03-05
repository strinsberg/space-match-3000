# Space Match 3000

A very simple match 3 game.

This is the first full program I developed. The software design is not ideal, But I learned so much.

# Playing the game
All menus can be navigated by pressing the key that is in brackets. ie. (n)ew game  - start a new game by pressing 'n'

In game the left mouse button can be used to select a block to move and then pressed again to attempt moving it to an adjacent space.

3 or more of the same color block in a row or column will create a match. Those blocks are removed and new ones drop into the gaps. Scoreing is based on the number of blocks matched and the number of times the board has updated since the last user generated match. As a result the more you can get matches to happen after making a move the higher the score will be.

Games can be paused, and if you are stuck you can ask for hints to see blocks that could be moved to make matches.

Each mode and difficulty has it's own high score table that keeps the 10 largest high scores

Supports several different modes
- move limit
- time limit
- no limit refill
- no limit no-refill

# Download for Linux
1. Download the .love file in /bin
2. If love2d is not installed download and install it here https://love2d.org/
3. In a terminal run  $> love space_match_3000.love

# Download for Windows
1. Download the space_match_3000_windows folder from /bin
2. Run space_match_3000.exe
