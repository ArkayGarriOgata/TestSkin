//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/13/07, 14:31:44
// ----------------------------------------------------
// Method: trigger_BillOfLading()  --> 
// ----------------------------------------------------

C_LONGINT:C283($0; $err)

$err:=0
$msg:=""
//If ([Customers_Bills_of_Lading]WasPrinted)
//$msg:=" PRINTED "
//Else 
//$msg:=" PENDING "
//End if 
//
//If ([Customers_Bills_of_Lading]BOL_Executed)
//$msg:=$msg+" EXECUTED "
//Else 
//$msg:=$msg+""
//End if 
//
//If (Length($msg)>0)
//  `utl_Logfile ("shipping.log";(20*"="))
//utl_Logfile ("shipping.log";"BOL# "+String([Customers_Bills_of_Lading]ShippersNo)+"; trigger "+$msg)
//End if 

Case of 
	: (<>GNS_Doing_FillInSyncIDs)
		//skip trigger
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		
		$err:=BOL_ListBox1("stage-inventory")
		
		If ($err=0)
			$err:=BOL_ExecuteShipment
		End if 
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		
		$err:=BOL_ListBox1("stage-inventory")
		
		If ($err=0)
			$err:=BOL_ExecuteShipment
		End if 
		
End case 

$0:=$err