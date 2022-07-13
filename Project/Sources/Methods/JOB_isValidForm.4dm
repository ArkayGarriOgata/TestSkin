//%attributes = {"publishedWeb":true}
//PM: JOB_isValidForm(jobformid) -> true or false
//@author mlb - 5/23/02  15:42

C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_LONGINT:C283($numForms)

$0:=False:C215

If (Length:C16($1)=8)
	If (Position:C15("."; $1)=6)
		SET QUERY DESTINATION:C396(Into variable:K19:4; $numForms)
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$1)
		If ($numForms>0)
			$0:=True:C214
		End if 
		SET QUERY LIMIT:C395(0)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
	End if   //decimal
End if   //length