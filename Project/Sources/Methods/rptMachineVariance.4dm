//%attributes = {"publishedWeb":true}
//PM:  rptMachineVariance  UPR2054 090199  mlb
//report hr and $ variances by machinc

C_DATE:C307($1; $2; dDateEnd; dDateBegin)
C_LONGINT:C283($i; $numJobs; $j; $gridSize)
C_REAL:C285($printingHrs; $gluingHrs)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

$gridSize:=21  //=columns of data
$t:=","
$cr:="\r"


// Modified by: Mel Bohince (8/10/21) setup local $_aStdCC arrays
ARRAY TEXT:C222($_aStdCC; 0)
ARRAY TEXT:C222($_aCostCtrDes; 0)
ARRAY TEXT:C222($_aCostCtrGroup; 0)
READ ONLY:C145([Cost_Centers:27])
QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ProdCC:39=True:C214)
SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $_aStdCC; [Cost_Centers:27]Description:3; $_aCostCtrDes; [Cost_Centers:27]cc_Group:2; $_aCostCtrGroup)
SORT ARRAY:C229($_aStdCC; $_aCostCtrDes; $_aCostCtrGroup; >)
// end Modified by: Mel Bohince (8/10/21) setup local $_$_aStdCC arrays

MESSAGES OFF:C175

//*Find the jobs to report
If (Count parameters:C259=2)
	dDateBegin:=$1
	dDateEnd:=$2
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]ClosedDate:11>=dDateBegin; *)
	QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]ClosedDate:11<=dDateEnd)
	OK:=1
Else 
	//NewWindow (240;115;6;0;"Select Closed Date")
	$winRef:=Open form window:C675([zz_control:1]; "DateRange2")  // Modified by: Mel Bohince (8/10/21) 
	dDateBegin:=4D_Current_date-1
	dDateEnd:=dDateBegin
	DIALOG:C40([zz_control:1]; "DateRange2")
	CLOSE WINDOW:C154($winRef)
	If (OK=1)
		If (bSearch=1)
			QUERY:C277([Job_Forms:42])  //the Find Button
		Else 
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]ClosedDate:11>=dDateBegin; *)
			QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]ClosedDate:11<=dDateEnd)
		End if 
	End if 
End if   //params

