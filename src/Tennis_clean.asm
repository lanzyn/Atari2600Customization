
processor 6502
INCLUDE "vcs.h"
INCLUDE "macro.h"


VSYNC   =  $00
VBLANK  =  $01
WSYNC   =  $02
NUSIZ0  =  $04
NUSIZ1  =  $05
COLUP0  =  $06
COLUP1  =  $07
COLUPF  =  $08
COLUBK  =  $09
CTRLPF  =  $0A
REFP0   =  $0B
REFP1   =  $0C
PF1     =  $0E
PF2     =  $0F
RESP0   =  $10
RESP1   =  $11
AUDC0   =  $15
AUDF0   =  $17
AUDV0   =  $19
GRP0    =  $1B
GRP1    =  $1C
ENAM0   =  $1D
ENAM1   =  $1E
ENABL   =  $1F
HMP0    =  $20
HMP1    =  $21
HMM0    =  $22
HMM1    =  $23
HMOVE   =  $2A
HMCLR   =  $2B
SWCHA   =  $0280
SWCHB   =  $0282
INTIM   =  $0284
TIM64T  =  $0296

       ORG $F000

START:
       SEI            
       CLD            
       LDX    #$00    
LF004: LDY    #$00    
LF006: STY    VSYNC,X 
       TXS            
       INX            
       BNE    LF006   
       STA    AUDC0   
       STA    AUDF0   
       RTS

; --- Fim do código executável ---
; Bloco de dados inicia aqui
LF649: .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$30,$78,$48,$C8,$48,$78
       LDX    $D0     
       BEQ    LF082   
       LDA    $BE     
       LDY    $BD     
       STA    $BD     
       STY    $BE     
       DEX            
LF082: JSR    LF618   
       BEQ    LF0C0   
LF087: STA    WSYNC   
       STA    HMOVE   
       STY    COLUPF  
       STY    ENABL   
       STX    GRP0    
       STA    GRP1    
       LDA    $BA     
       CMP    #$0C    
       BEQ    LF0F6   
       CMP    #$8C    
       BEQ    LF0FC   
       LDX    #$00    
       STX    PF1     
       STX    PF2     
       BIT    $A1     
       BEQ    LF0AD   
       CMP    #$5A    
       BEQ    LF110   
       BNE    LF0B5   
LF0AD: LDX    #$F0    
       STX    HMM1    
       LDX    #$10    
       STX    HMM0    
LF0B5: LDY    $8A     
       LDA    ($A8),Y 
       TAX            
       LDA    ($AA),Y 
       DEC    $BA     
       LDY    $BC     
LF0C0: STA    WSYNC   
       STA    HMOVE   
       STX    GRP0    
       STA    GRP1    
       LDA    $BA     
       CMP    $B6     
       BNE    LF0D1   
       INY            
       BNE    LF0D7   
LF0D1: CMP    $B7     
       BNE    LF0D7   
       LDY    #$02    
LF0D7: STY    $8B     
       LDA    $BA     
       SEC            
       SBC    $B5     
       CMP    #$19    
       BCS    LF10A   
       TAY            
       BEQ    LF10A   
       LDA    ($A4),Y 
       TAX            
       LDA    ($A6),Y 
LF0EA: STY    $8A     
       STA    HMCLR   
       LDY    $8B     
       DEC    $BA     
       BNE    LF087   
       BEQ    LF149   
LF0F6: LDX    #$3F    
       STX    PF1     
       BNE    LF100   
LF0FC: LDA    #$03    
       STA    PF1     
LF100: LDX    #$FF    
       STX    PF2     
       STA    ENAM0   
       STA    ENAM1   
       BNE    LF0B5   
LF10A: LDX    #$00    
       TXA            
       TAY            
       BEQ    LF0EA   
LF110: INX            
       STX    ENAM0   
       STX    ENAM1   
       STX    ENABL   
       LDA    #$FF    
       LDY    #$0F    
       STA    WSYNC   
       STA    HMOVE   
       STY    PF1     
       STA    PF2     
       LDA    $BC     
       STA    COLUPF  
       JSR    LF618   
       LDX    #$E0    
       STX    HMM1    
       LDX    #$20    
       STX    HMM0    
       STA    WSYNC   
       STA    HMOVE   
       LDX    #$06    
