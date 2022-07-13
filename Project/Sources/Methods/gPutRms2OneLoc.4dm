//%attributes = {"publishedWeb":true}
//gPutRMs2OneLoc
//roll all RM locations which have the same Job, CPN & Location 
//into one RMLocation record
//4/28/95 chip, removed location references.

ALL RECORDS:C47([Raw_Materials_Locations:25])
ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >; [Raw_Materials_Locations:25]POItemKey:19; >)  //;[RM_BINS]Location;>
//$Location:=[RM_BINS]Location
$Job:=[Raw_Materials_Locations:25]POItemKey:19
$Prod:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
$QtyOh:=[Raw_Materials_Locations:25]QtyOH:9
$Rec:=Record number:C243([Raw_Materials_Locations:25])
NEXT RECORD:C51([Raw_Materials_Locations:25])
For ($i; 1; Records in selection:C76([Raw_Materials_Locations:25]))
	Case of 
		: ([Raw_Materials_Locations:25]POItemKey:19=$Job) & ([Raw_Materials_Locations:25]Raw_Matl_Code:1=$Prod)  //this is the same, removed location check since this caused a problem
			[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+$QtyOh
			[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
			[Raw_Materials_Locations:25]ModWho:22:=<>zResp
			SAVE RECORD:C53([Raw_Materials_Locations:25])
			COPY NAMED SELECTION:C331([Raw_Materials_Locations:25]; "Current")
			GOTO RECORD:C242([Raw_Materials_Locations:25]; $Rec)
			DELETE RECORD:C58([Raw_Materials_Locations:25])
			USE NAMED SELECTION:C332("Current")
			//the location for most RMs is Arkay, however, PI creates 'PIcreated' for possibly
			//the same item, so a location check fails to roll in properly
			//  : ([RM_BINS]Location#$Location)      
			//   $Location:=[RM_BINS]Location
			//  $Job:=[RM_BINS]PO_No
			// $Prod:=[RM_BINS]Raw_Matl_Code
			
		: ([Raw_Materials_Locations:25]POItemKey:19#$Job)
			//    $Location:=[RM_BINS]Location
			$Job:=[Raw_Materials_Locations:25]POItemKey:19
			$Prod:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
			
		: ([Raw_Materials_Locations:25]Raw_Matl_Code:1#$Prod)
			//  $Location:=[RM_BINS]Location
			$Job:=[Raw_Materials_Locations:25]POItemKey:19
			$Prod:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
	End case 
	$QtyOh:=[Raw_Materials_Locations:25]QtyOH:9
	$rec:=Record number:C243([Raw_Materials_Locations:25])
	NEXT RECORD:C51([Raw_Materials_Locations:25])
End for 