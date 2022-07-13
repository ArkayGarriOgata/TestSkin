//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/13/07, 15:57:32
// ----------------------------------------------------
// Method: BOL_PutAwayInventory(aRecNo2{ListBox1};$stageBin;aTotalPicked2{ListBox1})  --> 
// Description
// if something is removed from bol or the bol is voided 
//  then the inventory needs to be returned
// ----------------------------------------------------
//mlb 6/8/12 add palletid
// Modified by: Mel Bohince (5/6/16) send email when there is a 'fail' -- EMAIL_Sender ("Check Shipping.log";"";"failure recorded by BOL_PutAwayInventory line 141";"";"";"";"mel.bohince@arkay.com")
// ----------------------------------------------------

C_TEXT:C284($1; $2; $location; $jobit; $pallet; $3)
C_LONGINT:C283($numFGL; $err; $0)

$location:=$1
$jobit:=$2
$pallet:=$3
$err:=0
If ($jobit#"T.B.D.")
	READ WRITE:C146([Finished_Goods_Locations:35])
	$numFGL:=FGL_qryBin($jobit; $location; $pallet)
	If ($numFGL>0)
		If (fLockNLoad(->[Finished_Goods_Locations:35]))
			utl_LogfileServer(<>zResp; "PutAway jobit:"+$jobit+" in location: "+$location+" success, bol#"+String:C10([Finished_Goods_Locations:35]BOL_Pending:31); "shipping.log")
			[Finished_Goods_Locations:35]BOL_Pending:31:=0
			SAVE RECORD:C53([Finished_Goods_Locations:35])
			
		Else 
			$err:=TriggerMessage_Set(-30000-Table:C252(->[Finished_Goods_Locations:35]); "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+" locked bin "+$location+" couldn't remove pending#")
			utl_LogfileServer(<>zResp; "shipping.log"; "PutAway jobit:"+$jobit+" in location: "+$location+" failed, record locked, bol#"+String:C10([Finished_Goods_Locations:35]BOL_Pending:31); "shipping.log")
			EMAIL_Sender("Check Shipping.log"; ""; "failure recorded by BOL_PutAwayInventory line 31"; ""; ""; ""; "mel.bohince@arkay.com")
		End if 
		
	Else 
		//commented out the error so bol's can be voided, anyway, the inventory is not where it was so the pending flag would be gone
		//$err:=TriggerMessage_Set (-30000-Table(->[Finished_Goods_Locations]);"BOL# "+String([Customers_Bills_of_Lading]ShippersNo)+" missing bin "+$location+" couldn't remove pending#")
		utl_LogfileServer(<>zResp; "PutAway jobit:"+$jobit+" in location: "+$location+" failed, record not found"; "shipping.log")
		EMAIL_Sender("Check Shipping.log"; ""; "failure recorded by BOL_PutAwayInventory line 38"; ""; ""; ""; "mel.bohince@arkay.com")
	End if 
	
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	READ ONLY:C145([Finished_Goods_Locations:35])
	
Else 
	utl_LogfileServer(<>zResp; "PutAway jobit:"+$jobit; "shipping.log")
End if 
$0:=$err