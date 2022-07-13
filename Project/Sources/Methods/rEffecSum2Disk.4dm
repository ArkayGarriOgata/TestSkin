//%attributes = {"publishedWeb":true}
//(p) rEffecSum2Disk
//$1- text - folder path for document
//$2 - string - report division
//print effeciency Running report to disk
//all arrays are populated during execution of rEffecMr2Disk
//• 2/23/98 cs created
//• 3/3/98 cs changed where production comes from (now Mac@tic@]goodunits)
//  prev JMI act - also modofied looping to handle printing of last CC in list
//  this was getting dropped because of compares
C_TEXT:C284(xText; $1)
C_LONGINT:C283($Count; $i)
C_TEXT:C284($T)
C_TEXT:C284($Format; $Dollar)
C_REAL:C285($MrATot; $ActMr; $MrSTot; $StdMr; $RunATot; $ActRun; $RunSTot; $StdRun; $ProdTot; $Prod; $DownATot; $ActDown)
C_BOOLEAN:C305($0)
C_TEXT:C284($2)  //report division
C_TEXT:C284($Zero)

ON EVENT CALL:C190("eCancelPrint")

<>fContinue:=True:C214
$0:=False:C215  //used to indicate that reporting to disk completed
$Zero:="- 0 -"
$Format:="###,###,##0.00"
$Dollar:="$#,###,##0.00"
$T:=Char:C90(9)
vDoc:=?00:00:00?
//setup titles
$Count:=Records in selection:C76([Job_Forms_Machine_Tickets:61])
vDoc:=Create document:C266($1+"Summary Effcy "+String:C10(dDateBegin)+"-"+String:C10(dDateEnd))
//*setup header

