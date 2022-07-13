//%attributes = {"publishedWeb":true}
//(p) DoPurgeOrphans
//moved this code from DoPurge to simplify that code
//• 11/6/97 cs created

C_TEXT:C284(xTitle; xText)
C_TEXT:C284($Cr)

$Cr:=Char:C90(13)
xTitle:="Estimate Orphan Purge Summary for "+String:C10(4D_Current_date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="____________________________________________"

ALL RECORDS:C47([Estimates:17])
ARRAY TEXT:C222(aEstimate; 0)
SELECTION TO ARRAY:C260([Estimates:17]EstimateNo:1; aEstimate)
uPurgeEstOrphs(->[Estimates_Carton_Specs:19]Estimate_No:2)
uPurgeEstOrphs(->[Estimates_Differentials:38]estimateNum:2)
uPurgeEstOrphs(->[Estimates_DifferentialsForms:47]DiffFormId:3)
uPurgeEstOrphs(->[Estimates_Materials:29]DiffFormID:1)
uPurgeEstOrphs(->[Estimates_Machines:20]DiffFormID:1)
uPurgeEstOrphs(->[Estimates_FormCartons:48]DiffFormID:2)
uPurgeEstOrphs(->[Estimates_PSpecs:57]EstimateNo:1)
uPurgeEstOrphs(->[Work_Orders:37]id:1)

xText:=xText+$CR+"_______________ END OF REPORT ______________"+String:C10(4d_Current_time; <>HMMAM)
//*Print a list of what happened on this run
rPrintText("ORPHANES_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; ""))
xTitle:=""
xText:=""

ARRAY TEXT:C222(aEstimate; 0)