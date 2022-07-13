//%attributes = {"publishedWeb":true}
//Procedure: rCostCardHdrs(whichHeader)  090998  MLB
//get around a 32k problem
//•091198  MLB  make all caps, add ITEM
// Modified by: MelvinBohince (4/4/22) chg to CSV for wip rpt

C_LONGINT:C283($1)
C_TEXT:C284($0)
C_TEXT:C284($t; $cr)

$t:=","  // Modified by: MelvinBohince (4/4/22) chg to CSV     was Char(9)
$cr:=Char:C90(13)

Case of 
	: ($1=1)
		$0:="JOB FORM"+$t+"STARTED"+$t+"@SEQ"+$t+"BEG BAL"+$t+"MATL"+$t+"LABOR"+$t+"BURDEN"+$t+"MATL+CONV"+$t+"XFERS->FGs"+$t+"END BAL"+$t+"SPOIL(EXCESS)"+$t+"FLAG"+$t+"$PRODUCED"+$t+"$PRIOR FG"+$t+"$HPV"+$t+"Customer"+$t+"Status"+$t+"Completed"+$t+"JobType"+$t+"Location"+$cr
		
	: ($1=2)
		$0:=$t+$t+$t+$t+$t+$t+"C  x  F"+$t
		$0:=$0+$t+$t+$t+$t+"I x C"+$t+"L - G"+$t+"M / L"+$t+"((IxK)-(JxK))/(IxK)"+$t+"(I x K) - G"+$t+"P/(I x K)"+$cr
		$0:=$0+"ITEM"+$t+"CPN"+$t+"WANT QTY"+$t+"ACT QTY"+$t+"GLUED"+$t+"COST/M"+$t+"HPV"+$t
		$0:=$0+"ORD LINE"+$t+"PRICE/M"+$t+"BOOK COST"+$t+"ORDER QTY"+$t+"SALES VALUE"+$t+"CONTRIBUTION"+$t+"JOB PV"+$t+"BOOK PV"+$t+"REALIZABLE PV"+$t+"REALZ CONTR"+$cr
		
	: ($1=3)
		$0:=$cr+$cr+"SEQ - C/C"+$t+"DESCRIPTION"+$t+"STANDARD"+$t+"MHR"+$t+"ACT C/C"+$t+"ACT MHR"+$t+"MT DATE"+$t+"ACT MR"+$t+"ACT RUN"+$t+"STD MR"+$t+"STD RUN"+$t+"IMPRESSIONS"+$t+"(Act*ActMHR)"+$t+"(Std*StdMHR)"+$t+"ITEM"+$t+"ACT RATE"+$t+"STD RATE"+$cr
		
	: ($1=4)
		$0:=$cr+"  UNBUDGETED PRODUCTION CENTERS:  "+$cr
		
	: ($1=5)
		$0:=$cr+$cr+"   MATERIAL RECEIPTS:  "+$cr
		$0:=$0+"DATE"+$t+"COMMODITY"+$t+"R/M CODE"+$t+"ACT_QTY"+$t+"ACT $"+$t+$t+"BUD_COMMS"+$t+"BUD_QTY"+$t+"BUD $"+$cr
		
	: ($1=6)
		$0:=$cr+$cr+"MATL"+$t+"LABOR"+$t+"BURDEN"+$t+"MATL+CONV"+$t+"XFERS->FGs"+$t+"END BAL"+$t+"SPOIL(EXCESS)"+$t+"FLAG"+$t+"$PRODUCED"+$t+"$PRIOR FG"+$t+"$HPV"+$cr
End case 