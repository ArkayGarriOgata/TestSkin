//%attributes = {}
// ----------------------------------------------------
// Method: REL_RequestForModeRpt   (distributionList ) ->
// By: Mel Bohince @ 02/18/16, 21:54:29
// Description
// email list of waiting RFM's
// ----------------------------------------------------
// Modified by: Mel Bohince (2/24/17) use attachment because of text overflow
// Modified by: Mel Bohince (4/9/19) the array $_CustomerRefer needs to be added to the sort
C_TEXT:C284($title; $text; $docName; $tableData)
C_TIME:C306($docRef)

$title:=""
$text:=""

If (Count parameters:C259>0)
	$distributionList:=$1
Else 
	//$distributionList:=Email_WhoAmI 
	//$distributionList:=Request("Send report to: ";$distributionList)
End if 

$numRel:=ELC_RFM("waiting")
If ($numRel>0)
	
	$docName:="WaitingforRFM_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->$docName)
	If ($docRef#?00:00:00?)
		
		$date:=4D_Current_date  //•041996  MLB  
		$subject:="Outstanding Requests For Mode as of "+String:C10($date; <>LONGDATE)
		$prehead:="Listed are releases waiting for shipping mode before they can ship."
		
		SEND PACKET:C103($docRef; $subject+"\r\r")
		
		$tableData:=""
		$bodyText:="Open attached with Excel. "+String:C10($numRel)+" RFM's waiting dispostion."
		
		//$r:="</td></tr>\r"
		
		//$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		//$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$b:=""
		$r:="\r"
		$t:="\t"
		
		$tableData:=$tableData+$b+"PRODUCT CODE"+$t+"LINE"+$t+"DESTINATION"+$t+"WEEKDAY"+$t+"REQUESTED MODE"+$t+"WAIT(BizDays)"+$t+"PO"+$r
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]user_date_1:48; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
			
			//$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
			//$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
			
			$excelHeaderRows:=3
			
			uThermoInit($numRel; "Listing RFMs")
			For ($i; 1; $numRel)
				
				If (Length:C16($tableData)>25000)
					SEND PACKET:C103($docRef; $tableData)
					$tableData:=""
				End if 
				
				$tableData:=$tableData+$b+[Customers_ReleaseSchedules:46]ProductCode:11+$t+[Customers_ReleaseSchedules:46]CustomerLine:28+$t+ADDR_getCity([Customers_ReleaseSchedules:46]Shipto:10)+$t+"=text(E"+String:C10($i+$excelHeaderRows)+",\"ddd\")"+$t+String:C10([Customers_ReleaseSchedules:46]user_date_1:48; <>MIDDATE)+$t+"=NETWORKDAYS(E"+String:C10($i+$excelHeaderRows)+",TODAY())"+$t+[Customers_ReleaseSchedules:46]CustomerRefer:3+$r
				
				NEXT RECORD:C51([Customers_ReleaseSchedules:46])
				uThermoUpdate($i)
			End for 
			
			
		Else 
			
			ARRAY DATE:C224($_user_date_1; 0)
			ARRAY DATE:C224($_Sched_Date; 0)
			ARRAY TEXT:C222($_ProductCode; 0)
			ARRAY TEXT:C222($_CustomerLine; 0)
			ARRAY TEXT:C222($_Shipto; 0)
			ARRAY TEXT:C222($_CustomerRefer; 0)
			
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]user_date_1:48; $_user_date_1; [Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; [Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; [Customers_ReleaseSchedules:46]CustomerLine:28; $_CustomerLine; [Customers_ReleaseSchedules:46]Shipto:10; $_Shipto; [Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer)
			
			SORT ARRAY:C229($_user_date_1; $_Sched_Date; $_ProductCode; $_CustomerLine; $_Shipto; $_CustomerRefer; >)  // Modified by: Mel Bohince (4/9/19) the array $_CustomerRefer needs to be added to the sort
			
			
			$excelHeaderRows:=3
			
			uThermoInit($numRel; "Listing RFMs")
			For ($i; 1; $numRel; 1)
				
				If (Length:C16($tableData)>25000)
					SEND PACKET:C103($docRef; $tableData)
					$tableData:=""
				End if 
				
				$tableData:=$tableData+$b+$_ProductCode{$i}+$t+$_CustomerLine{$i}+$t+ADDR_getCity($_Shipto{$i})+$t+"=text(E"+String:C10($i+$excelHeaderRows)+",\"ddd\")"+$t+String:C10($_user_date_1{$i}; <>MIDDATE)+$t+"=NETWORKDAYS(E"+String:C10($i+$excelHeaderRows)+",TODAY())"+$t+$_CustomerRefer{$i}+$r
				
				uThermoUpdate($i)
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 First record
		
		SEND PACKET:C103($docRef; $tableData)
		SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		uThermoClose
		
		
		
		If (Count parameters:C259>0)
			Email_html_table($subject; $prehead; $bodyText; 650; $distributionList; $docName)
			util_deleteDocument($docName)
		Else 
			$err:=util_Launch_External_App($docName)
		End if 
		
	Else 
		//doc couldn't be created
	End if 
End if 