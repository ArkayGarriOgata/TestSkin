//%attributes = {"publishedWeb":true}
//(p) rEffecRun2Disk
//$1- text - folder path for document
//$2 - string - report division
//print effeciency Running report to disk
//all arrays are populated during execution of rEffecMr2Disk
//• 2/23/98 cs created
C_TEXT:C284(xText; $1)
C_LONGINT:C283($Count; $i)
C_TEXT:C284($T)
C_TEXT:C284($Format; $Dollar)
C_REAL:C285($Var; $Tot; $VarTot; $DolTot; $VarGrand; $DolGrand)
C_BOOLEAN:C305($0)
C_TEXT:C284($2)  //report division

ON EVENT CALL:C190("eCancelPrint")

<>fContinue:=True:C214
$0:=False:C215  //used to indicate that reporting to disk completed
$Format:="###,###,##0.00"
$Dollar:="$#,###,##0.00"
$T:=Char:C90(9)
vDoc:=?00:00:00?
//setup titles
$Count:=Records in selection:C76([Job_Forms_Machine_Tickets:61])
vDoc:=Create document:C266($1+"Run Efficiency "+String:C10(dDateBegin)+"-"+String:C10(dDateEnd))

If (vDoc#?00:00:00?)
	//*setup header
	xText:=String:C10(4D_Current_date)+($t*3)+"Running Efficiency for"+$2+Char:C90(13)+($t*4)+"for Date Range: "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)+Char:C90(13)+Char:C90(13)
	xText:="Cost Center"+$t+"Job Form"+$t+"Customer | Line"+$t+"Seq"+$t+"Actual Run"+$t+"Standard Run"+$t+"Run Varience"+$t+"OOP MR"+$t+"Total"+$t+"Effeciency % (Standard/Actual)"+Char:C90(13)
	SEND PACKET:C103(vDoc; xText)
	$CurCC:=""
	FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])  //printing from previous selection & Sort
	uThermoInit($Count; "Printing Run Effeciencies")
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		For ($i; 1; $Count)
			xText:=""
			//* populate text for send packet  
			If ([Job_Forms_Machine_Tickets:61]CostCenterID:2#$CurCC)
				xText:=[Job_Forms_Machine_Tickets:61]CostCenterID:2+$t
				xText:=xText+aDesc{$i}+Char:C90(13)
				$CurCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
				SEND PACKET:C103(vDoc; xText)
				xText:=$t
			Else 
				xText:=$t
			End if 
			$Var:=[Job_Forms_Machine_Tickets:61]Run_AdjStd:15-[Job_Forms_Machine_Tickets:61]Run_Act:7  //$varience for this item
			$Tot:=$Var*arNum1{$i}  //tot $ for this item
			xText:=xText+[Job_Forms_Machine_Tickets:61]JobForm:1+$t  //job item
			xText:=xText+aText{$i}+$t  //custoemr/line
			xText:=xText+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3)+$t  //sequence 
			xText:=xText+String:C10([Job_Forms_Machine_Tickets:61]Run_Act:7; $Format)+$t  //actals
			xText:=xText+String:C10([Job_Forms_Machine_Tickets:61]Run_AdjStd:15; $Format)+$t  //budget
			xText:=xText+String:C10($Var; $Format)+$t  //varience
			xText:=xText+String:C10(arNum1{$i}; $Dollar)+$t  //$/hr
			xText:=xText+String:C10(arNum1{$i}*$Var; $Dollar)+$t  //$ value of varience
			xText:=xText+String:C10(([Job_Forms_Machine_Tickets:61]Run_AdjStd:15/[Job_Forms_Machine_Tickets:61]Run_Act:7)*100; $Format)+"%"+Char:C90(13)  //eff
			$VarTot:=$VarTot+$Var
			$DolTot:=$DolTot+$Tot
			SEND PACKET:C103(vDoc; xText)  //*write to disk
			NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
			
			If ($CurCC#[Job_Forms_Machine_Tickets:61]CostCenterID:2) | (End selection:C36([Job_Forms_Machine_Tickets:61]))  //*if the next Cost center is different or endo of records
				xText:=($t*5)+"Total for CC"+$t+String:C10($VarTot; $Format)+$t+$t+String:C10($DolTot; $Dollar)+Char:C90(13)+Char:C90(13)  //print CC totals
				$VarGrand:=$VarGrand+$VarTot  //add to grand totals
				$DolGrand:=$DolGrand+$DolTot
				$DolTot:=0
				$VarTot:=0
				SEND PACKET:C103(vDoc; xText)
				
				If (End selection:C36([Job_Forms_Machine_Tickets:61]))  //if end of records print grand totals for report
					xText:=($t*5)+"Grand Total"+$t+String:C10($VarGrand; $Format)+$t+$t+String:C10($DolGrand; $Dollar)
					SEND PACKET:C103(vDoc; xText)
					CLOSE DOCUMENT:C267(vDoc)
					xText:=""
					$0:=True:C214  //*report completed normally - continue to next report
				End if 
			End if 
			
			If (Not:C34(<>fContinue))  //*user has canceled report
				$i:=$Count+1
				CLOSE DOCUMENT:C267(vDoc)
			End if 
			uThermoUpdate($i)
		End for 
		
	Else 
		
		//laghzaoui line 131 to line 140
		
		ARRAY TEXT:C222($_CostCenterID; 0)
		ARRAY REAL:C219($_Run_AdjStd; 0)
		ARRAY REAL:C219($_Run_Act; 0)
		ARRAY INTEGER:C220($_Sequence; 0)
		ARRAY TEXT:C222($_JobForm; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID; \
			[Job_Forms_Machine_Tickets:61]Run_AdjStd:15; $_Run_AdjStd; \
			[Job_Forms_Machine_Tickets:61]Run_Act:7; $_Run_Act; \
			[Job_Forms_Machine_Tickets:61]Sequence:3; $_Sequence; \
			[Job_Forms_Machine_Tickets:61]JobForm:1; $_JobForm)
		
		For ($i; 1; $Count; 1)
			xText:=""
			//* populate text for send packet  
			If ($_CostCenterID{$i}#$CurCC)
				xText:=$_CostCenterID{$i}+$t
				xText:=xText+aDesc{$i}+Char:C90(13)
				$CurCC:=$_CostCenterID{$i}
				SEND PACKET:C103(vDoc; xText)
				xText:=$t
			Else 
				xText:=$t
			End if 
			$Var:=$_Run_AdjStd{$i}-$_Run_Act{$i}  //$varience for this item
			$Tot:=$Var*arNum1{$i}  //tot $ for this item
			xText:=xText+$_JobForm{$i}+$t  //job item
			xText:=xText+aText{$i}+$t  //custoemr/line
			xText:=xText+String:C10($_Sequence{$i})+$t  //sequence 
			xText:=xText+String:C10($_Run_Act{$i}; $Format)+$t  //actals
			xText:=xText+String:C10($_Run_AdjStd{$i}; $Format)+$t  //budget
			xText:=xText+String:C10($Var; $Format)+$t  //varience
			xText:=xText+String:C10(arNum1{$i}; $Dollar)+$t  //$/hr
			xText:=xText+String:C10(arNum1{$i}*$Var; $Dollar)+$t  //$ value of varience
			xText:=xText+String:C10(($_Run_AdjStd{$i}/$_Run_Act{$i})*100; $Format)+"%"+Char:C90(13)  //eff
			$VarTot:=$VarTot+$Var
			$DolTot:=$DolTot+$Tot
			SEND PACKET:C103(vDoc; xText)  //*write to disk
			
			//add by 4d
			
			$Iter:=$i
			$Iter:=$Iter+1
			
			$CostCenterID:=""
			If ($Iter>$Count)
				
			Else 
				$CostCenterID:=$_CostCenterID{$Iter}
				
			End if 
			If ($CurCC#$CostCenterID) | ($Iter>$Count)  //*if the next Cost center is different or endo of records
				xText:=($t*5)+"Total for CC"+$t+String:C10($VarTot; $Format)+$t+$t+String:C10($DolTot; $Dollar)+Char:C90(13)+Char:C90(13)  //print CC totals
				$VarGrand:=$VarGrand+$VarTot  //add to grand totals
				$DolGrand:=$DolGrand+$DolTot
				$DolTot:=0
				$VarTot:=0
				SEND PACKET:C103(vDoc; xText)
				
				If ($Iter>$Count)  //if end of records print grand totals for report
					xText:=($t*5)+"Grand Total"+$t+String:C10($VarGrand; $Format)+$t+$t+String:C10($DolGrand; $Dollar)
					SEND PACKET:C103(vDoc; xText)
					CLOSE DOCUMENT:C267(vDoc)
					xText:=""
					$0:=True:C214  //*report completed normally - continue to next report
				End if 
			End if 
			
			If (Not:C34(<>fContinue))  //*user has canceled report
				$i:=$Count+1
				CLOSE DOCUMENT:C267(vDoc)
			End if 
			uThermoUpdate($i)
		End for 
		
	End if   // END 4D Professional Services : January 2019 
	
	uThermoClose
Else 
	ALERT:C41("Running Disk file could not be created.")
End if 

ON EVENT CALL:C190("")
