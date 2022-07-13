//%attributes = {"publishedWeb":true}
//(S) sLinkEst
//upr 1303 11/9/94

If (Length:C16(sPONum)=9)
	ARRAY TEXT:C222(asBull; 0)
	ARRAY TEXT:C222(asCaseID; 0)
	ARRAY TEXT:C222(asDiff; 0)
	C_LONGINT:C283($T)
	OBJECT SET ENABLED:C1123(bPick; False:C215)  //the Update btn
	
	READ ONLY:C145([Estimates:17])  //gonna change the status
	QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=sPONum)
	If (Records in selection:C76([Estimates:17])=1)
		If (Position:C15("Quoted"; [Estimates:17]Status:30)#0) | (True:C214)
			If (True:C214)  //(fLockNLoad (»[ESTIMATE])
				READ ONLY:C145([Customers:16])
				RELATE ONE:C42([Estimates:17]Cust_ID:2)
				
				QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)
				SELECTION TO ARRAY:C260([Estimates_Differentials:38]diffNum:3; asCaseID; [Estimates_Differentials:38]PSpec_Qty_TAG:25; asDiff)
				
				$T:=Size of array:C274(asDiff)
				If ($T#0)
					SORT ARRAY:C229(asCaseID; asDiff; >)
					ARRAY TEXT:C222(asBull; $T)
					asDiff:=0
					If ([Estimates:17]z_Cost_TotalPrep:9#0)
						OBJECT SET ENABLED:C1123(rInclPrep; True:C214)
					Else 
						OBJECT SET ENABLED:C1123(rInclPrep; False:C215)
					End if 
					
				Else 
					BEEP:C151
					ALERT:C41(sPONum+" has no differential defined.")
					sPONum:=""
				End if 
				
			Else   //wrong status
				BEEP:C151
				ALERT:C41(sPONum+" is locked by another process.")
				sPONum:=""
			End if   //locked estimate  
			
		Else   //wrong status
			BEEP:C151
			ALERT:C41(sPONum+" must be in a status of 'Quoted' to enter the order.")
			sPONum:=""
		End if 
		
	Else   //cant find the estimate
		BEEP:C151
		ALERT:C41(sPONum+" not found.")
		sPONum:=""
	End if   //found estimate 
	
Else   //not the wright length
	BEEP:C151
	ALERT:C41(sPONum+" is not a valid estimate number.")
	sPONum:=""
End if 