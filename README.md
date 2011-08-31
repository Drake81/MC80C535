#µC80C535

The [µC80C535](https://github.com/Drake81/MC80C535/blob/master/doc/MC80C535.pdf) is a simple circuit from maybe 1998.
It was published by a german electronic magazin, named [Elektor](http://www.elektor.de/).
It use the 80C535 from Siemens/Infinion as microcontroller as central CPU.

The only disadvantage, there is no flash memory inside. So every program is stored in RAM.

## Pictures
* [µC80C535 board from above](https://github.com/Drake81/MC80C535/blob/master/doc/Pictures/Compuboard-oben.jpg)
* [µC80C535 board from below](https://github.com/Drake81/MC80C535/blob/master/doc/Pictures/Compuboard-unten.jpg)

## DCF_Receiver
This is a part of my old school project. It was an digital station clock with a LED display.
Decode the received [DCF77 signal](http://en.wikipedia.org/wiki/DCF77) was my part of coding.
It's very ugly and old code, because i learned assembler that times. ;-)

#### There are two ASM program's in the directory:
* The first one emulate a DCF77 transmitter. Testing the receiver without hardware.
* The second one is the receiver itself.

## keyboard_ext
This an implement of a simple 4x4 matrix keyboard.
More to come...

## input_output
Two simple circuits for input and output.

## doc
Some documentation for the µC80C535