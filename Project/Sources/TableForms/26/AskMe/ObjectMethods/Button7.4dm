CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "holdBins")
uConfirm("Show bin map?"; sCPN; "Search")
If (ok=1)
	FGL_binLocator2(sCPN)
Else 
	QUERY:C277([Finished_Goods_Locations:35])
	If (ok=1)
		FGL_binLocator2
	End if 
End if 

uConfirm("Report skid/case/qty?"; "Yes"; "No")
If (ok=1)
	FGL_packingAnalysis
End if 

USE NAMED SELECTION:C332("holdBins")