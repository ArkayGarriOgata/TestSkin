//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: PO_NewChangeOrder
// Description
// creates new Purchase Order change order on load of a modify 
//
// Parameters
// ----------------------------------------------------
//formerly gNewPOCO(->recordnumberholder): creates new Purchase Order change order

C_BOOLEAN:C305($0)
C_LONGINT:C283($numChgOrds)
C_DATE:C307($today)

$0:=True:C214
$today:=4D_Current_date

SET QUERY DESTINATION:C396(Into variable:K19:4; $numChgOrds)
QUERY:C277([Purchase_Orders_Chg_Orders:13]; [Purchase_Orders_Chg_Orders:13]PONo:3=[Purchase_Orders:11]PONo:1)
SET QUERY DESTINATION:C396(Into current selection:K19:1)

CREATE RECORD:C68([Purchase_Orders_Chg_Orders:13])
[Purchase_Orders_Chg_Orders:13]PONo:3:=[Purchase_Orders:11]PONo:1
[Purchase_Orders_Chg_Orders:13]ChgOrdNo:5:=String:C10($numChgOrds+1; "00")
[Purchase_Orders_Chg_Orders:13]POCOKey:1:=[Purchase_Orders:11]PONo:1+[Purchase_Orders_Chg_Orders:13]ChgOrdNo:5
[Purchase_Orders_Chg_Orders:13]ChgOrdBy:4:=<>zResp
[Purchase_Orders_Chg_Orders:13]ChgOrdDate:6:=$today
[Purchase_Orders_Chg_Orders:13]ChgOrdDesc:7:=xText
[Purchase_Orders_Chg_Orders:13]ChgOrdStatus:10:="Open"
[Purchase_Orders_Chg_Orders:13]StatusBy:12:=<>zResp
[Purchase_Orders_Chg_Orders:13]StatusDate:13:=$today
[Purchase_Orders_Chg_Orders:13]ModDate:22:=$today
[Purchase_Orders_Chg_Orders:13]ModWho:23:=<>zResp
SAVE RECORD:C53([Purchase_Orders_Chg_Orders:13])
$1->:=Record number:C243([Purchase_Orders_Chg_Orders:13])
[Purchase_Orders:11]LastChgOrdNo:18:=[Purchase_Orders_Chg_Orders:13]ChgOrdNo:5
[Purchase_Orders:11]LastChgOrdDate:19:=$today
[Purchase_Orders:11]StatusTrack:51:="CHG ORD BY "+<>zResp+" "+String:C10(4D_Current_date)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51

QUERY:C277([Purchase_Orders_Chg_Orders:13]; [Purchase_Orders_Chg_Orders:13]PONo:3=[Purchase_Orders:11]PONo:1)  //get all CO's back