//%attributes = {"publishedWeb":true}
//(p) PoItemBldSubGrp
//build the subgroup based on entered/selected commodity code.
//$1 - subgroup entered/selected

C_TEXT:C284($1)
C_TEXT:C284($ComKey)

MESSAGES OFF:C175

ARRAY TEXT:C222(aSubGroup; 0)

SetObjectProperties(""; ->[Purchase_Orders_Items:12]SubGroup:13; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)

If ([Purchase_Orders_Items:12]CommodityCode:16#0)
	If (Count parameters:C259=0)
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=[Purchase_Orders_Items:12]CommodityCode:16)
	Else 
		$ComKey:=RMG_makeCommKey(->[Purchase_Orders_Items:12]CommodityCode:16; $1)
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$ComKey)
	End if 
	
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]SubGroup:10#"")  //remove blanks from list
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		
		If (Records in selection:C76([Raw_Materials_Groups:22])>0)
			DISTINCT VALUES:C339([Raw_Materials_Groups:22]SubGroup:10; aSubGroup)
		End if 
		
	End if 
	
	If ([Purchase_Orders_Items:12]SubGroup:13#"")
		If (Find in array:C230(aSubGroup; [Purchase_Orders_Items:12]SubGroup:13)<0)
			[Purchase_Orders_Items:12]SubGroup:13:=""
		End if 
	End if 
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]SubGroup:13; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
End if 