LF138: STA    WSYNC   
       STA    HMCLR   
       STA    HMOVE   
       DEX            
       BPL    LF138   
       STX    ENAM0   
       STX    ENAM1   
       INX            
       JMP    LF0C0   
LF149: STA    WSYNC   
       STA    HMOVE   
       STA    ENABL   
       SEC            
       LDA    #$F6    
       LDX    #$06    
LF154: STA    $AC,X   
       SBC    #$07    
       DEX            
       DEX            
       BPL    LF154   
       JSR    LF4EE   
       LDY    #$18    
LF161: STA    WSYNC   
       STA    HMOVE   
       DEY            
       BNE    LF161   
       LDX    #$03    
       STX    WSYNC   
       STX    VSYNC   
       STX    VBLANK  
       INC    $84     
       BNE    LF17B   
       INC    $88     
       BNE    LF17B   
       SEC            
       ROR    $88     
LF17B: DEY            
       LDA    SWCHB   
       PHA            
       AND    #$08    
       BNE    LF186   
       LDY    #$0F    
LF186: LDA    #$00    
       BIT    $88     
       BPL    LF195   
       STX    $90     
       TYA            
       AND    #$F7    
       TAY            
       LDA    $88     
       ASL    A       
LF195: STA    $82     
       STY    $83     
LF199: STA    WSYNC   
       DEX            
       BNE    LF199   
       STX    VSYNC   
       LDY    #$2D    
       STY    TIM64T  
       PLA            
       LSR    A       
       BCS    LF1AE   
       LDX    #$85    
LF1AB: JMP    LF004   
LF1AE: LSR    A       
       BCS    LF1D6   
       LDA    $A3     
       BEQ    LF1B9   
       DEC    $A3     
       BPL    LF1D8   
LF1B9: LDY    $80     
       INY            
       CPY    #$04    
       BCC    LF1C2   
       LDY    #$00    
LF1C2: STY    $80     
       TYA            
       AND    #$01    
       STA    $81     
       INY            
       STY    $86     
       LDA    #$11    
       STA    $87     
       LDX    #$88    
       STX    $85     
       BNE    LF1AB   
LF1D6: STX    $A3     
LF1D8: LDA    $CB     
       BMI    LF1E4   
       BEQ    LF1E1   
LF1DE: JMP    LF47C   
LF1E1: JSR    LF5E7   
LF1E4: LDA    $80     
       CMP    #$02    
       BCC    LF1F0   
       LDA    $84     
       AND    #$01    
       BNE    LF1DE   
LF1F0: LDX    #$01    
       STX    $89     
LF1F4: LDA    $89     
       EOR    $D0     
       TAX            
       LDA    SWCHB   
       AND    LF7FE,X 
       STA    $D3,X   
       STX    $D5     
       LDA    SWCHA   
       LDX    $89     
       CPX    $D0     
       BEQ    LF258   
       AND    #$0F    
       LDY    $81     
       BNE    LF25C   
       LDA    #$02    
       BIT    $84     
       BVS    LF21A   
       LDA    #$01    
LF21A: STA    $8B     
       CPX    $B4     
       BNE    LF22C   
       LDA    $98     
       SBC    $99     
       CMP    #$30    
       BCC    LF22C   
       LDA    #$58    
       BNE    LF22E   
LF22C: LDA    $90     
LF22E: STA    $8A     
       TXA            
       EOR    #$01    
       TAY            
       LDA    $009A,Y 
       CMP    #$50    
       BCS    LF23F   
       LDA    #$F5    
       BNE    LF241   
LF23F: LDA    #$FC    
LF241: ADC    $8A     
       SEC            
       SBC    $9A,X   
       BCC    LF24E   
       BNE    LF252   
       LDA    #$0F    
       BNE    LF254   
LF24E: LDA    #$0B    
       BNE    LF254   
LF252: LDA    #$07    
LF254: EOR    $8B     
       BNE    LF25C   
LF258: LSR    A       
       LSR    A       
       LSR    A       
       LSR    A       
LF25C: LDY    #$00    
       STY    $CD     
       ROR    A       
       BCS    LF264   
       INY            
LF264: ROR    A       
       BCS    LF268   
       DEY            
