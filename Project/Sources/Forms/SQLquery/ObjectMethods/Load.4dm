// ----------------------------------------------------
// Method: SQLquery.Load   ( ) ->
// By: Mel Bohince @ 02/24/16, 08:24:35
// Description
// 
// ----------------------------------------------------
READ ONLY:C145([x_shell_scripts:138])
QUERY:C277([x_shell_scripts:138]; [x_shell_scripts:138]scriptName:1="SQL_@")
SELECTION TO ARRAY:C260([x_shell_scripts:138]; aRecNum; [x_shell_scripts:138]scriptName:1; aName; [x_shell_scripts:138]description:2; aDesc)
REDUCE SELECTION:C351([x_shell_scripts:138]; 0)
For ($i; 1; Size of array:C274(aName))
	aName{$i}:=Substring:C12(aName{$i}; 5)
End for 

SORT ARRAY:C229(aName; aRecNum; aDesc; >)


$winRef:=Open form window:C675("SQLqueryLoad"; Resizable sheet window:K34:16)
recNum:=-3

DIALOG:C40("SQLqueryLoad")
CLOSE WINDOW:C154($winRef)

If (ok=1)
	GOTO RECORD:C242([x_shell_scripts:138]; recNum)
	tText:=[x_shell_scripts:138]scriptText:3
End if 

