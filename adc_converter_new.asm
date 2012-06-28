; Title: Voltmeter with pBlaze implemented on Spartan 3AN (Xlinx)
; Authors: Daniel Matras, Lukasz Madon
; emails: {mmatras,lukasz.madon} at gooogle's mail
; Krakow, 2012 
; AGH

MEM "init_test.mem" ;; generate by pBlaze
;VHDL "ROM_form.vhd", "init_test.vhd" ;; memory template

port0 EQU 0
PORT00 DSOUT port0

; --- ADC & AMP  definitons ---
adc_amp_port        EQU       $50
adc_amp_data_port   EQU       $51
adc_conv_port       EQU       $52
adc_data_port       EQU       $53

PORT01 DSIO adc_amp_port
PORT02 DSIN adc_amp_data_port
PORT03 DSIO adc_conv_port
PORT04 DSIN adc_data_port

;;; cost values 
d48 EQU 48 ; offset ASCII number 0-9
d65 EQU 55 ; ACII A-E

;;;;;;;;;; LCD ports;;;;;;;;;;;;;;;;;;;;;;
lcd_value_port      EQU       48
lcd_control_port    EQU       49

PORT05 DSOUT lcd_value_port
PORT06 DSOUT lcd_control_port

DB EQU s1
E EQU s2
RS EQU s3
RW EQU s4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;lcdCONFIG;;;;;;;;;;;;;;;
LOAD DB,00
LOAD E,00
LOAD RS,00
LOAD RW,00

LOAD DB,$38
OUT DB,lcd_value_port
CALL setE
LOAD DB,$06
OUT DB,lcd_value_port
CALL setE
LOAD DB,$0E
OUT DB,lcd_value_port
CALL setE
LOAD DB,$01
OUT DB,lcd_value_port
CALL setE
LOAD DB,$CC
OUT DB,lcd_value_port
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

config0 EQU sF;
config1 EQU s7;
config2 EQU s8;
config3 EQU s9;
config4 EQU s5;
config5 EQU s6;

num1 EQU sB;
num2 EQU sC;
num3 EQU sD;
num4 EQU sE;

LOAD config0, 0;
LOAD config1, 1;
LOAD config2, 2;
LOAD config3, 3;
LOAD config4, 4;
LOAD config5, 5;

;;; seting the amplifier 
	 ;OUT config8,adc_amp_port ; reset, clk 0
	 ;CALL delay_short
	
	 OUT config0,adc_amp_port ; clock
	 CALL delay_short	 	

	 OUT config4,adc_amp_port ; start config AMP_CS high, clk 1
	 CALL delay_short	
		
	 OUT config0,adc_amp_port ; start config AMP_CS high, clk 1
	  CALL delay_short
	
     OUT config0,adc_amp_port ; mosi start, clk 0
     CALL delay_short	
     OUT config0,adc_amp_port ; mosi start, clk 0
     CALL delay_short

	  OUT config1,adc_amp_port    ; , clk1
	  CALL delay_short	   	
	
	  OUT config0,adc_amp_port   ; , clk0 	  	  	
	  CALL delay_short	   	
	
	  OUT config1,adc_amp_port	 ; , clk1 	  	  	
	  CALL delay_short	   	
	
	  OUT config0,adc_amp_port	  ; , clk0	  	  	
	  CALL delay_short	   	
	
	  OUT config1,adc_amp_port	 ; , clk1 	  	  	
	  CALL delay_short	   	

	 OUT config0,adc_amp_port ; mosi start, clk 0
     CALL delay_short
	 OUT config2,adc_amp_port ; start config AMP_CS high, clk 1
     CALL delay_short	
     OUT config3,adc_amp_port ; start config AMP_CS high, clk 1
     CALL delay_short
	 OUT config2,adc_amp_port ; start config AMP_CS high, clk 1
     CALL delay_short

     OUT config0,adc_amp_port ; mosi start, clk 0
     CALL delay_short
	
	  OUT config0,adc_amp_port   ; , clk0 	  	  	
	  CALL delay_short	   	
	
	  OUT config1,adc_amp_port	 ; , clk1 	  	  	
	  CALL delay_short	   	
	
	  OUT config0,adc_amp_port	  ; , clk0	  	  	
	  CALL delay_short	   	
	
      OUT config1,adc_amp_port	 ; , clk1 	  	  	
	  CALL delay_short	   	
	
	  OUT config0,adc_amp_port	  ; , clk0	  	  	
	  CALL delay_short	   	
	
	  OUT config1,adc_amp_port	 ; , clk1 	  	  	
	  CALL delay_short

	  OUT config0,adc_amp_port ; clock
	  CALL delay_short	 	

	 OUT config0,adc_amp_port ; mosi start, clk 0
     CALL delay_short
	  OUT config2,adc_amp_port ; start config AMP_CS high, clk 1
     CALL delay_short
	  OUT config3,adc_amp_port    ; , clk1
	  CALL delay_short	   	
	  OUT config2,adc_amp_port ; start config AMP_CS high, clk 1
     CALL delay_short
		
	 ;;;;;;;;;;;;;;;;;;;;;	
	 OUT config0,adc_amp_port ; start config AMP_CS high, clk 1
     CALL delay_short

	 OUT config4,adc_amp_port ; start config AMP_CS high, clk 1
	 CALL delay_short
	
 		OUT config4,adc_amp_port ; start config AMP_CS high, clk 1
     CALL delay_short

	 OUT config5,adc_amp_port ; start config AMP_CS high, clk 1
     CALL delay_short

	 OUT config4,adc_amp_port ; start config AMP_CS high, clk 1
     CALL delay_short	
	  	
