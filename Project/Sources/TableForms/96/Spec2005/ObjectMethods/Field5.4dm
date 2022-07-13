//If (Length([SerializedShippingLabels]LotNumber)=13)
//$lot:=Substring([SerializedShippingLabels]LotNumber;1;4)+Substring([SerializedShippingLabels]LotNumber;7;3)+Substring([SerializedShippingLabels]LotNumber;13;1)
//Else 
$lot:=[WMS_SerializedShippingLabels:96]LotNumber:6
//End if 
t4:="(10) "+$lot+"   (90) NONE"