//%attributes = {}
// -------
// Method: MT_getGlueCount   ( ) ->
// By: Mel Bohince @ 01/18/19, 10:39:45
// Description
// return ttl good glue count for a jobit
// ----------------------------------------------------
C_TEXT:C284($jobit; $1)
C_LONGINT:C283($2; $3; $from; $to)

C_LONGINT:C283($0; $good)
$good:=0
$jobit:=$1
//[Job_Forms_Machine_Tickets]Jobit

If (Count parameters:C259=1)
	Begin SQL
		select sum(Good_Units) from Job_Forms_Machine_Tickets 
		where Jobit = :$jobit 
		group by Jobit 
		into :$good
	End SQL
	
Else   //datetime range provided
	$from:=$2
	$to:=$3
	//  [Job_Forms_Machine_Tickets]TimeStampEntered
	
	Begin SQL
		select sum(Good_Units) from Job_Forms_Machine_Tickets 
		where Jobit = :$jobit and 
		TimeStampEntered >= :$from and
		TimeStampEntered <= :$to
		group by Jobit 
		into :$good
	End SQL
End if 

$0:=$good