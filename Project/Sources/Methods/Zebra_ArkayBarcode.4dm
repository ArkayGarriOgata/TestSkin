//%attributes = {}
// Method: Zebra_ArkayBarcode
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 
// ----------------------------------------------------
// Description
// set up for a composite type of barcode
//
fCanChange:=True:C214
wmsDateMfg:=dDate
wmsCaseQty:=iQty
wmsCaseNumber1:=Zebra_CaseNumberManager("find"; sJMI)  //1  `set it to zero if you don't want to increment, such as for skids
$caseID:=WMS_CaseId(""; "set"; sJMI; wmsCaseNumber1; wmsCaseQty)
wmsCaseId1:=WMS_CaseId($caseID; "barcode")
wmsHumanReadable1:=WMS_CaseId($caseID; "human")

