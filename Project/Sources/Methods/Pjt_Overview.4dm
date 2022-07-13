//%attributes = {}
// -------
// Method: Pjt_Overview   ( ) ->
// By: Mel Bohince @ 03/13/17, 09:20:20
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($1; $pjtID)
C_BOOLEAN:C305($2; $detail)

utl_LogIt("init")

If (Count parameters:C259>0)
	$pjtID:=$1
	If (Count parameters:C259>1)
		$detail:=$2
	Else 
		$detail:=False:C215
	End if 
	utl_LogIt("PROJECT: "+$pjtId+" - "+pjtName+" for "+pjtCustName; 0)
	
Else 
	$pjtID:=Request:C163("Pjt Number?"; "03653")  //P&G's Maverick Project
	CONFIRM:C162("List details?"; "Summary"; "Details")
	If (ok=1)
		$detail:=False:C215
	Else 
		$detail:=True:C214
	End if 
	
	utl_LogIt("PROJECT: "+$pjtId)
End if 

$actMatlCost:=0
$materialCost:=0
$actMRHrs:=0
$actRunHrs:=0
$actTTLHrs:=0
$billings:=0
$inventory:=0
$openOrders:=0
$bookings:=0
//collect material costs
//  separate sub component issues so no double bump
Begin SQL
	select sum(ActExtCost) from Raw_Materials_Transactions where upper(Xfer_Type) = 'ISSUE' and CommodityCode <> 33 and JobForm in 
	(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
	into :$actMatlCost
End SQL
$materialCost:=Round:C94($actMatlCost*-1; 0)
utl_LogIt("Materials: "+String:C10($materialCost; "$ ###,###,##0"); 0)
//  now show sub components if any
Begin SQL
	select sum(ActExtCost) from Raw_Materials_Transactions where upper(Xfer_Type) = 'ISSUE' and CommodityCode = 33 and JobForm in 
	(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
	into :$actMatlCost
End SQL
$materialCost:=Round:C94($actMatlCost*-1; 0)
If ($materialCost>0)
	utl_LogIt("Components: "+String:C10($materialCost; "$ ###,###,##0"); 0)
End if 

//collect hours of machine time
Begin SQL
	select sum(MR_Act), sum(Run_Act) from Job_Forms_Machine_Tickets where JobForm in 
	(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
	into :$actMRHrs, :$actRunHrs
End SQL
$actTTLHrs:=Round:C94(($actMRHrs+$actRunHrs); 0)
utl_LogIt("Hours: "+String:C10($actTTLHrs; "###,###,##0"); 0)

//collect billings
Begin SQL
	select sum(ExtendedPrice) from Finished_Goods_Transactions where upper(XactionType) = 'SHIP' and JobForm in 
	(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
	into :$billings
End SQL
$billings:=Round:C94($billings; 0)
utl_LogIt("Billings: "+String:C10($billings; "$ ###,###,##0"); 0)

//collect bookings
Begin SQL
	select sum(Price_Extended) from Customers_Order_Lines where ProjectNumber = :$pjtID 
	into :$bookings
End SQL
$bookings:=Round:C94($bookings; 0)
utl_LogIt("Bookings: "+String:C10($bookings; "$ ###,###,##0"); 0)

//collect remaining inventory
Begin SQL
	select sum(QtyOH) from Finished_Goods_Locations where JobForm in 
	(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
	into :$inventory
End SQL
utl_LogIt("Inventory: "+String:C10($inventory; "###,###,##0"); 0)

//collect remaining open order bookings
Begin SQL
	select sum(Price_Extended) from Customers_Order_Lines where Qty_Open > 0 and ProjectNumber = :$pjtID
	into :$openOrders
End SQL
$openOrders:=Round:C94($openOrders; 0)
utl_LogIt("Open Orders: "+String:C10($openOrders; "$ ###,###,##0"); 0)

//list details if requested
If ($detail)
	
	utl_LogIt("\rCommodity Usage:  ")
	ARRAY TEXT:C222($aCommodity; 0)
	ARRAY REAL:C219($aIssues; 0)
	Begin SQL
		select Commodity_Key, sum(ActExtCost) from Raw_Materials_Transactions where upper(Xfer_Type) = 'ISSUE' and JobForm in 
		(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
		GROUP BY Commodity_Key ORDER BY Commodity_Key
		into :$aCommodity, :$aIssues
	End SQL
	For ($i; 1; Size of array:C274($aCommodity))
		utl_LogIt($aCommodity{$i}+" "+String:C10(($aIssues{$i}*-1); "$ ###,###,##0"); 0)
	End for 
	
	//test forSubcomponents
	ARRAY TEXT:C222($aSubComponent; 0)
	ARRAY REAL:C219($aQtyAct; 0)
	
	Begin SQL
		select Raw_Matl_Code, sum(Actual_Qty) from Job_Forms_Materials where Commodity_Key like '33%' and JobForm in 
		(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
		GROUP BY Raw_Matl_Code ORDER BY Raw_Matl_Code
		into :$aSubComponent, :$aQtyAct
	End SQL
	
	If (Size of array:C274($aSubComponent)>0)
		utl_LogIt("\rSubcomponents:  ")
		For ($i; 1; Size of array:C274($aSubComponent))
			utl_LogIt($aSubComponent{$i}+" "+String:C10($aQtyAct{$i}; "###,###,##0"); 0)
		End for 
	End if 
	
	
	utl_LogIt("\rMachine hours distribution:  ")
	ARRAY TEXT:C222($aCCs; 0)
	ARRAY REAL:C219($aHrs; 0)
	Begin SQL
		select CostCenterID, sum(MR_Act+Run_Act) from Job_Forms_Machine_Tickets where JobForm in 
		(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
		GROUP BY CostCenterID ORDER BY CostCenterID
		into :$aCCs, :$aHrs
	End SQL
	For ($i; 1; Size of array:C274($aCCs))
		utl_LogIt($aCCs{$i}+" "+String:C10($aHrs{$i}); 0)
	End for 
	
	utl_LogIt("\rItems produced:  ")
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY LONGINT:C221($aProduced; 0)
	Begin SQL
		select ProductCode, sum(Qty_Actual) from Job_Forms_Items where JobForm in 
		(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
		GROUP BY ProductCode ORDER BY ProductCode
		into :$aCPN, :$aProduced
	End SQL
	For ($i; 1; Size of array:C274($aCPN))
		utl_LogIt($aCPN{$i}+" "+String:C10($aProduced{$i}; "###,###,###"); 0)
	End for 
	
	utl_LogIt("\rJobs:  ")
	ARRAY TEXT:C222($aJobs; 0)
	ARRAY TEXT:C222($aType; 0)
	ARRAY TEXT:C222($aStatus; 0)
	ARRAY TEXT:C222($aSpec; 0)
	ARRAY TEXT:C222($aLine; 0)
	
	Begin SQL
		select JobFormID, JobType, Status, ProcessSpec, CustomerLine from Job_Forms where ProjectNumber = :$pjtID 
		order BY JobFormID
		into :$aJobs, :$aType, :$aStatus, :$aSpec, :$aLine
	End SQL
	For ($i; 1; Size of array:C274($aJobs))
		utl_LogIt($aJobs{$i}+" "+$aType{$i}+" "+$aStatus{$i}+" "+$aSpec{$i}+" "+$aLine{$i})
	End for 
	
	utl_LogIt("\rBookings:  ")
	ARRAY TEXT:C222($aOL; 0)
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY REAL:C219($aBooked; 0)
	Begin SQL
		select ProductCode, sum(Price_Extended) from Customers_Order_Lines where ProjectNumber = :$pjtID 
		GROUP BY ProductCode ORDER BY ProductCode
		into :$aCPN, :$aBooked
	End SQL
	
	For ($i; 1; Size of array:C274($aCPN))
		$bookings:=Round:C94($aBooked{$i}; 0)
		utl_LogIt($aCPN{$i}+" "+String:C10($bookings; "$ ###,###,###"); 0)
	End for 
	
	utl_LogIt("\rShipments:  ")
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY TEXT:C222($aOL; 0)
	ARRAY REAL:C219($aQtyAct; 0)
	ARRAY REAL:C219($aBooked; 0)
	Begin SQL
		select ProductCode, OrderItem, Qty, ExtendedPrice from Finished_Goods_Transactions where upper(XactionType) = 'SHIP' and JobForm in 
		(select JobFormID from Job_Forms where ProjectNumber = :$pjtID ) 
		ORDER BY ProductCode, OrderItem
		into :$aCPN, :$aOL, :$aQtyAct, :$aBooked
	End SQL
	For ($i; 1; Size of array:C274($aCPN))
		utl_LogIt($aCPN{$i}+" "+$aOL{$i}+" "+String:C10($aQtyAct{$i}; "###,###,###")+"    "+String:C10($aBooked{$i}; "$ ###,###,###"))
	End for 
	
End if   //details


utl_LogIt("show")

utl_LogIt("init")