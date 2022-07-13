//%attributes = {}
// Method: TS_translateUI () -> 

// ----------------------------------------------------

// by: mel: 06/23/04, 16:26:05

// ----------------------------------------------------


// ----------------------------------------------------

C_LONGINT:C283($ts)

Repeat 
	$ts:=Num:C11(Request:C163("TS:"; ""; "Translate"; "Done"))
	If (ok=1)
		ALERT:C41(String:C10($ts)+" is "+TS2String($ts))
	End if 
Until (ok=0)