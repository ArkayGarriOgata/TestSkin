//(s) sCriterion2

// • mel (11/18/03, check for inv

READ ONLY:C145([Purchase_Orders_Items:12])
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)

If (Records in selection:C76([Purchase_Orders_Items:12])=1)
	t3:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
	READ ONLY:C145([Purchase_Orders:11])
	READ ONLY:C145([Vendors:7])
	RELATE ONE:C42([Purchase_Orders_Items:12]PONo:2)
	RELATE ONE:C42([Purchase_Orders:11]VendorID:2)
	sCriterion1:=[Vendors:7]Name:2+"'s "+[Purchase_Orders_Items:12]Raw_Matl_Code:15
	READ ONLY:C145([Raw_Materials_Groups:22])
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Purchase_Orders_Items:12]Commodity_Key:26)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([Raw_Materials_Groups:22])
		
		
	Else 
		
		//you have a query to Raw_Materials_Groups this selected first 
		
	End if   // END 4D Professional Services : January 2019 First record
	READ WRITE:C146([Raw_Materials_Locations:25])  // • mel (11/18/03, check for inv
	
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
	$numBins:=Records in selection:C76([Raw_Materials_Locations:25])
	If ([Raw_Materials_Groups:22]ReceiptType:13=1) | ($numBins>0)
		//query bin was here
		
		If (fLockNLoad(->[Raw_Materials_Locations:25]))
			sCriterion3:=[Raw_Materials_Locations:25]Location:2
			rReal1:=[Raw_Materials_Locations:25]QtyOH:9
			If (Records in selection:C76([Raw_Materials_Locations:25])=0)
				sCriterion3:=""
				GOTO OBJECT:C206(sCriterion3)
			Else 
				GOTO OBJECT:C206(rReal1)
			End if 
			
		Else 
			sCriterion3:=""
			rReal1:=0
			GOTO OBJECT:C206(sCriterion3)
		End if 
		
	Else 
		rReal1:=0
		If ([Raw_Materials_Groups:22]ReceiptType:13=2)
			sCriterion3:="Direct Purchase"
		Else 
			sCriterion3:="Expense Item"
		End if 
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("PO item "+sCriterion2+" not found.")
	sCriterion2:=""
	sCriterion1:=""
	sCriterion3:=""
	sCriterion4:=""
	GOTO OBJECT:C206(sCriterion2)
End if 

//