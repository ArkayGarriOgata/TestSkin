//If (Is new record([Raw_Materials_Tappi_Roll_id]))
//If (Length([Raw_Materials_Tappi_Roll_id]POItemKey)=9)
//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=[Raw_Materials_Tappi_Roll_id]POItemKey)
//If (Records in selection([Purchase_Orders_Items])>0)
//sPOI:=[Raw_Materials_Tappi_Roll_id]POItemKey
//Else 
//sPOI:=""
//End if 

//Else 
//sPOI:=""
//End if 

//Else   //existing
//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=[Raw_Materials_Tappi_Roll_id]POItemKey)
//sPOI:=""
//End if 
