// ----------------------------------------------------
// User name (OS): TJF
// Date: 0401096
// ----------------------------------------------------
// Form Method: [Job_Forms_CloseoutSummaries].SelectSumCrit
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY DATE:C224(aTimes; 3; 2)
		ARRAY TEXT:C222(puCustomers; 0)
		ARRAY TEXT:C222(puLines; 0)
		
		srb1:=1
		srb2:=0
		srb3:=0
		drb1:=1
		drb2:=0
		drb3:=0
		cbAllTotals:=1
		rb1:=1
		rb2:=0
		
		$FstMthYear:=4  //first month of the "year"-------------
		vFstMthYr:=$FstMthYear
		//*determine month of report, prior months and YTD months
		$CDate:=4D_Current_date
		vDTo:=$CDate-Day of:C23($CDate)
		vDFrom:=vDTo-(Day of:C23(vDTo))+1
		$LMonth:=Month of:C24(vDTo)
		If ($LMonth>=$FstMthYear)
			$LYear:=Year of:C25(vDTo)
		Else 
			$LYear:=Year of:C25(vDTo)-1
		End if 
		aTimes{1}{1}:=vDFrom
		aTimes{1}{2}:=vDTo
		aTimes{2}{1}:=Date:C102(String:C10($FstMthYear)+"/1/"+String:C10($LYear))
		aTimes{2}{2}:=vDTo-(Day of:C23(vDTo))
		aTimes{3}{1}:=aTimes{2}{1}
		aTimes{3}{2}:=vDTo
		//*do interface stuff
		ALL RECORDS:C47([Job_Forms_CloseoutSummaries:87])
		DISTINCT VALUES:C339([Job_Forms_CloseoutSummaries:87]Customer:2; puCustomers)
		INSERT IN ARRAY:C227(puCustomers; 1)
		puCustomers{1}:="All Customers"
		puCustomers:=1
		INSERT IN ARRAY:C227(puLines; 1)
		puLines{1}:="All Lines"
		puLines:=1
		
		ARRAY TEXT:C222(puMonths; 4)
		ARRAY DATE:C224(aFTTime; 4; 2)
		$DateF:=$CDate
		For ($i; 1; 4)
			$DateT:=$DateF-Day of:C23($DateF)
			$DateF:=$DateT-(Day of:C23($DateT))+1
			aFTTime{$i}{1}:=$DateF
			aFTTime{$i}{2}:=$DateT
			$Date:=String:C10($DateT; 6)
			$pos:=Position:C15(","; $date)+1
			puMonths{$i}:=Substring:C12($Date; 1; 3)
		End for 
		puMonths:=1
		
		If ($LMonth=$FstMthYear)
			OBJECT SET ENABLED:C1123(drb2; False:C215)  //if your looking at the first month of the year,there are no priors
			OBJECT SET ENABLED:C1123(drb3; False:C215)
			OBJECT SET ENABLED:C1123(cbAllTotals; False:C215)
			cbAllTotals:=0
		End if 
		
	: (Form event code:C388=On Display Detail:K2:22)
		If (drb4=1)  //other time frame
			SetObjectProperties(""; ->vDFrom; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->vDTo; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		Else 
			SetObjectProperties(""; ->vDFrom; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->vDTo; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		End if 
		If (drb1=1)  //standard monthly report
			
			OBJECT SET ENABLED:C1123(cbAllTotals; True:C214)
			OBJECT SET ENABLED:C1123(cbAllTotals; True:C214)
		Else 
			
			OBJECT SET ENABLED:C1123(cbAllTotals; False:C215)
			OBJECT SET ENABLED:C1123(cbAllTotals; False:C215)
		End if 
		
End case 