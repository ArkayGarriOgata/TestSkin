//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/22/17, 09:08:07
// ----------------------------------------------------
// Method: api_DeleteRollStockRecord
// Description
// 
//
// Parameters
// ----------------------------------------------------

//$1=-> Blob to return
//$2=PO Item Key
//$3=Roll ID

//C_TEXT($2;$3;$ttDeleteRollID;$ttPOItemKey;$ttRollID)
//C_BLOB($obReturn)
//C_OBJECT($obRecord;$obJSON)
//SET BLOB SIZE($1->;0)
//$ttPOItemKey:=$2
//$ttDeleteRollID:=$3

//READ WRITE([Raw_Materials_Tappi_Roll_id])

//If (($ttDeleteRollID#"") & ($ttPOItemKey#""))
//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=$ttPOItemKey)
//If (Records in selection([Purchase_Orders_Items])>0)
//QUERY([Raw_Materials_Tappi_Roll_id];[Raw_Materials_Tappi_Roll_id]POItemKey=$ttPOItemKey)
//If ((Records in selection([Raw_Materials_Tappi_Roll_id])>0) & Not(Locked([Raw_Materials_Tappi_Roll_id])))

//If ([Raw_Materials_Tappi_Roll_id]Roll_id#"")
//$obJSON:=JSON Parse([Raw_Materials_Tappi_Roll_id]Roll_id)
//End if 
//ARRAY OBJECT($aRollobj;0)
//OB GET ARRAY($obJSON;"rolls";$aRollobj)

//For ($i;Size of array($aRollobj);1;-1)
//$ttRollID:=OB Get($aRollobj{$i};"roll";Is text)
//If ($ttRollID=$ttDeleteRollID)
//DELETE FROM ARRAY($aRollobj;$i;1)
//End if 
//End for 

//OB SET ARRAY($obJSON;"rolls";$aRollobj)
//[Raw_Materials_Tappi_Roll_id]Roll_id:=JSON Stringify($obJSON)

//SAVE RECORD([Raw_Materials_Tappi_Roll_id])



//End if 

//UNLOAD RECORD([Raw_Materials_Tappi_Roll_id])
//End if 
//UNLOAD RECORD([Purchase_Orders_Items])
//End if 

//$ttReturn:="SUCCESS"
//TEXT TO BLOB($ttReturn;$obReturn;UTF8 text without length)
//$1->:=$obReturn
