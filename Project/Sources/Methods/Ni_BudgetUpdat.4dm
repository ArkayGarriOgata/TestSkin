//%attributes = {"publishedWeb":true}
//Ni_BudgetUpdate
//$1 - longint - Issue array index
//$2 - longint - POItem array index
//$3 - string - anyhting flag to use this is being done by a user
//• 10/31/97 cs 
//• 4/10/98 cs Nan Checking
//• 4/20/98 cs setup flag to handle unbudgeted issues
//• 4/21/98 cs incorrect record locking
//  change system to be smarter about locating budget item to issue against
//• 6/30/98 cs try to get a better handle on Divisional ids
//• 7/15/98 cs sometimes the commKey did not match (issue v Budget)
//   so we want the system to locate similar budgeted commodity
//• 7/30/98 cs make sure the mod date is updted

C_LONGINT:C283($1; $2; $i)

READ WRITE:C146([Job_Forms_Materials:55])
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=Substring:C12(aIssueJF{$1}; 1; 8); *)  //SEARCH([Machine_Job]; & [Material_Job]Sequence#"")
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Raw_Matl_Code:7=aPOIRMCode{$2})

If (Records in selection:C76([Job_Forms_Materials:55])=0)
	$Seq:=Num:C11(Substring:C12(aIssueJf{$i}; 10; 3))  //`• 4/24/98 cs get seqnumber
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=Substring:C12(aIssueJF{$1}; 1; 8); *)  //• 4/21/98 cs locate a possible budget line which has not  been issued
	QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12=aPOIComKey{$2}; *)  //AND matches Commodity KEY
	
	If ($seq=0)
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Actual_Qty:14=0)
	Else 
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Actual_Qty:14=0; *)
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Sequence:3=$Seq)
	End if 
	
	If (Records in selection:C76([Job_Forms_Materials:55])=0)  //• 7/15/98 cs sometimes an items CommKey won't  for simialr commodity 
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=Substring:C12(aIssueJF{$1}; 1; 8); *)  //• 4/21/98 cs locate a possible budget line which has not  been issued
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12=Substring:C12(aPOIComKey{$2}; 1; 2); *)  //AND matches COMMODITY CODE
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Raw_Matl_Code:7=""; *)  //and has NO Raw material code  - we do not want to overwrite existing budgeted RM
		
		If ($seq=0)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Actual_Qty:14=0)
		Else 
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Actual_Qty:14=0; *)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Sequence:3=$Seq)
		End if 
		
		If (Records in selection:C76([Job_Forms_Materials:55])=0)
			CREATE RECORD:C68([Job_Forms_Materials:55])
			//get jobform - set flag so that we know this was done
			// for reference for Closeout issuing
			[Job_Forms_Materials:55]JobForm:1:=Substring:C12(aIssueJF{$1}; 1; 8)
			[Job_Forms_Materials:55]Sequence:3:=Num:C11(Substring:C12(aIssueJF{$1}; 10; 3))
			[Job_Forms_Materials:55]Comments:4:="Non-budgeted item. VF"  // see doReviseJob for the importance of this assignment
			[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
			
			If ([Job_Forms:42]JobFormID:5#[Job_Forms_Materials:55]JobForm:1)
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Materials:55]JobForm:1)
			End if 
			
			If (fLockNLoad(->[Job_Forms:42]))
				[Job_Forms:42]UnBudgetedVFIss:50:=True:C214  //mark as unbudgeted from VF issue
				SAVE RECORD:C53([Job_Forms:42])
			End if 
			
			If (Count parameters:C259=3)
				[Job_Forms_Materials:55]ModWho:11:="Btch"
			Else 
				[Job_Forms_Materials:55]ModWho:11:=<>zResp
			End if 
		Else 
			FIRST RECORD:C50([Job_Forms_Materials:55])
		End if 
	Else 
		FIRST RECORD:C50([Job_Forms_Materials:55])
	End if 
	[Job_Forms_Materials:55]Raw_Matl_Code:7:=aPOIRMCode{$2}  //update RM code etc if not RM specified or creating record
	
	If (aPOICompId{$2}="")  //• 6/30/98 cs try to get a better handle on Divisional ids
		Case of 
			: ([Job_Forms:42]Run_Location:55="Haup@")  //Hauppauge only
				[Job_Forms_Materials:55]CompanyId:23:="1"
			: ([Job_Forms:42]Run_Location:55="Roan@")  //roanoke only
				[Job_Forms_Materials:55]CompanyId:23:="2"
			: ([Job_Forms:42]Run_Location:55="Start Roan@")  //start roanoke - finish Hauppauge - most likely a Hauppauge issue
				[Job_Forms_Materials:55]CompanyId:23:="1"
			: ([Job_Forms:42]Run_Location:55="Start Haup@")  //start Hauppauge - finish Roanoke - most likely a Roanoke issue
				[Job_Forms_Materials:55]CompanyId:23:="2"
			Else   //default
				[Job_Forms_Materials:55]CompanyId:23:="1"
		End case 
		
	Else 
		[Job_Forms_Materials:55]CompanyId:23:=aPOICompId{$2}
	End if 
	[Job_Forms_Materials:55]DepartmentID:24:=aPOIDept{$2}
	[Job_Forms_Materials:55]ExpenseCode:25:=aPOIExpcode{$2}
