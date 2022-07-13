//%attributes = {"publishedWeb":true}
C_LONGINT:C283($1)  //sMode:=fGetMode(iMode)    
C_TEXT:C284($0)
Case of 
	: ($1=1)
		$0:="NEW"
	: ($1=2)
		$0:="MODIFY"
	: ($1=3)
		$0:="REVIEW"
	: ($1=4)
		$0:="DELETE"
	: ($1=5)
		$0:="COPY"
	: ($1=6)
		$0:="RESTORE"
	: ($1=7)
		$0:="REPORT"
	Else 
		$0:="AdHoc?"
End case 