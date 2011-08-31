$NOLIST 	      ;keine Ausgabe ins Listing
$PROCESSOR(80515)     ;Assemblierung fuer Controller 80C515
$REGISTERBANK(0)      ;Linker reserviert nur Speicherplatz fuer 1 Registerbank
$NOXREF               ;Referenz-Liste der Symbole wird nicht erstellt
$BATCH                ;Assembler haelt beim Erkennen eines Fehlers nicht an
$NOMACRO              ;Quellcode enthaelt keine Makros
$NOERRORPRINT         ;keine Fehlermeldungen auf den Bildschirm

;*  Assembler-Anweisungen                          Datum:4.12.2000
;*****************************************************************
$LIST
NAME   dcf77emp         ;Modulname
;*****************************************************************
;Deklaration der in diesem Modul verwendeten Segmente
;dcf77emp	SEGMENT CODE
;*****************************************************************
;Funktion: DCF77 Sender Emulation 
;*****************************************************************
;Programmanfang


; Definitionen




;*****************************************************************

	org 801bh			; Die naechsten Befehle ab 801bh
	ljmp time1			; springe nach time1
	
	org 804bh			; Die naechsten Befehle ab 804bh
	ljmp inter2			; springe nach inter2


	org 8100h			; Die naechsten Befehle ab 8100h

; Ein und Ausgabe
	serout	equ	024eh		; serielle Ausgabe
	serin	equ	0236h		; serielle Eingabe
	sertext	equ	027ah		; Stringausgabe(DTPR)
	ser8	equ	020ah		; Akku hex ausgeben
	sercrlf equ     0272h  	 	; Return und Linefeed

; Variablen
	Zaehler1	equ	30h	; Variable auf adr. 30h
	pauseda		equ	31h	; Markbit Pause 1=pause war da
	synmode		equ	32h	; Syncron ? 
	datentabelle	equ	9000h	; Datentabelle
	sekzaehler	equ	33h	; Sekundenzaehler
	ergbit		equ	34h	; Uebergangs Ergebnis
	minute		equ	35h	; minute
	stunde		equ	36h	; stunde
	tag		equ	37h	; tag
	wochentag	equ	38h	; wochentag
	monat		equ	39h	; monat
	jahr		equ	3ah	; jahr
	tagalt		equ	3bh	; alte Werte
	wochentagalt	equ	3ch	;
	monatalt	equ	3dh	;
	jahralt		equ	3eh	;
	DPLSTORE	equ	3fh	; Low-Byte Datenpointer
	DPHSTORE	equ	40h	; High-Byte Datenpointer
	
	

;-----------------------------------------------------------------
;				Search-Mode
;
; Eingang: 
; Ausgang: 
;-----------------------------------------------------------------
begin:	lcall sercrlf			; ein Zeile tiefer

		
;Timer initialisieren
	orl TMOD,#00010000b		; lade den Bit-Wert oderverknuepft 
					; in das Register TMOD 

;Interrupt initialisieren
	setb I2FR			; Flanke bei Interrupt EX2
	clr IEX2			; Interruptbit auf 0 setzen
	setb EX2			; Interrupt EXT2 einschalten
	setb ET1			; Interrupt ET1	einschalten
	setb EAL			; alle Interrupts entsperren


	mov pauseda,#00h		; loesche pauseda
	mov synmode,#00h		; loesche daten
	mov zaehler1,#00h		; loesche zaehler1
	mov sekzaehler,#00h		; loesche sekzaehler


searchAnfang:
	mov dptr,#datentabelle		; setze Datentabelle
	lcall DPTRSAVE
search:	mov a,pauseda			; lade a mit synmode
	cjne a,#01,search		; vergleiche a mit #01,wenn ungleich springe nach search

