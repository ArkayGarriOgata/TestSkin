//%attributes = {"publishedWeb":true}
//(P) gGetDate
//  $1 = Fiscal Year
//  $2 = Fiscal Period
//-----------------------------

C_TEXT:C284($1; $2)
C_TEXT:C284($YYMM)

$YYMM:=$1+$2
$month:=$2
$year:="20"+$1
dDateBegin:=Date:C102($month+"/1/"+$year)
dDateEnd:=Date:C102($month+"/"+String:C10(<>aDaysInMth{Num:C11($month)})+"/"+$year)
dFrom:=dDateBegin
dTo:=dDateEnd