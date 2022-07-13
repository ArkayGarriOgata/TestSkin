//%attributes = {}
// -------
// Method: RM_LaserCam({dDateBegin;dDateEnd;$distributionList}) ->
// By: Mel Bohince @ 08/02/16, 10:07:43
// Description
// roll up laser cam receipts (laser dies) and make an import file for accountvantage
// ----------------------------------------------------
// Modified by: Mel Bohince (8/23/16) report any LaserCam receipt, not just 13 laser dies
// Modified by: Mel Bohince (11/5/17) tag transaction and don't open doc when run as batch


READ ONLY:C145([Purchase_Orders_Job_forms:59])
READ ONLY:C145([Purchase_Orders_Items:12])
READ WRITE:C146([Raw_Materials_Transactions:23])

//for debugging, use dates
//dDateEnd:=!06/14/2016!  //4D_Current_date-1  //dDateBegin
//dDateBegin:=dDateEnd

C_TEXT:C284($vendorsToInclude)
$vendorsToInclude:=" 04526 "  //lasercam, chg here and in RM_AP_to_OpenAccounts

If (Count parameters:C259>0)
	dDateBegin:=$1  //4D_Current_date
	dDateEnd:=$2  //dDateBegin
	$distributionList:=$3
	ok:=1
Else 
	dDateBegin:=4D_Current_date-1
	dDateEnd:=dDateBegin
	$winRef:=Open window:C153(2; 40; 638; 478; 8; "Receiving Dates")
	DIALOG:C40([zz_control:1]; "DateRange2")
	CLOSE WINDOW:C154($winRef)
	$distributionList:=Email_WhoAmI
End if 



