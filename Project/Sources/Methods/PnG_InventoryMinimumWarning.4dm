//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/04/14, 09:29:26
// ----------------------------------------------------
// Method: PnG_InventoryMinimumWarning was Est_PnGMinQtyTest
// Description:
// 1. P&G Only (00199)
// 2. [Finished_Goods]InventoryMin has been set. (Max is ignored)
// 3. Evoked by [Finished_Goods_Transactions]XactionType = "Ship" for the current date.
// ----------------------------------------------------
// Modified by: Mel Bohince (3/31/15) html'ize

C_LONGINT:C283($i; $xlNumTrans; $xlQtyOH; $xlMin)
C_BOOLEAN:C305($bSend)
ARRAY TEXT:C222(atProdCode; 0)
ARRAY TEXT:C222(atMin; 0)
ARRAY TEXT:C222(atQty; 0)

$bSend:=False:C215  //Assume we are not sending the email

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12="00199"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3=Current date:C33)

$xlNumTrans:=Records in selection:C76([Finished_Goods_Transactions:33])

If ($xlNumTrans>0)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
		
		For ($i; 1; $xlNumTrans)
			GOTO SELECTED RECORD:C245([Finished_Goods_Transactions:33]; $i)
			
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Finished_Goods_Transactions:33]ProductCode:1)  //Get the Min
			$xlMin:=[Finished_Goods:26]InventoryMin:62
			
			If ($xlMin>0)  //If zero skip this transaction.
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods_Transactions:33]ProductCode:1)  //Get the Qty On Hand
				$xlQtyOH:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
				
				If ($xlQtyOH<=$xlMin)  //Send the email!
					$bSend:=True:C214
					If (Find in array:C230(atProdCode; [Finished_Goods_Transactions:33]ProductCode:1)=-1)
						APPEND TO ARRAY:C911(atProdCode; [Finished_Goods_Transactions:33]ProductCode:1)
						APPEND TO ARRAY:C911(atMin; String:C10($xlMin; "#,###,##0"))
						APPEND TO ARRAY:C911(atQty; String:C10($xlQtyOH; "#,###,##0"))
					End if 
				End if 
			End if 
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_ProductCode; 0)
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]ProductCode:1; $_ProductCode)
		$xlNumTrans:=Size of array:C274($_ProductCode)
		
		
		ARRAY TEXT:C222($_ProductCode_1; 0)
		ARRAY LONGINT:C221($_InventoryMin; 0)
		
		QUERY WITH ARRAY:C644([Finished_Goods:26]ProductCode:1; $_ProductCode)
		SELECTION TO ARRAY:C260([Finished_Goods:26]ProductCode:1; $_ProductCode_1; \
			[Finished_Goods:26]InventoryMin:62; $_InventoryMin)
		
		
		For ($i; 1; $xlNumTrans)
			
			$xlMin:=0
			$position:=Find in array:C230($_ProductCode_1; $_ProductCode{$i})
			If ($position>0)
				
				$xlMin:=$_InventoryMin{$position}
				
			End if 
			
			If ($xlMin>0)  //If zero skip this transaction.
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$_ProductCode{$i})  //Get the Qty On Hand
				$xlQtyOH:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
				
				If ($xlQtyOH<=$xlMin)  //Send the email!
					$bSend:=True:C214
					If (Find in array:C230(atProdCode; $_ProductCode{$i})=-1)
						APPEND TO ARRAY:C911(atProdCode; $_ProductCode{$i})
						APPEND TO ARRAY:C911(atMin; String:C10($xlMin; "#,###,##0"))
						APPEND TO ARRAY:C911(atQty; String:C10($xlQtyOH; "#,###,##0"))
					End if 
				End if 
			End if 
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 


If ($bSend)
	C_TEXT:C284($tSubject; $tBodyTitle; $tBody; $tSender; $tRecepients; $0)
	C_LONGINT:C283($i; $xlSize)
	
	$xlSize:=Size of array:C274(atProdCode)
	$tBody:=""
	
	$tBodyTitle:="The following "+util_plural("product"; $xlSize)
	
	If ($xlSize=1)
		$tSubject:="Inventory Minimum Reached for "+atProdCode{1}+"."
		$tBodyTitle:=$tBodyTitle+" has quantities under the required minimums:"
	Else 
		$tSubject:="Inventory Minimum Reached for Multiple Products."
		$tBodyTitle:=$tBodyTitle+" have quantities under the required minimums:"
	End if 
	
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$r:="</td></tr>"+<>CR
	$tBody:=$tBody+$b+"Product Code"+$t+"Minimum"+$t+"On Hand"+$r
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	For ($i; 1; $xlSize)
		$tBody:=$tBody+$b+atProdCode{$i}+$t+atMin{$i}+$t+atQty{$i}+$r
	End for 
	
	
	//$tSender:=Email_WhoAmI 
	
	$tRecepients:=Batch_GetDistributionList("PnG Min Check")
	//$tRecepients:="mel.bohince@arkay.com"
	//$err:=EMAIL_Sender ($tSubject;$tBodyTitle;$tBody;$tRecepients;"";"";$tSender)
	Email_html_table($tSubject; $tBodyTitle; $tBody; 450; $tRecepients)
End if 