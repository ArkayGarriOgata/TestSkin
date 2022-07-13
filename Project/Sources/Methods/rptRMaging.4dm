//%attributes = {"publishedWeb":true}
//PM:  rptRMaging  082302  mlb
//bin report by age of bin
// • mel (6/2/04, 15:12:42)allw search

// Modified by: Mel Bohince (8/21/19) remove query selection when called from Reports popup menu
// Modified by: Mel Bohince (9/5/19) return the specifed doc var, not the one that was doing the reset

C_LONGINT:C283($1)
C_TEXT:C284($2; $pathToPDF; $0)
C_REAL:C285(r30; r60; r90; r120; rUnkn; rOver)

MESSAGES OFF:C175

util_PAGE_SETUP(->[Raw_Materials_Locations:25]; "printLinePlain")
If (<>PrintToPDF)
	$pathToPDF:=PDF_setUp("RM_Aging_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".pdf")
End if 

If (Count parameters:C259=2)
	<>PrintToPDF:=True:C214
	$pathToPDF:=PDF_setUp($2)
End if 

READ ONLY:C145([Raw_Materials:21])
READ ONLY:C145([Raw_Materials_Locations:25])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	ALL RECORDS:C47([Raw_Materials_Locations:25])
	
	If (Count parameters:C259=1)
		QUERY SELECTION:C341([Raw_Materials_Locations:25])  // • mel (6/2/04, 15:12:42)
	End if 
	
Else 
	
	// Modified by: Mel Bohince (8/21/19)
	//If (Count parameters=1)
	//QUERY([Raw_Materials_Locations])  // • mel (6/2/04, 15:12:42)
	//Else 
	ALL RECORDS:C47([Raw_Materials_Locations:25])
	//End if 
	
End if   // END 4D Professional Services : January 2019 query selection

$numBins:=Records in selection:C76([Raw_Materials_Locations:25])
ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Commodity_Key:12; >; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >)
$today:=4D_Current_date
$ageCurrent:=Add to date:C393($today; 0; 0; -30)
$age60:=Add to date:C393($today; 0; 0; -60)
$age90:=Add to date:C393($today; 0; 0; -90)
$age120:=Add to date:C393($today; 0; 0; -120)
$ageOver120:=Add to date:C393($today; -10; 0; 0)
$ageUnknown:=!00-00-00!
$totalCurrent:=0
$total60:=0
$total90:=0
$total120:=0
$totalOver120:=0
$totalUnknown:=0

