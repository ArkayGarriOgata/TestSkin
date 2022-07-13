//%attributes = {"publishedWeb":true}
//Procedure: TS2String(timeStamp) ->string 073196  MLB
//convert longint  time stamp back to date and time
//see(P) TSTimeStamp and TN 29
C_LONGINT:C283($1; $2)

If (Count parameters:C259=1)
	
	If ($1>0)
		$0:=String:C10((!1995-04-17!+($1\86400)); <>MIDDATE)+" "  //24*60*60
		$0:=$0+Time string:C180($1%86400)
	Else 
		$0:="00/00/00 00:00"
	End if 
Else 
	
	If ($1>0)
		$0:=String:C10((!1995-04-17!+($1\86400)); <>MIDDATE)+" "  //24*60*60
		$0:=$0+String:C10(Time:C179(Time string:C180($1%86400)); $2)
	Else 
		$0:="00/00/00 00:00"
	End if 
End if 
//