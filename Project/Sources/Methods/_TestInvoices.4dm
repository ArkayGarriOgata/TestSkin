//%attributes = {}
// _______
// Method: _TestInvoices   ( ) ->
// By: Mel Bohince @ 04/22/21, 09:10:13
// Description
// 
// ----------------------------------------------------
C_OBJECT:C1216($counter; $inv_es; $inv; $xact_es)

C_BOOLEAN:C305($repair)
CONFIRM:C162("Which?"; "Verify"; "Repair")
$repair:=(ok=0)

SET MENU BAR:C67(<>DefaultMenu)  //Apple File Edit Window

$start:=Date:C102(Request:C163("start date"; "01/01/2018"))
$end:=Date:C102(Request:C163("end date"; String:C10(Current date:C33; Internal date short special:K1:4)))

//[Customers_Invoices]InvoiceNumber
$inv_es:=ds:C1482.Customers_Invoices.query("Invoice_Date >= :1 and Invoice_Date <= :2 and ReleaseNumber  > 0"; $start; $end).orderBy("InvoiceNumber")
//utl_LogIt ("init")
utl_Logfile("missing-x.log"; "######## START ###########")
C_OBJECT:C1216($counter)
$counter:=New object:C1471
//("2018i";0;"2019i";0;"2020i";0;"2021i";0;"2018b";0;"2019b";0;"2020b";0;"2021b";0;"2018x";0;"2019x";0;"2020x";0;"2021x";0)

C_LONGINT:C283($outerBar; $outerLoop; $out)
$out:=0
$outerLoop:=$inv_es.length
$outerBar:=Progress New  //new progress bar
Progress SET TITLE($outerBar; "Processing Releases...")  //optional init of the thermoeters title
Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button, see $continueInteration

For each ($inv; $inv_es)
	//If ($inv.ReleaseNumber=4770623)
	//TRACE
	//End if 
	$out:=$out+1  //update a counter
	Progress SET PROGRESS($outerBar; $out/$outerLoop)  //update the thermometer
	Progress SET MESSAGE($outerBar; String:C10($out; "^^^^^")+" of "\
		+String:C10($outerLoop; "^^^^^")+" @ "+String:C10(100*$out/$outerLoop; "###%"))  //optional verbose status
	
	$continueInteration:=(Not:C34(Progress Stopped($outerBar)))  //test if cancel button clicked
	If ($continueInteration)
		$year_s:=String:C10(Year of:C25($inv.Invoice_Date))
		If (Not:C34(OB Is defined:C1231($counter; $year_s+"x")))
			$counter[$year_s+"b"]:=0
			$counter[$year_s+"r"]:=0
			$counter[$year_s+"x"]:=0
		End if 
		
		//test for rel
		If ($inv.CUST_RELEASE=Null:C1517)
			//utl_LogIt ("BOL "+String($inv.B_O_L_number)+" is missing"+" for "+String($inv.InvoiceNumber)+" on "+String($inv.Invoice_Date))
			$counter[$year_s+"r"]:=$counter[$year_s+"r"]+1
		End if 
		
		//test for bol
		If ($inv.BOL=Null:C1517)
			//utl_LogIt ("BOL "+String($inv.B_O_L_number)+" is missing"+" for "+String($inv.InvoiceNumber)+" on "+String($inv.Invoice_Date))
			$counter[$year_s+"b"]:=$counter[$year_s+"b"]+1
		End if 
		
		//test for xactions
		$fgxOrderItem:=$inv.OrderLine+"/"+String:C10($inv.ReleaseNumber)
		//$xact_es:=ds.Finished_Goods_Transactions.query("ProductCode = :1 and XactionDate = :2 and XactionType = :3 and OrderItem = :4";$inv.ProductCode;$inv.Invoice_Date;"ship";$fgxOrderItem)
		$xact_es:=ds:C1482.Finished_Goods_Transactions.query("OrderItem = :1"; $fgxOrderItem)
		
		If ($xact_es.length=0)
			//utl_LogIt ("Transactions are missing"+" for "+String($inv.InvoiceNumber)+" on "+String($inv.Invoice_Date))
			//utl_Logfile ("missing-x.log";String($inv.InvoiceNumber))
			$counter[$year_s+"x"]:=$counter[$year_s+"x"]+1
			
			If ($repair)
				FGX_backFillShipment($inv)
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