LF268: STY    $CE     
       LDY    #$00    
       ROR    A       
       BCS    LF270   
       DEY            
LF270: ROR    A       
       BCS    LF274   
       INY            
LF274: STY    $CF     
       TYA            
       BEQ    LF285   
       LDY    #$4E    
       BIT    $88     
       BPL    LF281   
       STY    $90     
LF281: LDY    #$00    
       STY    $88     
LF285: CLC            
       LDY    $CE     
       TYA            
       BEQ    LF295   
       LDA    $98,X   
       LSR    A       
       LSR    A       
       AND    #$03    
       STA    $CD     
       CLC            
       TYA            
LF295: ADC    $98,X   
       TAY            
       CMP    #$95    
       BNE    LF29D   
       DEY            
LF29D: CMP    #$01    
       BNE    LF2A2   
       INY            
LF2A2: BIT    $A0     
       BMI    LF2A8   
       STY    $98,X   
LF2A8: LDY    $98     
       CPY    #$5B    
       BCS    LF2B1   
       INY            
       STY    $98     
LF2B1: LDY    $99     
       CPY    #$36    
       BCC    LF2BA   
       DEY            
       STY    $99     
LF2BA: LDA    $CF     
       BEQ    LF2C4   
       LDA    $9A,X   
       LSR    A       
       LSR    A       
       AND    #$03    
LF2C4: PHA            
       LDA    $9A,X   
       CLC            
       LDY    $B8,X   
       BEQ    LF2CE   
       ADC    #$08    
LF2CE: CLC            
       ADC    #$01    
       SEC            
       SBC    $90     
       BCC    LF2EB   
       LDA    #$FF    
       CMP    $B8,X   
       BEQ    LF2E5   
       STA    $B8,X   
       LDA    $9A,X   
       CLC            
       ADC    #$F8    
       STA    $9A,X   
LF2E5: PLA            
       EOR    #$03    
       JMP    LF2FB   
LF2EB: LDA    #$00    
       CMP    $B8,X   
       BEQ    LF2FA   
       STA    $B8,X   
       LDA    $9A,X   
       CLC            
       ADC    #$08    
       STA    $9A,X   
LF2FA: PLA            
LF2FB: LDX    $CF     
       BNE    LF301   
       LDA    $CD     
LF301: TAX            
       LDA    LF700,X 
       PHA            
       LDX    $89     
       LDA    $C1,X   
       TAY            
       LDA    LF704,Y 
       LDY    $B8,X   
       BMI    LF319   
       STA    $9C,X   
       PLA            
       STA    $9E,X   
       BNE    LF31E   
LF319: STA    $9E,X   
       PLA            
       STA    $9C,X   
LF31E: CLC            
       LDA    $CF     
       ADC    $9A,X   
       TAY            
       CMP    #$8F    
       BCC    LF329   
       DEY            
LF329: CMP    #$11    
       BCS    LF32E   
       INY            
LF32E: STY    $9A,X   
       LDA    $C1,X   
       BEQ    LF33E   
       DEC    $C3,X   
       BNE    LF34B   
       LDA    #$04    
       STA    $C3,X   
       DEC    $C1,X   
LF33E: LDA    $98,X   
       SEC            
       SBC    $8F     
       CMP    #$08    
       BCC    LF34E   
       CMP    #$F8    
       BCS    LF34E   
LF34B: JMP    LF405   
LF34E: LDA    $A0     
       BMI    LF356   
       CPX    $B4     
       BEQ    LF34B   
LF356: LDA    $90     
       SEC            
       SBC    $9A,X   
       BCC    LF34B   
       CMP    #$10    
       BCS    LF34B   
       STA    $8A     
       BIT    $A0     
       BPL    LF37A   
       LDA    $CA     
       EOR    $D0     
       BEQ    LF375   
       LDY    $81     
       BNE    LF375   
       DEC    $A2     
       BEQ    LF37A   
LF375: TAX            
       LDY    REFP1,X 
       BMI    LF34B   
LF37A: LDX    $89     
       STX    $B4     
       LDY    #$03    
       STY    $C3,X   
       STY    $C1,X   
       STY    $C9     
       LDA    $9A,X   
       LSR    A       
       LSR    A       
       LSR    A       
       STA    $8B     
       CMP    #$0D    
       BCC    LF393   
       LDA    #$0C    
