//(S) [CONTROL]RMAlloc'bPost
//upr 1347 12/5/94
//12/13/94 unload record when done.
//•032697  MLB 
If (iMode=4)  //delete
	If (Records in selection:C76([Raw_Materials_Allocations:58])>0)
		<>fContinue:=True:C214
		Repeat 
			DELETE SELECTION:C66([Raw_Materials_Allocations:58])
			If (Records in set:C195("LockedSet")>0)
				USE SET:C118("LockedSet")
				fLockNLoad(->[Raw_Materials_Allocations:58])
			End if 
			
		Until ((Records in set:C195("LockedSet")=0) | (Not:C34(<>fContinue)))
	End if 
	
Else 
	//If ((Records in selection([RAW_MATERIALS])=1) & (Records in selection(
	//«[JobForm])=1))
	If ((sCriterion2#"") & (sCriterion3#""))  //•032697  MLB 
		If (iMode=1)
			CREATE RECORD:C68([Raw_Materials_Allocations:58])
		End if 
		
		[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=sCriterion2
		[Raw_Materials_Allocations:58]commdityKey:13:=[Raw_Materials:21]Raw_Matl_Code:1
		[Raw_Materials_Allocations:58]CustID:2:=t3b
		[Raw_Materials_Allocations:58]JobForm:3:=sCriterion3
		[Raw_Materials_Allocations:58]Qty_Allocated:4:=rReal1
		[Raw_Materials_Allocations:58]Date_Allocated:5:=dDate
		[Raw_Materials_Allocations:58]ModDate:8:=4D_Current_date
		[Raw_Materials_Allocations:58]ModWho:9:=<>zResp
		[Raw_Materials_Allocations:58]zCount:10:=1
		SAVE RECORD:C53([Raw_Materials_Allocations:58])
		
		QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=sCriterion3)
		Case of 
			: (Records in selection:C76([Raw_Materials_Allocations:58])=0)
				BEEP:C151
				ALERT:C41("Warning: Form "+sCriterion3+" has not been allocated.")
			: (Records in selection:C76([Raw_Materials_Allocations:58])>1)
				BEEP:C151
				ALERT:C41("Warning: Form "+sCriterion3+" has been allocated "+String:C10(Records in selection:C76([Raw_Materials_Allocations:58]))+" times.")
		End case 
		
		If ([Raw_Materials_Allocations:58]Qty_Allocated:4=0)  //upr 1347 12/5/94
			DELETE RECORD:C58([Raw_Materials_Allocations:58])
		End if 
		
	Else 
		ALERT:C41("You need 1 R/M and 1 Job form to continue.")
		BEEP:C151
		REJECT:C38
	End if 
	
End if 
sCriterion2:=""
sCriterion3:="00000.00"
rReal1:=0
dDate:=!00-00-00!
t3:="Then enter a Job Form, total quantity of the allocation, and date needed."
sCriterion1:="First enter a Raw Material Code."
UNLOAD RECORD:C212([Raw_Materials_Allocations:58])  //12/13/94


//EOS