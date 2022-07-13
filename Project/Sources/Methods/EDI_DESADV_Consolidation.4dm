//%attributes = {}
// _______
// Method: EDI_DESADV_Consolidation   ( argment object ) -> none
// By: Mel Bohince @ 06/01/20, 08:25:52
// Description
// manage a consolidation for mixed pallet scenarios
// init iwth last release = 0 to disable

//Parameter Signature:
// argument.msg
// argument.lastRelease     this is the last one in the entity selection, used as a marker to close the consolidation
// argument.currentRelease
// argument.casesPerPallet
// argument.consolidationName
// argument.incrementCases
// argument.purchaseOrder
// argument.consolDetail

// Sample calls:
//EDI_DESADV_Consolidation(New object("msg";"init";"lastRelease";$lastReleaseNum;"casesPerPallet";$defaultCasesPerSkid))
//EDI_DESADV_Consolidation(New object("msg";"incrementCases";"incrementCases";$numberOfCases))
//EDI_DESADV_Consolidation(New object("msg";"addDetail";"consolDetail";$consolidationDetail_o))
// see also EDI_DESADV_ConsolidationSkidTTL

// ----------------------------------------------------
// Modified by: Mel Bohince (12/9/20) allow for user entered consolidation id
// Modified by: Mel Bohince (1/20/21) allow for a blank consolidation for parcels so pallet count is not given
// Modified by: Mel Bohince (3/9/21) don't send less than one pallet
// Modified by: Mel Bohince (4/13/21) User controlled number of pallets, added $consolidationDetail_o and call
// Modified by: Mel Bohince (4/14/21) change $1 to object

C_TEXT:C284($msg; $consolidationId; $default; $consolidationName)  //;$4)
C_OBJECT:C1216(consolidation_o; $argv; $1; $consolDetail)
C_LONGINT:C283($lastRelease; $currentRelease; $casesPerPallet; $numCases)

If (Count parameters:C259=1)
	$argv:=$1
	If ($argv#Null:C1517)
		If (OB Is defined:C1231($argv; "msg"))
			$msg:=$argv.msg
			
			If (OB Is defined:C1231($argv; "lastRelease"))
				$lastRelease:=$argv.lastRelease
			End if 
			
			If (OB Is defined:C1231($argv; "currentRelease"))
				$currentRelease:=$argv.currentRelease
			End if 
			
			If (OB Is defined:C1231($argv; "casesPerPallet"))
				$casesPerPallet:=$argv.casesPerPallet
			End if 
			
			If (OB Is defined:C1231($argv; "consolidationName"))
				$consolidationName:=$argv.consolidationName
			End if 
			
			If (OB Is defined:C1231($argv; "incrementCases"))
				$numCases:=$argv.incrementCases
			End if 
			
			If (OB Is defined:C1231($argv; "purchaseOrder"))
				$consolidationName:=$argv.purchaseOrder
			End if 
			
			If (OB Is defined:C1231($argv; "consolDetail"))
				$consolDetail:=$argv.consolDetail
			End if 
			
		Else   //badly formed arguments
			$msg:="ERROR3"
		End if 
	Else 
		$msg:="ERROR2"
	End if 
Else 
	$msg:="ERROR1"
End if 

If (False:C215)  //(Count parameters>1) the original argv sig
	//$longInt:=$2  //either the last releaseid or the cases to increment by
	//End if 
	
	//If (Count parameters>2)
	//$casesPerPallet:=$3
	//End if 
	
	//If (Count parameters>3)
	//$consolidationName:=$4
End if 

Case of 
	: ($msg="init")
		//set up and id# and create the accumlator
		consolidation_o:=New object:C1471
		//calculate a unique number based on date
		$millinow:=Milliseconds:C459  //don't want all the time since boot
		$millithen:=Round:C94($millinow; -4)
		$millidiff:=String:C10(Abs:C99($millinow-$millithen); "0000")
		$default:=fYYMMDD(4D_Current_date)+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+$millidiff
		consolidation_o.id:="U"+$default
		
		If ($lastRelease>0)  // last release number provided   Modified by: Mel Bohince (12/11/20) 
			
			Case of   //consolidationType is set when Send ASN button is first clicked on the form
				: (consolidationType="Parcel")  //parcels purposely omit the consolidation and pallet count, typically small # of cases going UPS
					consolidation_o.id:=""  //purposely left blank to benefit the TMC system
					
				: (consolidationType="PerASN")  //PerASN targeted at overseas booked with DSV who can't handle the pallet count, so each po is a pallet fractional
					consolidation_o.id:="PO"+$consolidationName  // the consolidation number is always the PO#
					
				Else 
					$consolidationId:=Request:C163("Enter Authorization Number (Load/Consolidation)"; consolidation_o.id; "Set"; "None")  //offer a choice fro the consl#
					Case of 
						: (ok=0)  // Modified by: Mel Bohince (1/20/21) allow for a blank consolidation for parcels so pallet count is not given
							consolidation_o.id:=""  //none button clicked
							//NOT:use the timestamp style already calculated
							
						: (ok=1)  //set button clicked
							If (Length:C16($consolidationId)>3)
								consolidation_o.id:=$consolidationId  //user entered
							Else 
								uConfirm("Entry too short, using "+$default; "Ok"; "What?")
							End if 
					End case 
					
			End case 
			
		End if   //last release provided
		
		consolidation_o.cases:=0  //accumulator
		consolidation_o.casesPerPallet:=$casesPerPallet
		consolidation_o.lastRelease:=$lastRelease  //marker for last release going to this ship-to, time to dump in the accumlated stats 
		consolidation_o.totalPallets:=0
		consolidation_o.numberPalletSpaces:=0  //this si the same as totalPallets, just needed for asn segment that is not applicable to arkay
		consolidation_o.purchaseOrders_c:=New collection:C1472
		
	: ($msg="incrementCases")
		consolidation_o.cases:=consolidation_o.cases+$numCases  //accumulator
		
	: ($msg="addDetail")
		consolidation_o.purchaseOrders_c.push($consolDetail)
		
	: ($msg="close?")
		If (consolidation_o.lastRelease#0)  //sending 0 means don't consolidate
			
			Case of 
				: (consolidationType="Parcel")
					consolidation_o.totalPallets:=0
					
				: (consolidationType="PerASN")
					consolidation_o.totalPallets:=Round:C94(consolidation_o.cases/consolidation_o.casesPerPallet; 2)
					
				Else 
					If ($currentRelease=consolidation_o.lastRelease) & (consolidation_o.lastRelease#0)  //sending 0 means don't consolidate
						consolidation_o.totalPallets:=EDI_DESADV_ConsolidationSkidTTL  // Modified by: Mel Bohince (4/13/21) User controlled number of pallets, added $consolidationDetail_o and call
						//consolidation_o.totalPallets:=Round(consolidation_o.cases/consolidation_o.casesPerPallet;2)  //24 is the mode of cases/skid, 30 is the average
						//consolidation_o.totalPallets:=Choose(consolidation_o.totalPallets>1;consolidation_o.totalPallets;1)  // Modified by: Mel Bohince (3/9/21) don't send less than one pallet
					End if 
			End case 
			
		End if   //last release in consolidation
		
		consolidation_o.numberPalletSpaces:=consolidation_o.totalPallets
		
	: ($msg="kill")
		consolidation_o:=Null:C1517
		
	Else 
		ALERT:C41("Parameter usage error in "+Current method name:C684)
End case 
