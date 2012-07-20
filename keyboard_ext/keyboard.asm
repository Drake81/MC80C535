$NOLIST               ;keine Ausgabe ins Listing
$PROCESSOR(80515)     ;Assemblierung fr Controller 80C515
$REGISTERBANK(0)      ;Linker reserviert nur Speicherplatz fr 1 Registerbank
$NOXREF               ;Referenz-Liste der Symbole wird nicht erstellt
$BATCH                ;Assembler h„lt beim Erkennen eines Fehlers nicht an
$NOMACRO              ;Quellcode enth„lt keine Makros
$NOERRORPRINT         ;keine Fehlermeldungen auf den Bildschirm
;*  Assembler-Anweisungen                                 Datum: 20.01.2006
;*****************************************************************************
$LIST
NAME   tastatur       ;Modulname
;*****************************************************************************
;Deklaration der in diesem Modul verwendeten Segmente
tastatur     SEGMENT CODE
;*****************************************************************************
;Funktion:
;*****************************************************************************
;Programmanfang

RSEG tastatur                            ;Aktivierung des CODE-Segments

;*****************************************************************************
; Konstanten

; Zeilenabfragen ( Zeile 1 bis Zeile 4 )
Zeile1		equ	11101111b
Zeile2		equ	11011111b
Zeile3		equ	10111111b
Zeile4		equ	01111111b

; Programm Beginn
start:		lcall testz1
		lcall testz2
		lcall testz3
		lcall testz4
		sjmp start

; Zeile1 testen
testz1:		mov P5,Zeile1		; Lade Zeile1 nach Port 5
		mov a,P5		; Lade Port 5 in den Akku
		cjne,Zeile1,aus10	; Wenn a <> Zeile1 dann springe nach aus10
		ret			; Ansonsten springe zurück
		
aus10:		cjne,#11101110b,aus11	; Wenn a <> bitkonstante dann springe nach aus11
		mov p4,#000h		; Gebe 00h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus11:		cjne,#11101101b,aus12	; Wenn a <> bitkonstante dann springe nach aus12
		mov p4,#001h		; Gebe 01h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus12:		cjne,#11101011b,aus13	; Wenn a <> bitkonstante dann springe nach aus13
		mov p4,#002h		; Gebe 02h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus13:		cjne,#11100111b,aus14	; Wenn a <> bitkonstante dann springe nach aus14
		mov p4,#003h		; Gebe 03h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus14:		ret			; Ansonsten springe zurück

; Zeile2 testen
testz2:		mov P5,Zeile1		; Lade Zeile1 nach Port 5
		mov a,P5		; Lade Port 5 in den Akku
		cjne,Zeile1,aus20	; Wenn a <> Zeile1 dann springe nach aus10
		ret			; Ansonsten springe zurück
		
aus20:		cjne,#11101110b,aus21	; Wenn a <> bitkonstante dann springe nach aus11
		mov p4,#004h		; Gebe 00h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus21:		cjne,#11101101b,aus22	; Wenn a <> bitkonstante dann springe nach aus12
		mov p4,#005h		; Gebe 01h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus22:		cjne,#11101011b,aus23	; Wenn a <> bitkonstante dann springe nach aus13
		mov p4,#006h		; Gebe 02h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus23:		cjne,#11100111b,aus24	; Wenn a <> bitkonstante dann springe nach aus14
		mov p4,#007h		; Gebe 03h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus24:		ret			; Ansonsten springe zurück

; Zeile3 testen
testz3:		mov P5,Zeile1		; Lade Zeile1 nach Port 5
		mov a,P5		; Lade Port 5 in den Akku
		cjne,Zeile1,aus30	; Wenn a <> Zeile1 dann springe nach aus10
		ret			; Ansonsten springe zurück
		
aus30:		cjne,#11101110b,aus31	; Wenn a <> bitkonstante dann springe nach aus11
		mov p4,#008h		; Gebe 00h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus31:		cjne,#11101101b,aus32	; Wenn a <> bitkonstante dann springe nach aus12
		mov p4,#009h		; Gebe 01h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus32:		cjne,#11101011b,aus33	; Wenn a <> bitkonstante dann springe nach aus13
		mov p4,#00Ah		; Gebe 02h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus33:		cjne,#11100111b,aus34	; Wenn a <> bitkonstante dann springe nach aus14
		mov p4,#00Bh		; Gebe 03h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus34:		ret			; Ansonsten springe zurück
; Zeile4 testen
testz4:		mov P5,Zeile1		; Lade Zeile1 nach Port 5
		mov a,P5		; Lade Port 5 in den Akku
		cjne,Zeile1,aus40	; Wenn a <> Zeile1 dann springe nach aus10
		ret			; Ansonsten springe zurück
		
aus40:		cjne,#11101110b,aus41	; Wenn a <> bitkonstante dann springe nach aus11
		mov p4,#00Ch		; Gebe 00h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus41:		cjne,#11101101b,aus42	; Wenn a <> bitkonstante dann springe nach aus12
		mov p4,#00Dh		; Gebe 01h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus42:		cjne,#11101011b,aus43	; Wenn a <> bitkonstante dann springe nach aus13
		mov p4,#00Eh		; Gebe 02h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus43:		cjne,#11100111b,aus44	; Wenn a <> bitkonstante dann springe nach aus14
		mov p4,#00Fh		; Gebe 03h an Port 4 aus
		ret			; Ansonsten springe zurück
		
aus44:		ret			; Ansonsten springe zurück

;*****************************************************************************
          END                        ;Programmende