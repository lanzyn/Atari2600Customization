; Author: Lucas Avanço (avanco89 at gmail)
; based on "thin red line by Kirk Israel"
; based on Stella Programming Guide

	processor 6502
	include vcs.h
	org $F000

; Variables (memory region: $80 to $FF)
YPosBall = $80
BallSize = $81
DirectionBall = $82
Top = $83
Down = $84
BallLeftRight = $85
Player0Pos = $86
Player1Pos = $87
Player0Size = $88
Player1Size = $89
Player0ActualSize = $90
Player1ActualSize = $91
LifePlayer0 = $92
LifePlayer1 = $93
CurrentSpeed = $94
CollisionTimer = $95

Start			; init stuff:
	SEI		; no interruptions
	CLD		; clear BCD Math Bit
	LDX #$FF	; X to up
	TXS		; stack pointer = X
	LDA #0

ClearMem
	STA 0,X		; MEM[X+0] = Accumulator value
	DEX		; X--
	BNE ClearMem

	LDA #190
	STA YPosBall
	LDA #194
	STA Top		; it will allow change ball direction to down
	LDA #6
	STA Down	; it will allow change ball direction to up
	LDA #0
	STA BallSize
	STA DirectionBall	; 0: down, 1: up
	LDA #$10
	STA BallLeftRight	; $10: left, $F0: right
	LDA #110
	STA Player0Pos
	STA Player1Pos
	LDA #0
	STA Player0Size		; draw controller
	STA Player1Size
	LDA #30
	STA Player0ActualSize
	LDA #34		; true size
	STA Player1ActualSize
	LDA #30
	STA LifePlayer0
	STA LifePlayer1
	LDA #$10              ; Velocidade Inicial (1 pixel por frame)
	STA CurrentSpeed      ; Guarda na memória

SetColors
	LDA #$C6      
	STA COLUBK   ; background color (verde escuro clássico)
	LDA #$21    ; defining PlayField size (D0) and Ball size (D4, D5)
	STA CTRLPF
	LDA #$10
	STA PF0
	LDA #$0E    ; ball color (branco)
	STA COLUPF
	LDA #$44       ; Cor avermelhada
    STA COLUP0     ; Define cor do Player 0 (Esquerda)
    LDA #$86       ; Cor azulada
    STA COLUP1     ; Define cor do Player 1 (Direita)

MainLoop

	; --- NOVO: SILENCIA O SOM DO FRAME ANTERIOR ---
	LDA #0
	STA AUDV0    ; Volume Zero (Cala a boca)
	; ----------------------------------------------

	LDA	#2	; VSYNC D1 = 1 --> turn off electron beam,
			;  position it at the top of the screen
	STA VSYNC	; VSYNC must be sent for at least 3 scanlines
	STA WSYNC	;  by TIA
	STA WSYNC
	STA WSYNC
	LDA #0
	STA VSYNC	; the time is over

	LDA #43		; 37 scanlines * 76 machine cycles = 2812
				; 2812 + 5 cycles(init timer) + 3 cycles(STA WSYNC) + 6 cycles(loop check)
				; Finally we have 2812-14=2798 cycles while VBLANK scanlines, and 2798/64=43
	STA TIM64T

	LDA #2
	STA VBLANK

	; game logic, timer is running
	LDA DirectionBall
	BNE BallUp
	DEC YPosBall
	LDA Down
	CMP YPosBall
	BNE EndBallUpDown
BallUp
	LDA #1
	STA DirectionBall
	INC YPosBall
	LDA Top
	CMP YPosBall
	BNE EndBallUpDown
	LDA #0
	STA DirectionBall
EndBallUpDown
	; input control Player0: down and up
	LDA #%00010000	;Up?
	BIT SWCHA 
	BNE SkipMoveDown0
	INC Player0Pos
	INC Player0Pos
SkipMoveDown0
	LDA #%00100000	;Down?
	BIT SWCHA 
	BNE SkipMoveUp0
	DEC Player0Pos
	DEC Player0Pos
SkipMoveUp0
	; input control Player1: down and up
	LDA #%00000001	;Up?
	BIT SWCHA 
	BNE SkipMoveDown1
	INC Player1Pos
	INC Player1Pos
SkipMoveDown1
	LDA #%00000010	;Down?
	BIT SWCHA 
	BNE SkipMoveUp1
	DEC Player1Pos
	DEC Player1Pos
