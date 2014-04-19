gaVRAMify
=========
PSX graphics dumps viewer in native formats. Mainly used for romhacking purposes.
Original code was written by Agemo: http://www.romhacking.net/community/737/
Slightly modified for MinGW, fixed bug with wrong sprintf with one of modes and prepared for my-internal-needs modification.
Also, translated readme and most of Chinese comments.


Translated version of readme.txt:
-----------
       The PS memory data viewing tool
             V 2007.2.8
                Agemo

The tool supports PS display mode (various modes of reference document GPU.txt)
Support 1MB memory dump files to (PCSX DUMP), as well as the epsxe, adripsx the instant archiving.

System requirements:
Resolution of 1024x768, 16-bit color or more.
Support 98/2000/xp

How to use:
1 If such the ePSXe emulator archive. Compressed archive after the zip algorithm, so we first
Archive file extension changed. Zip and then extract the to about 4mb original data.
To extract the files onto the interface of the software can display
  2 default for pcsx dump software reads the current directory below vram.bin

Explanation of the display screen:
The 1024x512 original memory map, above the blue line in 16bit mode.
Blue line is the red box (later called window) within the display in different modes.
All message displayed in the window title.

Keys to control
ž The left mouse button or press Enter: re-read into memory file
ž W, s, a, d moving window
ž 1,2,3,4,8,9,0 switch the display mode, the specific display mode see below:
1 = 4bit gray (grayscale, that is ignored CLUT)
2 = 8 bit gray
3 = 16bit (blue line is the same as mode)
4 = 24bit
8 = 24bit MDEC (animation)
9 = 4bit CLUT (gray mode difference is CLUT)
0 = 8-bit CLUT
~ Anti-color, 4bit color anti-color mode, is the anti-double-TIM font color
ž Directional arrows CLUT starting coordinates (see on the screen of the Red Cross), only for 9,0 CLUT mode.
ž SHIFT fine-tuning. About change by w, s, a, d, and the direction of the arrow 16 pixels, if you hold down the Shift (1)
ž CTL + mouse to move around the coordinates (decimal), as well as in memory IMB offset (hexadecimal)


Note 1 before using this tool, the best PSX various format to understand. gpu.txt
   http://psx.rules.org/

Note 2: Finding the CLUT skills
     CLUT is very obvious, is a color line.
     8bit CLUT length 256 4bit the CLUT length of 16
     CLUT memory abscissa must be an integer multiple of 16 (which is why
     About 16 pixels reasons set about pressing the arrow keys)

Note 3: ePSXe memory began in the progress of the archive decompression offset $ 2733DF. (1.52 and 1.60)
   adripsx memory on the progress of the archive offset 0, no compression.
   Program automatically identify more than two
   The peops soft at the same time support plug capture is memory, but plug-in
     16-bit color BMP when converted to 24-bit color distortion, so there is no practical significance.



Revision History

v1.1 2007.2.8 correction window is missing the last 1-pixel-height bug (thanks to Vincent B. discovered the problem)
v1.0 2003.10.1
