deforleard
=========
NES Superman RLE tool. Game uses RLE encoded tile maps. This tool can decode/encode them.

Usage:
```
deforleard [-d | -e] file_name [offset]
```


***-d*** - Decode from ROM to binary file. Input ROM name and offset in it must be specified: -d <file_name offset> 

***-e*** - Encode from raw binary. Input binary file with raw data must be specified: -e <file_name>