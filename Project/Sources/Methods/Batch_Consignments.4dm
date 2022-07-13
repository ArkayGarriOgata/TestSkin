//%attributes = {"publishedWeb":true}
//Batch_Consignments 062900 mlb

READ ONLY:C145([Finished_Goods_Transactions:33])
READ ONLY:C145([Customers_BilledPayUse:86])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Job_Forms_Items:44])

If (Count parameters:C259>0)
	$date:=$1
Else 
	$date:=4D_Current_date  //yesterday
	//$date:=!05/18/00!  `for testing
End if 
$rundate:=$date
C_TEXT:C284(xText; xTitle; $line; $blank)
$blank:=(62*" ")
xText:=""
xTitle:="Consignment Status "+String:C10($date; System date short:K1:1)

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:AV@")  //get the current consignment bins
ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16; >)
$numLoc:=Records in selection:C76([Finished_Goods_Locations:35])
uThermoInit($numLoc; "Tally Consignment Bins")
$currentCust:=[Finished_Goods_Locations:35]CustID:16
$units:=0
$rev:=0
$cost:=0
$age:=0

$unitsT:=0
$revT:=0
$costT:=0
$ageT:=0
xText:="CONSIGNMENT INVENTORIES"+Char:C90(13)
xText:=xText+"CUSTOMER                  "+"        UNITS"+"     BILLINGS"+"     COST@STD"+"  AVG-CARTON-DAYS"+Char:C90(13)
xText:=xText+"___________________________"+"  __________ "+"  __________ "+"  __________ "+" _______________"+Char:C90(13)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($location; 1; $numLoc)
		If ($currentCust#[Finished_Goods_Locations:35]CustID:16)
			//print results
			$age:=$age/$units  //ave days
			qryCustomer(->[Customers:16]ID:1; $currentCust)
			$cust:=27*" "
			$cust:=Change string:C234($cust; Substring:C12([Customers:16]Name:2; 1; 27); 1)
			xText:=xText+$cust+" "+String:C10($units; "^^^,^^^,^^^  ")+String:C10($rev; "$^^,^^^,^^^  ")+String:C10($cost; "$^^,^^^,^^^  ")+String:C10($age; "^^^,^^^,^^^,^^^")+Char:C90(13)
			//TOTALS
			$unitsT:=$unitsT+$units
			$revT:=$revT+$rev
			$costT:=$costT+$cost
			$ageT:=$ageT+$age
			
			//reset
			$currentCust:=[Finished_Goods_Locations:35]CustID:16
			$units:=0
			$rev:=0
			$cost:=0
			$age:=0
		End if 
		$units:=$units+[Finished_Goods_Locations:35]QtyOH:9
		$age:=$age+([Finished_Goods_Locations:35]QtyOH:9*($date-[Finished_Goods_Locations:35]OrigDate:27))  //carton*days
		
		$numJMI:=qryJMI([Finished_Goods_Locations:35]Jobit:33)
		If ($numJMI>0)
			$cost:=$cost+([Finished_Goods_Locations:35]QtyOH:9/1000*[Job_Forms_Items:44]PldCostTotal:21)
		End if 
		
		$po:=Substring:C12([Finished_Goods_Locations:35]Location:2; (Position:C15("#"; [Finished_Goods_Locations:35]Location:2)+1))
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods_Locations:35]ProductCode:1; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]PONumber:21=($po+"@"))
		
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			$rev:=$rev+([Finished_Goods_Locations:35]QtyOH:9/1000*[Customers_Order_Lines:41]Price_Per_M:8)
		End if 
		
		NEXT RECORD:C51([Finished_Goods_Locations:35])
		
		uThermoUpdate($location)
	End for 
	
