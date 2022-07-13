//%attributes = {"publishedWeb":true}
//Method: UpdateCommodityList()  042699  MLB
//why not
C_LONGINT:C283($i)
MESSAGES OFF:C175
ALL RECORDS:C47([Raw_Material_Commodities:54])
SELECTION TO ARRAY:C260([Raw_Material_Commodities:54]CommodityID:1; $aId; [Raw_Material_Commodities:54]CommodityName:2; $Desc)
SORT ARRAY:C229($Desc; $aId; >)
ARRAY TEXT:C222($List; Size of array:C274($aId))
uClearSelection(->[Raw_Material_Commodities:54])

For ($i; 1; Size of array:C274($List))
	$List{$i}:=String:C10($aId{$i}; "00 - ")+$Desc{$i}
End for 
//SORT ARRAY($List;>)

ARRAY TO LIST:C287($List; "CommCodes")
MESSAGES ON:C181
//
