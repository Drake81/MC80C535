#µC80C535

The [µC80C535](https://github.com/Drake81/MC80C535/blob/master/doc/MC80C535.pdf) is a simple circuit from maybe 1998.
It was published by a german electronic magazin, named [Elektor](http://www.elektor.de/) and uses the 80C535 from
Siemens/Infinion. The EEprom stores a monitor program with some usefull functions. 
Its also possible to code in the running system by manipulate the RAM. The monitor has also an inbuild debugger.
The only disadvantage, there is no flash memory inside. So every program is stored in RAM.

## Pictures
* [µC80C535 board from above](https://github.com/Drake81/MC80C535/blob/master/doc/Pictures/Compuboard-oben.jpg)
* [µC80C535 board from below](https://github.com/Drake81/MC80C535/blob/master/doc/Pictures/Compuboard-unten.jpg)

## DCF_Receiver
This is a part of my old school project. It was an digital station clock with LED display.
Programming the decode functions for the received [DCF77 signal](http://en.wikipedia.org/wiki/DCF77) was my part.
Sorry for this ugly piece of code, but i learned assembler these days. ;-)

#### There are two ASM program's in the directory:1
* The first One emulate a DCF77 transmitter. It was used to test the decode functions without hardware.
* The second One is the decoder itself.

## keyboard_ext
An implement of a simple 4x4 matrix keyboard.
Could be attached to the µC80C535 board.
More to come...

## input_output
Two simple circuits for input and output.

## doc
Some documentation for the µC80C535
