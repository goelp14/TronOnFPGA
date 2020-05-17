# Tron on FPGA

This is our implementation of Tron on the FPGA. Most of the game is implemented on hardware with *only* the keyboard inputs taken using C.

Requirements:

-   Intel Quartus 18.1
-   NIOSII (should be part of Quartus)
-   DE2 115 Control Panel Version 2 (newest version)

We took two methods of rendering - functional and frame buffer -  and combined them in order to have the game work with the a higher memory efficiency. With the left over space we are able to add several more maps to load. You should find more detailed READMEs further in the project.

Feel free to fork and make improvements if you want!