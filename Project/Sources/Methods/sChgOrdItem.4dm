//%attributes = {"publishedWeb":true}
//sChgOrdItem
//$1 optional, any character, indicate that this is from [chngord his]orditem incl
//(S) ItemNo:[OrderChgHistory]'OrderChg_Items'Output'ItemNo
//8/21/94
//1268 2/16/95 chip
//5/1/95 chip

C_BOOLEAN:C305($makeItem)
C_TEXT:C284($cpn)

$makeItem:=False:C215

uClearSelection(->[Finished_Goods:26])
//SEARCH([OrderLines];[OrderLines]OrderLine=String([OrderChgHistory]OrderNo;
//«"00000.")+String([OrderChgHistory]OrderChg_Items'ItemNo;"00"))
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=(fMakeOLkey([Customers_Order_Change_Orders:34]OrderNo:5; [Customers_Order_Changed_Items:176]ItemNo:1)))
Case of 
	: (Records in selection:C76([Customers_Order_Lines:41])=1)
		uLoadChgOrdItem
		SAVE RECORD:C53([Customers_Order_Changed_Items:176])
		
	: (Records in selection:C76([Customers_Order_Lines:41])>1)
		OL_select_line_for_chg_order
		
	: ([Customers_Order_Changed_Items:176]ItemNo:1=0)  //select a line
		OL_select_line_for_chg_order
		
	Else 
		$winRef:=OpenSheetWindow(->[zz_control:1]; "NewOrdItem")
		DIALOG:C40([zz_control:1]; "NewOrdItem")
		If (OK=1)
			If (bPick=1)  //spl billing      
				gMakeOrdChgItm
				
			Else 
				$cpn:=Substring:C12(Request:C163("Enter Product Code (20 Characters Max):"; ""); 1; 20)
				If (ok=1) & ($cpn#"")
					qryFinishedGood("#CPN"; $cpn)
					If (Records in selection:C76([Finished_Goods:26])=0)
						FG_SelectFromList([Customers_Order_Change_Orders:34]CustID:2)
					End if 
					If (Records in selection:C76([Finished_Goods:26])=1)
						gLoadHistItem
						SAVE RECORD:C53([Customers_Order_Changed_Items:176])
						
					Else 
						BEEP:C151
					End if 
				End if 
			End if 
		End if 
		
End case 

RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)