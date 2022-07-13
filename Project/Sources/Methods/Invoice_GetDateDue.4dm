//%attributes = {"publishedWeb":true}
//Method: Invoice_GetDateDue(terms;invo date) ->date 042099  MLB
//get the date due based on the terms
C_TEXT:C284($1; $terms)
$terms:=$1
C_DATE:C307($2; $0)
$0:=$2
C_LONGINT:C283($netAt; $days)
$netAt:=Position:C15("Net"; $terms)
$days:=0

Case of 
	: ($netAt>0)
		$days:=Num:C11(Substring:C12($terms; $netAt+4))
	: (Num:C11($terms)>0) & (Num:C11($terms)<90)
		$days:=Num:C11($terms)
	Else 
		$days:=0
End case 
$0:=$2+$days
Case of 
	: (Day number:C114($0)=Saturday:K10:18)
		$0:=$0+2
	: (Day number:C114($0)=Sunday:K10:19)
		$0:=$0+1
End case 

//