//%attributes = {"publishedWeb":true}
//(p) beforePOReview
//this code is run before the review screen for Accounting
//PLUS it is run from the next, prev, last, first butons on said
//`layout.
//the layout is setup so that the records (POs) are displayed in the same order
//in which they are entered into the search screen
//• 3/16/98 cs created

fChoose:=False:C215  //for double clicking on item
sName:=("Hauppauge"*Num:C11([Purchase_Orders:11]CompanyID:43="1"))+("Roanoke"*Num:C11([Purchase_Orders:11]CompanyID:43="2"))
QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=[Purchase_Orders:11]PONo:1+"@")
$Size:=Records in selection:C76([Purchase_Orders_Job_forms:59])
ARRAY TEXT:C222(axText; $Size)

If ($Size>0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		ORDER BY:C49([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1; >)
		
		For ($i; 1; $Size)
			axText{$i}:=[Purchase_Orders_Job_forms:59]JobFormID:2+" - "+Substring:C12([Purchase_Orders_Job_forms:59]POItemKey:1; 1; 7)+"."+Substring:C12([Purchase_Orders_Job_forms:59]POItemKey:1; 8; 2)
			NEXT RECORD:C51([Purchase_Orders_Job_forms:59])
		End for 
		uClearSelection(->[Purchase_Orders_Job_forms:59])
		
	Else 
		
		ARRAY TEXT:C222($_JobFormID; 0)
		ARRAY TEXT:C222($_POItemKey; 0)
		
		SELECTION TO ARRAY:C260([Purchase_Orders_Job_forms:59]JobFormID:2; $_JobFormID; [Purchase_Orders_Job_forms:59]POItemKey:1; $_POItemKey)
		SORT ARRAY:C229($_POItemKey; $_JobFormID; >)
		
		For ($i; 1; $Size; 1)
			axText{$i}:=$_JobFormID{$i}+" - "+Substring:C12($_POItemKey{$i}; 1; 7)+"."+Substring:C12($_POItemKey{$i}; 8; 2)
		End for 
		uClearSelection(->[Purchase_Orders_Job_forms:59])
		
	End if   // END 4D Professional Services : January 2019 First record
	
End if 
RELATE ONE:C42([Purchase_Orders:11]VendorID:2)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=[Purchase_Orders:11]PONo:1+"@")
	QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt"; *)
	QUERY SELECTION:C341([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Xfer_Type:2="Return")
	
	
Else 
	
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt"; *)
	QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Xfer_Type:2="Return"; *)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=[Purchase_Orders:11]PONo:1+"@")
	
	
End if   // END 4D Professional Services : January 2019 query selection
ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4; >)

QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=[Purchase_Orders:11]PONo:1+"@")
ORDER BY:C49([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1; >)

QUERY:C277([Purchase_Orders_Chg_Orders:13]; [Purchase_Orders_Chg_Orders:13]PONo:3=[Purchase_Orders:11]PONo:1)
ORDER BY:C49([Purchase_Orders_Chg_Orders:13]; [Purchase_Orders_Chg_Orders:13]POCOKey:1; >)

RELATE MANY:C262([Purchase_Orders:11]PONo:1)
ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)

Case of 
	: (Po1=1)
		OBJECT SET ENABLED:C1123(bFirstRec; False:C215)
		OBJECT SET ENABLED:C1123(bPrevRec; False:C215)
		
		If (Po1<Size of array:C274(aText))
			OBJECT SET ENABLED:C1123(bLastRec; True:C214)
			OBJECT SET ENABLED:C1123(bNextRec; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bLastRec; False:C215)
			OBJECT SET ENABLED:C1123(bNextRec; False:C215)
		End if 
	: (Po1=Size of array:C274(aText))
		OBJECT SET ENABLED:C1123(bLastRec; False:C215)
		OBJECT SET ENABLED:C1123(bNextRec; False:C215)
		
		If (Po1>1)
			OBJECT SET ENABLED:C1123(bFirstRec; True:C214)
			OBJECT SET ENABLED:C1123(bPrevRec; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bFirstRec; False:C215)
			OBJECT SET ENABLED:C1123(bPrevRec; False:C215)
		End if 
	Else 
		OBJECT SET ENABLED:C1123(bFirstRec; True:C214)
		OBJECT SET ENABLED:C1123(bPrevRec; True:C214)
		
		If (Po1<Size of array:C274(aText))
			OBJECT SET ENABLED:C1123(bLastRec; True:C214)
			OBJECT SET ENABLED:C1123(bNextRec; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bLastRec; False:C215)
			OBJECT SET ENABLED:C1123(bNextRec; False:C215)
		End if 
End case 

If ([Purchase_Orders:11]ChgdOrderAmt:13<=0)
	$poi:=Sum:C1([Purchase_Orders_Items:12]ExtPrice:11)
	If ($poi>0)
		ALERT:C41("PO's price with changes should be "+String:C10($poi); "Fix")
		//$id:=New process("PO_fixPrice";64*1024;"PO_fixPrice";[PURCHASE_ORDER]PONo;$poi)
		PO_fixPrice([Purchase_Orders:11]PONo:1; $poi)
	End if 
End if 
//