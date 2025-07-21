@echo off
java -jar rars.jar src\jogo.asm \
    dump .text HexText text.dump ^
    dump .data HexText data.dump ^
    dump 0x00100000:0x00112FFF Binary data\mapa2_colisao.data
pause
