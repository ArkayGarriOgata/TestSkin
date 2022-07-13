//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/28/07, 14:18:43
// ----------------------------------------------------
// Method: Job_beforeOnLoadStartDate()  --> 
// ---------------------------------------------------

C_DATE:C307(dDateBegin)
C_TEXT:C284($1)
C_BOOLEAN:C305(serverMethodDone)

dDateBegin:=!00-00-00!
serverMethodDone:=False:C215

If (Length:C16($1)=8)
	$RMStart:=!00-00-00!
	READ ONLY:C145([Raw_Materials_Transactions:23])
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$1; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
			
			SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $RMDate)
			SORT ARRAY:C229($RMDate; >)
			$RMStart:=$RMDate{1}
			
		Else 
			//Change after Mel Bug 
			$RMStart:=Min:C4([Raw_Materials_Transactions:23]XferDate:3)
			
		End if   // END 4D Professional Services : January 2019 
		
	End if 
	REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
	
	$MTStart:=!00-00-00!
	READ ONLY:C145([Job_Forms_Machine_Tickets:61])
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$1)
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
			
			SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]DateEntered:5; $MTDate)
			SORT ARRAY:C229($MTDate; >)
			$MTStart:=$MTDate{1}
		Else 
			//Change after Mel Bug 
			$MTStart:=Min:C4([Job_Forms_Machine_Tickets:61]DateEntered:5)
			
		End if   // END 4D Professional Services : January 2019 
		
		
	End if 
	REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
	
	Case of 
		: ($MTStart=!00-00-00!) & ($RMStart=!00-00-00!)
			dDateBegin:=!00-00-00!
		: ($MTStart=!00-00-00!)
			dDateBegin:=$RMStart
		: ($RmStart=!00-00-00!)
			dDateBegin:=$MTStart
		: ($RmStart<$MTStart)
			dDateBegin:=$RMStart
		: ($MtStart<$RmStart)
			dDateBegin:=$MTStart
		Else 
			dDateBegin:=$RMStart
	End case 
	
End if 

serverMethodDone:=True:C214
Repeat   //waiting till client resets serverMethodDone
	DELAY PROCESS:C323(Current process:C322; 30)
	IDLE:C311
Until (Not:C34(serverMethodDone))