LF393: CLC            
       ADC    #$02    
       EOR    #$0F    
       CMP    $8A     
       BCC    LF39E   
       STA    $8A     
LF39E: LDA    $8B     
       CMP    #$05    
       BCS    LF3A6   
       LDA    #$05    
LF3A6: SEC            
       SBC    #$05    
       EOR    #$0F    
       CMP    $8A     
       BCC    LF3B1   
       LDA    $8A     
LF3B1: LDY    #$FE    
       STY    $93     
       LDX    #$00    
       STX    $A0     
       STX    $88     
       LDX    $D5     
       LDY    $D3,X   
       BEQ    LF3CD   
       CMP    #$0B    
       BCC    LF3C7   
       LDA    #$0B    
LF3C7: CMP    #$04    
       BCS    LF3CD   
       LDA    #$04    
LF3CD: TAY            
       LDX    $89     
       LDA    #$68    
LF3D2: CLC            
       ADC    #$30    
       BCC    LF3D9   
       INC    $93     
LF3D9: DEY            
       BPL    LF3D2   
       STA    $96     
       DEX            
       STX    $95     
       LDA    #$0C    
       STA    $91     
       LDA    #$80    
       STA    $97     
       LDA    #$02    
       STA    $94     
       LDY    #$FF    
       STY    $CC     
       DEY            
       LDA    $99,X   
       CMP    #$6E    
       BCS    LF3FC   
       CMP    #$2A    
       BCS    LF3FD   
LF3FC: DEY            
LF3FD: TYA            
       INX            
       BEQ    LF403   
       EOR    #$FF    
LF403: STA    $92     
LF405: DEC    $89     
       BMI    LF40C   
       JMP    LF1F4   
LF40C: LDX    #$02    
LF40E: CLC            
       LDA    $8C,X   
       ADC    $95,X   
       STA    $8C,X   
       LDA    $8F,X   
       ADC    $92,X   
       STA    $8F,X   
       DEX            
       BPL    LF40E   
       CLC            
       LDA    $97     
       ADC    #$E0    
       STA    $97     
       LDA    $94     
       ADC    #$FF    
       STA    $94     
       LDA    $91     
       BPL    LF441   
       LDA    #$80    
       STA    $97     
       LDA    #$02    
       STA    $94     
       STA    $C9     
       LDA    #$00    
       STA    $91     
       INC    $CC     
       BNE    LF451   
LF441: LDA    $8F     
       CMP    #$A1    
       BCS    LF44D   
       LDA    $90     
       CMP    #$9B    
       BCC    LF458   
LF44D: LDA    #$02    
       STA    $90     
LF451: BIT    $A0     
       BMI    LF458   
       JSR    LF53B   
LF458: LDA    $8F     
       ORA    #$01    
       STA    $B7     
       LDA    $8F     
       CLC            
       ADC    $91     
       ORA    #$01    
       STA    $B6     
       LDX    #$01    
LF469: LDA    $B6,X   
       CMP    #$8D    
       BEQ    LF477   
       CMP    #$0B    
       BEQ    LF477   
       CMP    #$0D    
       BNE    LF479   
LF477: INC    $B6,X   
LF479: DEX            
       BPL    LF469   
LF47C: LDA    $C9     
       BMI    LF48C   
       DEC    $C9     
       LDX    $88     
       CPX    #$10    
       BCC    LF48A   
       LDA    #$00    
LF48A: STA    AUDV0   
LF48C: LDA    $CB     
       CMP    #$7F    
       BCS    LF494   
       DEC    $CB     
LF494: JMP    LF015   
LF497: STA    ENABL,X 
       STA    WSYNC   
LF49B: DEY            
       BPL    LF49B   
       STA    PF2,X   

RTS

LF4A1: LDX    #$FE    
LF4A3: CLC            
       ADC    #$25    
       TAY            
       AND    #$0F    
       STA    $89     
       TYA            
       LSR    A       
       LSR    A       
       LSR    A       
       LSR    A       
       TAY            
       CLC            
       ADC    $89     
       CMP    #$0F    
       BCC    LF4BB   
       SBC    #$0F    
       INY            
