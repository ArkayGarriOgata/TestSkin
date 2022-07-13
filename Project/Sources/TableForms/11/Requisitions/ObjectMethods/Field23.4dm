//(s)[purchase order]input'required
//see also required date - requisition
//•051799  mlb  optimize
If ([Purchase_Orders:11]Required:27<4D_Current_date)
	ALERT:C41("Invalid required date."+Char:C90(13)+"Date entered is before today.")
	GOTO OBJECT:C206([Purchase_Orders:11]Required:27)
Else 
	If (Records in selection:C76([Purchase_Orders_Items:12])>0)
		//MESSAGES OFF
		//CREATE SET([PO_Items];"Hold")
		SET QUERY LIMIT:C395(Records in selection:C76([Purchase_Orders_Items:12]))  //don't find more than you already got
		CUT NAMED SELECTION:C334([Purchase_Orders_Items:12]; "Hold")
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PONo:2=[Purchase_Orders:11]PONo:1; *)
		QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]ReqdDate:8<[Purchase_Orders:11]Required:27)
		SET QUERY LIMIT:C395(0)
		$found:=Records in selection:C76([Purchase_Orders_Items:12])
		If ($found>0)
			uConfirm("This PO has "+String:C10($found)+" items with required dates before "+String:C10([Purchase_Orders:11]Required:27; Internal date short:K1:7)+"."+Char:C90(13)+"Update their required dates to match?"; "Update"; "No Change")
			If (OK=1)
				ARRAY DATE:C224($aRequired; $found)
				For ($i; 1; $found)
					$aRequired{$i}:=[Purchase_Orders:11]Required:27
				End for 
				ARRAY TO SELECTION:C261($aRequired; [Purchase_Orders_Items:12]ReqdDate:8)
				//APPLY TO SELECTION([PO_Items];[PO_Items]ReqdDate:=[PURCHASE_ORDER]Required)
			End if 
		End if 
		
		USE NAMED SELECTION:C332("Hold")  //restore prior selection
		//USE SET("Hold")
		//CLEAR SET("Hold")
		//ORDER BY([PO_Items];[PO_Items]POItemKey;>)
		//MESSAGES ON
	End if 
End if 
//