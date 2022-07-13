//3/27/95

C_BOOLEAN:C305($continue)  //• mlb - 3/27/02  14:48

$continue:=False:C215

If (dDate=!00-00-00!)
	dDate:=4D_Current_date
End if 

READ ONLY:C145([Purchase_Orders_Items:12])
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
If (Records in selection:C76([Purchase_Orders_Items:12])=1)
	READ ONLY:C145([Purchase_Orders:11])
	READ ONLY:C145([Vendors:7])
	RELATE ONE:C42([Purchase_Orders_Items:12]PONo:2)
	RELATE ONE:C42([Purchase_Orders:11]VendorID:2)
	sCriterion1:=[Vendors:7]Name:2+"'s "+[Purchase_Orders_Items:12]Raw_Matl_Code:15
	
	READ ONLY:C145([Raw_Materials_Groups:22])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Purchase_Orders_Items:12]Commodity_Key:26)
		FIRST RECORD:C50([Raw_Materials_Groups:22])
		
		
	Else 
		
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Purchase_Orders_Items:12]Commodity_Key:26)
		
	End if   // END 4D Professional Services : January 2019 First record
	Case of 
		: ([Raw_Materials_Groups:22]ReceiptType:13=1)
			$continue:=True:C214
		: ([Raw_Materials_Groups:22]ReceiptType:13=2)
			$continue:=False:C215
		Else   //expense item
			
			$continue:=False:C215
	End case 
	
	If (Not:C34($continue))
		READ ONLY:C145([Raw_Materials:21])
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15)
		If (Records in selection:C76([Raw_Materials:21])=1)
			$continue:=[Raw_Materials:21]Stocked:5
		End if 
	End if 
	
	READ WRITE:C146([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
	If ($continue)
		If (fLockNLoad(->[Raw_Materials_Locations:25]))
			sCriterion3:=[Raw_Materials_Locations:25]Location:2
			rReal1:=[Raw_Materials_Locations:25]QtyOH:9
			If (Records in selection:C76([Raw_Materials_Locations:25])=0)
				GOTO OBJECT:C206(sCriterion3)
			Else 
				GOTO OBJECT:C206(rReal1)
			End if 
			
		Else 
			BEEP:C151
			sCriterion3:=""
			rReal1:=0
			GOTO OBJECT:C206(sCriterion3)
		End if 
		
	Else   //wrong receipt type
		
		If (fLockNLoad(->[Raw_Materials_Locations:25]))
			sCriterion3:=[Raw_Materials_Locations:25]Location:2
			rReal1:=[Raw_Materials_Locations:25]QtyOH:9
			If (Records in selection:C76([Raw_Materials_Locations:25])>0)
				GOTO OBJECT:C206(rReal1)
			Else 
				BEEP:C151
				sCriterion3:=""
				rReal1:=0
				ALERT:C41("This PO item is not an R/M type and no bin record exists.")
				sCriterion2:=""
				GOTO OBJECT:C206(sCriterion2)
			End if   //bin
			
		End if   //locked
		
		
	End if   //type
	
	
Else   //no poitem
	
	BEEP:C151
	If (Substring:C12(sCriterion2; 1; 1)="A")  //semi finished
		
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=sCriterion2)
		SET QUERY LIMIT:C395(0)
		sCriterion1:=[Raw_Materials_Transactions:23]Raw_Matl_Code:1
	Else 
		ALERT:C41("PO item "+sCriterion2+" not found.")
		sCriterion1:=Request:C163("What is the R/M code?")  //3/27/95
		
		If (ok=0)
			sCriterion1:=""
		End if 
	End if 
	
	READ ONLY:C145([Raw_Materials:21])
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sCriterion1)
	If (Records in selection:C76([Raw_Materials:21])=0)
		BEEP:C151
		ALERT:C41("That is not a valid RM code.")
		sCriterion1:=""
		sCriterion2:=""
		GOTO OBJECT:C206(sCriterion2)
	Else 
		sCriterion1:=[Raw_Materials:21]Raw_Matl_Code:1
		READ ONLY:C145([Raw_Materials_Groups:22])
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Raw_Materials:21]Commodity_Key:2)
	End if 
	sCriterion3:=""
	
	If (Not:C34(fPiActive))  //•4/1/97 cs if this was NOT called from Phys INv pallete
		
		sCriterion4:=""
	End if 
	rReal1:=0
	// GOTO AREA(sCriterion2)    
	
End if 

//