# MarsRover

**Based on an input, moves robots on Mars and returns their final and / or final position**

## Input format

The input is made of two parts:

1. A grid: a tuple of two integers determining the area where robots can move without being lost
2. A list of robots details: a list made of tuple, themselves made of:

- The initial robot position: a list of two integers for the location, and a one letter string for the orientation
- The robot's moves: a string

## Running the code

1. Checkout the code from GitHub (https://github.com/chadeyrasal/mars-rover)
2. Open an iex shell `iex -S mix`
3. Run `MarsRover.get_results(grid, robots)` where `grid` and `robots` match the above requirements
