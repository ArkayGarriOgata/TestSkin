//%attributes = {"publishedWeb":true}
//PM:  RM_newID  12/19/00  mlb
//get a prefix and number
//based on: fCSpecID()  120695  MLB
//• mlb - 7/18/02  09:21 allow 20 char max length

C_LONGINT:C283($FileNo)
C_TEXT:C284($0)

$FileNo:=21

READ WRITE:C146([x_id_numbers:3])  //*Load the files ID sequence record
QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=$FileNo)
If (Records in selection:C76([x_id_numbers:3])#1)  //*Create Id record if required
	CREATE RECORD:C68([x_id_numbers:3])
	[x_id_numbers:3]Table_Number:1:=$FileNo
	[x_id_numbers:3]ID_No:2:=1
	[x_id_numbers:3]Prefix:4:="MK"
	SAVE RECORD:C53([x_id_numbers:3])
End if 

If (fLockNLoad(->[x_id_numbers:3]))  //*Make sure its loaded R|W
	$0:=Substring:C12([x_id_numbers:3]Prefix:4+"-"; 1; 15)+String:C10([x_id_numbers:3]ID_No:2; "00000")  //*Return next ID
	[x_id_numbers:3]ID_No:2:=[x_id_numbers:3]ID_No:2+1  //*Update Counter
	SAVE RECORD:C53([x_id_numbers:3])
	
Else   //*  if locked and not waited for, return -1
	BEEP:C151
	ALERT:C41("Next ID_NUMBER process stopped by user")
	CANCEL:C270
	$0:="-1"
End if 

UNLOAD RECORD:C212([x_id_numbers:3])  //*Unload the sequence record
READ ONLY:C145([x_id_numbers:3])