If (OK=1)
	//for the email
	C_TEXT:C284($tSubject; $tBodyHeader; $tableData)
	$tSubject:="LaserCam Receipts from "+String:C10(dDateBegin; Internal date short special:K1:4)+" TO "+String:C10(dDateEnd; Internal date short special:K1:4)
	$tBodyHeader:="LaserCam receipts from "+String:C10(dDateBegin; Internal date short special:K1:4)+" TO "+String:C10(dDateEnd; Internal date short special:K1:4)+"."
	$tableData:=""
	
	If (bSearch=1)
		QUERY:C277([Raw_Materials_Transactions:23])
	Else 
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")  //;*)
		//QUERY([Raw_Materials_Transactions]; & ;[Raw_Materials_Transactions]Commodity_Key="13-Laser Dies")// Modified by: Mel Bohince (8/23/16) report any LaserCam receipt, not just 13 laser dies
	End if 
	
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4; >)
	
	//roll up by po
	$lastPO:=""
	$cursor:=0
	ARRAY TEXT:C222($aVendId; 0)
	ARRAY TEXT:C222($aPO; 0)
	ARRAY TEXT:C222($aJob; 0)
	ARRAY DATE:C224($aDateRcd; 0)
	ARRAY REAL:C219($aValue; 0)
	ARRAY LONGINT:C221($aReceipts; 0)
	
	
	While (Not:C34(End selection:C36([Raw_Materials_Transactions:23])))
		$currentPO:=Substring:C12([Raw_Materials_Transactions:23]POItemKey:4; 1; 7)
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=$currentPO)  // Modified by: Mel Bohince (8/23/16) report any LaserCam receipt, not just 13 laser dies
		If (Position:C15([Purchase_Orders:11]VendorID:2; $vendorsToInclude)>0)  //([Purchase_Orders]VendorID="04526")  //lasercam
			
			If ($currentPO#$lastPO)  //start new row
				$lastPO:=$currentPO
				$receipts:=1
				APPEND TO ARRAY:C911($aVendId; [Purchase_Orders:11]VendorID:2)
				APPEND TO ARRAY:C911($aPO; $currentPO)
				APPEND TO ARRAY:C911($aReceipts; 1)
				QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=($currentPO+"@"))
				If (Records in selection:C76([Purchase_Orders_Job_forms:59])>0)
					APPEND TO ARRAY:C911($aJob; [Purchase_Orders_Job_forms:59]JobFormID:2)
				Else 
					APPEND TO ARRAY:C911($aJob; "n/a")
				End if 
				APPEND TO ARRAY:C911($aDateRcd; [Raw_Materials_Transactions:23]XferDate:3)
				APPEND TO ARRAY:C911($aValue; [Raw_Materials_Transactions:23]ActExtCost:10)
				$cursor:=Size of array:C274($aPO)
			Else   //accumulate
				$aValue{$cursor}:=$aValue{$cursor}+[Raw_Materials_Transactions:23]ActExtCost:10
				$aReceipts{$cursor}:=$aReceipts{$cursor}+1
			End if 
			// Modified by: Mel Bohince (11/5/17) tag the transaction
			[Raw_Materials_Transactions:23]CostCenter:19:="OAAP"
			SAVE RECORD:C53([Raw_Materials_Transactions:23])
			
		End if   //lasercam
		NEXT RECORD:C51([Raw_Materials_Transactions:23])
	End while 
	
	
	
	C_LONGINT:C283($i)
	$total:=0
	$noJobTotal:=0
	$numItems:=0
	$row:=1
	//utl_LogIt ("init")
	//UTl_logit($tSubject)
	//utl_LogIt("PO\tJOB\tREC'D\tVOUCHER\tITEMS")
	//uThermoInit ($numElements;"Saving...")
	$b:="<tr><td width=\"150\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
	$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
	$e:="</td></tr>\r"
	
	For ($i; 1; $cursor)
		$row:=$row+1
		If (($row%2)#0)  //alternate row color
			$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
		Else 
			$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
		End if 
		
		$tableData:=$tableData+$b+$aPO{$i}+$t+$aJob{$i}+$t+String:C10($aDateRcd{$i}; Internal date short special:K1:4)+$t+String:C10($aValue{$i}; "###,##0")+$t+String:C10($aReceipts{$i}; "###,##0")+$e
		
		//utl_LogIt ($aPO{$i}+"\t"+$aJob{$i}+"\t"+String($aDateRcd{$i};Internal date short special)+"\t"+String($aValue{$i})+"\t"+string($aReceipts{$i}))
		$total:=$total+$aValue{$i}
		If ($aJob{$i}="n/a")
			$noJobTotal:=$noJobTotal+$aValue{$i}
		End if 
		$numItems:=$numItems+$aReceipts{$i}
		//uThermoUpdate ($i)
	End for 
	$discount:=Round:C94((0.02*$total); 0)
	
	$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$columnHeadings:=$b+"PO"+$t+"JOB"+$t+"REC'D"+$t+"$VOUCHER"+$t+"ITEMS"+$e
	$columnTotals:=$b+"TOTALS"+$t+" "+$t+" "+$t+String:C10($total; "$ ###,##0")+$t+String:C10($numItems; "###,##0")+$e
	$columnTotals:=$columnTotals+$b+"DISCOUNT"+$t+" "+$t+" "+$t+String:C10($discount; "$ ###,##0")+$t+"2%"+$e
	
	$tableData:=$columnHeadings+$tableData+$columnTotals
	
	
	C_TEXT:C284($text; $docName)
	C_TIME:C306($docRef)
	//ARRAY TEXT($aPO;0)
	//ARRAY TEXT($aJob;0)
	//ARRAY DATE($aDateRcd;0)
	//ARRAY REAL($aValue;0)
	//ARRAY LONGINT($aReceipts;0)
	$docName:=RM_AP_to_OpenAccounts(->$aPO; ->$aJob; ->$aDateRcd; ->$aValue; ->$aReceipts; ->$aVendId)
	
	//for the acctvantage import
	//$docName:="AP-LaserCam"+fYYMMDD (4D_Current_date)+"_"+Replace string(String(4d_Current_time;<>HHMM);":";"")+".txt"
	//$docRef:=util_putFileName (->$docName)
	
	//If ($docRef#?00:00:00?)
	//$text:="AVExtDef20050421\rDate\tMemo\r"+String(Current date;Internal date short special)+"\r"  //acctvantage header
	//$text:=$text+"GL Account Code\tDebit\tCredit\r"
	
	//$text:=$text+"21100-000-0000\t\t"+String($total)+"\r"
	//If ($noJobTotal=0)  //orginal code
	//$text:=$text+"51460-000-0000\t"+String($total)+"\t\r"
	//  //$text:=$text+"50800-000-0000\t\t"+String($discount)+"\r"
	//Else 
	//$text:=$text+"51460-000-0000\t"+String($total-$noJobTotal)+"\t\r"
	//$text:=$text+"55000-000-0000\t"+String($noJobTotal)+"\t\r"
	//End if 
	
	//$text:=$text+"GL Account Code\tClient/Vendor/Part\tClient/Vendor Number\tAV ID\tInvoice/Lot Number\tDoc Date\tDue Date\tDebit\tCredit\tProduct Qty\tWarehouse\tLocation\tMemo\r"
	//For ($i;1;$cursor)
	//$text:=$text+"21100-000-0000\tLasercam Inc*********\tLAS04526\t\t"+$aPO{$i}+"\t"+String($aDateRcd{$i};Internal date short special)+"\t"+String(($aDateRcd{$i}+45);Internal date short special)+"\t0\t"+String($aValue{$i})+"\t\t\t\t"+$aJob{$i}+"\r"
	//End for 
	//  //$text:=$text+"50800-000-0000\tLasercam Inc*********\tLAS04526\t\t"+fYYMMDD (4D_Current_date)+"\t"+String(4D_Current_date;Internal date short special)+"\t"+String((4D_Current_date);Internal date short special)+"\t"+String($discount)+"\t0\t\t\t\t2%Discount\r"
	//SEND PACKET($docRef;$text)
	//SEND PACKET($docRef;"EOF\r")
	//CLOSE DOCUMENT($docRef)
	//End if 
	
	Email_html_table($tSubject; $tBodyHeader; $tableData; 600; $distributionList; $docName)
	
	If (Count parameters:C259>0)  // Modified by: Mel Bohince (8/8/16) 
		util_deleteDocument($docName)
	Else 
		$err:=util_Launch_External_App($docName)
	End if 
	
	//uThermoClose 
	//utl_LogIt ("TOTAL:\t\t\t"+string($total))
	
	//utl_LogIt("show")
	
End if   //ok

UNLOAD RECORD:C212([Purchase_Orders_Job_forms:59])
UNLOAD RECORD:C212([Purchase_Orders_Items:12])
UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
