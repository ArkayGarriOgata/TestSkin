//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: POI_itemUpdate   ( ) ->
//gRMPOItemUpdate: Update [PO_ITEMS]
//03/14/95 chip 
//5/2/95 upr 1498, chip
//•051095 upr 1498 
//• 7/23/97 cs  insure that the open quantity is cleared if remaing amount on a PO
//(after receipt) is less than a half unit - UPR 179
//• 1/28/98 cs NAN checking

C_LONGINT:C283($1)
C_DATE:C307($2; $transDate)

$transDate:=$2

If ($transDate=!00-00-00!)
	$transDate:=4D_Current_date
End if 

UNLOAD RECORD:C212([Purchase_Orders:11])  // 09/14/10 maybe in read only
READ WRITE:C146([Purchase_Orders_Items:12])
READ WRITE:C146([Purchase_Orders:11])
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=aRMPONum{$1}+aRMPOItem{$1})

If (Records in selection:C76([Purchase_Orders_Items:12])>0)
	RELATE ONE:C42([Purchase_Orders_Items:12]PONo:2)
	
	If (Not:C34(Locked:C147([Purchase_Orders:11])))
		LOAD RECORD:C52([Purchase_Orders:11])
	Else 
		fLockNLoad(->[Purchase_Orders:11])
		uCancelTran
	End if 
	
	If (fCnclTrn=False:C215)  //not cancelled yet
		If (Not:C34(Locked:C147([Purchase_Orders_Items:12])))
			LOAD RECORD:C52([Purchase_Orders_Items:12])
		Else 
			fLockNLoad(->[Purchase_Orders_Items:12])
			uCancelTran
		End if 
		
		If (fCnclTrn=False:C215)  //not cancelled yet
			aRMPOQty{$1}:=uNANCheck(aRMPOQty{$1})  //• 1/28/98 cs check value for a NAN      
			[Purchase_Orders_Items:12]Qty_Received:14:=Round:C94([Purchase_Orders_Items:12]Qty_Received:14+aRMPOQty{$1}; 2)  //added round 03/14/95 chip 
			[Purchase_Orders_Items:12]Qty_Open:27:=Round:C94([Purchase_Orders_Items:12]Qty_Shipping:4-[Purchase_Orders_Items:12]Qty_Received:14; 2)  //03/14/95 chip
			
			//• 7/23/97 cs  insure that the open quantity is cleared if remaing amount on a PO
			//(after receipt) is less than a half unit - 
			If ([Purchase_Orders_Items:12]Qty_Open:27<0.5) & ([Purchase_Orders_Items:12]Qty_Open:27>-0.5)  //arbitrary value, if the left over is < ±1/2 clear it
				[Purchase_Orders_Items:12]Qty_Open:27:=0
			End if 
			//• 7/23/97  cs end      
			
			If ([Purchase_Orders_Items:12]RecvdDate:43=!00-00-00!)  //•5/10/95 dont replace first date
				[Purchase_Orders_Items:12]RecvdDate:43:=$transDate  //5/2/95 & 5/10/95
			End if 
			
			[Purchase_Orders_Items:12]RecvdCnt:42:=[Purchase_Orders_Items:12]RecvdCnt:42+1  //5/2/95
			[Purchase_Orders:11]StatusDate:17:=$transDate
			[Purchase_Orders:11]StatusBy:16:=<>zResp
			[Purchase_Orders:11]Status:15:="Partial Receipt"
			SAVE RECORD:C53([Purchase_Orders_Items:12])
			SAVE RECORD:C53([Purchase_Orders:11])
			RELATE MANY:C262([Purchase_Orders:11]PONo:1)  //get all PO items
			
			If (Sum:C1([Purchase_Orders_Items:12]Qty_Open:27)<=0)  //all fully received
				[Purchase_Orders:11]Status:15:="Full Receipt"
				[Purchase_Orders:11]StatusDate:17:=$transDate
				[Purchase_Orders:11]StatusBy:16:=<>zResp
				SAVE RECORD:C53([Purchase_Orders:11])
			End if 
			UNLOAD RECORD:C212([Purchase_Orders:11])
			UNLOAD RECORD:C212([Purchase_Orders_Items:12])
		End if 
	End if 
End if 