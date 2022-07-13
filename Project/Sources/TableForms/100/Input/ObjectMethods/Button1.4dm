//OM: bMod() -> 
//@author mlb - 8/29/02  07:38
C_TEXT:C284($cntrlNum)
$cntrlNum:=Substring:C12([To_Do_Tasks:100]Task:3; Length:C16([To_Do_Tasks:100]Task:3)-6)
If (Substring:C12($cntrlNum; 1; 1)#"C")
	$cntrlNum:=Substring:C12([To_Do_Tasks:100]Task:3; 1; 7)
End if 

If (Substring:C12($cntrlNum; 1; 1)="C")
	FG_PrepServiceUpdate($cntrlNum)
Else 
	FG_PrepServiceUpdate
End if 