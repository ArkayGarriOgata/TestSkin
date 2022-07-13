//%attributes = {"publishedWeb":true}
//PM: qryJML(jobformid) -> numfound
//@author mlb - 5/24/02  14:10

Case of 
	: (Count parameters:C259=1)
		If (Length:C16($1)=8)
			SET QUERY LIMIT:C395(1)
		End if 
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$1)
		If (Length:C16($1)=8)
			SET QUERY LIMIT:C395(0)
		End if 
	Else 
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
End case 
$0:=Records in selection:C76([Job_Forms_Master_Schedule:67])