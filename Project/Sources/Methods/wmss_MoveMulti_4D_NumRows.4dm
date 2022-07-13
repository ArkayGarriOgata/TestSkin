//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: MoveMulti_dio_Move_4D_NumRows - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumRows)
C_LONGINT:C283($1; $xlIndex)
C_TEXT:C284($ttSkidNum; $ttSQL)
$xlIndex:=$1
$xlNumRows:=0

Case of 
	: (Position:C15("cases"; rft_Case{$xlIndex})>0)
		$xlNumRows:=1
	Else 
		$ttSkidNum:=rft_Case{$xlIndex}
		$ttSQL:="SELECT COUNT(*) FROM cases WHERE skid_number= ?"
		
		SQL SET PARAMETER:C823($ttSkidNum; SQL param in:K49:1)
		SQL EXECUTE:C820($ttSQL; $xlNumRows)
		Case of 
			: (OK=0)
				
			: (Not:C34(SQL End selection:C821))
				SQL CANCEL LOAD:C824
				
			Else 
				SQL LOAD RECORD:C822(SQL all records:K49:10)
				SQL CANCEL LOAD:C824
				
		End case 
		
End case 


$0:=$xlNumRows