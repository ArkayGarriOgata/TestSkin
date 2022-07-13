//%attributes = {"publishedWeb":true}
//PM:  Est_LogIt  3/01/00  mlb

C_TEXT:C284($1)
C_LONGINT:C283($2)  //suppress flasher

Case of 
	: (Count parameters:C259=1)
		utl_LogIt($1)
		
	: (Count parameters:C259=2)
		utl_LogIt($1; $2)
End case 