If (OK=1)
	$numJobs:=Records in selection:C76([Job_Forms:42])
	If ($numJobs>0)
		If (OK=1)
			docName:="MachineVarianceRpt_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
			$docRef:=util_putFileName(->docName)
			If ($docRef#?00:00:00?)
				OK:=1
			End if 
			
			
			If (OK=1)
				$toleranceTrigger:=20
				If (Count parameters:C259=0)
					$toleranceTrigger:=Num:C11(Request:C163("Flag Machines with a Total$ variance greater than ?%"; "20"))
				End if 
				If ($toleranceTrigger>0)
					$toleranceTrigger:=$toleranceTrigger/100  //convert to decimal
				End if 
				//*Init the CostCenters
				CostCtrCurrent("init"; String:C10(dDateEnd; Internal date short special:K1:4))  //$_aStdCC is populated in here
				
				$numCC:=Size of array:C274($_aStdCC)
				ARRAY REAL:C219($aHrsStd; $numCC)
				ARRAY REAL:C219($aHrsAct; $numCC)
				ARRAY REAL:C219($aDolLabStd; $numCC)  //labor
				ARRAY REAL:C219($aDolLabAct; $numCC)
				ARRAY REAL:C219($aDolBurStd; $numCC)  //burden
				ARRAY REAL:C219($aDolBurAct; $numCC)
				
				C_REAL:C285($aTHrsStd; $aTHrsAct; $aTDolLabStd; $aTDolLabAct; $aTDolBurStd; $aTDolBurAct)
				//*Get related records    
				
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Machines:43])+" file. Please Wait...")
				RELATE MANY SELECTION:C340([Job_Forms_Machines:43]JobForm:1)
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Machine_Tickets:61])+" file. Please Wait...")
				RELATE MANY SELECTION:C340([Job_Forms_Machine_Tickets:61]JobForm:1)
				zwStatusMsg(""; "")
				
				REDUCE SELECTION:C351([Job_Forms:42]; 0)
				ARRAY TEXT:C222($aPldCC; 0)
				ARRAY REAL:C219($aPldMR; 0)
				ARRAY REAL:C219($aPldRun; 0)
				SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $aPldCC; [Job_Forms_Machines:43]Planned_MR_Hrs:15; $aPldMR; [Job_Forms_Machines:43]Planned_RunHrs:37; $aPldRun)
				REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
				ARRAY TEXT:C222($aActCC; 0)
				ARRAY REAL:C219($aActMR; 0)
				ARRAY REAL:C219($aActRun; 0)
				SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $aActCC; [Job_Forms_Machine_Tickets:61]MR_Act:6; $aActMR; [Job_Forms_Machine_Tickets:61]Run_Act:7; $aActRun)
				REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
				
				For ($i; 1; Size of array:C274($aPldCC))
					$hit:=Find in array:C230($_aStdCC; $aPldCC{$i})
					If ($hit>-1)
						$aHrsStd{$hit}:=$aHrsStd{$hit}+($aPldMR{$i}+$aPldRun{$i})
					End if 
				End for 
				ARRAY TEXT:C222($aPldCC; 0)
				ARRAY REAL:C219($aPldMR; 0)
				ARRAY REAL:C219($aPldRun; 0)
				
				For ($i; 1; Size of array:C274($aActCC))
					$hit:=Find in array:C230($_aStdCC; $aActCC{$i})
					If ($hit>-1)
						$aHrsAct{$hit}:=$aHrsAct{$hit}+($aActMR{$i}+$aActRun{$i})
					End if 
				End for 
				ARRAY TEXT:C222($aActCC; 0)
				ARRAY REAL:C219($aActMR; 0)
				ARRAY REAL:C219($aActRun; 0)
				
				//*   Send Header        
				xTitle:="Machine Variance - Closed from "+String:C10(dDateBegin; <>MIDDATE)+" to "+String:C10(dDateEnd; <>MIDDATE)
				xText:="NOTE: Copy/Paste the text below into a spreadsheet for the columns to align:"+$cr+$cr+xTitle+$cr
				xText:=xText+$cr+"Cost Ctr"+$t+"HrsStd"+$t+"HrsAct"+$t+"HrsVar"+$t+"Labor$Std"+$t+"Labor$Act"+$t+"Labor$Var"+$t+"Burden$Std"+$t+"Burden$Act"+$t+"Burden$Var"+$t+"OOP$Std"+$t+"OOP$Act"+$t+"OOP$Var"+$t+"> "+String:C10($toleranceTrigger*100)+" % $VAR"+$cr
				
				uThermoInit($numCC; "Saving Machine Variance to "+document)
				For ($i; 1; $numCC)
					$aDolLabStd{$i}:=$aHrsStd{$i}*CostCtrCurrent("Labor"; $_aStdCC{$i})
					$aDolLabAct{$i}:=$aHrsAct{$i}*CostCtrCurrent("Labor"; $_aStdCC{$i})
					$aDolBurStd{$i}:=$aHrsStd{$i}*CostCtrCurrent("Burden"; $_aStdCC{$i})
					$aDolBurAct{$i}:=$aHrsAct{$i}*CostCtrCurrent("Burden"; $_aStdCC{$i})
					$aTHrsStd:=$aTHrsStd+$aHrsStd{$i}
					$aTHrsAct:=$aTHrsAct+$aHrsAct{$i}
					$aTDolLabStd:=$aTDolLabStd+$aDolLabStd{$i}
					$aTDolLabAct:=$aTDolLabAct+$aDolLabAct{$i}
					$aTDolBurStd:=$aTDolBurStd+$aDolBurStd{$i}
					$aTDolBurAct:=$aTDolBurAct+$aDolBurAct{$i}
					xText:=xText+$_aStdCC{$i}+$t+String:C10($aHrsStd{$i})+$t+String:C10($aHrsAct{$i})+$t+String:C10($aHrsAct{$i}-$aHrsStd{$i})+$t+String:C10($aDolLabStd{$i})+$t+String:C10($aDolLabAct{$i})+$t+String:C10($aDolLabAct{$i}-$aDolLabStd{$i})+$t+String:C10($aDolBurStd{$i})+$t+String:C10($aDolBurAct{$i})+$t+String:C10($aDolBurAct{$i}-$aDolBurStd{$i})+$t+String:C10($aDolLabStd{$i}+$aDolBurStd{$i})+$t+String:C10($aDolLabAct{$i}+$aDolBurAct{$i})+$t+String:C10(($aDolLabAct{$i}+$aDolBurAct{$i})-($aDolLabStd{$i}+$aDolBurStd{$i}))+$t
					If ($toleranceTrigger#0)
						If (($aDolLabStd{$i}+$aDolBurStd{$i})>0)
							$var:=($aDolLabAct{$i}+$aDolBurAct{$i})/($aDolLabStd{$i}+$aDolBurStd{$i})
							If (Abs:C99($var)>Abs:C99($toleranceTrigger))  //out of tolerance
								xText:=xText+"<<<<"+String:C10(Round:C94($var*100; 0); "#,##0% F;#,##0% U; ")+">>>>"+$cr
							Else   //in tolerance
								xText:=xText+""+$cr
							End if   //in tolerance
							
						Else   //no budget
							If (($aDolLabAct{$i}+$aDolBurAct{$i})>0)
								xText:=xText+"<<<<100% U>>>>"+$cr
							Else 
								xText:=xText+""+$cr
							End if 
						End if   //no budget
						
					Else   //no tolerance
						xText:=xText+""+$cr
					End if   //no tolerance
					
					uThermoUpdate($i)
				End for   //cc
				
				xText:=xText+$cr+"TOTALS"+$t+String:C10($aTHrsStd)+$t+String:C10($aTHrsAct)+$t+String:C10($aTHrsAct-$aTHrsStd)+$t+String:C10($aTDolLabStd)+$t+String:C10($aTDolLabAct)+$t+String:C10($aTDolLabAct-$aTDolLabStd)+$t+String:C10($aTDolBurStd)+$t+String:C10($aTDolBurAct)+$t+String:C10($aTDolBurAct-$aTDolBurStd)+$t+String:C10($aTDolLabStd+$aTDolBurStd)+$t+String:C10($aTDolLabAct+$aTDolBurStd)+$t+String:C10(($aTDolLabAct+$aTDolBurAct)-($aTDolLabStd+$aTDolBurStd))+$t
				If (($aTDolLabStd+$aTDolBurStd)>0)
					$var:=($aTDolLabAct+$aTDolBurAct)/($aTDolLabStd+$aTDolBurStd)
					xText:=xText+"<<<<"+String:C10(Round:C94($var*100; 0); "#,##0% F;#,##0% U; ")+">>>>"+$cr
				Else 
					xText:=xText+"<<<<100% U>>>>"+$cr
				End if 
				//CostCtrCurrent ("kill")
				SEND PACKET:C103($docRef; xText)
				CLOSE DOCUMENT:C267($docRef)
				uThermoClose
				BEEP:C151
				
				If (Count parameters:C259=0)
					$err:=util_Launch_External_App(docName)
				Else 
					QM_Sender(xTitle; ""; "Open the attached with Excel"; distributionList; docName)
					util_deleteDocument(docName)
				End if 
				xText:=""
			End if   //doc created  
			
		Else   //none found
			If (Count parameters:C259=0)
				BEEP:C151
				ALERT:C41("No Job Forms matched your criterion.")
			End if 
		End if   //no records    
	End if   //query  
End if 