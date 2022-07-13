//%attributes = {"publishedWeb":true}
//PM:  Pjt_getReferId  5/03/00  mlb
//return the current project reference

C_TEXT:C284($0)

If (Length:C16(<>pjtId)=5)
	$0:=<>pjtId
	//If (Count parameters=0)
	//◊pjtId:=""
	// End if 
Else 
	$0:=""
	<>pjtId:=""
End if 