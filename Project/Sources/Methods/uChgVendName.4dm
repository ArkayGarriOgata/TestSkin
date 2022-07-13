//%attributes = {"publishedWeb":true}
//Procedure: uChgVendName()  071095  MLB
//•071095  MLB  UPR 1663
//•071095  MLB  UPR 1668
C_TEXT:C284($vendId)
C_TEXT:C284($vendName)
$vendId:=<>VendId
$vendName:=<>VendName
<>VendId:=""
<>VendName:=""
Open window:C153(250; 120; 600; 160; -722; "Changing Vendor "+$vendId+"'s Name in existing P.O.'s")
READ WRITE:C146([Purchase_Orders:11])
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2=$vendId)
APPLY TO SELECTION:C70([Purchase_Orders:11]; [Purchase_Orders:11]VendorName:42:=$vendName)
SAVE RECORD:C53([Vendors:7])
CLOSE WINDOW:C154
//