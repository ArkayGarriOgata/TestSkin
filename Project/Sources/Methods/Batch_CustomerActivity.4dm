//%attributes = {"publishedWeb":true}
//PM:  Batch_CustomerActivity  092999  mlb
//•092999  mlb  UPR rewrite for simplicity and consider orders and jobits
//was `(p) PurgeCustACtive 6/17/97 cs created
//mark customer(s) active -> inactive if no estimate since date
//and
//mark customer(s) inactive -> active if estimate since date

C_LONGINT:C283($i)
C_DATE:C307($cutOffDate; $1)

If (Count parameters:C259=1)
	$cutOffDate:=$1
Else 
	$cutOffDate:=Add to date:C393(4D_Current_date; 0; -6; 0)  //six months
End if 

MESSAGES OFF:C175
READ WRITE:C146([Customers:16])
//*If they have inventory, they are still active
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	uRelateSelect(->[Customers:16]ID:1; ->[Finished_Goods_Locations:35]CustID:16; 0)
	
Else 
	
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Customers:16])
	
	
End if   // END 4D Professional Services : January 2019 query selection
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)

CREATE SET:C116([Customers:16]; "haveInv")

ARRAY BOOLEAN:C223($aActive; Records in selection:C76([Customers:16]))
For ($i; 1; Size of array:C274($aActive))
	$aActive{$i}:=True:C214
End for 
ARRAY TO SELECTION:C261($aActive; [Customers:16]Active:15)
ARRAY BOOLEAN:C223($aActive; 0)

ALL RECORDS:C47([Customers:16])
CREATE SET:C116([Customers:16]; "allCusts")
DIFFERENCE:C122("allCusts"; "haveInv"; "allCusts")
USE SET:C118("allCusts")
CLEAR SET:C117("allCusts")
CLEAR SET:C117("haveInv")

ARRAY TEXT:C222($aCustid; 0)
SELECTION TO ARRAY:C260([Customers:16]ID:1; $aCustid)
ARRAY BOOLEAN:C223($aActive; Records in selection:C76([Customers:16]))
//TRACE
//$numFound:=0
//SET QUERY DESTINATION(Into variable;$numFound)
SET QUERY LIMIT:C395(1)
uThermoInit(Size of array:C274($aActive); "Checking for customers' activity")
For ($i; 1; Size of array:C274($aActive))
	$aActive{$i}:=False:C215  // assume they are not active
	
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]DateOpened:6>$cutOffDate; *)
	QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]CustID:2=$aCustid{$i})
	If (Records in selection:C76([Customers_Orders:40])>0)
		$aActive{$i}:=True:C214
	Else 
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33>$cutOffDate; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]CustId:15=$aCustid{$i})
		If (Records in selection:C76([Job_Forms_Items:44])>0)
			$aActive{$i}:=True:C214
		Else 
			
			QUERY:C277([Estimates:17]; [Estimates:17]DateOriginated:19>$cutOffDate; *)
			QUERY:C277([Estimates:17];  & ; [Estimates:17]Cust_ID:2=$aCustid{$i})
			If (Records in selection:C76([Estimates:17])>0)
				$aActive{$i}:=True:C214
			End if 
		End if 
	End if 
	uThermoUpdate($i)
End for 
//SET QUERY DESTINATION(Into current selection)
SET QUERY LIMIT:C395(0)

ARRAY TO SELECTION:C261($aActive; [Customers:16]Active:15)
uThermoClose
REDUCE SELECTION:C351([Customers:16]; 0)

Batch_CustomerFinancialStatus