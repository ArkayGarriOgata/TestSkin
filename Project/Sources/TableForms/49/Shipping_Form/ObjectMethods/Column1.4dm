READ WRITE:C146([Finished_Goods_Locations:35])
zwStatusMsg("Testing"; "Record #:"+String:C10(aRecNo{aLocation})+" for location "+aLocation{aLocation})
GOTO RECORD:C242([Finished_Goods_Locations:35]; aRecNo{aLocation})
If (fLockNLoad(->[Finished_Goods_Locations:35]))
	zwStatusMsg("Ready"; "Record #:"+String:C10(aRecNo{aLocation})+" for location "+aLocation{aLocation})
Else 
	zwStatusMsg("Locked"; "Record #:"+String:C10(aRecNo{aLocation})+" for location "+aLocation{aLocation})
End if 
UNLOAD RECORD:C212([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods_Locations:35])