[Estimates_Carton_Specs:19]Quantity_Want:27:=[Estimates_FormCartons:48]FormWantQty:9  //•052495 MLB UPR 1479
[Estimates_Carton_Specs:19]Qty1Temp:52:=[Estimates_Carton_Specs:19]Quantity_Want:27  //•052495 MLB UPR 1479
SAVE RECORD:C53([Estimates_Carton_Specs:19])  //•052495 MLB UPR 1479
r1:=Sum:C1([Estimates_FormCartons:48]FormWantQty:9)
RELATE ONE:C42([Estimates_FormCartons:48]Carton:1)

