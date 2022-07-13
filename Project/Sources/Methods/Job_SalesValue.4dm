//%attributes = {"publishedWeb":true}
//job_salesValue 01/31/01
//base on   `PM:  JOB_SellingPrice()  102799  mlb
//find the selling price of jobitems 
//•110199  mlb  preserve the selection

C_TEXT:C284($1)
C_LONGINT:C283($numJMI; $i; $units)
C_REAL:C285($revenue)

READ ONLY:C145([Customers_Order_Lines:41])

MESSAGES OFF:C175

If (Count parameters:C259=1)  //else assume selection is there and in read rite
	READ WRITE:C146([Job_Forms_Items:44])
	qryJMI($1; 0; "@")
End if 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "jmiSellingPrice")  //•110199  mlb  preserve the selection
	
	
Else 
	
	
	ARRAY LONGINT:C221($_jmiSellingPrice; 0)
	LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Items:44]; $_jmiSellingPrice)
	
End if   // END 4D Professional Services : January 2019 
$numJMI:=Records in selection:C76([Job_Forms_Items:44])
uThermoInit($numJMI; "Finding selling price...")

ARRAY TEXT:C222($aOrderline; 0)
ARRAY TEXT:C222($aCustid; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY LONGINT:C221($aQtyWant; 0)
ARRAY REAL:C219($aSellingPrc; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; $aOrderline; [Job_Forms_Items:44]CustId:15; $aCustid; [Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]Qty_Want:24; $aQtyWant)
ARRAY REAL:C219($aSellingPrc; $numJMI)

$units:=0
$revenue:=0
For ($i; 1; $numJMI)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$aOrderline{$i})
	uThermoUpdate($i; 1)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		$aSellingPrc{$i}:=[Customers_Order_Lines:41]Price_Per_M:8
		$qty:=[Customers_Order_Lines:41]Quantity:6
		If ($qty>$aQtyWant{$i})
			$qty:=$aQtyWant{$i}
		End if 
		If ($aSellingPrc{$i}#0)
			$revenue:=$revenue+($aSellingPrc{$i}*($qty/1000))
		End if 
		//$units:=$units+$qty
		
	Else 
		If ($aOrderline{$i}#"Rerun")  //•082399  mlb 
			$numFound:=qryFinishedGood($aCustid{$i}; $aCPN{$i})  //•030599  MLB  UPR for len ron
			If ($numFound>0)
				$aSellingPrc{$i}:=[Finished_Goods:26]RKContractPrice:49
				If ($aSellingPrc{$i}#0)
					$revenue:=$revenue+($aSellingPrc{$i}*($aQtyWant{$i}/1000))
				End if 
				//$units:=$units+$aQtyWant{$i}
			Else 
				$aSellingPrc{$i}:=0
				//zwStatusMsg ("Allocating";" ITEM "+$aCPN{$i}+" HAS NO RELATED ORDER ITEM")
			End if 
			
		Else 
			$aSellingPrc{$i}:=0
			//$units:=$units+$aQtyWant{$i}
		End if 
	End if 
End for 

uThermoClose
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	USE NAMED SELECTION:C332("jmiSellingPrice")  //•110199  mlb  preserve the selection
	CLEAR NAMED SELECTION:C333("jmiSellingPrice")  //•110199  mlb  preserve the selection
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_jmiSellingPrice)
	
End if   // END 4D Professional Services : January 2019 

If ($revenue#0)
	$0:=Round:C94($revenue; 0)
Else 
	//BEEP
	$0:=0
	zwStatusMsg("Pricing"; "Can't calculate sales value at this time.")
End if 