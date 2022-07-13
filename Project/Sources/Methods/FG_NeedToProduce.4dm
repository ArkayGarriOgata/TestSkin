//%attributes = {}
// Method: FG_NeedToProduce () -> 
// ----------------------------------------------------
// by: mel: 10/14/04, 11:07:24
//------
// Description:
// calculate how much should be planned by week

READ ONLY:C145([Customers:16])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods_Locations:35])

C_TEXT:C284($t; $cr)
C_LONGINT:C283($weeks; $rel; $hit; $wk; $i; $numRecs; $rel)

$t:=Char:C90(9)
$cr:=Char:C90(13)
$weeks:=12
ARRAY LONGINT:C221($aWeekNo; $weeks)
ARRAY LONGINT:C221($aWeekDemand; $weeks)
ARRAY LONGINT:C221($aWeekProduction; $weeks)
ARRAY LONGINT:C221($aWeekNeed; $weeks)
$aWeekNo{1}:=util_weekNumber(4D_Current_date)
$aWeekDemand{1}:=0
$aWeekProduction{1}:=0
$aWeekNeed{1}:=0
For ($wk; 1; Size of array:C274($aWeekNo)-1)
	$aWeekNo{$wk+1}:=$aWeekNo{1}+$wk
End for 

CONFIRM:C162("Update Release count on F/G records?"; "Update"; "As-is")
If (OK=1)
	Batch_ForecastAnalysis("UPDATE ALL AND SEND EMAIL TO MEL")
End if 

CONFIRM:C162("Restrict to only F/G's Releases?"; "Restrict"; "Not restricted")
If (OK=1)
	$restrict:=True:C214
Else 
	$restrict:=False:C215
End if 

C_BOOLEAN:C305($onlyELC)
CONFIRM:C162("Only report on ALL Estee Lauder products?"; "EL"; "Search")
If (OK=1)
	$onlyELC:=True:C214
Else 
	$onlyELC:=False:C215
End if 

If ($onlyELC)
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numRecs:=ELC_query(->[Finished_Goods:26]CustID:2)  //get elc's inventory
		
		
	Else 
		
		$Critiria:=ELC_getName
		QUERY:C277([Finished_Goods:26]; [Customers:16]ParentCorp:19=$Critiria)
		$numRecs:=Records in selection:C76([Finished_Goods:26])
		
	End if   // END 4D Professional Services : January 2019 ELC_query
Else 
	QUERY:C277([Finished_Goods:26])
End if 

If ($restrict)
	QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]FRCST_NumberOfReleases:69>0)
End if 

CREATE SET:C116([Finished_Goods:26]; "theChoosen")

//summarize open production
BatchJobcalc
//summarize inventory
BatchFGinventor