SkipMoveUp1
	;check collision: Player0 and Ball (Bateu na Direita -> Vai pra Esquerda)
	LDA #%1000000
	BIT CXP0FB
	BEQ NoCollisionP0Ball

	; --- SOM DE RAQUETADA (PING) ---
	LDA #4       ; Timbre (Puro)
	STA AUDC0
	LDA #4       ; Frequencia (Agudo)
	STA AUDF0
	LDA #8       ; Volume (Medio)
	STA AUDV0
	
	; AUMENTAR VELOCIDADE
	CLC
	LDA CurrentSpeed    ; Pega velocidade atual
	ADC #$10            ; Soma +1 de velocidade
	CMP #$50            ; Chegou no limite (velocidade 5)?
	BCS SkipSpeedIncP0  ; Se já é 50 ou mais, não aumenta
	STA CurrentSpeed    ; Salva nova velocidade
SkipSpeedIncP0
	LDA CurrentSpeed    ; Carrega a velocidade (positiva = Esquerda)
	STA BallLeftRight   ; Aplica na bola
NoCollisionP0Ball


	;check collision: Player1 and Ball (Bateu na Esquerda -> Vai pra Direita)
	LDA #%1000000
	BIT CXP1FB
	BEQ NoCollisionP1Ball

	; --- SOM DE RAQUETADA (PING) ---
	LDA #4       ; Timbre (Puro)
	STA AUDC0
	LDA #4       ; Frequencia (Agudo)
	STA AUDF0
	LDA #8       ; Volume (Medio)
	STA AUDV0

	; AUMENTAR VELOCIDADE
	CLC
	LDA CurrentSpeed
	ADC #$10
	CMP #$50
	BCS SkipSpeedIncP1
	STA CurrentSpeed
SkipSpeedIncP1
	LDA #0
	SEC                 ; Prepara subtração
	SBC CurrentSpeed    ; Faz (0 - Velocidade) para ficar Negativo (Direita)
	STA BallLeftRight
NoCollisionP1Ball
	;check collision: Ball and PlayField
	LDA CollisionTimer      ; Verifica se tem "Modo Fantasma"
	BNE DecreaseTimer       ; Se tiver (>0), diminui o tempo e IGNORA a colisão
	
	LDA #%10000000          ; Se não tiver, vida normal: Checa colisão
	BIT CXBLPF
	BEQ NoCollisionBallPF
	
	; --- GOL DETECTADO ---
	STA CXCLR	            ; Limpa colisões
	LDA BallLeftRight      
	BPL Player1Penalty     
	BMI Player0Penalty     

DecreaseTimer
	DEC CollisionTimer      ; Diminui o tempo de invencibilidade (30, 29, 28...)
	JMP NoCollisionBallPF   ; Segue o jogo sem tirar vida!
Player0Penalty
; --- SOM DE GOL (BOOM) ---
	LDA #8       ; Timbre (Ruído Branco/Explosão)
	STA AUDC0
	LDA #15      ; Frequencia (Grave)
	STA AUDF0
	LDA #15      ; Volume (Maximo)
	STA AUDV0

	LDA #30                 ; <--- ATIVA MODO FANTASMA: 60 frames (1 seg) de invencibilidade
	STA CollisionTimer      ; Isso deixa a bola sair da parede sem morrer de novo!
	
	LDA #$10 
	STA CurrentSpeed      
	STA BallLeftRight       ; Reseta velocidade para Lento
	
	LDA #100                ; Põe no MEIO da altura (Segurança)
	STA YPosBall          
	
	DEC Player0ActualSize
	DEC LifePlayer0
	BEQ EndGame
	JMP NoCollisionBallPF

Player1Penalty
; --- SOM DE GOL (BOOM) ---
	LDA #8       ; Timbre (Ruído Branco/Explosão)
	STA AUDC0
	LDA #15      ; Frequencia (Grave)
	STA AUDF0
	LDA #15      ; Volume (Maximo)
	STA AUDV0

	LDA #30                 ; <--- ATIVA MODO FANTASMA
	STA CollisionTimer      
	
	LDA #$10 
	STA CurrentSpeed      
	
	LDA #0
	SEC
	SBC CurrentSpeed      
	STA BallLeftRight       ; Reseta velocidade para Lento
	
	LDA #100                ; Põe no MEIO da altura
	STA YPosBall
	
	DEC Player1ActualSize
	DEC LifePlayer1
	BEQ EndGame
	JMP NoCollisionBallPF
