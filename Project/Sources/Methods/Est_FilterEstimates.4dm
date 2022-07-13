//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/19/13, 09:34:41
// ----------------------------------------------------
// Method: Est_FilterEstimates
// Description:
// Filters the Estimates based on user input.
// ----------------------------------------------------
// Modified by: Mel Bohince (4/22/13) declare date filters and get $pjt number as pjtID was empty, don't rely on bShowAll
// ----------------------------------------------------

C_LONGINT:C283($xlLastDay)
C_DATE:C307($dDateStart; $dDateEnd)
C_LONGINT:C283(xlDateStart; xlDateEnd)
C_TEXT:C284(tModDateStart; tModDateEnd)

$pjt:=Pjt_getReferId

If ((Form event code:C388=On Data Change:K2:15) | (Count parameters:C259=1) | (Form event code:C388=On Clicked:K2:4))
	QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2=Current user:C182; *)
	QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]PrefType:4="EstDateFilter")
	[UserPrefs:184]LongIntField:7:=xlDateStart
	[UserPrefs:184]LongIntField2:12:=xlDateEnd
	[UserPrefs:184]TextField:5:=tModDateStart
	[UserPrefs:184]TextField2:3:=tModDateEnd
	SAVE RECORD:C53([UserPrefs:184])
	
	Case of 
		: ((xlDateStart#0) | (xlDateEnd#0))
			QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=$pjt; *)
			If (xlDateStart#0)
				QUERY:C277([Estimates:17];  & ; [Estimates:17]EstimateNo:1>=String:C10(xlDateStart)+"@"; *)
			End if 
			If (xlDateEnd#0)
				QUERY:C277([Estimates:17];  & ; [Estimates:17]EstimateNo:1<=String:C10(xlDateEnd)+"@"; *)
			End if 
			QUERY:C277([Estimates:17])
			SetObjectProperties("xlNumRecs"; -><>NULL; True:C214; ""; False:C215; Red:K11:4; Blue:K11:7)  // Added by: Mark Zinke (5/9/13)
			SetObjectProperties("DataFilterAlert"; -><>NULL; True:C214)  // Added by: Mark Zinke (5/9/13)
			
		: ((tModDateStart#"") | (tModDateEnd#""))
			QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=$pjt; *)
			If (tModDateStart#"")
				If (Length:C16(tModDateStart)<6)  // Added by: Mark Zinke (4/1/13)
					GetStartEndDates("Start"; tModDateStart; ->$dDateStart)
				Else 
					$dDateStart:=Date:C102(tModDateStart)
				End if 
				QUERY:C277([Estimates:17];  & ; [Estimates:17]ModDate:37>=$dDateStart; *)
			End if 
			If (tModDateEnd#"")
				If (Length:C16(tModDateEnd)<6)  // Added by: Mark Zinke (4/1/13)
					GetStartEndDates("End"; tModDateEnd; ->$dDateEnd)
				Else 
					$dDateEnd:=Date:C102(tModDateEnd)
				End if 
				QUERY:C277([Estimates:17];  & ; [Estimates:17]ModDate:37<=$dDateEnd; *)
			End if 
			QUERY:C277([Estimates:17])
			SetObjectProperties("xlNumRecs"; -><>NULL; True:C214; ""; False:C215; Red:K11:4; Blue:K11:7)  // Added by: Mark Zinke (5/9/13)
			SetObjectProperties("DataFilterAlert"; -><>NULL; True:C214)  // Added by: Mark Zinke (5/9/13)
			
		Else   //: (bShowAll=1)
			QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=$pjt)
			atTextPick:=1
			SetObjectProperties("xlNumRecs"; -><>NULL; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
			SetObjectProperties("DataFilterAlert"; -><>NULL; False:C215)  // Added by: Mark Zinke (5/9/13)
			
	End case 
	
	SELECTION TO ARRAY:C260([Estimates:17]JobType:29; atJobType; [Estimates:17]EstimateNo:1; atEstimateNum; [Estimates:17]Status:30; atStatus; [Estimates:17]ModDate:37; adModDate; [Estimates:17]DateRFQ:52; adDateRfqd; [Estimates:17]DateEstimated:64; adDateEstimated; [Estimates:17]DatePrice:60; adDatePriced; [Estimates:17]POnumber:18; atPONum; [Estimates:17]z_Contact_Agent:43; atContactAgent; [Estimates:17]; axlRecNums)
	
	xlNumRecs:=Records in selection:C76([Estimates:17])
	
	Case of 
		: ((xlDateStart#0) | (xlDateEnd#0))
			LISTBOX SORT COLUMNS:C916(abEstimateLB; 2; <)
			
		: ((tModDateStart#"") | (tModDateEnd#""))
			LISTBOX SORT COLUMNS:C916(abEstimateLB; 4; <)
			
		Else   //: (bShowAll=1)
			LISTBOX SORT COLUMNS:C916(abEstimateLB; 2; <)
			
	End case 
End if 