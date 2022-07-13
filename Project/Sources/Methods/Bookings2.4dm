//%attributes = {}
// _______
// Method: Bookings2   ( {object}) -> csvfile {emailed}
// By: Mel Bohince @ 11/01/21, 08:34:31
// Description
// rewite Booking( ), listing of accepted or closed orderlines within a date range
// Object Parameter attributes:
//    { "fiscal":date within desired fiscal year }
//    or {"dateBegin"}
//    and optional {"dateEnd"}
//    {distribution} or emailed to self
// ----------------------------------------------------

C_OBJECT:C1216($arg_o; $1)
$arg_o:=New object:C1471

C_TEXT:C284($docName; $docShortName; $distributionList; $title; $text)
C_TIME:C306($docRef)

C_DATE:C307($fiscalStart; $fiscalEnd; $targetDate; dDateBegin; dDateEnd)

Case of 
	: (Count parameters:C259>0)  //expecting an object
		$arg_o:=$1
		
		If (OB Is defined:C1231($arg_o; "fiscal"))
			$targetDate:=$arg_o.fiscal
			$fiscalStart:=Date:C102(FiscalYear("start"; $targetDate))
			$fiscalEnd:=Add to date:C393($fiscalStart; 1; 0; -1)
			dDateBegin:=$fiscalStart
			dDateEnd:=$fiscalEnd
			
		Else 
			If (OB Is defined:C1231($arg_o; "dateBegin"))
				$targetDate:=$arg_o.fiscal
				$fiscalStart:=Date:C102(FiscalYear("start"; $targetDate))
				$fiscalEnd:=Add to date:C393($fiscalStart; 1; 0; -1)
				dDateBegin:=$arg_o.dateBegin
			Else   //begining of this year
				dDateBegin:=Date:C102(FiscalYear("start"; Current date:C33))
			End if 
			
			If (OB Is defined:C1231($arg_o; "dateEnd"))
				dDateEnd:=$arg_o.dateEnd
			Else   //ending of this year
				dDateEnd:=Add to date:C393(dDateBegin; 1; 0; -1)
			End if 
			
		End if 
		
		//email to:
		If (OB Is defined:C1231($arg_o; "distributionList"))
			$distributionList:=$arg_o.distributionList
		Else 
			$distributionList:=Email_WhoAmI
		End if 
		
		OK:=1
		bSearch:=0
		
		
	Else   //user specified
		dDateBegin:=Date:C102("01-01-"+String:C10(Year of:C25(Current date:C33)))
		dDateEnd:=Current date:C33
		$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
		DIALOG:C40([zz_control:1]; "DateRange2")
		CLOSE WINDOW:C154($winRef)
End case 

If (ok=1)
	
	$title:="Bookings Export for "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
	
	zwStatusMsg("YTD_BOOKINGS"; "retrieving orderlines dated from "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)+" Please wait...")
	
	$text:=Booking_EOS(dDateBegin; dDateEnd)
	
	zwStatusMsg("YTD_BOOKINGS"; "Finished retrieving order lines dated from "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd))
	
	$text:=$text+"\r\r"+$title+"\r\r------ END OF FILE ------"  // add some distance so excel has room for totals
	
	$docName:="Bookings"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")+".csv"
	$docShortName:=$docName  //capture before path is prepended
	$docRef:=util_putFileName(->$docName)
	CLOSE DOCUMENT:C267($docRef)
	
	TEXT TO DOCUMENT:C1237($docName; $text)
	
	If (Count parameters:C259>0)
		$text:="Open attached with Excel, Edit>SelectAll, Edit>Copy, then switch to YTD_BreakDown.xlsx  go to the YTD_BookingsFrom_aMs sheet and paste into cell A1; then 'Refresh All' on the Data ribbon."
		EMAIL_Sender($title; ""; $text; $distributionList; $docName)
		util_deleteDocument($docName)
		
	Else   //running interactively
		
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
