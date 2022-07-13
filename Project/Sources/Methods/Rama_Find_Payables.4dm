//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/03/12, 10:20:25
// ----------------------------------------------------
// Method: Rama_Find_Payables
// Description
// find r/m transactions that are ready to invoice or ready to pay
// ----------------------------------------------------
// Modified by: Mel Bohince (1/13/15) change to [Finished_Goods_Transactions] shipped perspective
C_TEXT:C284($1)
C_LONGINT:C283($0)

Case of 
	: ($1="open2")
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Invoiced:38=!00-00-00!; *)
		QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]Paid:39=!00-00-00!; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11="FG:AV=R@")  //should get Rama Gluing and Rama Freight
		
	: ($1="invoice2")
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Invoiced:38=!00-00-00!; *)
		QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]Paid:39=!00-00-00!; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11="FG:AV=R@")  //should get Rama Gluing and Rama Freight
		
	: ($1="pay2")
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="FG:AV=R@"; *)  //should get Rama Gluing and Rama Freight
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Invoiced:38#!00-00-00!; *)
		QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]Paid:39=!00-00-00!)
		
	: ($1="user_specified2")
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="FG:AV=R@"; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
		If (cb1=1)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Invoiced:38#!00-00-00!; *)
		Else 
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Invoiced:38=!00-00-00!; *)
		End if 
		If (cb2=1)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Paid:39#!00-00-00!; *)
		Else 
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Paid:39=!00-00-00!; *)
		End if 
		QUERY:C277([Finished_Goods_Transactions:33])
		
		
	: ($1="invoice")
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="RAMA @"; *)  //should get Rama Gluing and Rama Freight
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Invoiced:30=!00-00-00!; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Paid:31=!00-00-00!)
		
		
	: ($1="pay")
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="RAMA @"; *)  //should get Rama Gluing and Rama Freight
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Invoiced:30#!00-00-00!; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Paid:31=!00-00-00!)
		
	: ($1="open")
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Invoiced:30=!00-00-00!; *)
		QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Paid:31=!00-00-00!; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="RAMA @")  //should get Rama Gluing and Rama Freight
		
	: ($1="user_specified")
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="RAMA @"; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
		If (cb1=1)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Invoiced:30#!00-00-00!; *)
		Else 
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Invoiced:30=!00-00-00!; *)
		End if 
		If (cb2=1)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Paid:31#!00-00-00!; *)
		Else 
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Paid:31=!00-00-00!; *)
		End if 
		QUERY:C277([Raw_Materials_Transactions:23])
		
	Else   //get all
		//QUERY([Raw_Materials_Transactions];[Raw_Materials_Transactions]Raw_Matl_Code="RAMA @")  //should get Rama Gluing and Rama Freight
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Invoiced:38=!00-00-00!)
End case 

$0:=Records in selection:C76([Finished_Goods_Transactions:33])