CONFIRM:C162("Which Printer?"; "Zebra"; "6-up Laser")
If (ok=1)
	<>JOBIT:=[WMS_ItemMasters:123]LOT:3
	READ ONLY:C145([Finished_Goods:26])
	$numRec:=qryFinishedGood("#CPN"; [WMS_ItemMasters:123]SKU:2)
	READ ONLY:C145([Finished_Goods_PackingSpecs:91])
	QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=[Finished_Goods:26]OutLine_Num:4)
	Zebra_LabelSetup(<>JOBIT; "Arkay Barcode")
Else 
	WMS_PrintCaseLabels(6; [WMS_ItemMasters:123]LOT:3)
End if 

//$winRef:=Open form window([CONTROL];"SelectPrinter_dio")
//DIALOG([CONTROL];"SelectPrinter_dio")
//CLOSE WINDOW($winRef)

//util_PAGE_SETUP(->[WMS_ItemMaster];"CaseLabel_Laser")
// PDF_setUp (t1+".pdf")
//SET CURRENT PRINTER(◊aPrinterNames{0})
//Print form([WMS_ItemMaster];"CaseLabel_Laser")
//PAGE BREAK


//util_PAGE_SETUP(->[WMS_ItemMaster];"CaseLabel_Laser")
//SET CURRENT PRINTER($currentPrinter)
//Print form([WMS_ItemMaster];"CaseLabel_Laser")
//PAGE BREAK