Else 
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]CustID:16; $_CustID; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH; [Finished_Goods_Locations:35]OrigDate:27; $_OrigDate; [Finished_Goods_Locations:35]Jobit:33; $_Jobit; [Finished_Goods_Locations:35]Location:2; $_Location; [Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
	
	For ($location; 1; $numLoc; 1)
		If ($currentCust#$_CustID{$location})
			$age:=$age/$units  //ave days
			qryCustomer(->[Customers:16]ID:1; $currentCust)
			$cust:=27*" "
			$cust:=Change string:C234($cust; Substring:C12([Customers:16]Name:2; 1; 27); 1)
			xText:=xText+$cust+" "+String:C10($units; "^^^,^^^,^^^  ")+String:C10($rev; "$^^,^^^,^^^  ")+String:C10($cost; "$^^,^^^,^^^  ")+String:C10($age; "^^^,^^^,^^^,^^^")+Char:C90(13)
			$unitsT:=$unitsT+$units
			$revT:=$revT+$rev
			$costT:=$costT+$cost
			$ageT:=$ageT+$age
			$currentCust:=$_CustID{$location}
			$units:=0
			$rev:=0
			$cost:=0
			$age:=0
		End if 
		$units:=$units+$_QtyOH{$location}
		$age:=$age+($_QtyOH{$location}*($date-$_OrigDate{$location}))  //carton*days
		
		$numJMI:=qryJMI($_Jobit{$location})
		If ($numJMI>0)
			$cost:=$cost+($_QtyOH{$location}/1000*[Job_Forms_Items:44]PldCostTotal:21)
		End if 
		
		$po:=Substring:C12($_Location{$location}; (Position:C15("#"; $_Location{$location})+1))
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$_ProductCode{$location}; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]PONumber:21=($po+"@"))
		
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			$rev:=$rev+($_QtyOH{$location}/1000*[Customers_Order_Lines:41]Price_Per_M:8)
		End if 
		
		uThermoUpdate($location)
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

$age:=$age/$units  //ave days
qryCustomer(->[Customers:16]ID:1; $currentCust)
$cust:=27*" "
$cust:=Change string:C234($cust; Substring:C12([Customers:16]Name:2; 1; 27); 1)
xText:=xText+$cust+" "+String:C10($units; "^^^,^^^,^^^  ")+String:C10($rev; "$^^,^^^,^^^  ")+String:C10($cost; "$^^,^^^,^^^  ")+String:C10($age; "^^^,^^^,^^^,^^^")+Char:C90(13)
//TOTALS
$unitsT:=$unitsT+$units
$revT:=$revT+$rev
$costT:=$costT+$cost
$ageT:=$ageT+$age

xText:=xText+"___________________________"+"  __________ "+"  __________ "+"  __________ "+" _______________"+Char:C90(13)
$cust:=27*" "
$cust:=Change string:C234($cust; "TOTALS"; 1)
xText:=xText+$cust+" "+String:C10($unitsT; "^^^,^^^,^^^  ")+String:C10($revT; "$^^,^^^,^^^  ")+String:C10($costT; "$^^,^^^,^^^  ")+String:C10($ageT; "^^^,^^^,^^^,^^^")+Char:C90(13)

uThermoClose

//*Get the billings
If (Day number:C114($date)=2)  //monday, do friday and weekend
	$date:=$date-3
	//xTitle:=xTitle+String($date;◊MIDDATE)+", plus the weekend"
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=$date; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<($date+3); *)
Else 
	$date:=$date-1  //do yesterday 
	//xTitle:=xTitle+String($date;◊MIDDATE)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=$date; *)
End if 
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11="FG:AV@")
ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12; >)
xText:=xText+Char:C90(13)+Char:C90(13)+"CONSIGNMENT BILLINGS ON "+String:C10($date; System date short:K1:1)+Char:C90(13)
$numLoc:=Records in selection:C76([Finished_Goods_Transactions:33])
uThermoInit($numLoc; "Tally Consignment Billings")
$currentCust:=[Finished_Goods_Transactions:33]CustID:12
$units:=0
$rev:=0
$cost:=0

