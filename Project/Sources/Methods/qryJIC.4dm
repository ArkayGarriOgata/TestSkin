//%attributes = {"publishedWeb":true}
//PM:  qryJICobit;fgkey)  110999  mlb
//get a cost record
C_TEXT:C284($1; $2)

Case of 
	: (Count parameters:C259=1)
		QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3=$1)
	Else 
		QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13=$2)
End case 
$0:=Records in selection:C76([Job_Forms_Items_Costs:92])

