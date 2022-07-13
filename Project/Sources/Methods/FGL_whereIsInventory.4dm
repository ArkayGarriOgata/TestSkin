//%attributes = {}
// _______
// Method: FGL_whereIsInventory   (product code {;"NAD") ->   vendor name or arkay {shipfrom NAD}
// By: Mel Bohince @ 04/02/21, 14:20:45
// Description
// determine if any of a products inventory is at an O/S vendor and return either the vendor name or their NAD (name and address in EDIFACT)
// ----------------------------------------------------
// Modified by: Mel Bohince (4/6/21) add plant and generalfibre locations
// Modified by: Mel Bohince (4/8/21) add jaf
// Modified by: Mel Bohince (5/5/21) add TMC's W-Code (SHFR)
// Modified by: Mel Bohince (7/28/21) moved w-code to correct element

//to get the 'arkay plant' location, the query would need to change and the test would be that all the items inventory is at a FG:R@ location, pretty rare

C_TEXT:C284($cpn; $1; $vendor; $0; $2)
C_OBJECT:C1216($bin)

If (Count parameters:C259>0)
	$cpn:=$1
Else   //test
	//Use (Storage)
	//Storage.ELC_ShipFroms_o:=Null
	//End use 
	$cpn:="V27Y-Y1-0111"
End if 

$vendor:="arkay"

//parse the vendor, otherwise, assume Arkay's warehouse, even if no inventory exists which in the ASN context should not happen
For each ($bin; ds:C1482.Finished_Goods_Locations.query("ProductCode = :1 and Location = :2 "; $cpn; "@:OS@")) Until ($vendor#"arkay")
	If (Position:C15(":OS"; $bin.Location)>0)  //outside warehouse found
		$vendor:=Substring:C12($bin.Location; 7)
	End if 
End for each 

$vendor:=Lowercase:C14($vendor)  //Storage.ELC_ShipFroms_o properties will be in lowercase

If (Count parameters:C259>1)  // | (True)  //return an EDI NAD
	
	If (Storage:C1525.ELC_ShipFroms_o=Null:C1517)  //first use, save for later
		ARRAY TEXT:C222($_tmc_W_code; 4)  // Modified by: Mel Bohince (5/5/21) add TMC's W-Code (SHFR)
		$_tmc_W_code{1}:="W63752172"  //lee hwy  // Modified by: Mel Bohince (6/10/21) enabled
		$_tmc_W_code{2}:="W58829327"  //eastpark
		$_tmc_W_code{3}:="W64586247"  //globe
		$_tmc_W_code{4}:="W64586159"  //hauppauge
		
		Use (Storage:C1525)
			C_OBJECT:C1216($shipFrom_o)  //hash of vendor's name and address in EDIFACT format
			$shipFrom_o:=New shared object:C1526  //add a property with a name returned bty the above substring'd bin location
			Use ($shipFrom_o)
				$shipFrom_o.arkay:="NAD+SE+:ARKAY PACKAGING CORPORATION+872 LEE Highway::"+$_tmc_W_code{1}+":ROANOKE+VA:::US+24019"
				$shipFrom_o.plant:="NAD+SE+:ARKAY MANUFACTURING PLANT+350 EASTPARK DRIVE::"+$_tmc_W_code{2}+":ROANOKE+VA:::US+24019"  //not used, this is for reference, would need a user over-ride
				$shipFrom_o.globe:="NAD+SE+:GLOBE WAREHOUSE+76 LIBERTY STREET::"+$_tmc_W_code{3}+":METUCHEN+NJ:::US+08840"  // Modified by: Mel Bohince (7/28/21) moved w-code to correct element
				$shipFrom_o.generalfibre:="NAD+SE+:GENERAL FIBRE+170 NASSAU TERMINAL ROAD:::NEW HYDE PARK+NY:::US+11040"
				$shipFrom_o.multifold:="NAD+SE+:MULTIFOLD WAREHOUSE+120 RICEFIELD LANE SUITE B:::HAUPPAUGE+NY:::US+11788"
				$shipFrom_o.jaf:="NAD+SE+:JAF+60 MARCONI BLVD:::COPIAGUE+NY:::US+11726"
				$shipFrom_o.default:="NAD+SE+:ARKAY PACKAGING CORPORATION+872 LEE Highway::"+$_tmc_W_code{1}+":ROANOKE+VA:::US+24019"
			End use   //$shipFrom_o
			
			
			Storage:C1525.ELC_ShipFroms_o:=$shipFrom_o
			
		End use   //storage
	End if   //shipFrom property not null
	
	If (OB Is defined:C1231(Storage:C1525.ELC_ShipFroms_o; $vendor))
		$vendor:=Storage:C1525.ELC_ShipFroms_o[$vendor]  // Modified by: Mel Bohince (4/2/21) 
	Else 
		$vendor:=Storage:C1525.ELC_ShipFroms_o.default
	End if 
	
End if 

$0:=$vendor