NoCollisionBallPF
	STA CXCLR	; clear all collisions
	JMP WaitVBlankEnd

EndGame
	; --- SOM DE GAME OVER ---
	LDA #3       ; Timbre (Polifonia estranha)
	STA AUDC0
	LDA #20      ; Frequencia (Bem grave)
	STA AUDF0
	LDA #15      ; Volume
	STA AUDV0

	; --- DELAY LONGO (2 a 3 segundos) ---
	LDY #150     ; Contador Externo (Repete 150 vezes o loop de dentro)
DelayOuter
	LDX #250     ; Contador Interno (Espera ~1 frame)
DelayInner
	STA WSYNC    ; Espera desenhar uma linha
	DEX          ; X--
	BNE DelayInner
	
	DEY          ; Y--
	BNE DelayOuter ; Se Y não zerou, roda o loop do X tudo de novo
	
	JMP Start

WaitVBlankEnd
	LDA INTIM	        ; Carrega o temporizador
	BNE WaitVBlankEnd	; Espera o tempo acabar
	
	STA WSYNC           ; Sincroniza linha

	; Posicionamento horizontal dos jogadores e bola
    NOP
    NOP
    NOP
    NOP
    NOP
	STA RESP1           ; Posição Player 1

    ; --- Mover Player 0 (Vermelho) ---
    LDX #11              ; Ajuste fino da posição
PosLoop
    DEX
    BNE PosLoop
	STA RESP0           ; Posição Player 0

	; Movimento fino e bola
	LDA BallLeftRight   ; Velocidade da bola
	STA HMBL            ; Aplica na bola
    
	LDA #60            ; Zera movimento extra P0
	STA HMP0
	LDA #00            ; Zera movimento extra P1
	STA HMP1
    
	STA WSYNC           ; Nova linha
	STA HMOVE           ; Aplica movimento
    
    LDA #0
    STA VBLANK          ; Liga a tela
    
    LDY #192            ; Define altura da tela

ScanLoop
	STA WSYNC
; check if we are at ball position, scanline
	CPY YPosBall
	BEQ ActiveBallSize
	LDA BallSize
	BNE DrawingBall
NoBall
	LDA #0
	STA ENABL
	JMP OutBall
ActiveBallSize
	LDA #8
	STA BallSize
DrawingBall
	LDA #2
	STA ENABL
	DEC BallSize
OutBall
; check Player0 position
	CPY Player0Pos
	BEQ ActivePlayer0Size
	LDA Player0Size
	BNE DrawingPlayer0
NoPlayer0
	LDA #0
	STA GRP0
	JMP OutPlayer0
ActivePlayer0Size
	LDA Player0ActualSize
	STA Player0Size
DrawingPlayer0
	LDA #$AA
	STA GRP0
	DEC Player0Size
OutPlayer0
; check Player1 position
	CPY Player1Pos
	BEQ ActivePlayer1Size
	LDA Player1Size
	BNE DrawingPlayer1
NoPlayer1
	LDA #0
	STA GRP1
	JMP OutPlayer1
ActivePlayer1Size
	LDA Player1ActualSize
	STA Player1Size
DrawingPlayer1
	LDA #$AA
	STA GRP1
	DEC Player1Size
OutPlayer1


	DEY
	BNE ScanLoop

	LDA #2
	STA WSYNC
	STA VBLANK	; turn it on, actual tv picture has gone

	; Overscan
	LDX #30
OverScanWait
	STA WSYNC
	DEX
	BNE OverScanWait

	JMP MainLoop

; Kirk Israel words:
; OK, last little bit of crap to take care of.
; there are two special memory locations, $FFFC and $FFFE
; When the atari starts up, a "reset" is done (which has nothing to do with
; the reset switch on the console!) When this happens, the 6502 looks at
; memory location $FFFC (and by extension its neighbor $FFFD, since it's 
; seaching for both bytes of a full memory address)  and then goes to the 
; location pointed to by $FFFC/$FFFD...so our first .word Start tells DASM
; to put the binary data that we labeled "Start" at the location we established
; with org.  And then we do it again for $FFFE/$FFFF, which is for a special
; event called a BRK which you don't have to worry about now.
	org $FFFC
	.word Start
	.word Start