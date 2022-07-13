rActCost:=0
rActPrice:=0

If (ibomUOM="SHEETS")
	$sheets:=iQty
	iQty:=$sheets*iUp
	ibomUOM:="CARTONS"
	xText:="                  LOT#      "+"P&G ITEM"+"   PO                "+"DESC"+Char:C90(13)
	For ($i; 1; Size of array:C274(aJobit))
		$numFG:=qryFinishedGood("#CPN"; aCPN{$i})
		$qtyThisCarton:=$sheets*aCartonUp{$i}
		rActCost:=rActCost+(([Finished_Goods:26]RKContractPrice:49-15)*$qtyThisCarton/1000)
		rActPrice:=rActPrice+([Finished_Goods:26]RKContractPrice:49*$qtyThisCarton/1000)
		xText:=xText+"~"+String:C10(aCartonUp{$i})+" UP  "+txt_Pad(String:C10($qtyThisCarton); " "; -1; 5)+"   "+aJobit{$i}+"  "+aCPN{$i}+"   "+JMI_getPO(aJobit{$i})+" { "+Uppercase:C13(Substring:C12([Finished_Goods:26]CartonDesc:3; 1; 25))+Char:C90(13)
	End for 
	
Else 
	$numFG:=qryFinishedGood("#CPN"; aCPN{1})
	rActCost:=(([Finished_Goods:26]RKContractPrice:49-15)*iQty/1000)
	rActPrice:=[Finished_Goods:26]RKContractPrice:49*iQty/1000
End if 