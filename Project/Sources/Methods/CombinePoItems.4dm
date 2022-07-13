//%attributes = {"publishedWeb":true}
//(p) CombinePoItems
//display a dialog for user to select one or more PO to move items from
//and then processes them (moves PO items to primary PO)
//• 6/20/97 cs created
//• 8/12/97 cs some problems if items are attempted to be moved multiple times
//• 6/3/98 cs when move is complete mark secondary POs as 'canceled'
//• 7/14/98 cs update new modifcation tracker field

C_TEXT:C284($ReqNum)
C_LONGINT:C283($Offset; $Count; $ItmCount; $Loc)
C_TEXT:C284($NewComment; $NewExpidite; $NewShip)
C_TEXT:C284(sPONum)
C_TEXT:C284(sName)
C_TEXT:C284(CustNum)
C_REAL:C285($Additional)

$Additional:=0
USE SET:C118("Primary")  //created in button - from userset
$ReqNum:=[Purchase_Orders:11]ReqNo:5
sPoNum:=[Purchase_Orders:11]PONo:1
RELATE MANY:C262([Purchase_Orders:11]PONo:1)  //get po_items
ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; <)
$Offset:=Num:C11([Purchase_Orders_Items:12]ItemNo:3)  //used later to renumber po items
CustNum:=[Purchase_Orders:11]VendorID:2
sName:=[Purchase_Orders:11]VendorName:42
$NewComment:=[Purchase_Orders:11]Comments:21
$NewExpidite:=[Purchase_Orders:11]ExpeditingNote:40
$NewShip:=[Purchase_Orders:11]ShipInstruct:20
CLEAR SET:C117("UserSet")
USE SET:C118("Current")  //created in button
QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2=CustNum)  //locate all POs for the selected vendor

