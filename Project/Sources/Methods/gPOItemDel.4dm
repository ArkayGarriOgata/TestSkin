//%attributes = {"publishedWeb":true}
//(p)gPOItemDel

//• 4/10/97 cs allow po_item to be deleted when status of PO is 'Reserved'
//• 8/20/97 cs renumber remaining items, after deletion
//• 1/16/98 cs adjust Purchase order pricing - when item is deleted
//• 4/1/98 cs delted item(s0 did not renumber added repeat for lcoekd
//• 4/7/98 cs insure that repeat loops are woking on correct records
//• 4/20/98 cs problem with apply to selection duplicating poitemkeys 
//•010799  MLB don't reload all the items a second time, update the item counter

C_TEXT:C284($Item)

MESSAGES OFF:C175
C_LONGINT:C283($numTrans)
SET QUERY DESTINATION:C396(Into variable:K19:4; $numTrans)
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=[Purchase_Orders_Items:12]POItemKey:1)
SET QUERY DESTINATION:C396(Into current selection:K19:1)
Case of 
	: ([Purchase_Orders:11]Status:15#"Requisition") & ([Purchase_Orders:11]Status:15#"Reserved") & ([Purchase_Orders:11]Status:15#"Req Approved") & ([Purchase_Orders:11]Status:15#"PlantMgr") & ([Purchase_Orders:11]Status:15#"New Req")  //• 4/10/97 cs per request (e-mail) from Tina
		BEEP:C151
		ALERT:C41("Purchase Order status must be  New Req, 'Requisition', 'PlantMgr', 'Reserve"+"d', or 'Req Appr"+"oved' to"+"delete Items.")
		
	: ($numTrans>0)
		BEEP:C151
		ALERT:C41("This Item has Been Received Against. "+Char:C90(13)+"You MAY NOT delete this item.")
		
	Else 
		sItemNo:=[Purchase_Orders_Items:12]ItemNo:3
		$ItemValue:=[Purchase_Orders_Items:12]ExtPrice:11
		CONFIRM:C162("Are you sure you want to DELETE PO item "+sItemNo+" - "+[Purchase_Orders_Items:12]Raw_Matl_Code:15+"?")
		If (OK=1)
			If (fLockNLoad(->[Purchase_Orders_Items:12]))
				RELATE MANY:C262([Purchase_Orders_Items:12]POItemKey:1)
				DELETE SELECTION:C66([Purchase_Orders_Job_forms:59])
				DELETE SELECTION:C66([Purchase_Orders_Releases:79])
				DELETE RECORD:C58([Purchase_Orders_Items:12])
				
				zwStatusMsg("DEL POI"; "Updating PO Item Numbers...")
				QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PONo:2=[Purchase_Orders:11]PONo:1; *)
				QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]ItemNo:3>sItemNo)
				ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
				// If (Records in selection([PO_Items])>0)
				
				//SELECTION TO ARRAY([PO_Items]ItemNo;$aItemNum;[PO_Items]POItemKey;$aPOkey;[PO_It
				
				For ($i; 1; Records in selection:C76([Purchase_Orders_Items:12]))
					[Purchase_Orders_Items:12]ItemNo:3:=sItemNo  //String(Num($aItemNum{$i})-1;"00")
					
					[Purchase_Orders_Items:12]POItemKey:1:=[Purchase_Orders_Items:12]PONo:2+[Purchase_Orders_Items:12]ItemNo:3
					SAVE RECORD:C53([Purchase_Orders_Items:12])
					sItemNo:=String:C10(Num:C11(sItemNo)+1; "00")
					NEXT RECORD:C51([Purchase_Orders_Items:12])
				End for 
				
				//ARRAY TO SELECTION($aItemNum;[PO_Items]ItemNo;$aPOkey;[PO_Items]POItemKey)
				// End if   `items found
				
				RELATE MANY:C262([Purchase_Orders:11]PONo:1)
				ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
				
				[Purchase_Orders:11]OrigOrderAmt:12:=[Purchase_Orders:11]OrigOrderAmt:12-$ItemValue  //• 1/16/98 cs adjust Purchase order pricing
				
				[Purchase_Orders:11]ChgdOrderAmt:13:=[Purchase_Orders:11]ChgdOrderAmt:13-$ItemValue
				SAVE RECORD:C53([Purchase_Orders:11])
				sItemNo:=gFindPOItem  //•010799  MLB  UPR update for next record
				
				CANCEL:C270
			End if 
		End if 
End case 

uClearSelection(->[Raw_Materials_Transactions:23])