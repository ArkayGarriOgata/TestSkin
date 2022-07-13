//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/21/17, 11:00:24
// ----------------------------------------------------
// Method: api_CreateRollStockRecord
// Description
// 
//
// Parameters
// ----------------------------------------------------
//$1=-> Blob to return
//$2=PO Item Key
//$3=Roll ID
//$4=Linear Feet

//C_TEXT($2;$3;$ttNewRollID;$ttPOItemKey)
//C_LONGINT($4;$xlLinearFeet)
//C_BLOB($obReturn)
//C_OBJECT($obRecord;$obJSON)
//SET BLOB SIZE($1->;0)
//$ttPOItemKey:=$2
//$ttNewRollID:=$3
//$xlLinearFeet:=$4

//READ WRITE([Raw_Materials_Tappi_Roll_id])

//If (($ttNewRollID#"") & ($ttPOItemKey#""))
//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=$ttPOItemKey)
//If (Records in selection([Purchase_Orders_Items])>0)
//QUERY([Raw_Materials_Tappi_Roll_id];[Raw_Materials_Tappi_Roll_id]POItemKey=$ttPOItemKey)
//If (Records in selection([Raw_Materials_Tappi_Roll_id])=0)
//CREATE RECORD([Raw_Materials_Tappi_Roll_id])
//[Raw_Materials_Tappi_Roll_id]POItemKey:=$ttPOItemKey
//  //[Raw_Materials_Tappi_Roll_id]pk_id:= // AUTO UUID
//End if 


//  //[Raw_Materials_Tappi_Roll_id]Linear_Feet:=$xlLinearFeet
//  //[Raw_Materials_Tappi_Roll_id]Roll_id:=$ttNewRollID
//If ([Raw_Materials_Tappi_Roll_id]Roll_id#"")
//$obJSON:=JSON Parse([Raw_Materials_Tappi_Roll_id]Roll_id)
//End if 
//ARRAY OBJECT($aRollobj;0)
//OB GET ARRAY($obJSON;"rolls";$aRollobj)

//OB SET($obRecord;"roll";$ttNewRollID)
//OB SET($obRecord;"linearFeet";$xlLinearFeet)

//APPEND TO ARRAY($aRollobj;$obRecord)

//OB SET ARRAY($obJSON;"rolls";$aRollobj)
//[Raw_Materials_Tappi_Roll_id]Roll_id:=JSON Stringify($obJSON)

//SAVE RECORD([Raw_Materials_Tappi_Roll_id])
//UNLOAD RECORD([Raw_Materials_Tappi_Roll_id])
//End if 
//UNLOAD RECORD([Purchase_Orders_Items])
//End if 

//$ttReturn:="SUCCESS"
//TEXT TO BLOB($ttReturn;$obReturn;UTF8 text without length)
//$1->:=$obReturn
