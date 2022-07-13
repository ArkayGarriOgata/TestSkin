//%attributes = {}
// _______
// Method: Job_getProductionStats   ( jobform ) -> stats_object with mr, run, and dollars
// By: MelvinBohince @ 05/06/22, 12:25:57
// Description
// find the actual production hours consumed by a job and the cost
// ----------------------------------------------------
//NOT USED, used in testing INV_openActualsPageLoadJMI and Job_getProductionCost

C_TEXT:C284($jobForm; $1)
C_OBJECT:C1216($0; $jfmt_es; $jobStats_o; $machineTicket_o)
C_REAL:C285($machineTicketHours)

If (Count parameters:C259>0)
	$jobForm:=$1
Else 
	$jobForm:="18378.01"
End if 

$jobStats_o:=New object:C1471("mr"; 0; "run"; 0; "ttl"; 0; "dollarsOOP"; 0; "dollarsLabor"; 0; "dollarsOverhead"; 0)

$jfmt_es:=ds:C1482.Job_Forms_Machine_Tickets.query("JobForm = :1"; $jobForm)
//If ($jfmt_es.length>0)
//$jobStats_o.mr:=$jobStats_o.mr+$jfmt_es.sum("MR_Act")
//$jobStats_o.run:=$jobStats_o.run+$jfmt_es.sum("Run_Act")
//$jobStats_o.ttl:=$jobStats_o.mr+$jobStats_o.run
//End if 

//sum of the hours extended to OOP costs
For each ($machineTicket_o; $jfmt_es)
	$jobStats_o.mr:=$jobStats_o.mr+$machineTicket_o.MR_Act
	$jobStats_o.run:=$jobStats_o.run+$machineTicket_o.Run_Act
	$machineTicketHours:=$machineTicket_o.MR_Act+$machineTicket_o.Run_Act
	$jobStats_o.ttl:=$jobStats_o.ttl+$machineTicketHours
	$jobStats_o.dollarsOOP:=$jobStats_o.dollarsOOP+($machineTicketHours*$machineTicket_o.COST_CENTER.MHRoopSales)
	$jobStats_o.dollarsLabor:=$jobStats_o.dollarsLabor+($machineTicketHours*$machineTicket_o.COST_CENTER.MHRlaborSales)
	$jobStats_o.dollarsOverhead:=$jobStats_o.dollarsOverhead+($machineTicketHours*$machineTicket_o.COST_CENTER.MHRburdenSales)
End for each 

$jobStats_o.dollarsOOP:=Round:C94($jobStats_o.dollarsOOP; 2)
$jobStats_o.dollarsLabor:=Round:C94($jobStats_o.dollarsLabor; 2)
$jobStats_o.dollarsOverhead:=Round:C94($jobStats_o.dollarsOverhead; 2)

$0:=$jobStats_o
