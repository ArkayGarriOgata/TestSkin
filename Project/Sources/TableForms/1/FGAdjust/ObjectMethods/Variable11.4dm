//(S) [CONTROL]RMadjust'bView
//created  upr 1858 cs

If (sCriterion1="") | (sCriterion1=":")
	ALERT:C41("You Need to Identify the finished good for which you wish to see adjustments.")
Else 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CREATE SET:C116([Finished_Goods:26]; "Currentfg")  //save off current selections in these files
		CREATE SET:C116([Finished_Goods_Locations:35]; "CurrentFgl")
		CREATE SET:C116([Job_Forms_Items:44]; "CurrentJMI")
		
	Else 
		
		//Laghzaoui to mel:if i understand well you just modifie the courent selection of [Finished_Goods_Transactions]
		
	End if   // END 4D Professional Services : January 2019 
	
	Case of 
		: (Records in selection:C76([Job_Forms_Items:44])>=1)  //record in RM file 
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Job_Forms_Items:44]ProductCode:3; *)
		: (Records in selection:C76([Finished_Goods:26])>=1)  //no bin yet
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
		: (Records in selection:C76([Finished_Goods_Locations:35])>=1)  //use rm_b@in      
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Finished_Goods_Locations:35]ProductCode:1; *)
	End case 
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Adjust@")
	
	If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
		$Count:=Records in selection:C76([Finished_Goods_Transactions:33])
		ARRAY TEXT:C222(asCode; $Count)
		ARRAY DATE:C224(aDate; $Count)
		ARRAY LONGINT:C221(aQuantity; $Count)
		ARRAY TEXT:C222(aReason; $Count)
		ARRAY TEXT:C222(aLocation; $Count)
		ARRAY TEXT:C222($aReason; $Count)
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]ProductCode:1; asCode; [Finished_Goods_Transactions:33]XactionDate:3; aDate; [Finished_Goods_Transactions:33]Reason:26; $aReason; [Finished_Goods_Transactions:33]Qty:6; aQuantity; [Finished_Goods_Transactions:33]Location:9; aLocation)
		For ($i; 1; $Count)  //FG_Transaction reason is 80 characters, RM reason is 30, truncate to match
			aReason{$i}:=Substring:C12($aReason{$i}; 1; 30)
		End for 
		t2b:="Product Code"
		t2:="Adjustments for Finished Goods"
		uDialog("DisplayAdj"; 450; 200; 8)
	Else 
		ALERT:C41("No Adjustment transactions found.")
	End if 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		USE SET:C118("Currentfg")  //save off current selections in these files
		USE SET:C118("CurrentFgl")
		USE SET:C118("CurrentJMI")
		CLEAR SET:C117("Currentfg")  //save off current selections in these files
		CLEAR SET:C117("CurrentFgl")
		CLEAR SET:C117("CurrentJMI")
		
	Else 
		
		
	End if   // END 4D Professional Services : January 2019 
	
End if 
//