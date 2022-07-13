
CUT NAMED SELECTION:C334([Prep_Charges:103]; "hold")
$num:=FG_PrepServiceTotalCharges([Finished_Goods_Specifications:98]ControlNumber:2; ->r1; ->r2; ->r3)
USE NAMED SELECTION:C332("hold")
FG_PrepServiceSetFGrecord([Finished_Goods_Specifications:98]ControlNumber:2)
SAVE RECORD:C53([Finished_Goods_Specifications:98])

FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "PrepQuote")

PRINT RECORD:C71([Finished_Goods_Specifications:98])
FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "List")
//tickle the record so 
[Finished_Goods_Specifications:98]CommentsFromQA:53:=[Finished_Goods_Specifications:98]CommentsFromQA:53+" "
