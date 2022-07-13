// ----------------------------------------------------
// User name (OS): cs
// ----------------------------------------------------
// Object Method: [Estimates_Carton_Specs].Input.ProductCode
// ----------------------------------------------------

If ([Estimates_Carton_Specs:19]ProductCode:5#"")
	[Estimates_Carton_Specs:19]OriginalOrRepeat:9:=""
	[Estimates_Carton_Specs:19]ProductCode:5:=fStripSpace("B"; [Estimates_Carton_Specs:19]ProductCode:5)
	
	If ([Estimates_Carton_Specs:19]CustID:6="") | ([Estimates:17]CustomerName:47=<>sCombindID)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Estimates_Carton_Specs:19]ProductCode:5)
		$Found:=Records in selection:C76([Finished_Goods:26])
	Else 
		$Found:=qryFinishedGood([Estimates_Carton_Specs:19]CustID:6; [Estimates_Carton_Specs:19]ProductCode:5)
	End if 
	If ($Found=0)
		BEEP:C151
		ALERT:C41([Estimates_Carton_Specs:19]ProductCode:5+" does not exist for this customer. Please enter the details.")
		
	Else 
		uConfirm("Make this carton spec like F/G: "+[Finished_Goods:26]ProductCode:1)
		If (ok=1)
			FG_CspecLikeFG
			If ([Customers:16]ID:1#[Estimates_Carton_Specs:19]CustID:6)
				qryCustomer(->[Customers:16]ID:1; [Estimates_Carton_Specs:19]CustID:6)
			End if 
			Text1:=[Customers:16]Name:2
			GOTO OBJECT:C206([Estimates_Carton_Specs:19]PONumber:73)  //product & customer selected go to po
			RELATE ONE:C42([Estimates_Carton_Specs:19]ProcessSpec:3)
		End if 
	End if 
	
Else 
	UNLOAD RECORD:C212([Finished_Goods:26])
End if 

FillInClassification("ECS"; Self:C308; ->[Estimates_Carton_Specs:19]Classification:72)  // Added by: Mark Zinke (5/21/13)