bitmode:
	
	lcall bitauswertung		; springe bitauswertung
	lcall pruefung			; springe nach pruefung
	mov pauseda,#00h		; beschreibe pauseda mit 00
	jnz searchAnfang		; wenn nicht null springe nach search
	
	mov a,#'O'
	lcall serout	
	mov a,#'K'
	lcall serout
	lcall sercrlf
	mov a,#'M'
	lcall serout	
	mov a,#':'
	lcall serout
	mov a,minute
	lcall ser8
	mov a,minute
	lcall getH	
	lcall ser8
	mov a,minute
	lcall getL
	lcall ser8
	mov a,#' '
	lcall serout
	mov a,#'H'
	lcall serout	
	mov a,#':'
	lcall serout
	mov a,stunde
	lcall ser8
	mov a,stunde
	lcall getH	
	lcall ser8
	mov a,stunde
	lcall getL
	lcall ser8
	lcall sercrlf
	ljmp searchAnfang
	







;-----------------------------------------------------------------
;		Interrupt-Rountine EXTERNER INTERRUPT 2
;
; Eingang: P1.4
; Ausgang: 
;-----------------------------------------------------------------
inter2:  push ACC			; akku sichern
	 jb I2FR,hflank			; Springe wenn I2FR(pos. Flanke) 
					; gesetzt ist nach hbit


lflank:	 setb I2FR			; setze I2FR auf 1
	 mov a,zaehler1			; lade zaehler 1 in den akku 
	 subb a,#18d			; vergleich a mit 18d
	 mov a,#00h			; lbit in den akku setzen
	 jc lbit			; wenn kleiner dann springe nach lbit
	 mov a,#01h			; hbit in den akku setzen
lbit:	 lcall DPTRGET
	 movx @dptr,a			; schreibe daten in Datentabelle
	 inc dptr			; Datenpointer erhöhen
	 lcall DPTRSAVE	
	 lcall serout			; springe nach serout
	 pop ACC			; akku zurück screiben
	 reti				; verlassen der Interrupt Routine
	



hflank:	 clr I2FR			; setze I2FR auf 0
	 clr TR1			; stoppe Timer
	
	 mov TL1,#0efh			; lade den Wert efh in TL1
	 mov TH1,#0d8h			; lade den Wert d8h in TH1

	 mov a,zaehler1			; lade akku mit zaehler1
	 subb a,#130d			; vergleich akku mit 130d
	 jc weiter1			; wenn kleiner dann springe nach weiter1
	 mov pauseda,#01h		; lade pauseda mit 02h

weite2:	 mov dptr,#datentabelle+21d	; dptr auf datentabelle setzen
	 mov a,#0dh			; lade akku mit 0dh
	 lcall serout			; springe nach serout
	 mov a,#0ah			; lade akku mit 0ah
	 lcall serout			; springe serout
weiter1: mov zaehler1,#00h		; lade den Wert 00 in zaehler1
	 setb TR1			; starte TIMER1
	 pop ACC			; akku zurück schreiben
	 reti				; verlassen der Interrupt Routine







;----------------------------------------------------------------
;			Interrupt-Routine TIMER1
;	
; Eingang: 
; Ausgang: 
;----------------------------------------------------------------

time1:	mov TL1,#0efh		; lade den Wert efh in TL1
	mov TH1,#0d8h		; lade den Wert d8h in TH1
	inc zaehler1		; erhöre zaehler um 1
	reti			; verlassen der Interrupt Routine







;----------------------------------------------------------------
;			Unterprog Bitauswertung
;	
; Eingang: 
; Ausgang: 
;----------------------------------------------------------------


