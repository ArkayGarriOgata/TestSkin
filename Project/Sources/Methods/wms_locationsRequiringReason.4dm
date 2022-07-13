//%attributes = {}
// Method: wms_locationsRequiringReason () -> 
// ----------------------------------------------------
// by: mel: 03/03/05, 10:03:56
// ----------------------------------------------------
// Description:
// enforce require to give reason for some moves.
// Updates:
//mlb 11/8/7 if something like XC:R12-12-1 is sent also test for XC:R
// ----------------------------------------------------
C_LONGINT:C283($hit; $len)
C_TEXT:C284($1; $to_location)  //name of the location
C_BOOLEAN:C305($0)

If (Count parameters:C259=0)  //initialize
	If (Size of array:C274(<>aReasonRequiredForMove)=0)
		READ ONLY:C145([WMS_AllowedLocations:73])
		QUERY:C277([WMS_AllowedLocations:73]; [WMS_AllowedLocations:73]ReasonRequired:3=True:C214)
		SELECTION TO ARRAY:C260([WMS_AllowedLocations:73]ValidLocation:1; <>aReasonRequiredForMove)
		REDUCE SELECTION:C351([WMS_AllowedLocations:73]; 0)
	End if 
	$0:=True:C214
	
Else   //test if a reason in required
	$to_location:=$1
	
	$hit:=Find in array:C230(<>aReasonRequiredForMove; $to_location)
	If ($hit#-1)  //explicitly named location
		$0:=True:C214
		
	Else   //test only the prefix
		$len:=Length:C16($to_location)
		Case of 
			: ($len<=3)  //a Hauppauge floor area like FG: or EX:
				//pass, just run the same test and fail
			: ($len=4)  //a Roanoke floor area like FG:R or EX:R
				//pass, just run the same test and fail
				
			Else   //strip the bin address
				If ($to_location[[4]]="R")
					$to_location:=Substring:C12($to_location; 1; 4)
				Else 
					$to_location:=Substring:C12($to_location; 1; 3)
				End if 
		End case 
		
		$hit:=Find in array:C230(<>aReasonRequiredForMove; $to_location)
		$0:=($hit#-1)
	End if 
End if 