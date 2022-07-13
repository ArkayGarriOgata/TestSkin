If (app_LoadIncludedSelection("init"; ->[Finished_Goods:26]ProductCode:1)>0)
	zwStatusMsg("Open ArtPro Link"; [Finished_Goods:26]Line_Brand:15+"'s "+[Finished_Goods:26]ProductCode:1)
	
	FG_ArtProPath("view")
	
	app_LoadIncludedSelection("clear"; ->[Finished_Goods:26]ProductCode:1)
End if 
//