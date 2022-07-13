// ----------------------------------------------------
// Object Method: [Raw_Materials].POArray.Variable32
// Description:
// Check for valid Quantity Received
//•10/17/97 cs - stop ability to do a negative receipt
//• 11/4/97 cs control enterabiliry of rqty2
//• 3/11/98 cs stop receiving from accepting materials when incomming amount is 
//•121698  Systems G3  UPR limit to 20 over the open qty
//  greater than 10% over order qty
//•121698  Systems G3  UPR limit to 20 over the OPEN qty
//•090799  mlb  permit another overreceipt if total over within 20% and fix msgs
//• mlb - 6/17/02  16:25 go from 20% to 10% over receipt
// Modified by Mel Bohince on 11/20/06 at 14:50:34 :  no limit on inx, no pass on lasercam
// ----------------------------------------------------

C_REAL:C285($MaxRcv)

If (Self:C308-><0)
	ALERT:C41("You May not receive a NEGATIVE quantity."+Char:C90(13)+"Receive a POSITIVE quantity, or"+Char:C90(13)+"Enter a RETURN, to mark items returned or correct a mistake.")
	Self:C308->:=0
	GOTO OBJECT:C206(Self:C308->)
Else 
	$Percent:=(aPOQty{aPoQty}*0.1)  //• mlb - 6/17/02  16:25 was 20%
	$MaxRcv:=aQtyAvl{aQtyAvl}+$percent  //aPoqty{aPOQty}`•121698  Systems G3  UPR limit to 20 over the open qty
	
	Case of 
		: ([Purchase_Orders:11]INX_autoPO:48)  //• mlb - 11/15/06  14:58
			SetObjectProperties(""; ->rQty2; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			
		: (xText2="Consignment@")
			SetObjectProperties(""; ->rQty2; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			
		: (rQty>$MaxRcv)  //• 3/11/98 cs receive qty > max allowed to be received 
			uConfirm("The 'Qty Rec'd' will exceed "+"the order amount by more than 10%."+Char:C90(13)+"Purchasing must issue a "+"Change Order to adjust the Order amount to receive this amount."+Char:C90(13)+"Please contact the Purchasing department."; "OK"; "Help")
			rQty:=0
			GOTO OBJECT:C206(rQty)
			
		: (rQty>aQtyAvl{aQtyAvl})
			uConfirm("Warning: 'Qty Rec'd' exceeds open quantity, but is within tolerance."; "OK"; "Help")
			GOTO OBJECT:C206(rQty)
			
		Else 
			SetObjectProperties(""; ->rQty2; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	End case 
	rQty2:=rQty
	
	If (r1#0)
		rQty2:=rQty*r1
		
		If (r2#0)
			rQty2:=rQty2/r2
		End if 
		rPriceConv:=arNum2{aPOPrice}/arDenom2{aPOPrice}  //shipping to billing = ([PO_ITEMS]FactNship2price/[PO_ITEMS]FactDship2price)
		rPriceConv:=rPriceConv*(r2/r1)  //arkay to shipping =([PO_ITEMS]FactNship2cost/[PO_ITEMS]FactDship2cost
		rActPrice:=aPOPrice{aPOPrice}*rPriceConv
	End if 
	
	rQty2:=Round:C94(rQty2; 2)
End if 