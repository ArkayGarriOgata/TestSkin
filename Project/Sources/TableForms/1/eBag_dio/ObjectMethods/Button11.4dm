
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/05/15, 13:15:34
// ----------------------------------------------------
// Method: [zz_control].eBag_dio.Button11
// Description
// get the counts per subform
//
// ----------------------------------------------------
ARRAY LONGINT:C221($aShift; 0)
ARRAY LONGINT:C221($aHours; 0)
ARRAY LONGINT:C221($aSheets; 0)

ARRAY LONGINT:C221($aSF; 0)
ARRAY LONGINT:C221($aCount; 0)
$numMR:=0
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
	While (Not:C34(End selection:C36([Job_Forms_Machine_Tickets:61])))
		If ([Job_Forms_Machine_Tickets:61]MR_Act:6>0)
			$numMR:=$numMR+1
		End if 
		
		$hit:=Find in array:C230($aSF; [Job_Forms_Machine_Tickets:61]Subform:26)
		If ($hit=-1)
			APPEND TO ARRAY:C911($aSF; [Job_Forms_Machine_Tickets:61]Subform:26)
			APPEND TO ARRAY:C911($aCount; 0)
			$hit:=Find in array:C230($aSF; [Job_Forms_Machine_Tickets:61]Subform:26)
		End if 
		$aCount{$hit}:=$aCount{$hit}+[Job_Forms_Machine_Tickets:61]Good_Units:8
		
		$hit:=Find in array:C230($aShift; [Job_Forms_Machine_Tickets:61]Shift:18)
		If ($hit=-1)
			APPEND TO ARRAY:C911($aShift; [Job_Forms_Machine_Tickets:61]Shift:18)
			APPEND TO ARRAY:C911($aHours; 0)
			APPEND TO ARRAY:C911($aSheets; 0)
			$hit:=Find in array:C230($aShift; [Job_Forms_Machine_Tickets:61]Shift:18)
		End if 
		$aHours{$hit}:=$aHours{$hit}+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7+[Job_Forms_Machine_Tickets:61]DownHrs:11
		$aSheets{$hit}:=$aSheets{$hit}+[Job_Forms_Machine_Tickets:61]Good_Units:8
		
		NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
	End while 
	
Else 
	
	ARRAY REAL:C219($_MR_Act; 0)
	ARRAY LONGINT:C221($_Subform; 0)
	ARRAY LONGINT:C221($_Good_Units; 0)
	ARRAY LONGINT:C221($_Shift; 0)
	ARRAY REAL:C219($_Run_Act; 0)
	ARRAY REAL:C219($_DownHrs; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]MR_Act:6; $_MR_Act; [Job_Forms_Machine_Tickets:61]Subform:26; $_Subform; [Job_Forms_Machine_Tickets:61]Good_Units:8; $_Good_Units; [Job_Forms_Machine_Tickets:61]Shift:18; $_Shift; [Job_Forms_Machine_Tickets:61]Run_Act:7; $_Run_Act; [Job_Forms_Machine_Tickets:61]DownHrs:11; $_DownHrs)
	
	
	For ($Iter; 1; Size of array:C274($_Run_Act); 1)
		If ($_MR_Act{$Iter}>0)
			$numMR:=$numMR+1
		End if 
		
		$hit:=Find in array:C230($aSF; $_Subform{$Iter})
		If ($hit=-1)
			APPEND TO ARRAY:C911($aSF; $_Subform{$Iter})
			APPEND TO ARRAY:C911($aCount; 0)
			$hit:=Find in array:C230($aSF; $_Subform{$Iter})
		End if 
		$aCount{$hit}:=$aCount{$hit}+$_Good_Units{$Iter}
		
		$hit:=Find in array:C230($aShift; $_Shift{$Iter})
		If ($hit=-1)
			APPEND TO ARRAY:C911($aShift; $_Shift{$Iter})
			APPEND TO ARRAY:C911($aHours; 0)
			APPEND TO ARRAY:C911($aSheets; 0)
			$hit:=Find in array:C230($aShift; $_Shift{$Iter})
		End if 
		$aHours{$hit}:=$aHours{$hit}+$_MR_Act{$Iter}+$_Run_Act{$Iter}+$_DownHrs{$Iter}
		$aSheets{$hit}:=$aSheets{$hit}+$_Good_Units{$Iter}
		
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

SORT ARRAY:C229($aSF; $aCount; >)
SORT ARRAY:C229($aShift; $aHours; $aSheets; >)

utl_LogIt("init")
For ($hit; 1; Size of array:C274($aSF))
	utl_LogIt("Subform "+String:C10($aSF{$hit}; "00")+" - "+String:C10($aCount{$hit}; "###,###,###"))
End for 
utl_LogIt("---")
utl_LogIt("There were "+String:C10($numMR)+" make-readies entered.")
utl_LogIt("---")
For ($hit; 1; Size of array:C274($aShift))
	utl_LogIt("Shift "+String:C10($aShift{$hit}; "0")+" - Hours: "+String:C10($aHours{$hit}; "##0.00")+"  Good Sheets: "+String:C10($aSheets{$hit}; "###,###,###"))
End for 
utl_LogIt("---")
utl_LogIt("show")