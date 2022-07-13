//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 01/24/06, 12:22:25
// ----------------------------------------------------
// Method: WMS_nextSkidNumber
// Description
// return the current starting number and set up for the next starter
//
// Parameters
C_LONGINT:C283($numberOfSkids; $1; $0)  //number of numbers to consume, rtn the current
// ----------------------------------------------------
$0:=-2

If ($1<=0)
	$numberOfSkids:=1
Else 
	$numberOfSkids:=$1
End if 

READ WRITE:C146([x_id_numbers:3])
SET QUERY LIMIT:C395(1)
QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=9000)
SET QUERY LIMIT:C395(0)
If (Records in selection:C76([x_id_numbers:3])#1)
	CREATE RECORD:C68([x_id_numbers:3])
	[x_id_numbers:3]Table_Number:1:=9000
	[x_id_numbers:3]ID_No:2:=1
	[x_id_numbers:3]Usage:5:="SKID TICKETS"
	SAVE RECORD:C53([x_id_numbers:3])
End if 

If (fLockNLoad(->[x_id_numbers:3]))
	$0:=[x_id_numbers:3]ID_No:2
	[x_id_numbers:3]ID_No:2:=[x_id_numbers:3]ID_No:2+$numberOfSkids
	SAVE RECORD:C53([x_id_numbers:3])
Else 
	BEEP:C151
	ALERT:C41("Next SKID_ID_NUMBER process stopped by user")
	CANCEL:C270
	$0:=-1
End if 

UNLOAD RECORD:C212([x_id_numbers:3])
READ ONLY:C145([x_id_numbers:3])