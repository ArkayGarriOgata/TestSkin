//%attributes = {}
// Method: JML_BlockTimeInitProcessVars () -> 
// ----------------------------------------------------
// by: mel: 01/28/05, 09:41:30
// ----------------------------------------------------

//operation variables
C_LONGINT:C283(cb1; cb2; cb3; cb4; cb5; cb6; cb7; cb8; cb9)
C_REAL:C285(r1; r2; r3; r4; r5; r6; r7; r8; r9)
C_REAL:C285(r11; r12; r13; r14; r15; r16; r17; r18; r19)
C_REAL:C285(r21; r22; r23; r24; r25; r26; r27; r28; r29)
C_REAL:C285(r31; r32; r33; r34; r35; r36; r37; r38; r39)
//finishing location
C_LONGINT:C283(b1; b2)
b1:=1
b2:=0
//run size
C_LONGINT:C283(iSheets; iUp; iNumJobs)
iSheets:=0
iUp:=0
iNumJobs:=1
//set the frequency
C_LONGINT:C283(rb1; rb2; rb3; rb4; rb5; rb6)
C_LONGINT:C283(iDays; iTimes; iHRDweeks)
C_DATE:C307(dDateBegin)
rb1:=0
rb2:=0
rb3:=0
rb4:=0
rb5:=0
rb6:=0
iTmes:=0  //obsolete, see field NumberOfTimes

C_TEXT:C284(xText)
iSheets:=0
iUp:=0
iDays:=14
iHRDweeks:=6

dDateBegin:=4D_Current_date
sRMcode:=""
sOutline:=""
xText:=""
sComment:=""
sDieNumber:=""