C_TIME:C306($docRef)
docName:="NeedToProduce"+fYYMMDD(4D_Current_date)+".xls"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	C_TEXT:C284(xTitle; xText)
	xTitle:="Need To Produce"
	xText:="Customer"+$t+"Line"+$t+"S&S_Nº"+$t+"ColorSpecMaster"+$t+"ProductCode"+$t+"F/G_Inventory"
	For ($wk; 1; $weeks)
		xText:=xText+$t+"Wk"+String:C10($aWeekNo{$wk})+"Demand"+$t+"Wk"+String:C10($aWeekNo{$wk})+"Production"+$t+"Wk"+String:C10($aWeekNo{$wk})+"Need"
	End for 
	xText:=xText+$t+"Surplus"+$cr
	
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	
	USE SET:C118("theChoosen")
	CLEAR SET:C117("theChoosen")
	
	$numRecs:=Records in selection:C76([Finished_Goods:26])
	C_BOOLEAN:C305($break)
	$break:=False:C215
	ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]OutLine_Num:4; >; [Finished_Goods:26]ProductCode:1; >)
	
	uThermoInit($numRecs; "Reporting Need To Produce")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			For ($wk; 1; $weeks)
				$aWeekDemand{$wk}:=0
				$aWeekProduction{$wk}:=0
				$aWeekNeed{$wk}:=0
			End for 
			
			$binCursor:=Find in array:C230(<>aFGKey; [Finished_Goods:26]FG_KEY:47)
			If ($binCursor>-1)
				$fg:=<>aQty_FG{$binCursor}
			Else 
				$fg:=0
			End if 
			
			xText:=xText+CUST_getName([Finished_Goods:26]CustID:2)+$t+[Finished_Goods:26]Line_Brand:15+$t+[Finished_Goods:26]OutLine_Num:4+$t+[Finished_Goods:26]ColorSpecMaster:77+$t+[Finished_Goods:26]ProductCode:1+$t+String:C10($fg)
			
			$jobCursor:=Find in array:C230(<>aJMIKey; [Finished_Goods:26]FG_KEY:47)
			If ($jobCursor>-1)
				For ($wk; 1; $weeks)
					$aWeekProduction{$wk}:=<>aQty_JMIweekly{$jobCursor}{$wk}
				End for 
			End if 
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1)
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aRelDate; [Customers_ReleaseSchedules:46]OpenQty:16; $aRelQty)
			For ($rel; 1; Size of array:C274($aRelDate))
				$wk:=util_weekNumber($aRelDate{$rel})
				$hit:=Find in array:C230($aWeekNo; $wk)
				If ($hit=-1)
					If ($wk<$aWeekNo{1})
						$hit:=1
					Else 
						$hit:=$weeks
					End if 
				End if 
				$aWeekDemand{$hit}:=$aWeekDemand{$hit}+$aRelQty{$rel}
			End for 
			
			//calc $aWeekNeed
			$surplus:=$fg
			For ($wk; 1; $weeks)
				$aWeekNeed{$wk}:=$aWeekDemand{$wk}-$aWeekProduction{$wk}
				If ($aWeekNeed{$wk}>0)
					If ($surplus>$aWeekNeed{$wk})
						$surplus:=$surplus-$aWeekNeed{$wk}
						$aWeekNeed{$wk}:=0
					Else 
						$aWeekNeed{$wk}:=$aWeekNeed{$wk}-$surplus
						$surplus:=0
					End if 
				Else 
					$aWeekNeed{$wk}:=0
					$surplus:=$surplus+$aWeekProduction{$wk}-$aWeekDemand{$wk}
				End if 
			End for 
			
			//print 'em
			For ($wk; 1; $weeks)
				xText:=xText+$t+String:C10($aWeekDemand{$wk})+$t+String:C10($aWeekProduction{$wk})+$t+String:C10($aWeekNeed{$wk})
			End for 
			xText:=xText+$t+String:C10($surplus)+$cr
			
			NEXT RECORD:C51([Finished_Goods:26])
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		ARRAY TEXT:C222($_FG_KEY; 0)
		ARRAY TEXT:C222($_CustID; 0)
		ARRAY TEXT:C222($_Line_Brand; 0)
		ARRAY TEXT:C222($_OutLine_Num; 0)
		ARRAY TEXT:C222($_ColorSpecMaster; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		
		
		SELECTION TO ARRAY:C260([Finished_Goods:26]FG_KEY:47; $_FG_KEY; \
			[Finished_Goods:26]CustID:2; $_CustID; \
			[Finished_Goods:26]Line_Brand:15; $_Line_Brand; \
			[Finished_Goods:26]OutLine_Num:4; $_OutLine_Num; \
			[Finished_Goods:26]ColorSpecMaster:77; $_ColorSpecMaster; \
			[Finished_Goods:26]ProductCode:1; $_ProductCode)
		
		For ($i; 1; $numRecs; 1)
			
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			For ($wk; 1; $weeks)
				$aWeekDemand{$wk}:=0
				$aWeekProduction{$wk}:=0
				$aWeekNeed{$wk}:=0
			End for 
			
			$binCursor:=Find in array:C230(<>aFGKey; $_FG_KEY{$i})
			If ($binCursor>-1)
				$fg:=<>aQty_FG{$binCursor}
			Else 
				$fg:=0
			End if 
			
			xText:=xText+CUST_getName($_CustID{$i})+$t+$_Line_Brand{$i}+$t+$_OutLine_Num{$i}+$t+$_ColorSpecMaster{$i}+$t+$_ProductCode{$i}+$t+String:C10($fg)
			
			$jobCursor:=Find in array:C230(<>aJMIKey; $_FG_KEY{$i})
			If ($jobCursor>-1)
				For ($wk; 1; $weeks)
					$aWeekProduction{$wk}:=<>aQty_JMIweekly{$jobCursor}{$wk}
				End for 
			End if 
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=$_ProductCode{$i})
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aRelDate; [Customers_ReleaseSchedules:46]OpenQty:16; $aRelQty)
			For ($rel; 1; Size of array:C274($aRelDate))
				$wk:=util_weekNumber($aRelDate{$rel})
				$hit:=Find in array:C230($aWeekNo; $wk)
				If ($hit=-1)
					If ($wk<$aWeekNo{1})
						$hit:=1
					Else 
						$hit:=$weeks
					End if 
				End if 
				$aWeekDemand{$hit}:=$aWeekDemand{$hit}+$aRelQty{$rel}
			End for 
			
			
			$surplus:=$fg
			For ($wk; 1; $weeks)
				$aWeekNeed{$wk}:=$aWeekDemand{$wk}-$aWeekProduction{$wk}
				If ($aWeekNeed{$wk}>0)
					If ($surplus>$aWeekNeed{$wk})
						$surplus:=$surplus-$aWeekNeed{$wk}
						$aWeekNeed{$wk}:=0
					Else 
						$aWeekNeed{$wk}:=$aWeekNeed{$wk}-$surplus
						$surplus:=0
					End if 
				Else 
					$aWeekNeed{$wk}:=0
					$surplus:=$surplus+$aWeekProduction{$wk}-$aWeekDemand{$wk}
				End if 
			End for 
			
			For ($wk; 1; $weeks)
				xText:=xText+$t+String:C10($aWeekDemand{$wk})+$t+String:C10($aWeekProduction{$wk})+$t+String:C10($aWeekNeed{$wk})
			End for 
			xText:=xText+$t+String:C10($surplus)+$cr
			
			uThermoUpdate($i)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	SEND PACKET:C103($docRef; xText)
	uThermoClose
	
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
	
Else 
	BEEP:C151
	ALERT:C41("Couldn't create a document.")
End if 