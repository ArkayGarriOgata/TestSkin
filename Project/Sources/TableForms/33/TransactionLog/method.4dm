//(LP)Fg_Transactions.TransactionLog
//2/10/95
If (Form event code:C388=On Display Detail:K2:22)
	If ([Finished_Goods:26]FG_KEY:47#([Finished_Goods_Transactions:33]CustID:12+":"+[Finished_Goods_Transactions:33]ProductCode:1))  //get the description
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Finished_Goods_Transactions:33]CustID:12+":"+[Finished_Goods_Transactions:33]ProductCode:1)
	End if 
	C_LONGINT:C283($denom)
	If ([Finished_Goods:26]Acctg_UOM:29="M")
		$denom:=1000
	Else 
		$denom:=1
	End if 
	//get the costs
	If ([Finished_Goods_Transactions:33]JobForm:5="PriceChg")  //2/10/95 (set by uInvoAdjustment)
		uClearSelection(->[Job_Forms_Items:44])
		$denom:=1
	Else 
		If (([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Transactions:33]JobForm:5) | ([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Transactions:33]ProductCode:1))
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Finished_Goods_Transactions:33]JobForm:5; *)
			//SEARCH([JobMakesItem]; & [JobMakesItem]CustId=[FG_Transactions]CustID;*)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=[Finished_Goods_Transactions:33]ProductCode:1)
		End if 
	End if 
	
	If ([Finished_Goods_Transactions:33]SkipTrigger:14)
		real1:=0
		real2:=0
		real3:=0
		real4:=0
	Else 
		C_REAL:C285($thousand)
		If (Records in selection:C76([Job_Forms_Items:44])#0)
			$thousand:=[Finished_Goods_Transactions:33]Qty:6/$denom
			real1:=Round:C94([Job_Forms_Items:44]PldCostMatl:17*$thousand; 2)
			real2:=Round:C94([Job_Forms_Items:44]PldCostLab:18*$thousand; 2)
			real3:=Round:C94([Job_Forms_Items:44]PldCostOvhd:19*$thousand; 2)
			real4:=Round:C94(real1+real2+real3; 2)
		Else 
			real1:=0
			real2:=0
			real3:=0
			real4:=Round:C94(real1+real2+real3; 2)
		End if 
		
	End if 
	
End if 
//