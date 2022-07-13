//%attributes = {"publishedWeb":true}
//(p) gRmIssCalcTot
//$1 - string - (optional)  anything flag to determine which array to use
//BAK 9/19/94 - used to total Material actuals for Job Form
//10/26/94 attempt to straighten out
//see also gCalcActual
//•070695 add the -1
//• 10/31/97 cs addd parameter to allow this to work from either of 2 arrays
//aIssueJF coming from new (10/31/97) JobCloseOut system
//• 4/10/98 cs Nan Checking

C_TEXT:C284($JFtoFind)
C_TEXT:C284($1)

If (Count parameters:C259=1)  //• 10/31/97 cs determine which array to use
	$JFtoFind:=Substring:C12(aIssueJf{1}; 1; 8)  //get current JF
	$Size:=Size of array:C274(aIssueJf)  //set array size
	
	SORT ARRAY:C229(aIssueJf; >)
	asMAJobComp:=Substring:C12(aIssueJf{1}; 1; 8)
Else 
	$winRef:=NewWindow(150; 39; 6; 1; "")
	MESSAGE:C88(<>sCR+"Calculating RM Actuals!"+<>sCR+"Please Wait...")
	SORT ARRAY:C229(aRMJFNum; >)
	asMAJobComp:=aRMJFNum{1}
	$JFtoFind:=aRMJFNum{1}
	$Size:=Size of array:C274(aRMJFNum)
End if 
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$JFtoFind)
If (Not:C34(Locked:C147([Job_Forms:42]))) & (Records in selection:C76([Job_Forms:42])>0)  //fLockNLoad (->[JobForm])
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Location:15="WIP")
	[Job_Forms:42]ActMatlCost:40:=uNANCheck(Sum:C1([Raw_Materials_Transactions:23]ActExtCost:10)*-1)  //•070695 add the -1
	[Job_Forms:42]ActFormCost:13:=uNANCheck([Job_Forms:42]ActLabCost:37+[Job_Forms:42]ActOvhdCost:38+[Job_Forms:42]ActS_ECost:39+[Job_Forms:42]ActMatlCost:40)
	If (([Job_Forms:42]QtyActProduced:35#0) & ([Job_Forms:42]ActFormCost:13#0))
		[Job_Forms:42]ActCost_M:41:=uNANCheck(Round:C94(([Job_Forms:42]ActFormCost:13/[Job_Forms:42]QtyActProduced:35)*1000; 2))
	Else 
		[Job_Forms:42]ActCost_M:41:=0
	End if 
	SAVE RECORD:C53([Job_Forms:42])
End if 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Job_Forms:42])
	
Else 
	
	// i place it on line 89
	
End if   // END 4D Professional Services : January 2019 

For ($j; 2; $Size)
	If (Count parameters:C259=1)
		$JFtoFind:=Substring:C12(aIssueJf{$j}; 1; 8)
	Else 
		$JFtoFind:=aRMJFNum{$j}
	End if 
	
	If (asMAJobComp#$JFtoFind)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$JFtoFind)
		If (Not:C34(Locked:C147([Job_Forms:42]))) & (Records in selection:C76([Job_Forms:42])>0)
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Location:15="WIP")
			[Job_Forms:42]ActMatlCost:40:=uNANCheck(Sum:C1([Raw_Materials_Transactions:23]ActExtCost:10)*-1)  //•070695 add the -1
			[Job_Forms:42]ActFormCost:13:=uNANCheck([Job_Forms:42]ActLabCost:37+[Job_Forms:42]ActOvhdCost:38+[Job_Forms:42]ActS_ECost:39+[Job_Forms:42]ActMatlCost:40)
			If (([Job_Forms:42]QtyActProduced:35#0) & ([Job_Forms:42]ActFormCost:13#0))
				[Job_Forms:42]ActCost_M:41:=uNANCheck(Round:C94(([Job_Forms:42]ActFormCost:13/[Job_Forms:42]QtyActProduced:35)*1000; 2))
			Else 
				[Job_Forms:42]ActCost_M:41:=0
			End if 
			SAVE RECORD:C53([Job_Forms:42])
		End if 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([Job_Forms:42])
			
		Else 
			
			
			
		End if   // END 4D Professional Services : January 2019 
		
		asMAJobComp:=$JFtoFind
	End if 
End for 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
Else 
	UNLOAD RECORD:C212([Job_Forms:42])
End if   // END 4D Professional Services : January 2019 
