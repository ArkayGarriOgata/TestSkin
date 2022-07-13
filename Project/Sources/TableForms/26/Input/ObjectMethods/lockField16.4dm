// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 05/21/13, 15:10:19
// ----------------------------------------------------
// Object Method: [Finished_Goods].Input.lockField16 ([Finished_Goods]CartonDesc)
// ----------------------------------------------------

[Finished_Goods:26]CartonDesc:3:=edi_filter_delimiters([Finished_Goods:26]CartonDesc:3)
txt_Gremlinizer(->[Finished_Goods:26]CartonDesc:3)
[Finished_Goods:26]ModFlag:31:=True:C214

FillInClassification("FG"; Self:C308; ->[Finished_Goods:26]ClassOrType:28)  // Added by: Mark Zinke (5/21/13)