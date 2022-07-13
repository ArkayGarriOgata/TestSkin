// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/31/13, 22:20:23
// ----------------------------------------------------
// Method: [Customers_Projects].ControlCtr.atTextPick
// Description:
// Allows the user to filter the Modified dates by
// text phrases.
// ----------------------------------------------------

C_DATE:C307($dDate; $dEndDate)

xlDateStart:=0
xlDateEnd:=0

Case of 
	: (atTextPick=1)  //Do Nothing
		
	: (atTextPick=2)  //Today
		$dDate:=Current date:C33
		tModDateStart:=String:C10($dDate)
		tModDateEnd:=String:C10($dDate)
		
	: (atTextPick=3)  //Yesterday
		$dDate:=(UtilGetDate(Current date:C33; "Yesterday"; ->$dEndDate))
		tModDateStart:=String:C10($dDate)
		tModDateEnd:=String:C10($dEndDate)
		
	: (atTextPick=4)  //This Week
		$dDate:=(UtilGetDate(Current date:C33; "ThisWeek"; ->$dEndDate))
		tModDateStart:=String:C10($dDate)
		tModDateEnd:=String:C10($dEndDate)
		
	: (atTextPick=5)  //Last Week
		$dDate:=(UtilGetDate(Current date:C33; "LastWeek"; ->$dEndDate))
		tModDateStart:=String:C10($dDate)
		tModDateEnd:=String:C10($dEndDate)
		
	: ((atTextPick=6) | (atTextPick=7))  //This Month or Older
		$dDate:=(UtilGetDate(Current date:C33; "ThisMonth"; ->$dEndDate))
		tModDateStart:=String:C10($dDate)
		tModDateEnd:=String:C10($dEndDate)
		If (atTextPick=7)
			$dDate:=Add to date:C393($dDate; 0; 0; -1)
			tModDateStart:=""
			tModDateEnd:=String:C10($dDate)
		End if 
		
End case 

Est_FilterEstimates