mainLoop:

	  CALL adConv2	

	  ;LOAD num1, $3 test values
	  ;LOAD num2, $5
	  ;LOAD num3, $3
	  ;LOAD num4, $		
	;;; first LCD frame	
	CALL setE
	LOAD DB,$01
	OUT DB,lcd_value_port
	CALL setE
	
	 CALL setE
	 
	 CALL toU2 ;; printing - sign
	 
	 CALL setERS
	 ;;;;;;;;;;;;;
	      LOAD sA, num1
  	      COMP num1, 10
	  	  JUMP C, not_zero15
  	      ADD sA, d65
      	  JUMP out_val15
          not_zero15: ADD sA, d48 ;less
      	  out_val15:
	 ;;;;;;;;;;;;;
	 LOAD DB,sA
	 OUT DB,lcd_value_port
	 CALL setERS
	 ;;;;;;;;;;;;;
	      LOAD sA, num2
		  COMP num2, 10
	      JUMP C, not_zero16
          ADD sA, d65
          JUMP out_val16
          not_zero16: ADD sA, d48 ;
          out_val16:
	 ;;;;;;;;;;;;;
	 LOAD DB,sA
	 OUT DB,lcd_value_port
	 CALL setERS
	 ;;;;;;;;;;;;
	       LOAD sA, num3
		   COMP num3, 10
	       JUMP C, not_zero17
           ADD sA, d65
           JUMP out_val17
           not_zero17: ADD sA, d48 ;mniejsze
           out_val17:
	 ;;;;;;;;;;;;
	 LOAD DB,sA
	 OUT DB,lcd_value_port
	 CALL setERS
	 ;;;;;;;;;;;;
	       LOAD sA, num4
		   COMP num4, 10
	       JUMP C, not_zero18
           ADD sA, d65
           JUMP out_val18
           not_zero18: ADD sA, d48 ;mniejsze
           out_val18:
	 ;;;;;;;;;;;;
	 LOAD DB,sA
	 OUT DB,lcd_value_port
	
	;;;;;;;;;;BCD;;;;;;;;;;
	;8324
