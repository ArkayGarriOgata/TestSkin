//(lp) PiRMAdjSumry.d (detail)
sCommKey:=aComm{Index}
sRmCode:=aRmCode{Index}
rQtyOh:=arQuantity{Index}  //post inventory
rQtym:=arNewQty{Index}  //pre inventory
rReal1:=rQtyOh-rQtym  //difference
rReal2:=aActCost{Index}  //cost
rReal3:=Round:C94(rReal1*rReal2; 2)  //extended
//keep subtotals
rReal4:=rReal4+arQuantity{Index}  // commodity sum Post
rReal5:=rReal5+arNewQty{Index}  //commodity sum pre
rReal6:=rReal6+rReal3  //commodity sum extended