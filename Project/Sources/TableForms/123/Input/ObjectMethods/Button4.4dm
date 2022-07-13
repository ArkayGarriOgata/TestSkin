//print the pallet label
QUERY:C277([Customers:16]; [Customers:16]ID:1=[WMS_ItemMasters:123]CUST:9)
qryFinishedGood([WMS_ItemMasters:123]CUST:9; [WMS_ItemMasters:123]SKU:2)

t1:=WMS_PalletID([WMS_ItemMasters:123]PalletID:11; "human")  //human readable
t2:=WMS_PalletID([WMS_ItemMasters:123]PalletID:11; "barcode")
wmsZebra128:=WMS_PalletID([WMS_ItemMasters:123]PalletID:11; "zebra")

ARRAY TEXT:C222($aCaseList; 0)
SELECTION TO ARRAY:C260([WMS_Compositions:124]Content:2; $aCaseList)
$caseCount:=Size of array:C274($aCaseList)
t3:="Case List:"+<>cr
t4:=""
t3:=t3+" # ---LOT---  SERIAL-  ---QTY  "+" # ---LOT---  SERIAL-  ---QTY  "+<>cr
$zebraCRLF:=Char:C90(92)+Char:C90(38)  //"\&"
t4:=t4+" #  ---LOT---  SERIAL-  ---QTY  "+$zebraCRLF
$left:=True:C214



For ($case; 1; $caseCount)
	If (Length:C16($aCaseList{$case})>0)
		t4:=t4+String:C10($case; "00")+")"+WMS_CaseId($aCaseList{$case}; "human")+$zebraCRLF
		If ($left)
			t3:=t3+String:C10($case; "00")+")"+WMS_CaseId($aCaseList{$case}; "human")+"  "
			$left:=False:C215
		Else 
			t3:=t3+String:C10($case; "00")+")"+WMS_CaseId($aCaseList{$case}; "human")+<>cr
			$left:=True:C214
		End if 
	End if 
End for 


If (Zebra_SetUp)
	Zebra_PrintPalletLabel
	
Else 
	util_PAGE_SETUP(->[WMS_ItemMasters:123]; "PalletLabel_Laser")
	PDF_setUp("Pallet_"+t1+".pdf")
	Print form:C5([WMS_ItemMasters:123]; "PalletLabel_Laser")
	PAGE BREAK:C6
End if 



//wms_printManifest 