LF4BB: EOR    #$07    
       ASL    A       
       ASL    A       
       ASL    A       
       ASL    A       
       INX            
       BPL    LF497   
       PHA            
       CPY    #$03    
       BCS    LF4CD   
       STA    WSYNC   
       STA    HMOVE   
LF4CD: STA    WSYNC   
       STA    HMOVE   
LF4D1: DEY            
       BPL    LF4D1   
       STA    RESP1   
       STA    RESP0   
       STA    WSYNC   
       STA    HMOVE   
       LDY    $BC     
       LDX    #$00    
       STX    NUSIZ0  
       STX    NUSIZ1  
       CLC            
       PLA            
       STA    HMP0    
       ADC    #$F0    
       STA    HMP1    
       TXA            
       RTS            

LF4EE: STA    WSYNC   
       STA    HMOVE   
       LDA    #$2A    
       JSR    LF4A1   
       STX    REFP0   
       STX    REFP1   
       INX            
LF4FC: STX    NUSIZ0  
       STX    NUSIZ1  
       LDY    #$06    
       LDA    ($B2),Y 
       STA    $8A     
LF506: STA    WSYNC   
       STA    HMOVE   
       LDA    $BF     
       STA    COLUP1  
       STA    COLUP0  
       LDA    ($AC),Y 
       STA    GRP1    
       LDA    ($AE),Y 
       STA    GRP0    
       LDA    ($B0),Y 
       LDX    $8A     
       STA    GRP1    
       STX    GRP0    
       LDA    $C0     
       STA    COLUP1  
       STA    COLUP0  
       DEY            
       LDA    ($B2),Y 
       STA    $8A     
       TYA            
       STA    HMCLR   
       BPL    LF506   
       STA    WSYNC   
       STA    HMOVE   
       LDA    #$00    
       STA    GRP1    
       STA    GRP0    
       RTS            

LF53B: LDA    #$7E    
       STA    $CB     
       LDA    $B4     
       EOR    $D0     
       TAX            
       INC    $C5,X   
       EOR    #$01    
       TAY            
       LDA    LF75D,X 
       STA    AUDF0   
       LDA    #$0D    
       STA    AUDC0   
       STA    $C9     
       LDA    $C5,X   
       CMP    #$05    
       BEQ    LF59C   
       CMP    #$03    
       BCC    LF570   
       CMP    $00C5,Y 
       BEQ    LF57D   
       LDA    $00C5,Y 
       CMP    #$03    
       BEQ    LF58B   
       LDA    $C5,X   
       CMP    #$04    
       BCS    LF59C   
LF570: LDA    $C5     
       CLC            
       ADC    #$0D    
       TAX            
       LDA    $C6     
       CLC            
       ADC    #$0D    
       BNE    LF5E2   
LF57D: LDA    #$03    
       STA    $D1     
       STA    $C5     
       STA    $C6     
       LDX    #$08    
       LDA    #$09    
       BNE    LF5E2   
LF58B: TXA            
       EOR    $D0     
       LDX    #$0A    
       STX    $D1     
       LDY    #$0B    
       CMP    $CA     
       BEQ    LF599   
       INY            
LF599: TYA            
       BNE    LF5E2   
LF59C: INC    $C7,X   
       LDA    #$30    
       STA    $C9     
       LDA    #$00    
       STA    $D1     
       STA    $C5     
       STA    $C6     
       LDA    $D2     
       BEQ    LF5B8   
       LDA    $C7,X   
       SEC            
       SBC    $00C7,Y 
       CMP    #$02    
       BEQ    LF5CE   
LF5B8: LDA    $C7,X   
       CMP    #$07    
       BEQ    LF5CE   
       CMP    #$06    
       BCC    LF5DE   
       CMP    $00C7,Y 
       BEQ    LF5D6   
       LDA    $00C7,Y 
       CMP    #$05    
       BCS    LF5DE   
LF5CE: LDA    #$60    
       STA    $C9     
       INC    $CB     
       BNE    LF5DE   
LF5D6: LDA    #$00    
       STA    $C8     
       STA    $C7     
       INC    $D2     
LF5DE: LDA    $C8     
       LDX    $C7     
LF5E2: STX    $87     
       STA    $86     
       RTS            