$unitsT:=0
$revT:=0
$costT:=0
xText:=xText+"CUSTOMER                  "+"        UNITS"+"     BILLINGS"+"     COST@STD"+Char:C90(13)
xText:=xText+"___________________________"+"  __________ "+"  __________ "+"  __________ "+Char:C90(13)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($location; 1; $numLoc)
		If ($currentCust#[Finished_Goods_Transactions:33]CustID:12)
			//print results
			qryCustomer(->[Customers:16]ID:1; $currentCust)
			$cust:=27*" "
			$cust:=Change string:C234($cust; Substring:C12([Customers:16]Name:2; 1; 27); 1)
			xText:=xText+$cust+" "+String:C10($units; "^^^,^^^,^^^  ")+String:C10($rev; "$^^,^^^,^^^  ")+String:C10($cost; "$^^,^^^,^^^  ")+Char:C90(13)
			//TOTALS
			$unitsT:=$unitsT+$units
			$revT:=$revT+$rev
			$costT:=$costT+$cost
			
			//reset
			$currentCust:=[Finished_Goods_Transactions:33]CustID:12
			$units:=0
			$rev:=0
			$cost:=0
		End if 
		$units:=$units+[Finished_Goods_Transactions:33]Qty:6
		
		$cost:=$cost+[Finished_Goods_Transactions:33]CoGSExtended:8
		
		$rev:=$rev+[Finished_Goods_Transactions:33]ExtendedPrice:20
		
		NEXT RECORD:C51([Finished_Goods_Transactions:33])
		
		uThermoUpdate($location)
	End for 
	
	
Else 
	
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]CustID:12; $_CustID; [Finished_Goods_Transactions:33]Qty:6; $_Qty; [Finished_Goods_Transactions:33]CoGSExtended:8; $_CoGSExtended; [Finished_Goods_Transactions:33]ExtendedPrice:20; $_ExtendedPrice)
	
	For ($location; 1; $numLoc; 1)
		If ($currentCust#$_CustID{$location})
			
			qryCustomer(->[Customers:16]ID:1; $currentCust)
			$cust:=27*" "
			$cust:=Change string:C234($cust; Substring:C12([Customers:16]Name:2; 1; 27); 1)
			xText:=xText+$cust+" "+String:C10($units; "^^^,^^^,^^^  ")+String:C10($rev; "$^^,^^^,^^^  ")+String:C10($cost; "$^^,^^^,^^^  ")+Char:C90(13)
			$unitsT:=$unitsT+$units
			$revT:=$revT+$rev
			$costT:=$costT+$cost
			$currentCust:=$_CustID{$location}
			$units:=0
			$rev:=0
			$cost:=0
			
		End if 
		$units:=$units+$_Qty{$location}
		
		$cost:=$cost+$_CoGSExtended{$location}
		
		$rev:=$rev+$_ExtendedPrice{$location}
		
		uThermoUpdate($location)
		
	End for 
	
	
End if   // END 4D Professional Services : January 2019 First record

qryCustomer(->[Customers:16]ID:1; $currentCust)
$cust:=27*" "
$cust:=Change string:C234($cust; Substring:C12([Customers:16]Name:2; 1; 27); 1)
xText:=xText+$cust+" "+String:C10($units; "^^^,^^^,^^^  ")+String:C10($rev; "$^^,^^^,^^^  ")+String:C10($cost; "$^^,^^^,^^^  ")+Char:C90(13)
//TOTALS
$unitsT:=$unitsT+$units
$revT:=$revT+$rev
$costT:=$costT+$cost

xText:=xText+"___________________________"+"  __________ "+"  __________ "+"  __________ "+Char:C90(13)
$cust:=27*" "
$cust:=Change string:C234($cust; "TOTALS"; 1)
xText:=xText+$cust+" "+String:C10($unitsT; "^^^,^^^,^^^  ")+String:C10($revT; "$^^,^^^,^^^  ")+String:C10($costT; "$^^,^^^,^^^  ")+Char:C90(13)

uThermoClose

//*Get the moves
$date:=$rundate
If (Day number:C114($date)=2)  //monday, do friday and weekend
	$date:=$date-3
	//xTitle:=xTitle+String($date;◊MIDDATE)+", plus the weekend"
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=$date; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<($date+3); *)
Else 
	$date:=$date-1  //do yesterday 
	//xTitle:=xTitle+String($date;◊MIDDATE)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=$date; *)
End if 
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Move"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="FG:AV@")
ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12; >)
xText:=xText+Char:C90(13)+Char:C90(13)+"CONSIGNMENT MOVES ON "+String:C10($date; System date short:K1:1)+Char:C90(13)
$numLoc:=Records in selection:C76([Finished_Goods_Transactions:33])
uThermoInit($numLoc; "Tally Consignment Moves")
$currentCust:=[Finished_Goods_Transactions:33]CustID:12
$units:=0
$rev:=0
$cost:=0

