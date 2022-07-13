//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/20/09, 15:04:51
// ----------------------------------------------------
// Method: wms_convert_bin_id("desired format;binid)->converted bin_id
// Description 
// covert from/to ams wms style bin ids
//
// Parameters

// ----------------------------------------------------
// Modified by: Mel Bohince (5/18/17) don't double translate a ams location if already has the colon
// Modified by: MelvinBohince (6/23/22) don't convert Created

C_TEXT:C284($1; $chgTo; $fromFormat; $2; $0; $return)

If (Count parameters:C259>0)
	$chgTo:=$1
	$fromFormat:=$2
Else   //testing
	$chgTo:="wms"
	$fromFormat:="FG:V-123"  //"BNV--123"
End if 
$return:=$fromFormat

Case of 
	: ($chgTo="ams")  //supplied wms BNW...
		Case of 
			: (Position:C15(":"; $fromFormat)>0)  // Modified by: Mel Bohince (5/18/17) already an ams bin
				$return:=$fromFormat
				
			: (Position:C15("-"; $fromFormat)>0)
				$return:="FG:"+Substring:C12($fromFormat; 3; 1)+Substring:C12($fromFormat; 5)
				
			: (Position:C15("_"; $fromFormat)>0)
				$mark:=Position:C15("_"; $fromFormat)
				$return:=Substring:C12($fromFormat; 4; 2)+":"+Substring:C12($fromFormat; 3; 1)+Substring:C12($fromFormat; $mark)
				
			: (Position:C15("BOL"; $fromFormat)>0)  // Modified by: Mel Bohince (8/25/17) 
				$return:="FG:"+$fromFormat
				
			: ($fromFormat="BNVLOST")  // Modified by: Mel Bohince (8/25/17) 
				$return:="FG:V_LOST"
				
			: ($fromFormat="BNRLOST")  // Modified by: Mel Bohince (8/25/17) 
				$return:="FG:R_LOST"
				
			: ($fromFormat="CREATED")  // Modified by: Mel Bohince (6/23/22) don't convert Created
				$return:="CREATED"
				
			Else 
				$return:=Substring:C12($fromFormat; 4; 2)+":"+Substring:C12($fromFormat; 3; 1)+Substring:C12($fromFormat; 6)
		End case 
		
	: ($chgTo="wms")  //supplied ams  wms_convert_bin_id("wms";[Finished_Goods_Locations]Location)
		//If (Substring($fromFormat;1;2)="FX")
		//$fromFormat:="FG"+Substring($fromFormat;3)
		//End if 
		
		//If (Substring($fromFormat;1;2)="PX") & (Length($fromFormat)>4)
		//$fromFormat:="FG"+Substring($fromFormat;3)
		//End if 
		
		Case of 
			: (Length:C16($fromFormat)=3)  //FG: or CC:
				$return:="BNH"+Substring:C12($fromFormat; 1; 2)
				
			: (Length:C16($fromFormat)=4)  //FG:R or CC:R
				$return:="BN"+Substring:C12($fromFormat; 4; 1)+Substring:C12($fromFormat; 1; 2)
				
			: (Position:C15("-"; $fromFormat)>0)
				$return:="BN"+Substring:C12($fromFormat; 4; 1)+"-"+Substring:C12($fromFormat; 5)
				
			: (Position:C15("BOL"; $fromFormat)>0)  // Modified by: Mel Bohince (8/25/17) 
				$return:=Substring:C12($fromFormat; 4)
				
			: (Position:C15("_"; $fromFormat)>0)
				$mark:=Position:C15("_"; $fromFormat)
				$return:="BN"+Substring:C12($fromFormat; 4; 1)+Substring:C12($fromFormat; 1; 2)+Substring:C12($fromFormat; $mark)
				
			Else 
				$return:="BN"+Substring:C12($fromFormat; 4; 1)+Substring:C12($fromFormat; 5)
		End case 
		
	Else   //do nothing
		$return:=$fromFormat
End case 

$0:=$return