//Script: bPrintCC()  090998  MLB
//print a cost card
$jobForm:=[Job_Forms:42]JobFormID:5
$hold:=xtext

CUT NAMED SELECTION:C334([Job_Forms:42]; "holdJF")
CUT NAMED SELECTION:C334([Jobs:15]; "holdJ")
CUT NAMED SELECTION:C334([Job_Forms_Machines:43]; "holdMT")
CUT NAMED SELECTION:C334([Job_Forms_Materials:55]; "holdIT")
CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "holdJI")
rptWIPinventory(!00-00-00!; !00-00-00!; $jobForm; 1; 0)
USE NAMED SELECTION:C332("holdJF")
USE NAMED SELECTION:C332("holdJ")
USE NAMED SELECTION:C332("holdMT")
USE NAMED SELECTION:C332("holdIT")
USE NAMED SELECTION:C332("holdJI")
xtext:=$hold