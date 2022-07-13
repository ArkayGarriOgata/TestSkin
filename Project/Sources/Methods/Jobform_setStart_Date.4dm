//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/22/06, 12:05:52
// ----------------------------------------------------
// Method: Jobform_setStart_Date
// ----------------------------------------------------

C_DATE:C307($MTStart; $RMStart)

If ([Job_Forms:42]StartDate:10=!00-00-00!) & (iMode<3)
	$RMStart:=!00-00-00!
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
		SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $RMDate)
		SORT ARRAY:C229($RMDate; >)
		$RMStart:=$RMDate{1}
	End if 
	
	$MTStart:=!00-00-00!
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]DateEntered:5; $MTDate)
		SORT ARRAY:C229($MTDate; >)
		$MTStart:=$MTDate{1}
	End if 
	
	Case of 
		: ($MTStart=!00-00-00!) & ($RMStart=!00-00-00!)
			//$NoDate:=True
		: ($MTStart=!00-00-00!)
			[Job_Forms:42]StartDate:10:=$RMStart
		: ($RmStart=!00-00-00!)
			[Job_Forms:42]StartDate:10:=$MTStart
		: ($RmStart<$MTStart)
			[Job_Forms:42]StartDate:10:=$RMStart
		: ($MtStart<$RmStart)
			[Job_Forms:42]StartDate:10:=$MTStart
		Else 
			[Job_Forms:42]StartDate:10:=$RMStart
	End case 
End if 