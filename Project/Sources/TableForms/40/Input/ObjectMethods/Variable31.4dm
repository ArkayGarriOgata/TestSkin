//(S)PrtOrdAckn:

//gCOApproval   //•030596  MLB  
//gCODelete   //•030596  MLB

rRptOrderAckno
//uConfirm ("Print the Customer Order also?";"OK";"Cancel")
//If (ok=1)
//COPY NAMED SELECTION([Customers_Orders];"RptOrdAckn")
//ONE RECORD SELECT([Customers_Orders])
//rRptOrder 
//USE NAMED SELECTION("RptOrdAckn")
//CLEAR NAMED SELECTION("RptOrdAckn")
//FORM SET OUTPUT([Customers_Orders];"List")
//End if 