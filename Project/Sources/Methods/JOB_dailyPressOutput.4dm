//%attributes = {"publishedWeb":true}
//PM: JOB_dailyPressOutput() -> 
//@author mlb - 8/24/01  12:35
// Modified by: Mel Bohince (9/22/16) update for current press numbers and remove haup v roan ttls

C_DATE:C307($day; $1; dDateBegin; dDateEnd)
C_TEXT:C284($interesting)
C_LONGINT:C283($i)
C_TEXT:C284($t; $cr)


$interesting:=txt_Trim(<>PRESSES)  //load all presses in an array for a build query below
$cnt_of_presses:=Num:C11(util_TextParser(16; $interesting; Character code:C91(" "); 13))
$t:=Char:C90(9)
$cr:=Char:C90(13)

If (Count parameters:C259=0)
	$day:=Date:C102(Request:C163("Report which month?"; String:C10(4D_Current_date; System date short:K1:1); "Continue"; "Cancel"))
Else 
	$day:=$1
	oK:=1
End if 

If (OK=1)
	dDateBegin:=Date:C102(String:C10(Month of:C24($day))+"/1/"+String:C10(Year of:C25($day)))
	dDateEnd:=Date:C102(String:C10(Month of:C24($day)+1)+"/1/"+String:C10(Year of:C25($day)))
	
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dDateBegin; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<dDateEnd)
	
	QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=util_TextParser(1); *)
	For ($press; 2; $cnt_of_presses)
		QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=util_TextParser($press); *)
	End for 
	QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5; >)
		FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
		
	Else 
		
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5; >)
		
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	$lastDay:=!00-00-00!
	ARRAY LONGINT:C221($aRow; 0)
	xTitle:="Press Room Output for month "+String:C10(Month of:C24($day))
	//the headers
	xText:="Date"  //+$t+"6/c ManRoland"+$t+"7/c ManRoland"+$t+"2/c Heidelberg"+$t+"Total Roanoke"+$t+"4/c Heidelberg"+$t+"6/c Heidelberg"+$t+"Total Hauppauge"+$t+"Total Arkay"+$cr
	For ($press; 1; $cnt_of_presses)
		xText:=xText+$t+util_TextParser($press)
	End for 
	xText:=xText+$t+"TOTAL"+$cr
	
	// Modified by: Mel Bohince (9/22/16) make ttls for mth
	ARRAY LONGINT:C221($mthTotals; $cnt_of_presses)
	For ($press; 1; $cnt_of_presses)
		$mthTotals{$press}:=0
	End for 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; Records in selection:C76([Job_Forms_Machine_Tickets:61]))
			If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; $interesting)>0)
				If ([Job_Forms_Machine_Tickets:61]DateEntered:5#$lastDay)  //starting a different day
					
					If (Size of array:C274($aRow)>0)  //not the first row
						
						xText:=xText+String:C10($lastDay; System date short:K1:1)
						$dayTotal:=0
						For ($j; 1; $cnt_of_presses)
							xText:=xText+$t+String:C10($aRow{$j})
							$dayTotal:=$dayTotal+$aRow{$j}
						End for 
						xText:=xText+$t+String:C10($dayTotal)+$cr
					End if 
					
					$lastDay:=[Job_Forms_Machine_Tickets:61]DateEntered:5
					ARRAY LONGINT:C221($aRow; 0)
					ARRAY LONGINT:C221($aRow; $cnt_of_presses)
				End if 
				
				$column:=Find in array:C230(aParseArray; [Job_Forms_Machine_Tickets:61]CostCenterID:2)
				
				$aRow{$column}:=$aRow{$column}+[Job_Forms_Machine_Tickets:61]Good_Units:8
				$mthTotals{$column}:=$mthTotals{$column}+[Job_Forms_Machine_Tickets:61]Good_Units:8
				
			End if 
			NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
		End for 
		
	Else 
		
		ARRAY LONGINT:C221($_Good_Units; 0)
		ARRAY TEXT:C222($_CostCenterID; 0)
		ARRAY DATE:C224($_DateEntered; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Good_Units:8; $_Good_Units; [Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID; [Job_Forms_Machine_Tickets:61]DateEntered:5; $_DateEntered)
		
		For ($i; 1; Size of array:C274($_DateEntered); 1)
			If (Position:C15($_CostCenterID{$i}; $interesting)>0)
				If ($_DateEntered{$i}#$lastDay)  //starting a different day
					
					If (Size of array:C274($aRow)>0)  //not the first row
						
						xText:=xText+String:C10($lastDay; System date short:K1:1)
						$dayTotal:=0
						For ($j; 1; $cnt_of_presses)
							xText:=xText+$t+String:C10($aRow{$j})
							$dayTotal:=$dayTotal+$aRow{$j}
						End for 
						xText:=xText+$t+String:C10($dayTotal)+$cr
					End if 
					
					$lastDay:=$_DateEntered{$i}
					ARRAY LONGINT:C221($aRow; 0)
					ARRAY LONGINT:C221($aRow; $cnt_of_presses)
				End if 
				
				$column:=Find in array:C230(aParseArray; $_CostCenterID{$i})
				
				$aRow{$column}:=$aRow{$column}+$_Good_Units{$i}
				$mthTotals{$column}:=$mthTotals{$column}+$_Good_Units{$i}
				
			End if 
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	//the last row
	xText:=xText+String:C10($lastDay; System date short:K1:1)
	$dayTotal:=0
	For ($j; 1; $cnt_of_presses)
		xText:=xText+$t+String:C10($aRow{$j})
		$dayTotal:=$dayTotal+$aRow{$j}
	End for 
	xText:=xText+$t+String:C10($dayTotal)+$cr+$cr
	
	xText:=xText+"Mth TTL:"
	$rptTotal:=0
	For ($j; 1; $cnt_of_presses)
		xText:=xText+$t+String:C10($mthTotals{$j})
		$rptTotal:=$rptTotal+$mthTotals{$j}
	End for 
	xText:=xText+$t+String:C10($rptTotal)+$cr+$cr
	
	
	docName:="PressRoomOutput_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $cr+$cr+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	$err:=util_Launch_External_App(docName)
	
	xTitle:=""
	xText:=""
	
End if 