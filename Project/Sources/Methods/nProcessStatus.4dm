//%attributes = {"publishedWeb":true}
C_TEXT:C284($0)  //(P) nProcessStatus: return process status
C_LONGINT:C283($1)  //Example: $Status:=nProcessStatus($State)

Case of 
	: ($1=Does not exist:K13:3)
		$0:="Non-existent"
	: ($1=Aborted:K13:1)
		$0:="Aborted"
	: ($1=Executing:K13:4)
		$0:="Executing"
	: ($1=Delayed:K13:2)
		$0:="Delayed"
	: ($1=Waiting for input output:K13:7)
		$0:="Waiting"
	: ($1=Waiting for internal flag:K13:8)
		$0:="Waiting"
	: ($1=Waiting for user event:K13:9)
		$0:="Waiting"
	: ($1=Paused:K13:6)
		$0:="Paused"
		//: ($1=_o_Hidden modal dialog)
		//$0:="Hidden"
End case 