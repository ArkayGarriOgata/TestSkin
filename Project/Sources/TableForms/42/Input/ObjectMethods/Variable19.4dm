// _______
// Method: [Job_Forms].Input.bPrintCC( ) ->
//Script:   090998  MLB
// rewrite: MelvinBohince @ 04/06/22, 13:55:30 because Job_WIP_CostCard changed
// Description
//   //print a cost card
// ----------------------------------------------------

C_TEXT:C284($jobForm; $docName)
C_LONGINT:C283($err)

$jobForm:=[Job_Forms:42]JobFormID:5
CUT NAMED SELECTION:C334([Job_Forms:42]; "holdJF")
CUT NAMED SELECTION:C334([Jobs:15]; "holdJ")
CUT NAMED SELECTION:C334([Job_Forms_Machines:43]; "holdMT")
CUT NAMED SELECTION:C334([Job_Forms_Materials:55]; "holdIT")
CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "holdJI")

$docName:=Job_WIP_CostCard($jobForm)

$err:=util_Launch_External_App($docName)

USE NAMED SELECTION:C332("holdJF")
USE NAMED SELECTION:C332("holdJ")
USE NAMED SELECTION:C332("holdMT")
USE NAMED SELECTION:C332("holdIT")
USE NAMED SELECTION:C332("holdJI")
