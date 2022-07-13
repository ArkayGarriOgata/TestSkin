// ----------------------------------------------------
// Object Method: [Finished_Goods].Input.lockField1 ([Finished_Goods]ProductCode)
// ----------------------------------------------------

[Finished_Goods:26]ModFlag:31:=True:C214
[Finished_Goods:26]ProductCode:1:=fStripSpace("B"; [Finished_Goods:26]ProductCode:1)

If ([Finished_Goods:26]CustID:2#"")
	[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1
Else 
	[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]ProductCode:1
End if 

FillInClassification("FG"; Self:C308; ->[Finished_Goods:26]ClassOrType:28)  // Added by: Mark Zinke (5/21/13)