$unitsT:=0
$revT:=0
$costT:=0
xText:=xText+"CUSTOMER                  "+"        UNITS"+"     BILLINGS"+"     COST@STD"+Char:C90(13)
xText:=xText+"___________________________"+"  __________ "+"  __________ "+"  __________ "+Char:C90(13)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($location; 1; $numLoc)
		If ($currentCust#[Finished_Goods_Transactions:33]CustID:12)
			//print results
			qryCustomer(->[Customers:16]ID:1; $currentCust)
			$cust:=27*" "
			$cust:=Change string:C234($cust; Substring:C12([Customers:16]Name:2; 1; 27); 1)
			xText:=xText+$cust+" "+String:C10($units; "^^^,^^^,^^^  ")+String:C10($rev; "$^^,^^^,^^^  ")+String:C10($cost; "$^^,^^^,^^^  ")+Char:C90(13)
			//TOTALS
			$unitsT:=$unitsT+$units
			$revT:=$revT+$rev
			$costT:=$costT+$cost
			
			//reset
			$currentCust:=[Finished_Goods_Transactions:33]CustID:12
			$units:=0
			$rev:=0
			$cost:=0
		End if 
		$units:=$units+[Finished_Goods_Transactions:33]Qty:6
		
		$cost:=$cost+[Finished_Goods_Transactions:33]CoGSExtended:8
		
		$rev:=$rev+[Finished_Goods_Transactions:33]ExtendedPrice:20
		
		NEXT RECORD:C51([Finished_Goods_Transactions:33])
		
		uThermoUpdate($location)
	End for 
	
Else 
	
	
	ARRAY TEXT:C222($_CustID; 0)
	ARRAY LONGINT:C221($_Qty; 0)
	ARRAY REAL:C219($_CoGSExtended; 0)
	ARRAY REAL:C219($_ExtendedPrice; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]CustID:12; $_CustID; [Finished_Goods_Transactions:33]Qty:6; $_Qty; [Finished_Goods_Transactions:33]CoGSExtended:8; $_CoGSExtended; [Finished_Goods_Transactions:33]ExtendedPrice:20; $_ExtendedPrice)
	
	For ($location; 1; $numLoc; 1)
		If ($currentCust#$_CustID{$location})
			
			qryCustomer(->[Customers:16]ID:1; $currentCust)
			$cust:=27*" "
			$cust:=Change string:C234($cust; Substring:C12([Customers:16]Name:2; 1; 27); 1)
			xText:=xText+$cust+" "+String:C10($units; "^^^,^^^,^^^  ")+String:C10($rev; "$^^,^^^,^^^  ")+String:C10($cost; "$^^,^^^,^^^  ")+Char:C90(13)
			$unitsT:=$unitsT+$units
			$revT:=$revT+$rev
			$costT:=$costT+$cost
			$currentCust:=$_CustID{$location}
			$units:=0
			$rev:=0
			$cost:=0
		End if 
		$units:=$units+$_Qty{$location}
		
		$cost:=$cost+$_CoGSExtended{$location}
		
		$rev:=$rev+$_ExtendedPrice{$location}
		
		uThermoUpdate($location)
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

qryCustomer(->[Customers:16]ID:1; $currentCust)
$cust:=27*" "
$cust:=Change string:C234($cust; Substring:C12([Customers:16]Name:2; 1; 27); 1)
xText:=xText+$cust+" "+String:C10($units; "^^^,^^^,^^^  ")+String:C10($rev; "$^^,^^^,^^^  ")+String:C10($cost; "$^^,^^^,^^^  ")+Char:C90(13)
//TOTALS
$unitsT:=$unitsT+$units
$revT:=$revT+$rev
$costT:=$costT+$cost

xText:=xText+"___________________________"+"  __________ "+"  __________ "+"  __________ "+Char:C90(13)
$cust:=27*" "
$cust:=Change string:C234($cust; "TOTALS"; 1)
xText:=xText+$cust+" "+String:C10($unitsT; "^^^,^^^,^^^  ")+String:C10($revT; "$^^,^^^,^^^  ")+String:C10($costT; "$^^,^^^,^^^  ")+Char:C90(13)

uThermoClose

//*Email the results
QM_Sender(xTitle; ""; xText; distributionList)
//rPrintText ("ConsignmentStatus"+fYYMMDD ($date)+"_"+Replace 
//«string(String(4d_Current_time;◊HHMM);":";""))
xText:=""
xTitle:=""