ARRAY TEXT:C222($aComm; $numBins)
ARRAY TEXT:C222($aRM; $numBins)
ARRAY REAL:C219($aCurr; $numBins)
ARRAY REAL:C219($a60; $numBins)
ARRAY REAL:C219($a90; $numBins)
ARRAY REAL:C219($a120; $numBins)
ARRAY REAL:C219($aOvr; $numBins)
ARRAY REAL:C219($aUnkn; $numBins)
$numRMs:=0
$lastRM:=""
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Raw_Materials_Locations:25])
	
	
Else 
	
	// see line 38
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
uThermoInit($numBins; "Aging R/M Bins")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($bin; 1; $numBins)
		If ([Raw_Materials_Locations:25]Raw_Matl_Code:1#$lastRM)
			$numRMs:=$numRMs+1
			$aRM{$numRMs}:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
			$aComm{$numRMs}:=[Raw_Materials_Locations:25]Commodity_Key:12
			If (Length:C16($aComm{$numRMs})=0)
				$aComm{$numRMs}:="blank"
			End if 
			$lastRM:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
			uThermoUpdate($bin)
		End if 
		
		$extendedDollars:=[Raw_Materials_Locations:25]QtyOH:9*[Raw_Materials_Locations:25]ActCost:18
		
		Case of 
			: ([Raw_Materials_Locations:25]ActCost:18=0)
				//costless
			: (True:C214)
				RMB_ageInventory([Raw_Materials_Locations:25]POItemKey:19; [Raw_Materials_Locations:25]QtyOH:9; ->r30; ->r60; ->r90; ->r120; ->rOver; ->rUnkn)
				$aUnkn{$numRMs}:=$aUnkn{$numRMs}+rUnkn
				$totalUnknown:=$totalUnknown+rUnkn
				$aCurr{$numRMs}:=$aCurr{$numRMs}+r30
				$totalCurrent:=$totalCurrent+r30
				$a60{$numRMs}:=$a60{$numRMs}+r60
				$total60:=$total60+r60
				$a90{$numRMs}:=$a90{$numRMs}+r90
				$total90:=$total90+r90
				$a120{$numRMs}:=$a120{$numRMs}+r120
				$total120:=$total120+r120
				$aOvr{$numRMs}:=$aOvr{$numRMs}+rOver
				$totalOver120:=$totalOver120+rOver
				
			: ([Raw_Materials_Locations:25]BinCreated:4=$ageUnknown)
				$aUnkn{$numRMs}:=$aUnkn{$numRMs}+$extendedDollars
				$totalUnknown:=$totalUnknown+$extendedDollars
			: ([Raw_Materials_Locations:25]BinCreated:4>=$ageCurrent)
				$aCurr{$numRMs}:=$aCurr{$numRMs}+$extendedDollars
				$totalCurrent:=$totalCurrent+$extendedDollars
			: ([Raw_Materials_Locations:25]BinCreated:4>=$age60)
				$a60{$numRMs}:=$a60{$numRMs}+$extendedDollars
				$total60:=$total60+$extendedDollars
			: ([Raw_Materials_Locations:25]BinCreated:4>=$age90)
				$a90{$numRMs}:=$a90{$numRMs}+$extendedDollars
				$total90:=$total90+$extendedDollars
			: ([Raw_Materials_Locations:25]BinCreated:4>=$age120)
				$a120{$numRMs}:=$a120{$numRMs}+$extendedDollars
				$total120:=$total120+$extendedDollars
			Else 
				$aOvr{$numRMs}:=$aOvr{$numRMs}+$extendedDollars
				$totalOver120:=$totalOver120+$extendedDollars
		End case 
		
		NEXT RECORD:C51([Raw_Materials_Locations:25])
	End for 
	
	
Else 
	
	SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Raw_Matl_Code:1; $_Raw_Matl_Code; \
		[Raw_Materials_Locations:25]Commodity_Key:12; $_Commodity_Key; \
		[Raw_Materials_Locations:25]QtyOH:9; $_QtyOH; \
		[Raw_Materials_Locations:25]ActCost:18; $_ActCost; \
		[Raw_Materials_Locations:25]POItemKey:19; $_POItemKey; \
		[Raw_Materials_Locations:25]BinCreated:4; $_BinCreated)
	
	For ($bin; 1; $numBins; 1)
		If ($_Raw_Matl_Code{$bin}#$lastRM)
			$numRMs:=$numRMs+1
			$aRM{$numRMs}:=$_Raw_Matl_Code{$bin}
			$aComm{$numRMs}:=$_Commodity_Key{$bin}
			If (Length:C16($aComm{$numRMs})=0)
				$aComm{$numRMs}:="blank"
			End if 
			$lastRM:=$_Raw_Matl_Code{$bin}
			uThermoUpdate($bin)
		End if 
		
		$extendedDollars:=$_QtyOH{$bin}*$_ActCost{$bin}
		
		Case of 
			: ($_ActCost{$bin}=0)
				//costless
			: (True:C214)
				RMB_ageInventory($_POItemKey{$bin}; $_QtyOH{$bin}; ->r30; ->r60; ->r90; ->r120; ->rOver; ->rUnkn)
				$aUnkn{$numRMs}:=$aUnkn{$numRMs}+rUnkn
				$totalUnknown:=$totalUnknown+rUnkn
				$aCurr{$numRMs}:=$aCurr{$numRMs}+r30
				$totalCurrent:=$totalCurrent+r30
				$a60{$numRMs}:=$a60{$numRMs}+r60
				$total60:=$total60+r60
				$a90{$numRMs}:=$a90{$numRMs}+r90
				$total90:=$total90+r90
				$a120{$numRMs}:=$a120{$numRMs}+r120
				$total120:=$total120+r120
				$aOvr{$numRMs}:=$aOvr{$numRMs}+rOver
				$totalOver120:=$totalOver120+rOver
				
			: ($_BinCreated{$bin}=$ageUnknown)
				$aUnkn{$numRMs}:=$aUnkn{$numRMs}+$extendedDollars
				$totalUnknown:=$totalUnknown+$extendedDollars
			: ($_BinCreated{$bin}>=$ageCurrent)
				$aCurr{$numRMs}:=$aCurr{$numRMs}+$extendedDollars
				$totalCurrent:=$totalCurrent+$extendedDollars
			: ($_BinCreated{$bin}>=$age60)
				$a60{$numRMs}:=$a60{$numRMs}+$extendedDollars
				$total60:=$total60+$extendedDollars
			: ($_BinCreated{$bin}>=$age90)
				$a90{$numRMs}:=$a90{$numRMs}+$extendedDollars
				$total90:=$total90+$extendedDollars
			: ($_BinCreated{$bin}>=$age120)
				$a120{$numRMs}:=$a120{$numRMs}+$extendedDollars
				$total120:=$total120+$extendedDollars
			Else 
				$aOvr{$numRMs}:=$aOvr{$numRMs}+$extendedDollars
				$totalOver120:=$totalOver120+$extendedDollars
		End case 
	End for 
	
	
End if   // END 4D Professional Services : January 2019 

uThermoClose
ARRAY TEXT:C222($aComm; $numRMs)
ARRAY TEXT:C222($aRM; $numRMs)
ARRAY REAL:C219($aCurr; $numRMs)
ARRAY REAL:C219($a60; $numRMs)
ARRAY REAL:C219($a90; $numRMs)
ARRAY REAL:C219($a120; $numRMs)
ARRAY REAL:C219($aOvr; $numRMs)
ARRAY REAL:C219($aUnkn; $numRMs)

xTitle:="R/M AGING OF ACTUAL COST DOLLARS AS OF "+String:C10($today; System date short:K1:1)
xHeadings:=txt_Pad("R/M Code"; " "; 1; 22)+txt_Pad("CURRENT"; " "; -1; 14)+txt_Pad("31-60 DAYS"; " "; -1; 14)+txt_Pad("61-90 DAYS"; " "; -1; 14)+txt_Pad("91-120 DAYS"; " "; -1; 14)+txt_Pad("OVER 120 DAYS"; " "; -1; 14)+txt_Pad("UNKNOWN"; " "; -1; 14)+txt_Pad("TOTAL $'S"; " "; -1; 14)+"  Page "
xUnderLines:=txt_Pad("--------"; " "; 1; 22)+txt_Pad("-------"; " "; -1; 14)+txt_Pad("----------"; " "; -1; 14)+txt_Pad("----------"; " "; -1; 14)+txt_Pad("-----------"; " "; -1; 14)+txt_Pad("-------------"; " "; -1; 14)+txt_Pad("-------"; " "; -1; 14)+txt_Pad("---------"; " "; -1; 14)

$page:=1
xText:=xTitle
Print form:C5([Raw_Materials_Locations:25]; "printTextBold")
xText:=xHeadings+String:C10($page)
Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
xText:=xUnderLines
Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
$lastComm:=""
$lineCounter:=2
uThermoInit($numRMs; "Printing Aged R/M's")
For ($rm; 1; $numRMs)
	uThermoUpdate($rm)
	
	If ($lastComm#$aComm{$rm})
		If ($lineCounter>45)
			PAGE BREAK:C6(>)
			$lineCounter:=0
			$page:=1+$page
			xText:=xTitle
			Print form:C5([Raw_Materials_Locations:25]; "printTextBold")
			xText:=xHeadings+String:C10($page)
			Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
			xText:=xUnderLines
			Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
		End if 
		$lineCounter:=$lineCounter+1
		xText:=Replace string:C233(xUnderLines; "-"; ".")
		Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
		$lineCounter:=$lineCounter+1
		xText:=Uppercase:C13($aComm{$rm})
		Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
		
		$lastComm:=$aComm{$rm}
	End if 
	
	If ($lineCounter>46)
		PAGE BREAK:C6(>)
		$lineCounter:=0
		$page:=1+$page
		xText:=xTitle
		Print form:C5([Raw_Materials_Locations:25]; "printTextBold")
		xText:=xHeadings+String:C10($page)
		Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
		xText:=xUnderLines
		Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
	End if 
	
	$lineCounter:=$lineCounter+1
	xText:=txt_Pad("  "+$aRM{$rm}; " "; 1; 22)+txt_Pad(String:C10(Round:C94($aCurr{$rm}; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($a60{$rm}; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($a90{$rm}; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($a120{$rm}; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($aOvr{$rm}; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($aUnkn{$rm}; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($aCurr{$rm}+$a60{$rm}+$a90{$rm}+$a120{$rm}+$aOvr{$rm}+$aUnkn{$rm}; 0); "#,###,###"); " "; -1; 14)
	Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
	
End for 

xText:=xUnderLines
Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
xText:=xUnderLines
xText:=Replace string:C233(xText; "-"; "=")
Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")

xText:=txt_Pad("TOTALS"; " "; 1; 22)+txt_Pad(String:C10(Round:C94($totalCurrent; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($total60; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($total90; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($total120; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($totalOver120; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($totalUnknown; 0); "#,###,###"); " "; -1; 14)+txt_Pad(String:C10(Round:C94($totalCurrent+$total60+$total90+$total120+$totalOver120+$totalUnknown; 0); "#,###,###"); " "; -1; 14)

Print form:C5([Raw_Materials_Locations:25]; "printLinePlain")
PAGE BREAK:C6

uThermoClose
<>PrintToPDF:=False:C215
$reset:=PDF_setUp
// Modified by: Mel Bohince (9/5/19) return the specifed doc var, not the one that was doing the reset
$0:=$pathToPDF