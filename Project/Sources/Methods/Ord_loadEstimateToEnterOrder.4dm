//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/04/06, 14:26:23
// ----------------------------------------------------
// Method: Ord_loadEstimateToEnterOrder
// Description
// called by [zz_control];"OpenOrder"
// ----------------------------------------------------
//(S) sPONum
//051295 UPR 1508
//•060195  MLB  UPR 184
//*Validate the estimate number entered

If (Length:C16(sPONum)=9)
	OBJECT SET ENABLED:C1123(bPick; False:C215)
	
	QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=sPONum)
	If (Records in selection:C76([Estimates:17])=1)
		If (fLockNLoad(->[Estimates:17]))
			
			OBJECT SET ENABLED:C1123(rInclDies; True:C214)  //•051295 upr 1508  
			OBJECT SET ENABLED:C1123(rInclPlates; True:C214)  //•051295 upr 1508  
			OBJECT SET ENABLED:C1123(rInclDups; True:C214)  //•051295 upr 1508  
			OBJECT SET ENABLED:C1123(rInclPnD; True:C214)  //•051295 upr 1508   
			OBJECT SET ENABLED:C1123(rInclPrep; True:C214)
			//*.   Check estimate for proper Quoted status    
			If ((Position:C15("Quoted"; [Estimates:17]Status:30)#0) | (Position:C15("CONTRACT"; [Estimates:17]Status:30)#0) | (Current user:C182="Designer"))  //•060195  MLB  UPR 184
				
				//*.     Load the customer record
				RELATE ONE:C42([Estimates:17]Cust_ID:2)
				If (fLockNLoad(->[Customers:16]))
					//*.     Get the differencials for the estimate and list them          
					RELATE MANY:C262([Estimates:17]EstimateNo:1)  //get case scenarios, carton specs
					SELECTION TO ARRAY:C260([Estimates_Differentials:38]diffNum:3; asCaseID; [Estimates_Differentials:38]PSpec_Qty_TAG:25; asDiff)
					
					$T:=Size of array:C274(asDiff)
					If ($T#0)
						SORT ARRAY:C229(asCaseID; asDiff; >)
						ARRAY TEXT:C222(aSelected; $T)
						If ($T=1)
							aSelected{1}:="X"
							Ord_findSelectedDifferencial(sPONum; asCaseID{1})
						End if 
						
					Else 
						uConfirm(sPONum+" has no differential defined."; "OK"; "Help")
						sPONum:=""
					End if 
					
				Else 
					uConfirm(sPONum+"'s Customer record is currently in use."; "Try later"; "Help")
					sPONum:=""
				End if   //locked customer   
				
			Else 
				uConfirm(sPONum+" must be in a status of 'Quoted'  or 'Contract' to enter the order."; "OK"; "Help")
				sPONum:=""
			End if 
			
		Else 
			uConfirm(sPONum+" is currently in use."; "Try later"; "Help")
			sPONum:=""
		End if 
		
	Else 
		uConfirm("Estimate "+sPONum+" not found."; "OK"; "Help")
		sPONum:=""
	End if   //found estimate    
	
Else 
	uConfirm(sPONum+" is not a valid 9 characte estimate number."; "OK"; "Help")
	sPONum:=""
End if   //wrong length

If (Length:C16(sPONum)=0)
	GOTO OBJECT:C206(sPONum)
End if 