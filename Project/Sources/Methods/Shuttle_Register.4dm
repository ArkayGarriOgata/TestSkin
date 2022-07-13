//%attributes = {}
// -------
// Method: Que_Register (entity;str:key{;int:key}) -> 0 for success
// By: Mel Bohince @ 06/07/17, 08:23:04
// Description
// register an event to the shuttle queue
// ----------------------------------------------------

C_TEXT:C284($1; $2)  // what entity and it's primary key
C_LONGINT:C283($3)  // used if primary key is numeric
C_LONGINT:C283($0)  //0 for success

If (Count parameters:C259=2)
	$fk:=$2
Else 
	$fk:=String:C10($3)
End if 

READ WRITE:C146([ShuttleQ:174])

QUERY:C277([ShuttleQ:174]; [ShuttleQ:174]entity_type:2=$1; *)  // only have the latest
QUERY:C277([ShuttleQ:174];  & ; [ShuttleQ:174]fk_id:3=$fk)

If (Records in selection:C76([ShuttleQ:174])=0)
	CREATE RECORD:C68([ShuttleQ:174])
	[ShuttleQ:174]entity_type:2:=$1
	[ShuttleQ:174]fk_id:3:=$fk
End if 

[ShuttleQ:174]status:4:="NEW"
[ShuttleQ:174]target:5:="~/Dropbox/shuttle_inbox/"
[ShuttleQ:174]sent:6:=""
[ShuttleQ:174]created:7:=Substring:C12(String:C10(4D_Current_date; ISO date:K1:8); 1; 11)+String:C10(4d_Current_time; HH MM SS:K7:1)
[ShuttleQ:174]modWho:8:=<>zResp

SAVE RECORD:C53([ShuttleQ:174])

//test for success
If (Record number:C243([ShuttleQ:174])>New record:K29:1)
	$0:=0
Else 
	$0:=New record:K29:1
End if 
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	UNLOAD RECORD:C212([ShuttleQ:174])
	REDUCE SELECTION:C351([ShuttleQ:174]; 0)
	
Else 
	
	REDUCE SELECTION:C351([ShuttleQ:174]; 0)
	
End if   // END 4D Professional Services : January 2019 

