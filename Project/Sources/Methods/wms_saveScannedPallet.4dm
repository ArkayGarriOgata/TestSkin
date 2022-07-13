//%attributes = {}
//  ` Method: wms_saveScannedPallet (->manifest;skidnumber;$caseCount;$scannedQty) -> 
//  ` ----------------------------------------------------
//  ` by: mel: 02/12/05, 15:44:32
//  ` ----------------------------------------------------
//  ` Description:
//  ` Given an array of cases, print a pallet label and commit to the wms item master
//  `and the wms composition
//  `later try to shift this off to a separate process so operator doesn't have to wait.
//  ` 
//  `UPDATES
//  ` • mel (2/25/05, `make sure that any of these case are removed from prior skids
//  ` ----------------------------------------------------
//READ WRITE([WMS_ItemMasters])
//READ WRITE([WMS_Compositions])
//READ ONLY([Job_Forms_Items])
//READ ONLY([Customers])
//READ ONLY([Finished_Goods])
//C_BOOLEAN($loaded)
//C_POINTER($1;$ptrCaseList)
//$ptrCaseList:=$1
//C_TEXT($2;$skidID;$palletID;$sku;$lot)
//C_LONGINT($caseCount;$case;$numberCases;$3;$4;$scannedQty;$locked)
//$caseCount:=$3
//$scannedQty:=$4
//
//If ($caseCount>0)
//$lot:=WMS_CaseId ($ptrCaseList->{1};"jobit")
//$numJMI:=qryJMI ($lot)
//$sku:=[Job_Forms_Items]ProductCode
//
//$skidID:=$2
//
//If ($skidID="") | ($skidID="NEW")  `then a record needs to be created, else it was during an FG receive
//$skidID:="X"+app_set_id_as_string (Table(->[WMS_ItemMasters]);"000000")  `fGetNextID (->[WMS_ItemMasters];7)
//End if 
//
//If (Not(wms_itemExists ($skidID)))
//WMS_newItem ($skidID;$sku;$lot;$scannedQty;4D_Current_date;"CC:R")
//LOAD RECORD([WMS_ItemMasters])
//End if 
//
//$palletID:=WMS_PalletID ("";"set";$lot;$skidID;$scannedQty;$caseCount)
//[WMS_ItemMasters]PalletID:=$palletID  `always assign a new pallet id
//
//ARRAY TEXT($ptrCaseList->;$caseCount)
//ARRAY TEXT($aOnPalletID;$caseCount)
//$numberCases:=0
//t3:="Case List:"+◊cr
//t4:=""
//t3:=t3+" # ---LOT---  SERIAL-  ---QTY  "+" # ---LOT---  SERIAL-  ---QTY  "+◊cr
//$zebraCRLF:=Char(92)+Char(38)  `"\&"
//t4:=t4+" #  ---LOT---  SERIAL-  ---QTY  "+$zebraCRLF
//SORT ARRAY($ptrCaseList->)
//$left:=True
//
//For ($case;1;$caseCount)
//If (Length($ptrCaseList->{$case})>0)
//$numberCases:=$numberCases+1
//$aOnPalletID{$case}:=$palletID
//t4:=t4+String($case;"00")+")"+WMS_CaseId ($ptrCaseList->{$case};"human")+$zebraCRLF
//If ($left)
//t3:=t3+String($case;"00")+")"+WMS_CaseId ($ptrCaseList->{$case};"human")+"  "
//$left:=False
//Else 
//t3:=t3+String($case;"00")+")"+WMS_CaseId ($ptrCaseList->{$case};"human")+◊cr
//$left:=True
//End if 
//End if 
//End for 
//
//[WMS_ItemMasters]CASES:=$caseCount
//[WMS_ItemMasters]QTY:=$scannedQty
//[WMS_ItemMasters]STATE:="SCANNED"
//If (User in group(Current user;"Roanoke"))
//[WMS_ItemMasters]LOCATION:="CC:R"
//Else 
//[WMS_ItemMasters]LOCATION:="CC:"
//End if 
//SAVE RECORD([WMS_ItemMasters])
//
//  `make sure that any of these case are removed from prior skids
//QUERY WITH ARRAY([WMS_Compositions]Content;$ptrCaseList->)
//If (Records in selection([WMS_Compositions])>0)
//$locked:=util_DeleteSelection (->[WMS_Compositions])
//If ($locked>0)
//USE SET("LockedSet")
//FIRST RECORD([WMS_Compositions])
//While (Not(End selection([WMS_Compositions])))
//rft_logger ("ERROR: "+[WMS_Compositions]Content+" on skid "+[WMS_Compositions]Container+" could not be deleted.")
//NEXT RECORD([WMS_Compositions])
//End while 
//End if 
//End if 
//
//  `make the new manifest
//REDUCE SELECTION([WMS_Compositions];0)
//ARRAY TO SELECTION($aOnPalletID;[WMS_Compositions]Container;$ptrCaseList->;[WMS_Compositions]Content)
//ARRAY TEXT($ptrCaseList->;0)
//ARRAY TEXT($aOnPalletID;0)
//
//  `print the pallet label
//QUERY([Customers];[Customers]ID=[WMS_ItemMasters]CUST)
//qryFinishedGood ([WMS_ItemMasters]CUST;$sku)
//
//t1:=WMS_PalletID ($palletID;"human")  `human readable
//t2:=WMS_PalletID ($palletID;"barcode")
//wmsZebra128:=WMS_PalletID ($palletID;"zebra")
//
//If (Zebra_SetUp )  `(◊RFTBASE_STATION_PID))
//Zebra_PrintPalletLabel 
//
//Else   `laser print 
//util_PAGE_SETUP(->[WMS_ItemMasters];"PalletLabel_Laser")
//PDF_setUp ($palletID+".pdf")
//Print form([WMS_ItemMasters];"PalletLabel_Laser")
//PAGE BREAK
//End if 
//  `wms_printManifest 
//
//REDUCE SELECTION([WMS_ItemMasters];0)
//REDUCE SELECTION([WMS_Compositions];0)
//REDUCE SELECTION([Customers];0)
//REDUCE SELECTION([Finished_Goods];0)
//REDUCE SELECTION([Job_Forms_Items];0)
//
//Else 
//rft_logger ("ERROR: "+"No cases on skid: "+$2)
//End if 