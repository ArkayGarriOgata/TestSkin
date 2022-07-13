
//Case of 
//: (Form event=On Load)
//C_TEXT(sPOI;tRoll_id)
//C_OBJECT(json_obj)
//ARRAY TEXT(aText;0)
//READ ONLY([Purchase_Orders_Items])

//If (Is new record([Raw_Materials_Tappi_Roll_id]))
//If (Length(sPOI)=9)
//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=sPOI)
//If (Records in selection([Purchase_Orders_Items])>0)
//[Raw_Materials_Tappi_Roll_id]POItemKey:=sPOI
//GOTO OBJECT([Raw_Materials_Tappi_Roll_id]Roll_id)
//Else 
//sPOI:=""
//End if 

//Else 
//sPOI:=""
//REDUCE SELECTION([Purchase_Orders_Items];0)
//End if 

//Else   //existing
//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=[Raw_Materials_Tappi_Roll_id]POItemKey)
//json_obj:=JSON Parse([Raw_Materials_Tappi_Roll_id]Roll_id)
//ARRAY OBJECT($aRollobj;0)
//OB GET ARRAY(json_obj;"rolls";$aRollobj)

//For ($i;1;Size of array($aRollobj))
//APPEND TO ARRAY(aText;OB Get($aRollobj{$i};"roll";Is text))
//End for 

//End if 



//: (Form event=On Validate)
//  //[Raw_Materials_Tappi_Roll_id]Roll_id:=JSON Stringify array(aObj)

//[Raw_Materials_Tappi_Roll_id]Roll_id:="{"+txt_quote ("rolls")+": ["
//  //[Raw_Materials_Tappi_Roll_id]Roll_id:="{"\"rolls\": ["
//For ($i;1;Size of array(aText))
//  //[Raw_Materials_Tappi_Roll_id]Roll_id:=[Raw_Materials_Tappi_Roll_id]Roll_id+" {"+txt_quote ("roll")+":"+txt_quote (aText{$i})+"}"
//[Raw_Materials_Tappi_Roll_id]Roll_id:=[Raw_Materials_Tappi_Roll_id]Roll_id+"{\"roll\" :\""
//[Raw_Materials_Tappi_Roll_id]Roll_id:=[Raw_Materials_Tappi_Roll_id]Roll_id+aText{$i}
//[Raw_Materials_Tappi_Roll_id]Roll_id:=[Raw_Materials_Tappi_Roll_id]Roll_id+"\"}"
//If ($i#Size of array(aText))
//[Raw_Materials_Tappi_Roll_id]Roll_id:=[Raw_Materials_Tappi_Roll_id]Roll_id+","
//End if 
//End for 
//[Raw_Materials_Tappi_Roll_id]Roll_id:=[Raw_Materials_Tappi_Roll_id]Roll_id+"]}"

//End case 