;	LOAD num4,9; test
;	LOAD num3,10
;	LOAD num2,0
;	LOAD num1,1
	
	LOAD sA, num4
	LOAD num4, num1
	LOAD num1, sA

	LOAD sA, num3
	LOAD num3, num2
	LOAD num2, sA
		
	;2 hex in one reg
	SL0 num2
	SL0 num2
	SL0 num2
	SL0 num2
	ADD num2, num1

	SL0 num4
	SL0 num4
	SL0 num4
	SL0 num4
	ADD num4, num3

	;number is in num4 and num2
       LOAD num3, 0
	   CALL num4toBCD
	   CALL num4toBCD
	   CALL num4toBCD
	   CALL num4toBCD

	   CALL num4toBCD
	   CALL num4toBCD
	   CALL num4toBCD
	   CALL num4toBCD	
	   ; num2 is empty, so we can use it
	   CALL num2toBCD
	   CALL num2toBCD
	   CALL num2toBCD
	   CALL num2toBCD
	
	   CALL num2toBCD
	   CALL num2toBCD
	   CALL num2toBCD
	   CALL num2toBCDLast
	
	   ;result = num4 and num2
	   ;least significant bits in num3 then num4
	   LOAD num4, 0
	
	   SL0 num3
	   JUMP C, bitset
	   SL0 num4
	   JUMP bitnotset
	   bitset:
	   SL1 num4
	   bitnotset:
	
	   SL0 num3
	   JUMP C, bitset1
	   SL0 num4
	   JUMP bitnotset1
	   bitset1:
	   SL1 num4
	   bitnotset1:
	   
	   SL0 num3
	   JUMP C, bitset2
	   SL0 num4
	   JUMP bitnotset2
	   bitset2:
	   SL1 num4
	   bitnotset2:
	   
	   SL0 num3
	   JUMP C, bitset3
	   SL0 num4
	   JUMP bitnotset3
	   bitset3:
	   SL1 num4
	   bitnotset3:
	
	   SR0 num3
	   SR0 num3
	   SR0 num3
	   SR0 num3

	   ;;; next number
	      LOAD num1, 0
	
	   SL0 num2
	   JUMP C, bitset4
	   SL0 num1
	   JUMP bitnotset4
	   bitset4:
	   SL1 num1
	   bitnotset4:
	
	   SL0 num2
	   JUMP C, bitset5
	   SL0 num1
	   JUMP bitnotset5
	   bitset5:
	   SL1 num1
	   bitnotset5:
	
	   SL0 num2
	   JUMP C, bitset6
	   SL0 num1
	   JUMP bitnotset6
	   bitset6:
	   SL1 num1
	   bitnotset6:
	
	   SL0 num2
	   JUMP C, bitset7
	   SL0 num1
	   JUMP bitnotset7
	   bitset7:
	   SL1 num1
	   bitnotset7:
	
	   SR0 num2
	   SR0 num2
	   SR0 num2
	   SR0 num2
	
	   ;;;;;;;;;;print BCD;;;;;;;;;;;;
	 ;LOAD num4, 5; test
	 ;LOAD num3, 9;
	 
	 ADD num1, d48
	 ADD num2, d48
	 ADD num4, d48
	 ADD num3, d48
	 
	 CALL setERS
	 LOAD DB,$20
	 OUT DB,lcd_value_port
	 CALL setERS
	 LOAD DB,num1
	 OUT DB,lcd_value_port
	 CALL setERS
	 LOAD DB,num2
	 OUT DB,lcd_value_port
	 CALL setERS
	 LOAD DB,num4
	 OUT DB,lcd_value_port
	 CALL setERS
	 LOAD DB,num3
	 OUT DB,lcd_value_port
	 CALL setERS
	
	;;end of LCD frame
	CALL delay_1x
	CALL delay_1x
	CALL delay_1x
	CALL delay_1x	
		
    JUMP mainLoop
;;; LCD E frame	
setE:
	   LOAD E,00
	   OUT E,lcd_control_port
	   CALL delay_1m
	   CALL delay_1m
	   CALL delay_1m	
	   LOAD E,01
	   OUT E,lcd_control_port
	   CALL delay_1m
	   CALL delay_1m
	   CALL delay_1m
	   RET
;; RS frame
setERS:
	   LOAD E,02
	   OUT E,lcd_control_port
	   CALL delay_1m
	   CALL delay_1m
	   CALL delay_1m	
	   LOAD E,03
	   OUT E,lcd_control_port
	   CALL delay_1m
	   CALL delay_1m
	   CALL delay_1m
	   RET	

