//%attributes = {"publishedWeb":true}
//qryJMI
//• 7/22/97 cs added return of number of records found
//•110999  mlb  add 1 param case

C_LONGINT:C283($0; $params)
C_TEXT:C284($1)  //080995
C_LONGINT:C283($2)
C_TEXT:C284($3)

$params:=Count parameters:C259

Case of 
	: ($params=1)
		If ([Job_Forms_Items:44]Jobit:4#$1)
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$1)
		End if 
	: ($params=2)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$1; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ItemNumber:7=$2)
	: ($params=3)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$1; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=$3)  //5/4/95
End case 

$0:=Records in selection:C76([Job_Forms_Items:44])
If ($0=0)
	If (Trigger level:C398=1)
		$0:=1
	End if 
End if 