//%attributes = {"publishedWeb":true}
//PM: Zebra_LauderData() -> 
//@author mlb - 11/14/01  12:54
// Modified by: Mel Bohince (9/24/13) add comment for hot stamping or cold foil, will interfer with COC statement
$cpn:=sCPN
sCPN:=Replace string:C233(sCPN; "-"; "")  //they don't allow hyphens on the label

//
If ([Job_Forms_Items:44]Category:31="Repeat")  //marked as such so when they are received they don't need to be inspected
	sCriterion4:="CERTIFIED"  //certified
	sCriterion5:="    ITEM"  //item
Else 
	sCriterion4:=""  //certified
	sCriterion5:=""  //item
End if 

sPO:=coc_num  //don't use the PO on the label

If ([Finished_Goods:26]ProductCode:1#$cpn)
	READ ONLY:C145([Finished_Goods:26])
	$numFG:=qryFinishedGood(sCustId; $cpn)
End if 
Case of   // Modified by: Mel Bohince (9/24/13) 
	: (Position:C15("Cold Foil"; [Finished_Goods:26]Leaf_Information:107)>0)
		sPO:="COLD FOIL "+sPO
		
	: (Position:C15("Hot Stamping"; [Finished_Goods:26]Leaf_Information:107)>0)
		sPO:="HOT STAMPING "+sPO
End case 