bitauswertung:
	
	mov tagalt,tag
	mov wochentagalt,wochentag
	mov monatalt,monat
	mov jahralt,jahr


	mov dptr,#datentabelle+21d	; 
	mov ergbit,#00h
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	rrc a
	mov minute,a
	
	mov a,#'M'
	lcall serout	
	mov a,#':'
	lcall serout

	mov a,minute
	lcall ser8
	mov a,#' '
	lcall serout


	mov dptr,#datentabelle+29d
	mov ergbit,#00h
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	rrc a
	rrc a
	mov stunde,a

	mov a,#'H'
	lcall serout	
	mov a,#':'
	lcall serout

	mov a,stunde
	lcall ser8

	mov a,#' '
	lcall serout

	mov dptr,#datentabelle+36d
	mov ergbit,#00h
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	rrc a
	rrc a
	mov tag,a

	mov a,#'D'
	lcall serout	
	mov a,#':'
	lcall serout

	mov a,tag
	lcall ser8

	mov a,#' '
	lcall serout

	mov dptr,#datentabelle+42d
	mov ergbit,#00h
	acall schieberein
	acall schieberein
	acall schieberein
	rrc a
	rrc a
	rrc a
	rrc a
	rrc a
	mov wochentag,a

	mov a,#'W'
	lcall serout	
	mov a,#':'
	lcall serout

	mov a,wochentag
	lcall ser8

	mov a,#' '
	lcall serout

	mov dptr,#datentabelle+45d
	mov ergbit,#00h
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	rrc a
	rrc a
	rrc a
	mov monat,a

	mov a,#'m'
	lcall serout	
	mov a,#':'
	lcall serout

	mov a,monat
	lcall ser8

	mov a,#' '
	lcall serout

	mov dptr,#datentabelle+50d
	mov ergbit,#00h
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	acall schieberein
	mov jahr,a

	mov a,#'y'
	lcall serout	
	mov a,#':'
	lcall serout

	mov a,jahr
	lcall ser8

	mov a,#' '
	lcall serout

	lcall sercrlf

	ret





;----------------------------------------------------------------
;			Unterprog Schieberein
;	
; Eingang: 
; Ausgang: 
;----------------------------------------------------------------

schieberein:	
		movx a,@dptr			; datenpointer in den akku schreiben
		rrc a				; akku rechts routieren durch carry
		mov a,ergbit			; ergbit in den akku schreiben
		rrc a				; akku links routieren durch carry
		mov ergbit,a			; lade ergbit mit akkuinhalt
		inc dptr			; erhoehe datenpointer
		ret				; und cia bella






;----------------------------------------------------------------
;			Unterprog pruefung
;	
; Eingang: 
; Ausgang: 
;----------------------------------------------------------------

pruefung:	mov a,tagalt
		cjne a,tag,ungleich
		mov a,wochentagalt		;
		cjne a,wochentag,ungleich	;vergleiche a mit wochentag wenn ungleich springe nach ungleich
		mov a,monatalt			;schreibe monatalt in akku
		cjne a,monat,ungleich		;vergleiche a mit monat wenn ungleich springe nach ungleich
		mov a,jahralt			;schreibe jahralt in den akku 
		cjne a,jahr,ungleich		;vergleiche a mit jahr wenn ungleich springe nach ungleich
		mov a,#00h			;schreibe 00h in den akku
		ret				;return

ungleich:	mov a,0ffh			;schreibe 0ffh in den akku
		ret				;return		







;-----------------------------------------------------------------
;				Datenpointer sichern
;
; Eingang: 
; Ausgang: 
;-----------------------------------------------------------------
DPTRSAVE:	mov DPLSTORE,DPL	;schreibe DPLSTORE in DPL
		mov DPHSTORE,DPH	;schreibe DPHSTORE in DPH
		ret			;return





;-----------------------------------------------------------------
;				Datenpointer sichern
;
; Eingang: 
; Ausgang: 
;-----------------------------------------------------------------
DPTRGET:	mov DPL,DPLSTORE	;speichere DPL in DPLSTORE
		mov DPH,DPHSTORE	;speichere DPH in DPHSTORE
		ret			;return









;----------------------------------------------------------------
;			Hole  Low-Byte
;	
; Eingang: 
; Ausgang: 
;----------------------------------------------------------------
getl:		anl a,#0fh	;Und-Maske 0fh ueber akku legen
		ret		;return
		









;----------------------------------------------------------------
;			Hole High-Byte
;	
; Eingang: 
; Ausgang: 
;----------------------------------------------------------------
getH:		rr a		;schiebe nach rechts
		rr a		;schiebe nach rechts
		rr a		;schiebe nach rechts
		rr a		;schiebe nach rechts
		anl a,#0fh	;Und-Maske 0fh ueber akku legen
		ret		; return










;****************************************************************
          END                        ;Programmende