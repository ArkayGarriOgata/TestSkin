// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 06/05/13, 08:53:55
// ----------------------------------------------------
// Object Method: bDelPairs
// ----------------------------------------------------

// Modified by: Garri Ogata (9/3/20) - added single form modification 


C_LONGINT:C283($xlID)
app_Log_Usage("log"; "FG"; "FG Plus/Minus Pairs")

If (Shift down:C543)
	
	FGPlusMinusPairs
	
Else 
	
	FGLc_Menu_Adjust
	
End if 