adConv2:
	   ;; clear old values
	   LOAD sA, 0
	   LOAD num1, 0
	   LOAD num2, 0
	   LOAD num3, 0
	   LOAD num4, 0
	   	
	   OUT config0, adc_conv_port
	   CALL delay_short	
	   OUT config4, adc_conv_port
	   CALL delay_short	
	   OUT config0, adc_conv_port
	   CALL delay_short
	;; 3 cycles init
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	;;; Read 14 bits
	;IN sA - input bit
	;COMP sA 1 ; compare and set bit ZERO if sA == 1
	;JUMP NZ, not_zero ; if ZERO =1 go to not_zero
	;SL0 sB ;else, shit 0
	;JUMP out_val
	;not_zero: SL1 sB shit 
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
    ;;;;;;;;;;;;;;;;;;;;num1
	   COMP sA, 1
	   JUMP Z, not_zero0
	   CALL delay_short
	   SL0 num1
	   CALL delay_short
	   JUMP out_val0
	   CALL delay_short
	   not_zero0: SL1 num1
	   CALL delay_short
	   out_val0:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	   ;;;;;;;;;;;;;;;;;;;;num1
	   COMP sA, 1
	   JUMP Z, not_zero1
	   CALL delay_short
	   SL0 num1
	   CALL delay_short
	   JUMP out_val1
	   CALL delay_short
	   not_zero1: SL1 num1
	   CALL delay_short
	   out_val1:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
    ;;;;;;;;;;;;;;;;;;;;num2
	   COMP sA, 1
	   JUMP Z, not_zero4
	   CALL delay_short
	   SL0 num2
	   CALL delay_short
	   JUMP out_val4
	   CALL delay_short
	   not_zero4: SL1 num2
	   CALL delay_short
	   out_val4:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num2
	   COMP sA, 1
	   JUMP Z, not_zero5
	   CALL delay_short
	   SL0 num2
	   CALL delay_short
	   JUMP out_val5
	   CALL delay_short
	   not_zero5: SL1 num2
	   CALL delay_short
	   out_val5:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num2
	   COMP sA, 1
	   JUMP Z, not_zero6
	   CALL delay_short
	   SL0 num2
	   CALL delay_short
	   JUMP out_val6
	   CALL delay_short
	   not_zero6: SL1 num2
	   CALL delay_short
	   out_val6:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num2
	   COMP sA, 1
	   JUMP Z, not_zero7
	   CALL delay_short
	   SL0 num2
	   CALL delay_short
	   JUMP out_val7
	   CALL delay_short
	   not_zero7: SL1 num2
	   CALL delay_short
	   out_val7:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num3
	   COMP sA, 1
	   JUMP Z, not_zero8
	   CALL delay_short
	   SL0 num3
	   CALL delay_short
	   JUMP out_val8
	   CALL delay_short
	   not_zero8: SL1 num3
	   CALL delay_short
	   out_val8:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num3
	   COMP sA, 1
	   JUMP Z, not_zero9
	   CALL delay_short
	   SL0 num3
	   CALL delay_short
	   JUMP out_val9
	   CALL delay_short
	   not_zero9: SL1 num3
	   CALL delay_short
	   out_val9:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num3
	   COMP sA, 1
	   JUMP Z, not_zero10
	   CALL delay_short
	   SL0 num3
	   CALL delay_short
	   JUMP out_val10
	   CALL delay_short
	   not_zero10: SL1 num3
	   CALL delay_short
	   out_val10:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num3
	   COMP sA, 1
	   JUMP Z, not_zero11
	   CALL delay_short
	   SL0 num3
	   CALL delay_short
	   JUMP out_val11
	   CALL delay_short
	   not_zero11: SL1 num3
	   CALL delay_short
	   out_val11:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num4
	   COMP sA, 1
	   JUMP Z, not_zero12
	   CALL delay_short
	   SL0 num4
	   CALL delay_short
	   JUMP out_val12
	   CALL delay_short
	   not_zero12: SL1 num4
	   CALL delay_short
	   out_val12:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num4
	   COMP sA, 1
	   JUMP Z, not_zero13
	   CALL delay_short
	   SL0 num4
	   CALL delay_short
	   JUMP out_val13
	   CALL delay_short
	   not_zero13: SL1 num4
	   CALL delay_short
	   out_val13:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short   
	   ;xxxxxxxxxxxxxxxxxxxxxxxxx
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;num4
	   COMP sA, 1
	   JUMP Z, not_zero144
	   CALL delay_short
	   SL0 num4
	   CALL delay_short
	   JUMP out_val144
	   CALL delay_short
	   not_zero144: SL1 num4
	   CALL delay_short
	   out_val144:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short
	;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   IN sA, adc_data_port
	   CALL delay_short
    ;;;;;;;;;;;;;;;;;;;;num4
	   COMP sA, 1
	   JUMP Z, not_zero155
	   CALL delay_short
	   SL0 num4
	   CALL delay_short
	   JUMP out_val155
	   CALL delay_short
	   not_zero155: SL1 num4
	   CALL delay_short
	   out_val155:
	;;;;;;;;;;;;;;;;;;;
	   CALL delay_short	   
	;;2 cycles
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	;   IN sA, adc_data_port
	   CALL delay_short
	   	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	;   IN sA, adc_data_port
	   CALL delay_short
	;;14 cycles
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short
	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	   CALL delay_short		
	;;2 cycles
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	;   IN sA, adc_data_port
	   CALL delay_short
	   	
	   OUT config1, adc_conv_port
	   CALL delay_short
	   OUT config0, adc_conv_port
	;   IN sA, adc_data_port
	   CALL delay_short
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	   OUT sB, port0
	   RET
	   
