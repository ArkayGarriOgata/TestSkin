//OM: btotal() -> 
//@author mlb - 6/29/01  15:31
CUT NAMED SELECTION:C334([Prep_Charges:103]; "hold")
$num:=FG_PrepServiceTotalCharges([Finished_Goods_Specifications:98]ControlNumber:2; ->r1; ->r2; ->r3)
USE NAMED SELECTION:C332("hold")