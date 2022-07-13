//%attributes = {"publishedWeb":true}
//  `sSubformMgr  3/16/95 upr 66  script on caseform.input.subforms
//COPY NAMED SELECTION([Estimates_Machines];"mach")
//C_LONGINT($recs;$next;$subs;$i;$j)
//ARRAY TEXT($subforms;0)
//$recs:=qryEstSubForm ([Estimates_DifferentialsForms]DiffFormId)
//DISTINCT VALUES(;$subforms)
//$subs:=Size of array($subforms)
//Case of 
//: ([Estimates_DifferentialsForms]Subforms<$subs)  `delete subforms
//uConfirm ("Reducing the number of subforms to "+String([Estimates_DifferentialsForms]Subforms)+" will require "+String($subs-[Estimates_DifferentialsForms]Subforms)+" subforms to be removed."+Char(13)+"Delete them?";"Delete";"Cancel")
//If (ok=1)
//QUERY SELECTION(;>String([Estimates_DifferentialsForms]Subforms;"00"))
//DELETE SELECTION()
//Else 
//[Estimates_DifferentialsForms]Subforms:=$subs
//End if 
//
//: ([Estimates_DifferentialsForms]Subforms>$subs)  `add subforms
//If ($subs>0)
//SORT ARRAY($subforms;<)  ` determine the next subform
//$next:=Num($subforms{1})+1
//Else 
//$next:=1
//End if 
//
//QUERY([Estimates_Machines];[Estimates_Machines]DiffFormID=[Estimates_DifferentialsForms]DiffFormId;*)  ` find the machines which have form changes
//QUERY([Estimates_Machines]; & ;[Estimates_Machines]FormChangeHere=True)
//For ($i;$next;[Estimates_DifferentialsForms]Subforms)  `loop to make subform records for the new count
//FIRST RECORD([Estimates_Machines])  `start with the first form chg sequence each time
//For ($j;1;Records in selection([Estimates_Machines]))
//CREATE RECORD()
//:=[Estimates_Machines]DiffFormID
//:=String($i;"00")
//:=[Estimates_Machines]Sequence
//:=[Estimates_Machines]CostCtrID
//SAVE RECORD()
//NEXT RECORD([Estimates_Machines])
//End for   `each maching
//
//End for   `each new subform
//
//
//Else 
//  `the same, do nothing    
//End case 
//SAVE RECORD([Estimates_DifferentialsForms])
//USE NAMED SELECTION("mach")
//CLEAR NAMED SELECTION("mach")
//  `