;;; delay for clock	   
delay_1const EQU $0B ;11d

delay_short: LOAD s0, delay_1const
wait_short:  SUB s0, 01
			JUMP NZ, wait_short
			LOAD s0, s0 ;pusta instrukcja
			RET
			
delay_40u: LOAD s1, 24 ;36d
wait_40u:  CALL delay_short
			 SUB s1, 01
			 JUMP NZ, wait_40u
			 RET
			
delay_1m: LOAD s2, 19 ;25d
wait_1m:	CALL delay_40u
			SUB s2,01
			JUMP NZ, wait_1m
			RET
			
delay_1x: LOAD s3, 250 ;25d
wait_1x:	CALL delay_1m
			SUB s3,01
			JUMP NZ, wait_1x
			RET
			
			
;;;;;;;BCD;;;;;;;;
num4toBCD:
	;least sig bit to CARRY
	SL0 num2
	JUMP C, notzero2
	SL0 num4
	JUMP go2
	notzero2:
	SL1 num4
	go2:

	JUMP C, notzero
	SL0 num3
	JUMP go
	notzero:
	SL1 num3
	go:

	CALL checkAndAdd
RET

num2toBCD:
	; CARRY put bit from num4
	SL0 num4

	JUMP C, notzero5
	SL0 num3
	JUMP go5
	notzero5:
	SL1 num3
	go5:

	JUMP C, notzero6
	SL0 num2
	JUMP go6
	notzero6:
	SL1 num2
	go6:

	;to co bylo
	CALL checkAndAdd
	;dla kolejnych 8 bitow w num2
	CALL checkAndAddN2
RET

num2toBCDLast:
	;do CARRY wstawiamy bit z num4, a nastepnie
	;przesowamy num3
	SL0 num4
	
	JUMP C, notzero9
	SL0 num3
	JUMP go9
	notzero9:
	SL1 num3
	go9:
	
	;teraz w C mamy bit z num3, wstawiamy go do num2
	
	JUMP C, notzero10
	SL0 num2
	JUMP go10
	notzero10:
	SL1 num2
	go10:				
RET

checkAndAdd:
	;tmp value to num1
	;;;;;;;;;;;;;;;; 1111 0000
	LOAD num1, num3

	AND num1, 240
	SR0 num1
	SR0 num1
	SR0 num1
	SR0 num1

	COMP num1,5
	JUMP C,go1
	ADD num3, 48
	go1:
	;;;;;;;;;;;;;;;; 0000 1111
	LOAD num1, num3

	AND num1, 15

	COMP num1,5
	JUMP C,go3
	ADD num3, 3
	go3:

RET

checkAndAddN2:
	;;;;;;;;;;;;;;;; 1111 0000
	LOAD num1, num2

	AND num1, 240
	SR0 num1
	SR0 num1
	SR0 num1
	SR0 num1

	COMP num1,5
	JUMP C,go7
	ADD num2, 48
	go7:
	;;;;;;;;;;;;;;;; 0000 1111
	LOAD num1, num2

	AND num1, 15

	COMP num1,5
	JUMP C,go8
	ADD num2, 3
	go8:			
RET

toU2:
	;num1 num2...
	;config5, config3
	LOAD config5, num1
	SR0 config5

	COMP config5, 1
	JUMP NZ,go88

	LOAD config5, num1
		SL0 config5
		SL0 config5
		SL0 config5
		SL0 config5
		ADD config5, num2

	LOAD config3, num3
		SL0 config3
		SL0 config3
		SL0 config3
		SL0 config3
		ADD config3, num4
		
	XOR config5, $FF
	XOR config3, $FF

	SL0 config5
	SL0 config5
	SR0 config5
	SR0 config5

	ADD config3, 1
	ADDC config5, 0

	LOAD num1, config5
	SR0 num1
	SR0 num1
	SR0 num1
	SR0 num1

	LOAD num2, config5
	SL0 num2
	SL0 num2
	SL0 num2
	SL0 num2

	SR0 num2
	SR0 num2
	SR0 num2
	SR0 num2
	;;;;num3num4;;;;;;
	LOAD num3, config3
	SR0 num3
	SR0 num3
	SR0 num3
	SR0 num3

	LOAD num4, config3
	SL0 num4
	SL0 num4
	SL0 num4
	SL0 num4

	SR0 num4
	SR0 num4
	SR0 num4
	SR0 num4
	CALL setERS
		 LOAD DB,$2D
		 OUT DB,lcd_value_port
		
	go88:
ret
