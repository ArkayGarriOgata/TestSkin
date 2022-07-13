//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/15/11, 11:29:33
// ----------------------------------------------------
// Method: JML_getDate
// Description
// return specified value
// ----------------------------------------------------

C_TEXT:C284($1)  //what is requested
C_TEXT:C284($2)  //jobform
C_POINTER:C301($3)  //pointer to date variable to receive date
C_DATE:C307($date)
C_TEXT:C284($4)  //show messages
C_TEXT:C284($0)
C_BOOLEAN:C305($showMsg)

If (Count parameters:C259=4)
	$showMsg:=True:C214
Else 
	$showMsg:=False:C215
End if 

If (Length:C16($2)=8)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$2)
	
	Case of 
		: (Records in selection:C76([Job_Forms_Master_Schedule:67])#1)
			If ($showMsg)
				uConfirm("The Jobmaster record for '"+$2+"' is was not found.")
			End if 
			$date:=!00-00-00!
			$0:="ERR"
			
		: ($1="glue-ready")
			$date:=[Job_Forms_Master_Schedule:67]GlueReady:28
			
		: ($1="printed")
			$date:=[Job_Forms_Master_Schedule:67]Printed:32
			
		Else 
			If ($showMsg)
				uConfirm("The request for '"+$1+"' is not understood.")
			End if 
			$date:=!00-00-00!
			$0:="ERR"
	End case 
	
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	
Else 
	If ($showMsg)
		uConfirm("Please specify the job form number.")
	End if 
	$date:=!00-00-00!
	$0:="ERR"
End if 

If ($date#!00-00-00!)
	$0:="YES"
Else 
	$0:="NO"
End if 
If (Count parameters:C259=4)
	$3->:=$date
End if 