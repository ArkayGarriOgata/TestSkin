//%attributes = {}
// Method: FG_getPromosWithExcess () -> 
// ----------------------------------------------------
// by: mel: 06/09/04, 11:10:07
// ----------------------------------------------------
// Description:
// need to find promos that have inventory yet finished shipping
// define demand as having neither open order OR release

C_LONGINT:C283($i; $numRecs; $numOrd; $numRel)
C_BOOLEAN:C305($break; $noDemand)

MESSAGES OFF:C175

READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers_Order_Lines:41])

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OrderType:59="Promotional"; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]InventoryNow:73>0)

$custids:=Request:C163("Enter CustId's separated by commas:"; "All"; "Search"; "All")
If (OK=1)
	$custids:=Replace string:C233($custids; " "; "")
	If (Length:C16($custids)>4)
		util_TextParser(1; $custids; Character code:C91(","); Character code:C91(","))
		QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]CustID:2=util_TextParser(1); *)
		For ($id; 2; Size of array:C274(aParseArray))
			QUERY SELECTION:C341([Finished_Goods:26];  | ; [Finished_Goods:26]CustID:2=util_TextParser($id); *)
		End for 
		QUERY SELECTION:C341([Finished_Goods:26])
	End if 
End if 

//CREATE SET([Finished_Goods];"promoWithInv")


If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	CREATE EMPTY SET:C140([Finished_Goods:26]; "promoNoDemand")
	
	$break:=False:C215
	$numRecs:=Records in selection:C76([Finished_Goods:26])
	
	uThermoInit($numRecs; "Analyzing Promo Items...")
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		$noDemand:=True:C214  //default: assume its excess
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1)
			$numOrd:=qryOpenOrdLines("-"; "*")
			
		Else 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
			$numOrd:=Records in selection:C76([Customers_Order_Lines:41])
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		If ($numOrd>0)
			$noDemand:=False:C215
			
		Else 
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
			$numRel:=Records in selection:C76([Customers_ReleaseSchedules:46])
			If ($numRel>0)
				$noDemand:=False:C215
			End if 
		End if 
		
		If ($noDemand)
			ADD TO SET:C119([Finished_Goods:26]; "promoNoDemand")
		End if 
		
		NEXT RECORD:C51([Finished_Goods:26])
		uThermoUpdate($i)
	End for 
	
	USE SET:C118("promoNoDemand")
	CLEAR SET:C117("promoNoDemand")
	
	
Else 
	//laghzaoui remove next and add and empty set
	
	$numRecs:=Records in selection:C76([Finished_Goods:26])
	
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY LONGINT:C221($_Record_Number; 0)
	ARRAY LONGINT:C221($_promoNoDemand; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods:26]ProductCode:1; $_ProductCode; [Finished_Goods:26]; $_Record_Number)
	
	uThermoInit($numRecs; "Analyzing Promo Items...")
	
	For ($i; 1; $numRecs)
		
		$noDemand:=True:C214  //default: assume its excess
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$_ProductCode{$i}; *)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
		$numOrd:=Records in selection:C76([Customers_Order_Lines:41])
		
		If ($numOrd>0)
			$noDemand:=False:C215
			
		Else 
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$_ProductCode{$i}; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
			$numRel:=Records in selection:C76([Customers_ReleaseSchedules:46])
			If ($numRel>0)
				$noDemand:=False:C215
			End if 
		End if 
		
		If ($noDemand)
			
			APPEND TO ARRAY:C911($_promoNoDemand; $_Record_Number{$i})
			
		End if 
		
		uThermoUpdate($i)
	End for 
	
	CREATE SELECTION FROM ARRAY:C640([Finished_Goods:26]; $_promoNoDemand)
	
End if   // END 4D Professional Services : January 2019 
uThermoClose

ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]LastShipDate:19; >)