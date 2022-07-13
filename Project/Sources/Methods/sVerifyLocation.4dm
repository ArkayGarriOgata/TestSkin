//%attributes = {"publishedWeb":true}
//(p)boolean:=sVerifyLocation(»Location)11/13/94
//• Adam Soos 3/29/96 During PI, ceation of location allowed
//•010697  MLB  UPR allow bill and holds to be entered freely
//•3/4/97 cs upr 1858 - allow location to pass through if user needs it to
//  removed some of adams code
//• 4/8/97 cs added restriction that only certain users allowed to create location
//  requested method implementation by MLB, for PI (users creating locations)
//•031699  MLB  limit server hits during PI
//•081799  mlb  valid if already a bin with that name
//Modified by: Mel Bohince (5/29/13) allow setting to Rama
//see also wms_locationIsValid($1)
// Modified by: Mel Bohince (5/10/16) remove that flip flop to $temp

C_POINTER:C301($1)
C_TEXT:C284($Location; $temp)
C_BOOLEAN:C305($0)  //rtn true if its a valide location
C_LONGINT:C283($numFound)

$Location:=$1->
$0:=False:C215

Case of   //speed up for generic R/M bins and floor locations    
	: ($Location="Roanoke")
		$numFound:=1
	: ($Location="Hauppauge")
		$numFound:=1
	: ($Location="Vista")
		$numFound:=1
	: ($Location="ROC_WHS")  // Modified by: Mel Bohince (10/28/21) 
		$numFound:=1
	: ($Location="FG:V")
		$numFound:=1
	: ($Location="FG:R")
		$numFound:=1
	: ($Location="FG:OS")
		$numFound:=1
		//: ($Location="FX:R")
		//$numFound:=1
	: ($Location="CC:")
		$numFound:=1
	: ($Location="CC:R")
		$numFound:=1
	: ($Location="EX:")
		$numFound:=1
	: ($Location="EX:R")
		$numFound:=1
	: ($Location="XC:")
		$numFound:=1
	: ($Location="XC:R")
		$numFound:=1
		//: (Position("FG:AV=Rama#";$Location)>0)  // Rama location - Modified by: Mel Bohince (5/29/13) allow setting to Rama
		//$numFound:=1
		//: (Position("FG:AV-Rama#";$Location)>0)  // In transit to Rama - Modified by: Mel Bohince (5/29/13) allow setting to Rama
		//$numFound:=1
	: (Position:C15("Stage"; $Location)>0)
		$numFound:=1
	Else 
		//$temp:=$Location  //•010697  MLB  UPR special handling for Bill and Holds
		//If (Substring($Location;1;2)="BH") | (Substring($Location;1;2)="FX")  `mlb 04/17/06 ignor prefix
		//If (Length($Location)>4)  //FX:R
		//$Location:="FG"+Substring($Location;3)  //see if the whse/row/isle/shelf exist
		//$Location:=Replace string($Location;":V";":R")
		//End if 
		READ ONLY:C145([WMS_AllowedLocations:73])
		$numFound:=0  // Modified by: Mel Bohince (6/9/21) 
		SET QUERY DESTINATION:C396(Into variable:K19:4; $numFound)
		QUERY:C277([WMS_AllowedLocations:73]; [WMS_AllowedLocations:73]ValidLocation:1=$Location)
		//If ($numFound=0)  //see if the barcode was scanned in
		//  //$bc:=$Location
		//  //If (Length($bc)#0)
		//  //QUERY([WMS_AllowedLocations];[WMS_AllowedLocations]BarcodedID=$bc)
		//  //If ($numFound=0)  //•081799  mlb  valid if already a bin with that name
		//  //QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location=$Location)
		//  //End if 
		
		//  //Else   //does it already exist somewhere
		//  //QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location=$Location)
		//  //End if 
		//End if 
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		//$Location:=$temp  //•010697  MLB change back to value entered
End case 

Case of 
	: ($numFound>=1)
		$0:=True:C214
		
	: ($numFound=0)
		If ((User in group:C338(Current user:C182; "Inv Mgr")) | (User in group:C338(Current user:C182; "Physical Inv Manager")))  //• 4/8/97 cs new restriction
			uConfirm("The location you have entered, '"+$Location+", is invalid."+<>sCr+"                    Does it really exist?"; "Yes, allow it"; "Try again")
			If (OK=1)  //user oks first confirm                
				CREATE RECORD:C68([WMS_AllowedLocations:73])
				[WMS_AllowedLocations:73]ValidLocation:1:=$Location
				
				uConfirm("Does this location require a reason when moving to it?"; "Yes"; "No")
				If (ok=1)
					[WMS_AllowedLocations:73]ReasonRequired:3:=True:C214
				Else 
					[WMS_AllowedLocations:73]ReasonRequired:3:=False:C215
				End if 
				
				//$bc:=Request("What is the bin_id for this location?";"Set";"Not barcoded")
				//If (ok=1) & (Length($bc)>0)
				[WMS_AllowedLocations:73]BarcodedID:2:=wms_convert_bin_id("wms"; $Location)
				//Else 
				//[WMS_AllowedLocations]BarcodedID:=""
				//End if 
				
				SAVE RECORD:C53([WMS_AllowedLocations:73])
				UNLOAD RECORD:C212([WMS_AllowedLocations:73])
				$0:=True:C214
				
			Else 
				uConfirm("Location "+$Location+"' was not created."; "Try Again"; "Help")
				$1->:=""
				GOTO OBJECT:C206($1->)
			End if   //end first confirm
			
		Else 
			uConfirm("The Location You have Entered, '"+$Location+"' is Invalid."+<>sCr+"You must be an Inventory Manager or Physical Invenory Manager to create"+" new locations."; "Try Again"; "Help")
			$1->:=""
			GOTO OBJECT:C206($1->)
		End if 
End case 