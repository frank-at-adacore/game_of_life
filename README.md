# game_of_life
This is a simple demonstration of Conway's Game of Life (https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) written using the Ada language (With parts written solely in SPARK).
This is not a very full-featured application. It was written to help me increase my knowledge of Ada2012, SPARK, and GtkAda, as well as experiment with the AdaCore tools CodePeer and the SPARK prover.

## How to build

### Prerequisites
This GNAT Project builds and executes with the GNAT Community Edition (https://www.adacore.com/download). In addition, you will need to install the GtkAda libraries as well (https://www.adacore.com/download/more).

### Build an executable
You can either open the .gpr file using GPS and built interactively, or you can issue the command:
```
gprbuild -P game_of_life.gpr -Xlibrary_type=static
```
This will create the executable in the 'obj' subfolder

## How to run
Running the executable brings up a small graphical window with the following input objects

### Starting file
Select a file to generate a starting population (examples are in the 'seed_files' folder). Each line in the file corresponds to a row in the starting grid. Blank spaces are considered 'dead' cells - all other characters are 'live' cells

### Delay timer
Specify amount of time between generations

### Scale
Scale value is (almost) the size of each individual cell. The widget is actually drawn 90% of scale to allow for whitespace between cells.

### Cell color
Select the color of the 'live' cells. I used complementary colors for the 'dead' cells (with a fudge factor if the complement was too close to the original color)

### Quit
Obvious
