//%attributes = {"publishedWeb":true}
//1/10/97 -cs- modified to handle multiple xustomers on one job
C_LONGINT:C283($temp; $recNo)  //(P) zoomFG
C_POINTER:C301($1)
$temp:=iMode
TRACE:C157
If ($temp<=2)
	iMode:=2
Else 
	iMode:=3
End if 
fromZoom:=True:C214
[Estimates_Carton_Specs:19]OriginalOrRepeat:9:=""
If (Count parameters:C259<1)
	iMode:=2
	READ WRITE:C146([Finished_Goods:26])
	If ([Estimates_Carton_Specs:19]ProductCode:5#"")
		qryFinishedGood([Estimates_Carton_Specs:19]CustID:6; [Estimates_Carton_Specs:19]ProductCode:5)  //•1/10/97 -cs - replaced below search with this
		//SEARCH([Finished_Goods];[Finished_Goods]FG_KEY=[CARTON_SPEC]CustID+":"
		//«+[CARTON_SPEC]ProductCode)
		//MODIFY RECORD([Finished_Goods];*)
		Case of 
			: (Records in selection:C76([Finished_Goods:26])=1)
				CONFIRM:C162("Make this carton spec like CPN: "+[Finished_Goods:26]ProductCode:1)
				If (ok=1)
					FG_CspecLikeFG
				End if 
			: (Records in selection:C76([Finished_Goods:26])>1)
				BEEP:C151
				ALERT:C41([Estimates_Carton_Specs:19]ProductCode:5+" does not uniquely describe any F/G product codes for this customer.")
			Else 
				BEEP:C151
				ALERT:C41([Estimates_Carton_Specs:19]ProductCode:5+" does not match any F/G product codes for this customer.")
		End case 
	Else 
		
		//•1/10/97 -cs - mods for multi customer/job    
		Case of 
			: ([Estimates:17]Cust_ID:2=<>sCombindID) & ([Estimates_Carton_Specs:19]CustID:6="")  //if this is for a combined customer, no limit on what is selected
				uConfirm("There was NO Customer ID entered."+Char:C90(13)+"Do You REALLY want to get a list of ALL Finished Goods?")
				If (OK=1)
					$recNo:=fPickList(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods:26]CustID:2; ->[Finished_Goods:26]CartonDesc:3)
				Else 
					$RecNo:=-1
				End if 
			: ([Estimates:17]Cust_ID:2=<>sCombindID) & ([Estimates_Carton_Specs:19]CustID:6#"")  //combined job and customer is specified on Cspec
				$recNo:=fPickList(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods:26]CustID:2; ->[Finished_Goods:26]CartonDesc:3; [Estimates_Carton_Specs:19]CustID:6)
			Else   //for specific customer([estimate]), allow only FGs for that customer
				$recNo:=fPickList(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods:26]CustID:2; ->[Finished_Goods:26]CartonDesc:3; [Estimates:17]Cust_ID:2)
		End case 
		//end 1/10/97 mods    
		
		If ($recNo#-1)
			GOTO RECORD:C242([Finished_Goods:26]; $recNo)
			CONFIRM:C162("Make this carton spec like CPN: "+[Finished_Goods:26]ProductCode:1)
			If (ok=1)
				FG_CspecLikeFG
				GOTO OBJECT:C206([Estimates_Carton_Specs:19]PONumber:73)  //•1/10/97 product & customer selected go to po
			End if 
		End if 
	End if 
Else 
	iMode:=3
	READ ONLY:C145([Finished_Goods:26])
	If ($1->#"")
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$1->)
		If (Records in selection:C76([Finished_Goods:26])>=1)
			Open window:C153(12; 50; 518; 348; 8; "Zoom F/G:"+[Finished_Goods:26]ProductCode:1+" from Order Line")  //;"wCloseWinBox")  
			DISPLAY SELECTION:C59([Finished_Goods:26]; *)
		Else 
			BEEP:C151
			ALERT:C41($1->+" not found.")
		End if 
	Else 
		$recNo:=fPickList(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods:26]CustID:2; ->[Finished_Goods:26]CartonDesc:3; [Customers_Orders:40]CustID:2)
		If ($recNo#-1)
			GOTO RECORD:C242([Finished_Goods:26]; $recNo)
			[Customers_Order_Lines:41]ProductCode:5:=[Finished_Goods:26]ProductCode:1
			[Customers_Order_Lines:41]Cost_Per_M:7:=[Finished_Goods:26]LastCost:26
		End if 
	End if 
End if   //1 param
iMode:=$temp
If ($temp=2)
	OBJECT SET ENABLED:C1123(bAcceptRec; True:C214)
	OBJECT SET ENABLED:C1123(bDelete; True:C214)
	OBJECT SET ENABLED:C1123(bDeleteRec; True:C214)
End if 
If ($temp=1)
	OBJECT SET ENABLED:C1123(bAcceptRec; True:C214)
End if 
fromZoom:=False:C215
//