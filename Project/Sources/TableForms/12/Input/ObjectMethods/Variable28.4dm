//COPY NAMED SELECTION([PO_Releases];"holdThem")

FORM SET OUTPUT:C54([Purchase_Orders_Releases:79]; "VendReleaseForm")
//While (Not(End selection([PO_Releases])))
PRINT RECORD:C71([Purchase_Orders_Releases:79]; *)
// NEXT RECORD([PO_Releases])
//End while 

FORM SET OUTPUT:C54([Purchase_Orders_Releases:79]; "List")
//USE NAMED SELECTION("holdThem")
//CLEAR NAMED SELECTION("holdThem")