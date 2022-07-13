//%attributes = {"publishedWeb":true}
//(p) VenSumConvert
//this routine is to be used to convert various Arkay use units
//to 'industry standard' units for vensum report (new)
//• 12/22/97 cs created 12/22/97
//modified to handle processing with out having the po_item record in hand 
//$1 - comm code
//$2 com key
//$3 ship qty
//$4 UOM
//$5 flex field 3 (length)
//$6 flex field 2 (width)
//$7 Raw material code
//VenSumConvert (aCode;aKey;aQty;aUOM;aFlex3;aFlex2;aRmCode)
C_REAL:C285($Qty; $0)

If (Count parameters:C259=0)
	
	Case of 
		: ([Purchase_Orders_Items:12]CommodityCode:16=1)  //* std units for board  - tons, wieght given in lbs/MSF          
			
			If ([Raw_Materials_Groups:22]Commodity_Key:3#[Purchase_Orders_Items:12]Commodity_Key:26)
				//USE SET("ComOne")  `speed this search
				QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Purchase_Orders_Items:12]Commodity_Key:26)
			End if 
			$Qty:=ConvertUnits([Purchase_Orders_Items:12]Qty_Shipping:4; [Purchase_Orders_Items:12]UM_Ship:5; "MSF"; ->r10; ->r11; "*")  //convert units to MSF
			
			If ([Raw_Materials_Groups:22]Flex3:16#0)
				$Qty:=($Qty*[Raw_Materials_Groups:22]Flex3:16)/2000  //get tons based on Rm_group record
			Else 
				$Qty:=($Qty*AvgLbsMSF)/2000  //get tons based on avgerage lbs/msf
			End if 
			
		: ([Purchase_Orders_Items:12]CommodityCode:16=2)
			$Qty:=ConvertUnits([Purchase_Orders_Items:12]Qty_Shipping:4; [Purchase_Orders_Items:12]UM_Ship:5; "Lb"; ->r10; ->r11; "*")  //convert units to lb for ink
			
		: ([Purchase_Orders_Items:12]CommodityCode:16=3)
			$Qty:=ConvertUnits([Purchase_Orders_Items:12]Qty_Shipping:4; [Purchase_Orders_Items:12]UM_Ship:5; "Lb"; ->r10; ->r11; "*")  //convert units to lb for laquers    
			
		: ([Purchase_Orders_Items:12]CommodityCode:16=5)
			//conversion does not exist in convert units routine    
			$Qty:=[Purchase_Orders_Items:12]Qty_Shipping:4*[Purchase_Orders_Items:12]Flex3:33  //get total number of linear feet (roll in feet(flex3) * # rolls)
			$Qty:=$Qty/200  //number of Lf in a 'unit' (1" x 200')
			$Qty:=$Qty*[Purchase_Orders_Items:12]Flex2:32  //number of linear units * width of leaf roll = units (1"x200')
		Else 
			$Qty:=[Purchase_Orders_Items:12]Qty_Shipping:4
	End case 
	$0:=$Qty
Else   //called using values
	Case of 
		: ($1=1)  //* std units for board  - tons, wieght given in lbs/MSF          
			
			If ([Raw_Materials_Groups:22]Commodity_Key:3#$2)
				QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$2)
			End if 
			$Qty:=ConvertUnits($3; $4; "MSF"; ->r10; ->r11; "*"; $7; $6; $5)  //convert units to MSF
			
			If ([Raw_Materials_Groups:22]Flex3:16#0)
				$Qty:=($Qty*[Raw_Materials_Groups:22]Flex3:16)/2000  //get tons based on Rm_group record
			Else 
				$Qty:=($Qty*AvgLbsMSF)/2000  //get tons based on avgerage lbs/msf
			End if 
			
		: ($1=2)
			$Qty:=ConvertUnits($3; $4; "Lb"; ->r10; ->r11; "*")  //convert units to lb for ink
			
		: ($1=3)
			$Qty:=ConvertUnits($3; $4; "Lb"; ->r10; ->r11; "*")  //convert units to lb for laquers    
			
		: ($1=5)
			//conversion does not exist in convert units routine    
			$Qty:=$3*$5  //get total number of linear feet (roll in feet(flex3) * # rolls)
			$Qty:=$Qty/200  //number of Lf in a 'unit' (1" x 200')
			$Qty:=$Qty*$6  //number of linear units * width of leaf roll = units (1"x200')
		Else 
			$Qty:=$3
	End case 
	$0:=$Qty
End if 
//