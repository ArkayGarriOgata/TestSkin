//%attributes = {}
// -------
// Method: JMI_setCashFlow   ( ) ->
// By: Mel Bohince @ 09/16/16, 12:03:13
// Description
// sum up the expected dollars from 8 wks of releases that arent already covered
// and stuff it into the jmi record for items printed and not complete
// ----------------------------------------------------
READ WRITE:C146([Job_Forms_Items:44])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Finished_Goods:26])

C_DATE:C307($boundaryDate)
$boundaryDate:=Add to date:C393(4D_Current_date; 0; 0; (8*7))  //8 weeks
C_LONGINT:C283($jobit; $numJMI; $rel)

//only calc for jobs which have printed but are not complete
ARRAY TEXT:C222($aProduct; 0)
ARRAY LONGINT:C221($aWantQty; 0)
ARRAY TEXT:C222($aId; 0)

Begin SQL
	Select ProductCode, Qty_Want, pk_id
	from Job_Forms_Items
	where Qty_Actual = 0 and 
	JobForm in (SELECT JobForm from Job_Forms_Master_Schedule where Printed > '01/01/95' and DateComplete < '01/01/95') 
	ORDER BY ProductCode
	INTO :$aProduct, :$aWantQty, :$aId
End SQL

$numJMI:=Size of array:C274($aProduct)
//CREATE EMPTY SET([Job_Forms_Items];"changed")
utl_Logfile("JMI_setCashFlow"; String:C10($numJMI)+" jobits calculated")
uThermoInit($numElements; "Processing Array")
For ($jobit; 1; $numJMI)
	$cashFlow:=0  //what were're looking for
	
	//find open releases for next 8 wks not already covered
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$aProduct{$jobit}; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>1; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31#1; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$boundaryDate)
	
	//value the releases up to the qty wanted on the jobit
	$qty:=$aWantQty{$jobit}  //consume this qty
	
	For ($rel; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
		$price:=REL_getPrice
		Case of 
			: ($qty<=0)
				$j:=1+Records in selection:C76([Customers_ReleaseSchedules:46])  //break
				
			: ($qty>=[Customers_ReleaseSchedules:46]Sched_Qty:6)  //value all of the release
				$cashFlow:=$cashFlow+(([Customers_ReleaseSchedules:46]Sched_Qty:6/1000)*$price)
				$qty:=$qty-[Customers_ReleaseSchedules:46]Sched_Qty:6
				
			: ($qty<[Customers_ReleaseSchedules:46]Sched_Qty:6)  //value all of the production
				$cashFlow:=$cashFlow+(($qty/1000)*$price)
				$qty:=$qty-$qty
		End case 
		
		NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	End for   //each release
	
	//save it to the jmi record
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]pk_id:54=$aId{$jobit})
	[Job_Forms_Items:44]CashFlow:58:=Round:C94($cashFlow; 0)  //$aCashFlow{$jobit}
	SAVE RECORD:C53([Job_Forms_Items:44])
	//ADD TO SET([Job_Forms_Items];"changed")
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		
		UNLOAD RECORD:C212([Job_Forms_Items:44])
		
	Else 
		
		// you have REDUCE SELECTION([Job_Forms_Items];0) on line 85
		
	End if   // END 4D Professional Services : January 2019 
	
	uThermoUpdate($jobit)
End for   //each jobit
uThermoClose

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
//USE SET("changed")
//CLEAR SET("changed")


