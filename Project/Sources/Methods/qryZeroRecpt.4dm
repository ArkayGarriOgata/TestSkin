//%attributes = {"publishedWeb":true}
//(p) qryZeroRecpt
//query received POs for items with zero cost
//• 9/17/97 cs moved into po_items for seach

//SEARCH([RM_XFER];[RM_XFER]XferDate=4D_Current_date-30;*)
//SEARCH([RM_XFER]; & [RM_XFER]Xfer_Type="Receipt";*)
//SEARCH([RM_XFER];[RM_XFER]UnitPrice=0)
//$0:=Records in selection([RM_XFER])

QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]RecvdDate:43>=4D_Current_date-30; *)
QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]ExtPrice:11=0)

$0:=Records in selection:C76([Purchase_Orders_Items:12])