LF5E7: LDX    #$23    
LF5E9: LDA    LF709,X 
       STA    $90,X   
       DEX            
       BPL    LF5E9   
       CLC            
       LDA    $C7     
       ADC    $C8     
       LDY    #$8E    
       ROR    A       
       AND    #$01    
       STA    $CA     
       EOR    #$01    
       STA    $B4     
       EOR    #$01    
       BEQ    LF607   
       LDY    #$07    
LF607: STY    $8F     
       ROL    A       
       ADC    #$01    
       LSR    A       
       AND    #$01    
       STA    $D0     
       LDA    #$02    


; --- Fim do código executável ---
; Bloco de dados inicia aqui
LF649: .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$30,$78,$48,$C8,$48,$78
       .byte $30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$0F,$09,$F9,$09
       .byte $0F,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .byte $0C,$9E,$52,$32,$12,$1E,$0C,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$A0,$70,$50,$50,$50
       .byte $70,$20,$00,$00,$C0,$80,$86,$84,$C4,$C4,$6C,$6C,$78,$38,$30,$B1
       .byte $B3,$B7,$BE,$FC,$F8,$70,$30,$38,$38,$30,$38,$00,$00,$03,$02,$02
       .byte $82,$86,$E6,$EC,$2C,$38,$38,$30,$B1,$B3,$B7,$BE,$FC,$F8,$70,$30
       .byte $38,$38,$30,$38,$00,$00,$0C,$08,$08,$08,$28,$28,$3C,$3C,$3C,$38
       .byte $30,$B1,$B3,$B7,$BE,$FC,$F8,$70,$30,$38,$38,$30,$38,$00,$00,$30
       .byte $20,$20,$20,$2C,$28,$28,$28,$38,$38,$30,$B1,$B3,$B7,$BE,$FC,$F8
       .byte $70,$30,$38,$38,$30,$38,$00
LF700: .byte $9C,$B5,$CE,$E7
LF704: .byte $84,$6C,$5B,$4A
LF708: .byte $AB
LF709: .byte $4D,$00,$00,$00,$02,$00,$00,$80,$8E,$07,$48,$48,$84,$84,$9C,$9C
       .byte $FF,$07,$40,$20,$4A,$F6,$4A,$F6,$4A,$F6,$4A,$F6,$6A,$F7,$6A,$F7
       .byte $6A,$F7,$6A,$F7
LF72D: .byte $DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA,$A2,$B0,$B7,$C5,$CC,$DA,$71,$7F
       .byte $86,$DA
LF73F: .byte $6A,$71,$78,$7F,$86,$8D,$94,$9B,$A9,$DA,$BE,$DA,$D3,$6A,$8D,$6A
       .byte $6A,$DA
LF751: .byte $D4,$0D,$4C,$8C,$4C,$8C
LF757: .byte $04,$09,$0F,$01,$0F,$01
LF75D: .byte $0C,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3C,$66,$66
       .byte $66,$66,$66,$3C,$3C,$18,$18,$18,$18,$38,$18,$7E,$60,$60,$3C,$06
       .byte $46,$3C,$3C,$46,$06,$0C,$06,$46,$3C,$0C,$0C,$7E,$4C,$2C,$1C,$0C
       .byte $7C,$46,$06,$7C,$60,$60,$7E,$3C,$66,$66,$7C,$60,$62,$3C,$18,$18
       .byte $18,$0C,$06,$42,$7E,$E7,$94,$94,$97,$94,$94,$E7,$98,$25,$25,$25
       .byte $25,$25,$A4,$CF,$28,$08,$0E,$08,$28,$CF,$97,$94,$F4,$94,$94,$94
       .byte $67,$00,$80,$80,$80,$80,$80,$00,$A2,$A6,$A6,$AA,$B2,$B2,$A2,$63
       .byte $94,$94,$94,$94,$94,$64,$08,$88,$88,$88,$88,$88,$BE,$00,$00,$00
       .byte $00,$00,$00,$00,$AD,$A9,$E9,$A9,$ED,$41,$0F,$50,$58,$5C,$56,$53
       .byte $11,$F0,$BA,$8A,$BA,$A2,$3A,$80,$FE,$E9,$AB,$AF,$AD,$E9,$00,$00
       .byte $F0
LF7FE: .byte $40,$80

ORG $FFFC
.word START
.word START