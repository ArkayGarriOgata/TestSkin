//build a packing slip

sArkayUCCid:="0010808292"  //pallet arkay
$container:=[WMS_ItemMasters:123]Skidid:1
$serialnumber:=txt_Pad($container; "0"; -1; 9)

CUT NAMED SELECTION:C334([WMS_ItemMasters:123]; "beforeLabel")

$chkMod10:=fBarCodeMod10Digit(sArkayUCCid+$serialnumber)
t1:=sArkayUCCid+$serialnumber+$chkMod10  //human readable
t2:=fBarCodeSym(128; sArkayUCCid+$serialnumber+$chkMod10)

READ ONLY:C145([WMS_Compositions:124])
QUERY:C277([WMS_Compositions:124]; [WMS_Compositions:124]Container:1=$container)
SELECTION TO ARRAY:C260([WMS_Compositions:124]Content:2; $aCases)
SORT ARRAY:C229($aCases)
t3:=""
SET QUERY LIMIT:C395(1)
For ($i; 1; Size of array:C274($aCases))
	t3:=t3+String:C10($i; "00")+") "
	QUERY:C277([WMS_ItemMasters:123]; [WMS_ItemMasters:123]Skidid:1=$aCases{$i})
	If (Records in selection:C76([WMS_ItemMasters:123])>0)
		t3:=t3+[WMS_ItemMasters:123]Skidid:1+" "+[WMS_ItemMasters:123]LOT:3+" "+[WMS_ItemMasters:123]SKU:2+Char:C90(13)
	Else 
		t3:=t3+$aCases{$i}+" ERROR"+Char:C90(13)
	End if 
End for 
SET QUERY LIMIT:C395(0)

util_PAGE_SETUP(->[WMS_ItemMasters:123]; "SkidLabel_Laser")
PDF_setUp($serialnumber+".pdf")
Print form:C5([WMS_ItemMasters:123]; "SkidLabel_Laser")
PAGE BREAK:C6
USE NAMED SELECTION:C332("beforeLabel")