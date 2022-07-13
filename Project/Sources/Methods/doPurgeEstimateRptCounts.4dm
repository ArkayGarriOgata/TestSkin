//%attributes = {"publishedWeb":true}
//PM:  doPurgeEstimateRptCounts  100199  mlb
//offload some of the main proc

C_TEXT:C284($Cr)
C_LONGINT:C283($1)

$Cr:=Char:C90(13)

Case of 
	: ($1=1)
		xTitle:="Estimate Purge Summary for "+String:C10(4D_Current_date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
		
		xText:="____________________________________________"+$Cr
		xText:=xText+"(Purged estimates are listed alphabetically. Period substituted with"+$Cr
		xText:=xText+" 'o' means that an order retained some pieces, "+$Cr
		xText:=xText+" 'j' means that an job retained some pieces, "+$Cr
		xText:=xText+" '*' means that retension occured last purge."+$Cr+$Cr
		
	: ($1=2)
		xText:=xText+$CR+String:C10(Records in set:C195("New"); "^^^,^^^,^^0")+" New Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("RFQ"); "^^^,^^^,^^0")+" RFQ Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Estimated"); "^^^,^^^,^^0")+" Estimated Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Priced"); "^^^,^^^,^^0")+" Priced@ Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Quoted"); "^^^,^^^,^^0")+" Quoted Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Ordered"); "^^^,^^^,^^0")+" Ordered Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Accepted"); "^^^,^^^,^^0")+" Accepted Order Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Budgeting"); "^^^,^^^,^^0")+" Budgeting Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Budget"); "^^^,^^^,^^0")+" Budget Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Contract"); "^^^,^^^,^^0")+" Contract Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Hold"); "^^^,^^^,^^0")+" Hold Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Kill"); "^^^,^^^,^^0")+" Kill Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("blank"); "^^^,^^^,^^0")+" 'blank' Estimates."
		xText:=xText+$CR+String:C10(Records in set:C195("Super"); "^^^,^^^,^^0")+" Superceded Estimates."
		xText:=xText+$CR+"____________________________________________"+$CR
		
	: ($1=3)
		xText:=xText+$CR+"____________________________________________"
		xText:=xText+$CR+String:C10(r56; "^^^,^^^,^^0")+" Estimates deleted."
		xText:=xText+$CR+String:C10(r61; "^^^,^^^,^^0")+" Est_PSpecs deleted."
		xText:=xText+$CR+String:C10(r62; "^^^,^^^,^^0")+" Est_Ship_tos deleted."
		xText:=xText+$CR+String:C10(r63; "^^^,^^^,^^0")+" Carton_Specs deleted."
		xText:=xText+$CR+String:C10(r64; "^^^,^^^,^^0")+" CaseScenarios deleted."
		xText:=xText+$CR+String:C10(r65; "^^^,^^^,^^0")+" CaseForms deleted."
		xText:=xText+$CR+String:C10(r66; "^^^,^^^,^^0")+" Material_Ests deleted."
		xText:=xText+$CR+String:C10(r67; "^^^,^^^,^^0")+" Machine_Ests deleted."
		xText:=xText+$CR+String:C10(r68; "^^^,^^^,^^0")+" FormCartons deleted."
		xText:=xText+$CR+String:C10(r69; "^^^,^^^,^^0")+" Est_SubForms deleted."
		xText:=xText+$CR+String:C10(r70; "^^^,^^^,^^0")+" Prep_Specs deleted."
		xText:=xText+$CR+String:C10(r71; "^^^,^^^,^^0")+" ReproKits deleted."
		xText:=xText+$CR+"____________________________________________"
		xText:=xText+$CR+String:C10(r72; "^^^,^^^,^^0")+" Estimates promoted to Ordered."
		xText:=xText+$CR+String:C10(r73; "^^^,^^^,^^0")+" Estimates promoted to Budget."
		xText:=xText+$CR+"____________________________________________"
		xText:=xText+$CR+"_______________ END OF REPORT ______________"+String:C10(4d_Current_time; <>HMMAM)
End case 