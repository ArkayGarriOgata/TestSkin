//%attributes = {"publishedWeb":true}
//PM: util_Patch(text) -> 
//@author mlb - 4/13/01  22:28
C_TEXT:C284($1; $thePatch; $statement)
$thePatch:=$1
C_LONGINT:C283(iRow; $eol; $0)
C_TEXT:C284($CR)
$CR:=Char:C90(13)
$0:=0
<>fContinue:=True:C214
ON ERR CALL:C155("util_patchErrHandler")

If (Length:C16($thePatch)>0)
	If (Length:C16($thePatch)<=32000)
		NewWindow(500; 400; 2; 5; "util_Patch")
		$eol:=Position:C15($CR; $thePatch)  //get end of line 
		iRow:=1
		While (($eol#0)) & (<>fContinue)
			$statement:=Substring:C12($thePatch; 1; ($eol-1))  //get a line 
			If (Length:C16($statement)>0)
				MESSAGE:C88(String:C10(iRow; "^^^^^")+": "+$statement+$CR)
				EXECUTE FORMULA:C63($statement)
			Else 
				MESSAGE:C88(String:C10(iRow; "^^^^^")+": "+"NULL"+$CR)
			End if 
			$thePatch:=Substring:C12($thePatch; ($eol+1))  //ditch the last line
			$eol:=Position:C15($CR; $thePatch)
			iRow:=1+iRow
		End while 
		
		$0:=iRow-1
		
		CLOSE WINDOW:C154
		
	Else 
		BEEP:C151
		zwStatusMsg("util_Patch"; "The patch file is greater than 32k.")
	End if   //length      
	
Else 
	BEEP:C151
	zwStatusMsg("util_Patch"; "The patch file was empty.")
End if   //length

ON ERR CALL:C155("")