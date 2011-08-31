$NOLIST               ;keine Ausgabe ins Listing
$PROCESSOR(80515)     ;Assemblierung fuer Controller 80C515
$REGISTERBANK(0)      ;Linker reserviert nur Speicherplatz fuer 1 Registerbank
$NOXREF               ;Referenz-Liste der Symbole wird nicht erstellt
$BATCH                ;Assembler haelt beim Erkennen eines Fehlers nicht an
$NOMACRO              ;Quellcode enthaelt keine Makros
$NOERRORPRINT         ;keine Fehlermeldungen auf den Bildschirm
;*  Assembler-Anweisungen                          Datum:4.12.2000
;*****************************************************************
$LIST
NAME   dcf77se2         ;Modulname
;*****************************************************************
;Deklaration der in diesem Modul verwendeten Segmente
dcf77se2     SEGMENT CODE
;*****************************************************************
;Funktion: DCF77 Sender Emulation 
;*****************************************************************
;Programmanfang

RSEG dcf77se2                            ;Aktivierung des CODE-Segments
; Konstanten

;Zeitschleife equ 0,12 Sekunden
Z1K2	equ	15h	;Z1K2 =  32(dez.) 	
Z1K1	equ	80h	;Z1K1 = 128(dez.)  
Z1K0	equ	1dh	;Z1K0 =  29(dez.)  
Z1K3	equ	2dh	;Z1K3 =  45(dez.) 


;Ein und Ausgabe
serout  equ     024eh           ;serielle Ausgabe
serin   equ     0236h           ;serielle Eingabe

;Variable
buffer	equ	30h		;musterbuffer


		
begin:		lcall serin		; taste einlesen
		lcall serout		; taste ausgeben

		mov r7,#00h
		clr c
		
weiter:		cjne r7,#8,weiter2
		sjmp nix

weiter2:	inc r7
		rlc a			; links schieben
		jc setz			; springe nach high wenn carry = 1
		sjmp setznot		; springe nach low
		sjmp weiter	 	; springe nach weiter





;--------------------------------------------------------------------------
;	Ausgabe eines High-Bit´s
;	0,1 sec high -- 0,9 sec low
;Ausgabe: P5
;-------------------------------------------------------------------------

setz:		mov p5,#04h	; setze D3 auf high
		lcall ms100	; warte 100ms
		mov p5,#00h	; loesche D3
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		sjmp weiter	; fertig !




 
;--------------------------------------------------------------------------
;	Ausgabe eines Low-Bit´s
;	0,2 sec high -- 0,8 sec low
;Ausgabe: P5
;-------------------------------------------------------------------------

setznot:	mov p5,#04h	; setze D3 auf high
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		mov p5,#00h	; loesche D3
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		lcall ms100	; warte 100ms
		sjmp weiter	; fertig !





;--------------------------------------------------------------------------
;	Ausgabe der Sendepause
;	1 sec low
;Ausgabe: P5
;-------------------------------------------------------------------------

nix:		mov p5,#00h	; loesche D3
		lcall ms100
		lcall ms100
		lcall ms100
		lcall ms100
		lcall ms100
		lcall ms100
		lcall ms100
		lcall ms100
		lcall ms100
		lcall ms100
		ljmp begin	; fertig !










;-------------------------------------------------------------------------		
ms100:	
	 mov r2,#Z1K2	; Zeitschleife R2	(1)
l12:	 mov r1,#Z1K1	; Zeitschleife R1	    (1)
l11:	 mov r0,#Z1K0	; Zeitschleife R0	        (1)
l10:	 djnz r0,l10	; R0 dekrementieren	             (2)
	 djnz r1,l11	; R1 dekrementieren	        (2)
	 djnz r2,l12	; R2 dekrementieren	    (2)
	
	 mov r3,#Z1K3	; Zeitschleife 91 M	(1)
l13	 djnz r3,l13	; R3 dekrementieren			    (2)	
	
	 ret		; return




;**************************************************************
          END                        ;Programmende