If (Records in selection:C76([Purchase_Orders:11])>1)  //the above search will find the primary record too
	CREATE SET:C116([Purchase_Orders:11]; "Secondary")
	DIFFERENCE:C122("Secondary"; "Primary"; "Secondary")
	USE SET:C118("Secondary")
	CLEAR SET:C117("Secondary")
	$Count:=Records in selection:C76([Purchase_Orders:11])
	ARRAY TEXT:C222(aRmPoNum; $Count)  //reused arrays
	ARRAY LONGINT:C221(aL1; $Count)
	ARRAY TEXT:C222(aDeptCode; $Count)  //for department from which order came
	ARRAY TEXT:C222(aLine; $Count)
	ARRAY DATE:C224(aDate; $Count)
	ARRAY TEXT:C222(aBullet; $Count)
	ARRAY REAL:C219(aPOPrice; $Count)
	
	SELECTION TO ARRAY:C260([Purchase_Orders:11]; aL1; [Purchase_Orders:11]ReqNo:5; aReqNo; [Purchase_Orders:11]PONo:1; aRmPoNum; [Purchase_Orders:11]Status:15; aLine; [Purchase_Orders:11]Dept:7; aDeptCode; [Purchase_Orders:11]PODate:4; aDate; [Purchase_Orders:11]ChgdOrderAmt:13; aPOPrice)
	SORT ARRAY:C229(aRmPoNum; aL1; aDeptCode; aLine; aDate; aReqNo; >)
	
	$winRef:=Open form window:C675([zz_control:1]; "CombinePoItems"; Sheet form window:K39:12)
	DIALOG:C40([zz_control:1]; "CombinePoItems")
	CLOSE WINDOW:C154($winRef)
	
	If (OK=1)
		$Loc:=Find in array:C230(aBullet; "•")
		uThermoInit(0; "Processing Moves....")
		Repeat 
			GOTO RECORD:C242([Purchase_Orders:11]; aL1{$Loc})
			uMyLoadRec(->[Purchase_Orders:11])
			RELATE MANY:C262([Purchase_Orders:11]PONo:1)
			$ItmCount:=Records in selection:C76([Purchase_Orders_Items:12])
			
			If ($ItmCount>0)  //• 8/12/97 cs there are actually items to move
				$Comment:=[Purchase_Orders:11]Comments:21
				
				If ([Purchase_Orders:11]ExpeditingNote:40#"")
					$NewExpidite:=[Purchase_Orders:11]ExpeditingNote:40+Char:C90(13)+$NewExpidite
				End if 
				
				If ([Purchase_Orders:11]ShipInstruct:20#"")
					$NewShip:=[Purchase_Orders:11]ShipInstruct:20+Char:C90(13)+$NewShip
				End if 
				[Purchase_Orders:11]Status:15:="Cancelled"  //• 6/3/98 cs move POs losing items to 'Canceled'
				[Purchase_Orders:11]StatusDate:17:=4D_Current_date  //• 6/3/98 cs 
				[Purchase_Orders:11]StatusBy:16:=<>zResp  //• 6/3/98 cs 
				[Purchase_Orders:11]Comments:21:="Items moved to PO Number/Requistion Number: "+sPoNum+"/"+$ReqNum+Char:C90(13)+[Purchase_Orders:11]Comments:21  //note where the items went, for requistioner
				[Purchase_Orders:11]ChgdOrderAmt:13:=0  //clear final order amount since all items moved
				//• 7/14/98 cs angelo wants to be able to track every thing
				[Purchase_Orders:11]StatusTrack:51:="Combined"+" "+[Purchase_Orders:11]Status:15+" "+<>zResp+" "+String:C10(4D_Current_date)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
				SAVE RECORD:C53([Purchase_Orders:11])
				ARRAY TEXT:C222($ItemPo; $ItmCount)
				ARRAY TEXT:C222($ItemNo; $ItmCount)
				ARRAY TEXT:C222($ItemKey; $ItmCount)
				ARRAY REAL:C219($Price; $ItmCount)
				SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]PONo:2; $ItemPo; [Purchase_Orders_Items:12]ItemNo:3; $ItemNo; [Purchase_Orders_Items:12]POItemKey:1; $ItemKey; [Purchase_Orders_Items:12]ExtPrice:11; $Price)
				
				For ($j; 1; $ItmCount)  //renumber items on combined po
					$ItemPo{$j}:=sPoNum
					$ItemNo{$j}:=String:C10(Num:C11($ItemNo{$j})+$Offset; "00")
					$ItemKey{$j}:=$ItemPo{$j}+$ItemNo{$j}
					$Additional:=$Price{$j}+$Additional  //add additional item values to po header
					
					If ($Comment#"")  //if the comment field is not empty correct item references also
						$Comment:=Replace string:C233($Comment; $ItemNo{$j}; String:C10(Num:C11($ItemNo{$j})+$Offset; "00"))
					End if 
				End for 
				
				If ($Comment#"")
					$NewComment:=$Comment+Char:C90(13)+$NewComment  //add updated comments
				End if 
				ARRAY TO SELECTION:C261($ItemPo; [Purchase_Orders_Items:12]PONo:2; $ItemKey; [Purchase_Orders_Items:12]POItemKey:1; $ItemNo; [Purchase_Orders_Items:12]ItemNo:3)
				$OffSet:=$OffSet+$ItmCount  //update         
			End if   //ther are items
			$Loc:=Find in array:C230(aBullet; "√"; $Loc+1)
		Until ($Loc<0)
		USE SET:C118("Primary")
		uMyLoadRec(->[Purchase_Orders:11])
		[Purchase_Orders:11]Comments:21:=$NewComment
		[Purchase_Orders:11]ShipInstruct:20:=$NewShip
		[Purchase_Orders:11]ExpeditingNote:40:=$NewExpidite
		[Purchase_Orders:11]ChgdOrderAmt:13:=[Purchase_Orders:11]ChgdOrderAmt:13+$Additional
		SAVE RECORD:C53([Purchase_Orders:11])
		uThermoClose
	End if 
	$Count:=0
	$ItmCount:=0
	ARRAY TEXT:C222($ItemPo; $ItmCount)  //clear arrays
	ARRAY TEXT:C222($ItemNo; $ItmCount)
	ARRAY TEXT:C222($ItemKey; $ItmCount)
	ARRAY TEXT:C222(aRmPoNum; $Count)  //reused arrays
	ARRAY LONGINT:C221(aL1; $Count)
	ARRAY TEXT:C222(aDeptCode; $Count)  //for department from which order came
	ARRAY TEXT:C222(aLine; $Count)
	ARRAY DATE:C224(aDate; $Count)
	ARRAY TEXT:C222(aBullet; $Count)
	ARRAY REAL:C219(aPOPrice; $Count)
Else 
	uConfirm("No Other Requisitions found using Vendor '"+sName+"'."; "OK"; "Help")
End if 