//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/15/11, 16:02:57
// ----------------------------------------------------
// Method: FG_getStyle
// ----------------------------------------------------
// Modified by: Mel Bohince (5/13/14) add direction is needed

READ ONLY:C145([Finished_Goods:26])
$numFG:=qryFinishedGood($1; $2)
If ($numFG=1)
	If (Length:C16([Finished_Goods:26]GlueDirection:104)>0) & ([Finished_Goods:26]GlueDirection:104#"Regular")
		$0:=[Finished_Goods:26]GlueType:34+"/"+[Finished_Goods:26]GlueDirection:104
	Else 
		$0:=[Finished_Goods:26]GlueType:34
	End if 
Else 
	$0:="n/f"
End if 
