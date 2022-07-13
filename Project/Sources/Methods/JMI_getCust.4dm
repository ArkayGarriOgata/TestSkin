//%attributes = {}
// -------
// Method: JMI_getCust   ( ) ->
// By: Mel Bohince @ 12/01/18, 08:53:18
// Description
// return the customer id for a jobit
// ----------------------------------------------------

C_TEXT:C284($1; $jobit)
C_TEXT:C284($cust; $0)

$cust:=""

Case of 
	: (Length:C16($1)=11)
		$jobit:=$1
		
	: (Length:C16($1)=9)
		$jobit:=JMI_makeJobIt($1)
		
	Else 
		$jobit:="N/A"
End case 

If (Length:C16($jobit)=11)
	If ([Job_Forms_Items:44]Jobit:4#$jobit)
		MESSAGES OFF:C175
		READ ONLY:C145([Job_Forms_Items:44])
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$jobit)
		SET QUERY LIMIT:C395(0)
	End if 
	
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		$cust:=[Job_Forms_Items:44]ProductCode:3
	End if 
End if 

$0:=$cust