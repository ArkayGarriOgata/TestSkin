//%attributes = {}
// -------
// Method: INV_YTD_Billings_Export   ( ) ->
// By: Mel Bohince @ 10/11/18, 10:33:54
// Description
// export invoice data for excel massage
// ----------------------------------------------------
// Modified by: Mel Bohince (10/8/21) change from xls to csv file type
// Modified by: Mel Bohince (10/20/21) include data for SalesByRep, Commission, and SalesByState and execute building of text to server
// Modified by: Mel Bohince (11/24/21) properly size date range dialog

C_DATE:C307(dDateBegin; $1; $2; dDateEnd)
C_TEXT:C284($docName; $docShortName; $3; $distributionList)


If (Count parameters:C259>2)
	dDateBegin:=$1
	dDateEnd:=$2
	$distributionList:=$3
	OK:=1
	bSearch:=0
	
Else 
	windowTitle:="Invoice Date Range for Billings Export"
	$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)  // Modified by: Mel Bohince (11/24/21) properly size date range dialog
	dDateBegin:=Date:C102("01-01-"+String:C10(Year of:C25(Current date:C33)))
	dDateEnd:=Current date:C33
	DIALOG:C40([zz_control:1]; "DateRange2")
End if 

If (ok=1)
	
	$title:="INV_YTD_Billings_Export for "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
	
	zwStatusMsg("YTD_BILLING"; "retrieving invoices dated from "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)+" Please wait...")
	
	$text:=INV_YTD_Billings_Export_EOS(dDateBegin; dDateEnd)
	
	zwStatusMsg("YTD_BILLING"; "Finished retrieving invoices dated from "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd))
	
	$text:=$text+"\r\r"+$title+"\r\r------ END OF FILE ------"  // add some distance so excel has room for totals
	
	$docName:="YTD_Billings_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
	$docShortName:=$docName  //capture before path is prepended
	C_TIME:C306($docRef)
	$docRef:=util_putFileName(->$docName)
	CLOSE DOCUMENT:C267($docRef)
	
	TEXT TO DOCUMENT:C1237(document; $text)
	
	If (Count parameters:C259>2)
		$text:="Open attached with Excel, Edit>SelectAll, Edit>Copy, then switch to YTD_BreakDown.xlsx  go to the YTD_BillingsFrom_aMs sheet and paste into cell A1; then 'Refresh All' on the Data ribbon."
		EMAIL_Sender($title; ""; $text; $distributionList; $docName)
		util_deleteDocument($docName)
	Else 
		
		
		uConfirm("Download the pivot template?"; "Yes"; "No")
		If (ok=1)
			
			READ ONLY:C145([x_shell_scripts:138])
			QUERY:C277([x_shell_scripts:138]; [x_shell_scripts:138]scriptName:1="YTD_BreakDown.xlsx")
			If (Records in selection:C76([x_shell_scripts:138])>0)
				app_ExportScript
				REDUCE SELECTION:C351([x_shell_scripts:138]; 0)
			End if   //temp found
			
		End if   //get template
		
		$err:=util_Launch_External_App($docName)
		
	End if   //#params
	
End if   //ok. 
