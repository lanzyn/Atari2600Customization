    processor 6502
    include "dasm/machines/atari2600/macro.h"
    include "dasm/machines/atari2600/vcs.h"

    ORG $F000

RESET:
    sei
    cld
    ldx #$FF
    txs
    inx

    lda #$22       ; muda o background pra azul
    sta COLUBK

    lda #$1C       ; cor da barra (Player 0)
    sta COLUP0

    lda #%11111111 ; forma da barra (8 pixels)
    sta GRP0

    lda #$80       ; posição horizontal (centro)
    sta RESP0

DrawFrame:
    sta WSYNC      ; espera o início da linha
    lda #$80
    sta RESP0      ; reposiciona Player 0 a cada linha
    lda #%11111111
    sta GRP0       ; mantém a barra visível
    lda #$00
    sta GRP1       ; Player 1 invisível
    jmp DrawFrame

    ORG $FFFC
    .word RESET
    .word RESET