If (vDoc#?00:00:00?)
	xText:=String:C10(4D_Current_date)+($t*3)+"Summary Efficiencies for"+$2+Char:C90(13)+($t*4)+"for Date Range: "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)+Char:C90(13)+Char:C90(13)
	xText:="Cost Center"+$t+"Production"+$t+"Actual MR"+$t+"Std MR"+$t+"MR Eff"+$t+"Actual Run"+$t+"Std Run"+$t+"Run Eff"+$t+"Total Actual"+$t+"Total Std"+$t+"Total Eff"+$t+"Actual Down"+$t+"Down %"+$t+"Down Budget"+$t+"Actual Impressions/Hr"+$t+"Std Impressions/Hr"+Char:C90(13)
	SEND PACKET:C103(vDoc; xText)
	FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])  //printing from previous selection & Sort
	$CurCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
	uThermoInit($Count; "Printing Summary Report")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $Count+1)  //+1 to get system to print last items.
			//* populate text for send packet  
			//*use $i-1
			If ([Job_Forms_Machine_Tickets:61]CostCenterID:2#$CurCC)  //* CC changed, print total for CC 
				xText:=""  //clear
				$CurCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2  //set next CC
				PREVIOUS RECORD:C110([Job_Forms_Machine_Tickets:61])  //go back one record to get needed data
				xText:=[Job_Forms_Machine_Tickets:61]CostCenterID:2+" "+aDesc{$i-1}+$t  //CC & description
				xText:=xText+String:C10($Prod; $Format)+$t  //production
				xText:=xText+String:C10($ActMr; $Format)+$t  //ACtual Make Ready
				xText:=xText+String:C10($StdMr; $Format)+$t  //budgeted Make ready
				
				If ($ActMr>0)  //Eff, check for div by zero
					xText:=xText+String:C10(($StdMr/$ActMr)*100; $Format)+"%"+$t
				Else 
					xText:=xText+$Zero+$t
				End if 
				
				xText:=xText+String:C10($ActRun; $Format)+$t  //Actual Run hrs
				xText:=xText+String:C10($StdRun; $Format)+$t  //budgeted Run hours
				
				If ($ActRun>0)  //Eff, check for div by zero
					xText:=xText+String:C10(($StdRun/$ActRun)*100; $Format)+"%"+$t
				Else 
					xText:=xText+$Zero+$t
				End if 
				xText:=xText+String:C10($ActRun+$ActMr; $Format)+$t  //total actual hrs
				xText:=xText+String:C10($StdMr+$StdRun; $Format)+$t  //budgeted hrs
				
				If ($ActRun+$ActMr>0)  //Eff, check for div by zero
					xText:=xText+String:C10(($StdRun+$StdMr)/($ActRun+$ActMr)*100; $Format)+"%"+$t
				Else 
					xText:=xText+$Zero+$t
				End if 
				xText:=xText+String:C10($ActDown; $Format)+$t  //Actual down time
				xText:=xText+String:C10($ActDown/($ActDown+$ActRun+$ActMr)*100; $Format)+"%"+$t  //down% of total actual
				xText:=xText+String:C10(ayDown_Bud{$i-1}; $Format)+$t  //budgeted down
				
				If ($ActRun>0)  //actual impressions/hr, check for div by zero
					xText:=xText+String:C10($Prod/$ActRun; $Format)+$t
				Else 
					xText:=xText+$Zero+$t
				End if 
				
				If ($StdRun>0)  //budget impressions/hr, check for div by zero
					xText:=xText+String:C10($Prod/$StdRun; $Format)+Char:C90(13)
				Else 
					xText:=xText+$Zero+Char:C90(13)
				End if 
				SEND PACKET:C103(vDoc; xText)
				$MrATot:=$ActMr+$MrATot  //* sum for report total
				$MrSTot:=$StdMr+$MrSTot
				$RunATot:=$ActRun+$RunATot
				$RunSTot:=$StdRun+$RunSTot
				$ProdTot:=$Prod+$ProdTot
				$DownATot:=$ActDown+$DownATot
				
				$ActMr:=0  //clear for next record
				$ActRun:=0
				$ActDown:=0
				$StdMr:=0
				$StdRun:=0
				$Prod:=0
				NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])  //return to record that changed CC
			End if 
			//* summ for each CC  
			$ActMr:=$ActMr+[Job_Forms_Machine_Tickets:61]MR_Act:6
			$ActRun:=$ActRun+[Job_Forms_Machine_Tickets:61]Run_Act:7
			$ActDown:=$ActDown+[Job_Forms_Machine_Tickets:61]DownHrs:11
			$StdMr:=$StdMr+[Job_Forms_Machine_Tickets:61]MR_AdjStd:14
			$StdRun:=$StdRun+[Job_Forms_Machine_Tickets:61]Run_AdjStd:15
			$Prod:=$Prod+[Job_Forms_Machine_Tickets:61]Good_Units:8
			NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
			
			If (Not:C34(<>fContinue))  //*user has canceled report
				$i:=$Count+1
				CLOSE DOCUMENT:C267(vDoc)
			End if 
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		// Laghzaoui i use $Iter to do previous and next
		
		ARRAY TEXT:C222($_CostCenterID; 0)
		ARRAY REAL:C219($_MR_Act; 0)
		ARRAY REAL:C219($_Run_Act; 0)
		ARRAY REAL:C219($_DownHrs; 0)
		ARRAY REAL:C219($_MR_AdjStd; 0)
		ARRAY REAL:C219($_Run_AdjStd; 0)
		ARRAY LONGINT:C221($_Good_Units; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID; \
			[Job_Forms_Machine_Tickets:61]MR_Act:6; $_MR_Act; \
			[Job_Forms_Machine_Tickets:61]Run_Act:7; $_Run_Act; \
			[Job_Forms_Machine_Tickets:61]DownHrs:11; $_DownHrs; \
			[Job_Forms_Machine_Tickets:61]MR_AdjStd:14; $_MR_AdjStd; \
			[Job_Forms_Machine_Tickets:61]Run_AdjStd:15; $_Run_AdjStd; \
			[Job_Forms_Machine_Tickets:61]Good_Units:8; $_Good_Units)
		
		C_LONGINT:C283($Iter)
		$Iter:=1
		
		For ($i; 1; $Count+1)  //+1 to get system to print last items.
			//* populate text for send packet  
			//*use $i-1
			If ($_CostCenterID{$Iter}#$CurCC)  //* CC changed, print total for CC 
				xText:=""  //clear
				$CurCC:=$_CostCenterID{$Iter}  //set next CC
				$Iter:=$Iter-1
				xText:=$_CostCenterID{$Iter}+" "+aDesc{$i-1}+$t  //CC & description
				xText:=xText+String:C10($Prod; $Format)+$t  //production
				xText:=xText+String:C10($ActMr; $Format)+$t  //ACtual Make Ready
				xText:=xText+String:C10($StdMr; $Format)+$t  //budgeted Make ready
				
				If ($ActMr>0)  //Eff, check for div by zero
					xText:=xText+String:C10(($StdMr/$ActMr)*100; $Format)+"%"+$t
				Else 
					xText:=xText+$Zero+$t
				End if 
				
				xText:=xText+String:C10($ActRun; $Format)+$t  //Actual Run hrs
				xText:=xText+String:C10($StdRun; $Format)+$t  //budgeted Run hours
				
				If ($ActRun>0)  //Eff, check for div by zero
					xText:=xText+String:C10(($StdRun/$ActRun)*100; $Format)+"%"+$t
				Else 
					xText:=xText+$Zero+$t
				End if 
				xText:=xText+String:C10($ActRun+$ActMr; $Format)+$t  //total actual hrs
				xText:=xText+String:C10($StdMr+$StdRun; $Format)+$t  //budgeted hrs
				
				If ($ActRun+$ActMr>0)  //Eff, check for div by zero
					xText:=xText+String:C10(($StdRun+$StdMr)/($ActRun+$ActMr)*100; $Format)+"%"+$t
				Else 
					xText:=xText+$Zero+$t
				End if 
				xText:=xText+String:C10($ActDown; $Format)+$t  //Actual down time
				xText:=xText+String:C10($ActDown/($ActDown+$ActRun+$ActMr)*100; $Format)+"%"+$t  //down% of total actual
				xText:=xText+String:C10(ayDown_Bud{$i-1}; $Format)+$t  //budgeted down
				
				If ($ActRun>0)  //actual impressions/hr, check for div by zero
					xText:=xText+String:C10($Prod/$ActRun; $Format)+$t
				Else 
					xText:=xText+$Zero+$t
				End if 
				
				If ($StdRun>0)  //budget impressions/hr, check for div by zero
					xText:=xText+String:C10($Prod/$StdRun; $Format)+Char:C90(13)
				Else 
					xText:=xText+$Zero+Char:C90(13)
				End if 
				SEND PACKET:C103(vDoc; xText)
				$MrATot:=$ActMr+$MrATot  //* sum for report total
				$MrSTot:=$StdMr+$MrSTot
				$RunATot:=$ActRun+$RunATot
				$RunSTot:=$StdRun+$RunSTot
				$ProdTot:=$Prod+$ProdTot
				$DownATot:=$ActDown+$DownATot
				
				$ActMr:=0  //clear for next record
				$ActRun:=0
				$ActDown:=0
				$StdMr:=0
				$StdRun:=0
				$Prod:=0
				$Iter:=$Iter+1
				
			End if 
			//* summ for each CC  
			$ActMr:=$ActMr+$_MR_Act{$Iter}
			$ActRun:=$ActRun+$_Run_Act{$Iter}
			$ActDown:=$ActDown+$_DownHrs{$Iter}
			$StdMr:=$StdMr+$_MR_AdjStd{$Iter}
			$StdRun:=$StdRun+$_Run_AdjStd{$Iter}
			$Prod:=$Prod+$_Good_Units{$Iter}
			
			$Iter:=$Iter+1
			
			If (Not:C34(<>fContinue))  //*user has canceled report
				$i:=$Count+1
				CLOSE DOCUMENT:C267(vDoc)
			End if 
			uThermoUpdate($i)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	If (<>fContinue) & (End selection:C36([Job_Forms_Machine_Tickets:61]))  //if report is not canceled & at end of records
		//* print total line
		xText:=""  //clear
		xText:=Char:C90(13)+"Grand Totals"+$t  //cc description area
		xText:=xText+String:C10($ProdTot; $Format)+$t  //production
		xText:=xText+String:C10($MrATot; $Format)+$t  //ACtual Make Ready
		xText:=xText+String:C10($MrSTot; $Format)+$t  //budgeted Make ready
		
		If ($MrATot>0)  //Eff, check for div by zero
			xText:=xText+String:C10(($MrSTot/$MrATot)*100; $Format)+"%"+$t
		Else 
			xText:=xText+$Zero+$t
		End if 
		xText:=xText+String:C10($RunATot; $Format)+$t  //Actual Run hrs
		xText:=xText+String:C10($RunSTot; $Format)+$t  //budgeted Run hours
		
		If ($RunATot>0)  //Eff, check for div by zero
			xText:=xText+String:C10(($RunSTot/$RunATot)*100; $Format)+"%"+$t
		Else 
			xText:=xText+$Zero+$t
		End if 
		xText:=xText+String:C10($RunATot+$MrATot; $Format)+$t  //total actual hrs
		xText:=xText+String:C10($MrSTot+$RunSTot; $Format)+$t  //budgeted hrs
		
		If ($RunATot+$MrATot>0)  //Eff, check for div by zero
			xText:=xText+String:C10(($MrSTot+$RunSTot)/($RunATot+$MrATot)*100; $Format)+"%"+$t
		Else 
			xText:=xText+$Zero+$t
		End if 
		xText:=xText+String:C10($DownATot; $Format)+$t  //Actual down time
		xText:=xText+String:C10($DownATot/($DownATot+$RunATot+$MrATot)*100; $Format)+"%"+$t  //down% of total actual
		xText:=xText+$t  //budgeted down - do nothing here for totals
		
		If ($RunATot>0)  //actual impressions/hr, check for div by zero
			xText:=xText+String:C10($ProdTot/$RunATot; $Format)+$t
		Else 
			xText:=xText+$Zero+$t
		End if 
		
		If ($RunSTot>0)  //budget impressions/hr, check for div by zero
			xText:=xText+String:C10($ProdTot/$RunSTot; $Format)+Char:C90(13)
		Else 
			xText:=xText+$Zero+Char:C90(13)
		End if 
		SEND PACKET:C103(vDoc; xText)
		$0:=True:C214
		CLOSE DOCUMENT:C267(vDoc)
	End if 
	uThermoClose
Else 
	ALERT:C41("Summary Disk file could not be created.")
End if 

ON EVENT CALL:C190("")