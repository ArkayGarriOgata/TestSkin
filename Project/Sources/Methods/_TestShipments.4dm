//%attributes = {}
// _______
// Method: _TestShipments   ( ) ->
// By: Mel Bohince @ 04/20/21, 14:03:25
// Description
// look for missing records
// ----------------------------------------------------
C_OBJECT:C1216($counter; $rel_es; $e; $xact_es)

C_BOOLEAN:C305($repair)
CONFIRM:C162("Which?"; "Verify"; "Repair")
$repair:=(ok=0)

$start:=Date:C102(Request:C163("start date"; "01/01/2018"))
$end:=Date:C102(Request:C163("end date"; String:C10(Current date:C33; Internal date short special:K1:4)))

//[Customers_ReleaseSchedules]Actual_Date
$rel_es:=ds:C1482.Customers_ReleaseSchedules.query("Actual_Date >= :1 and Actual_Date <= :2 and Actual_Qty  > 0"; $start; $end).orderBy("Actual_Date")
//utl_LogIt ("init")
utl_Logfile("missing-x.log"; "######## START ###########")

$counter:=New object:C1471
//("2018i";0;"2019i";0;"2020i";0;"2021i";0;"2018b";0;"2019b";0;"2020b";0;"2021b";0;"2018x";0;"2019x";0;"2020x";0;"2021x";0)

C_LONGINT:C283($outerBar; $outerLoop; $out)
$out:=0
$outerLoop:=$rel_es.length
$outerBar:=Progress New  //new progress bar
Progress SET TITLE($outerBar; "Processing Releases...")  //optional init of the thermoeters title
Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button, see $continueInteration

For each ($e; $rel_es)
	//If ($e.ReleaseNumber=4770623)
	//TRACE
	//End if 
	$out:=$out+1  //update a counter
	Progress SET PROGRESS($outerBar; $out/$outerLoop)  //update the thermometer
	Progress SET MESSAGE($outerBar; String:C10($out; "^^^^^")+" of "\
		+String:C10($outerLoop; "^^^^^")+" @ "+String:C10(100*$out/$outerLoop; "###%"))  //optional verbose status
	
	$continueInteration:=(Not:C34(Progress Stopped($outerBar)))  //test if cancel button clicked
	If ($continueInteration)
		$year_s:=String:C10(Year of:C25($e.Actual_Date))
		If (Not:C34(OB Is defined:C1231($counter; $year_s+"i")))
			$counter[$year_s+"b"]:=0
			$counter[$year_s+"i"]:=0
			$counter[$year_s+"x"]:=0
		End if 
		//test for invoice
		If ($e.INVOICES.length=0)
			If ($e.InvoiceNumber#-3)
				//utl_LogIt ("Invoice "+String($e.InvoiceNumber)+" is missing"+" for "+String($e.ReleaseNumber)+" on "+String($e.Actual_Date))
				$counter[$year_s+"i"]:=$counter[$year_s+"i"]+1
			End if 
		End if 
		
		//test for bol
		If ($e.BOL=Null:C1517)
			//utl_LogIt ("BOL "+String($e.B_O_L_number)+" is missing"+" for "+String($e.ReleaseNumber)+" on "+String($e.Actual_Date))
			$counter[$year_s+"b"]:=$counter[$year_s+"b"]+1
		End if 
		
		//test for xactions
		$fgxOrderItem:=$e.OrderLine+"/"+String:C10($e.ReleaseNumber)
		$xact_es:=ds:C1482.Finished_Goods_Transactions.query("ProductCode = :1 and XactionDate = :2 and XactionType = :3 and OrderItem = :4"; $e.ProductCode; $e.Actual_Date; "ship"; $fgxOrderItem)
		If ($xact_es.length=0)
			//utl_LogIt ("Transactions are missing"+" for "+String($e.ReleaseNumber)+" on "+String($e.Actual_Date))
			$counter[$year_s+"x"]:=$counter[$year_s+"x"]+1
			
			If ($repair)
				FGX_backFillShipment($e)
			End if 
		End if 
		
	End if   //continue
	
End for each 
Progress QUIT($outerBar)  //remove the thermometer

BEEP:C151


//show counters
ARRAY TEXT:C222($_counterProps; 0)
OB GET PROPERTY NAMES:C1232($counter; $_counterProps)
SORT ARRAY:C229($_counterProps; >)
utl_Logfile("missing-x.log"; "$$$$$$$$ SUMMARY $$$$$$$$$")
For ($i; 1; Size of array:C274($_counterProps))
	utl_Logfile("missing-x.log"; $_counterProps{$i}+": "+String:C10($counter[$_counterProps{$i}]; "##,##0"))
	//utl_LogIt ($_counterProps{$i}+": "+String($counter[$_counterProps{$i}];"##,##0"))
End for 

//utl_LogIt ("show")
utl_Logfile("missing-x.log"; "######## FINI ###########")
//ALERT(JSON Stringify($counter))//;*




