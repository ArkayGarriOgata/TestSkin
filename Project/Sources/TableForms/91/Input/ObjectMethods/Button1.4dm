SAVE RECORD:C53([Finished_Goods_PackingSpecs:91])

xText:=User_ResolveInitials([Finished_Goods_PackingSpecs:91]ModWho:38)
If (Length:C16(xText)=0)
	xText:="No Clue"
End if 
FORM SET OUTPUT:C54([Finished_Goods_PackingSpecs:91]; "PrintForm")
util_PAGE_SETUP(->[Finished_Goods_PackingSpecs:91]; "PrintForm")
PDF_setUp("PacSpec-"+[Finished_Goods_PackingSpecs:91]FileOutlineNum:1+".pdf")

PRINT RECORD:C71([Finished_Goods_PackingSpecs:91]; *)

FORM SET OUTPUT:C54([Finished_Goods_PackingSpecs:91]; "List")
xText:=""
PDF_setUp