Else 
	fLockNLoad(->[Job_Forms_Materials:55])
End if 
[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck([Job_Forms_Materials:55]Actual_Qty:14+aIssueQty{$1})
[Job_Forms_Materials:55]Actual_Price:15:=uNANCheck(Round:C94(aIssueQty{$1}*aPOIPrice{$2}; 2))
[Job_Forms_Materials:55]ModDate:10:=4D_Current_date  //• 7/30/98 cs make sure the mod date is updted
SAVE RECORD:C53([Job_Forms_Materials:55])
UNLOAD RECORD:C212([Job_Forms_Materials:55])
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=aPOIRMCode{$2})

If ([Raw_Materials:21]CommodityCode:26=1)  //show issue on allocations
	READ WRITE:C146([Raw_Materials_Allocations:58])
	//QUERY([RM_Allocations];[RM_Allocations]Raw_Matl_Code=aPOIRMCode{$2};*)
	QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=Substring:C12(aIssueJF{$1}; 1; 8))
	
	If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
		CREATE RECORD:C68([Raw_Materials_Allocations:58])
		[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=aPOIRMCode{$2}
		[Raw_Materials_Allocations:58]commdityKey:13:=aPOIComKey{$2}
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=Substring:C12(aIssueJF{$1}; 1; 8))
		RELATE ONE:C42([Job_Forms:42]JobNo:2)
		[Raw_Materials_Allocations:58]CustID:2:=[Jobs:15]CustID:2
		[Raw_Materials_Allocations:58]JobForm:3:=Substring:C12(aIssueJF{$1}; 1; 8)
		[Raw_Materials_Allocations:58]Qty_Allocated:4:=aIssueQty{$1}
		[Raw_Materials_Allocations:58]Date_Allocated:5:=4D_Current_date
		[Raw_Materials_Allocations:58]ModDate:8:=4D_Current_date
		
		If (Count parameters:C259=2)
			[Job_Forms_Materials:55]ModWho:11:="Btch"
		Else 
			[Job_Forms_Materials:55]ModWho:11:=<>zResp
		End if 
		[Raw_Materials_Allocations:58]zCount:10:=1
		SAVE RECORD:C53([Raw_Materials_Allocations:58])
	End if 
	fLockNLoad(->[Raw_Materials_Allocations:58])
	
	If (([Raw_Materials_Allocations:58]Qty_Issued:6+aIssueQty{$1})>[Raw_Materials_Allocations:58]Qty_Allocated:4)
		$realnum:=((([Raw_Materials_Allocations:58]Qty_Issued:6+aIssueQty{$1})-[Raw_Materials_Allocations:58]Qty_Allocated:4)/[Raw_Materials_Allocations:58]Qty_Allocated:4)*100
		[Raw_Materials_Allocations:58]Qty_Issued:6:=[Raw_Materials_Allocations:58]Qty_Issued:6+aIssueQty{$1}
		[Raw_Materials_Allocations:58]Date_Issued:7:=4D_Current_date
		SAVE RECORD:C53([Raw_Materials_Allocations:58])
		
	Else 
		[Raw_Materials_Allocations:58]Qty_Issued:6:=[Raw_Materials_Allocations:58]Qty_Issued:6+aIssueQty{$1}
		[Raw_Materials_Allocations:58]Date_Issued:7:=4D_Current_date
		SAVE RECORD:C53([Raw_Materials_Allocations:58])
	End if 
End if 
UNLOAD RECORD:C212([Raw_Materials_Allocations:58])