//%attributes = {}

// Method: Job_getGlueSequence ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 05/05/14, 11:23:28
// ----------------------------------------------------
// Description
// return the seq number of the glue operation
//
// ----------------------------------------------------
C_LONGINT:C283($0; $cnt_of_gluers; $gluer)
C_TEXT:C284($jobform; $1; $gluer_ids)
$jobform:=$1

$gluer_ids:=txt_Trim(<>GLUERS)  //load all gluers in an array for a build query below
$cnt_of_gluers:=Num:C11(util_TextParser(16; $gluer_ids; Character code:C91(" "); 13))

//find the glue sequences in this form's budget
QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jobform)
QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4=util_TextParser(1); *)
For ($gluer; 2; $cnt_of_gluers)
	QUERY SELECTION:C341([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4=util_TextParser($gluer); *)
End for 
QUERY SELECTION:C341([Job_Forms_Machines:43])

If (Records in selection:C76([Job_Forms_Machines:43])>0)  //some gluer(s) specified
	$0:=[Job_Forms_Machines:43]Sequence:5
Else 
	$0:=0
End if 