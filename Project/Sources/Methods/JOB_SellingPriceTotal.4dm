//%attributes = {}
//PM:  JOB_SellingPriceTotal 08202013  mlb
//find the selling price of jobitems and return the total, dig deep as necessary

C_TEXT:C284($1)
C_LONGINT:C283($numJMI; $i; $units)
C_REAL:C285($revenue)

READ ONLY:C145([Customers_Order_Lines:41])

COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "jmiSellingPrice")  //•110199  mlb  preserve the selection
If (Count parameters:C259=1)  //else assume selection is there and in read rite
	READ WRITE:C146([Job_Forms_Items:44])
	qryJMI($1; 0; "@")
End if 
$jobform:=[Job_Forms_Items:44]JobForm:1

$numJMI:=Records in selection:C76([Job_Forms_Items:44])
//utl_Logfile ("AutoInk.log";"   "+$jobform+String($numJMI)+" items")
//uThermoInit ($numJMI;"Finding selling price...")

ARRAY TEXT:C222($aOrderline; 0)
ARRAY TEXT:C222($aCustid; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY LONGINT:C221($aQtyWant; 0)
ARRAY REAL:C219($aSellingPrc; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; $aOrderline; [Job_Forms_Items:44]CustId:15; $aCustid; [Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]Qty_Want:24; $aQtyWant)
ARRAY REAL:C219($aSellingPrc; $numJMI)

$revenue:=0
For ($i; 1; $numJMI)
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$aOrderline{$i})
	//uThermoUpdate ($i;1)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)  //pegged orderline
		$aSellingPrc{$i}:=[Customers_Order_Lines:41]Price_Per_M:8
		//utl_Logfile ("AutoInk.log";"   "+$jobform+String($numJMI)+" ("+String($i)+") via orderline "+string($aSellingPrc{$i}))
		
	Else   //try for contract price
		$numFound:=qryFinishedGood($aCustid{$i}; $aCPN{$i})  //•030599  MLB  UPR for len ron
		If ($numFound>0)
			$aSellingPrc{$i}:=[Finished_Goods:26]RKContractPrice:49
			//utl_Logfile ("AutoInk.log";"   "+$jobform+String($numJMI)+" ("+String($i)+") via contract price "+string($aSellingPrc{$i}))
			
		Else   //get latest orderline
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$aCPN{$i})
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13; <)
				$aSellingPrc{$i}:=[Customers_Order_Lines:41]Price_Per_M:8
				//utl_Logfile ("AutoInk.log";"   "+$jobform+String($numJMI)+" ("+String($i)+") via lastest orderline "+string($aSellingPrc{$i}))
				
			Else 
				$aSellingPrc{$i}:=0
				utl_Logfile("AutoInk.log"; "   "+$jobform+String:C10($numJMI)+" ("+String:C10($i)+") no pricing info "+String:C10($aSellingPrc{$i}))
			End if 
		End if 
	End if 
	
	If ($aSellingPrc{$i}#0) & ($aQtyWant{$i}#0)
		$revenue:=$revenue+($aSellingPrc{$i}*($aQtyWant{$i}/1000))
	End if 
End for 

USE NAMED SELECTION:C332("jmiSellingPrice")

$0:=uNANCheck($revenue)