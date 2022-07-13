//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/26/08, 13:45:11
// ----------------------------------------------------
// Method: Zebra_CaseNumberManager("action";jobit)
// Description
// keep track of case numbers issued to a jobit, ignor locking
//
//instead of WMS_newItem to keep records, just going to keep counters
// 
//For ($i;iItemNumber;iLastLabel)
//WMS_newItem (("RK"+String($i;"000000000"));sCPN;sJMI;iQty;dDate)
//End for 
//$serialNumber:=iItemNumber
//$nextSeries:=WMS_setNextItemId (->[WMS_ItemMasters];(iLastLabel+1))  `release the lock
// ----------------------------------------------------
C_LONGINT:C283($0; $counter; $3; $4)
C_TEXT:C284($2; $1)

Case of 
	: ($1="find")
		SET QUERY LIMIT:C395(1)
		READ WRITE:C146([Job_Forms_Items_Labels:149])
		QUERY:C277([Job_Forms_Items_Labels:149]; [Job_Forms_Items_Labels:149]Jobit:1=$2)
		SET QUERY LIMIT:C395(0)
		If (Records in selection:C76([Job_Forms_Items_Labels:149])=0)
			CREATE RECORD:C68([Job_Forms_Items_Labels:149])
			[Job_Forms_Items_Labels:149]Jobit:1:=$2
			[Job_Forms_Items_Labels:149]jobform:5:=Substring:C12($2; 1; 8)  // Modified by: Mel Bohince (6/14/16) handle for purge to use
			[Job_Forms_Items_Labels:149]StartingCaseNumber:2:=0
			[Job_Forms_Items_Labels:149]LastCaseNumber:3:=0
			SAVE RECORD:C53([Job_Forms_Items_Labels:149])
		End if 
		$0:=[Job_Forms_Items_Labels:149]LastCaseNumber:3+1
		
	: ($1="update")
		If ([Job_Forms_Items_Labels:149]Jobit:1#$2)
			$counter:=Zebra_CaseNumberManager("find"; $2)
		End if 
		If ([Job_Forms_Items_Labels:149]StartingCaseNumber:2=0)
			[Job_Forms_Items_Labels:149]StartingCaseNumber:2:=$3
		End if 
		[Job_Forms_Items_Labels:149]LastCaseNumber:3:=$3+$4-1  // current starting case number + iCnt - 1
		SAVE RECORD:C53([Job_Forms_Items_Labels:149])
		
		LOAD RECORD:C52([Job_Forms_Items_Labels:149])
		If ([Job_Forms_Items_Labels:149]LastCaseNumber:3=$4)
			$0:=[Job_Forms_Items_Labels:149]LastCaseNumber:3
		Else 
			$0:=[Job_Forms_Items_Labels:149]LastCaseNumber:3*-1
		End if 
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			UNLOAD RECORD:C212([Job_Forms_Items_Labels:149])
			REDUCE SELECTION:C351([Job_Forms_Items_Labels:149]; 0)
			
		Else 
			
			REDUCE SELECTION:C351([Job_Forms_Items_Labels:149]; 0)
			
		End if   // END 4D Professional Services : January 2019 
		
	: ($1="issued")
		READ ONLY:C145([Job_Forms_Items_Labels:149])
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Job_Forms_Items_Labels:149]; [Job_Forms_Items_Labels:149]Jobit:1=$2)
		SET QUERY LIMIT:C395(0)
		If (Records in selection:C76([Job_Forms_Items_Labels:149])>0)
			$0:=[Job_Forms_Items_Labels:149]LastCaseNumber:3-[Job_Forms_Items_Labels:149]StartingCaseNumber:2+1
		Else 
			$0:=0
		End if 
		REDUCE SELECTION:C351([Job_Forms_Items_Labels:149]; 0)
		
	: ($1="last")
		READ ONLY:C145([Job_Forms_Items_Labels:149])
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Job_Forms_Items_Labels:149]; [Job_Forms_Items_Labels:149]Jobit:1=$2)
		SET QUERY LIMIT:C395(0)
		If (Records in selection:C76([Job_Forms_Items_Labels:149])>0)
			$0:=[Job_Forms_Items_Labels:149]LastCaseNumber:3
		Else 
			$0:=0
		End if 
		REDUCE SELECTION:C351([Job_Forms_Items_Labels:149]; 0)
End case 
