//%attributes = {"publishedWeb":true}
//fCalcComm71($thisUM;$FormSqIn;$stdCost;$Flex4;$Flex2;$Flex3)
//• 4/9/98 cs nan checking/removal

C_LONGINT:C283($0)
C_TEXT:C284($thisUM; $1)
C_REAL:C285($FormSqIn; $2; $stdCost; $3; $Flex4; $4; $Flex2; $5; $Flex3; $6; $die; $counter; $misc)
C_BOOLEAN:C305($repeatForm)

$thisUM:=$1
$FormSqIn:=$2
$stdCost:=$3
$Flex4:=$4
$Flex2:=$5
$Flex3:=$6
[Estimates_Materials:29]Commodity_Key:6:="13-Laser Dies"
[Estimates_Materials:29]UOM:8:="EACH"
$thisUM:="EACH"

BEEP:C151
ALERT:C41("FIX YOUR PROCESS SPEC, IT IS STILL USING COMMODIY 71 WHICH IS OBSOLETE!")
If ($thisUM="SQIN")
	[Estimates_Materials:29]Qty:9:=uNANCheck($FormSqIn)
	$misc:=$FormSqIn*$stdCost*$Flex4
	If ([Estimates_Materials:29]Real1:14#0)  //              overrides
		$Flex2:=[Estimates_Materials:29]Real2:15
	End if 
	If ([Estimates_Materials:29]Real2:15#0)
		$Flex3:=[Estimates_Materials:29]Real2:15
	End if 
	$die:=$FormSqIn*$Flex2*$Flex4
	$counter:=$FormSqIn*$Flex3*$Flex4
	[Estimates_Materials:29]Cost:11:=$misc+$die+$counter
	[Estimates_Materials:29]CalcDetails:24:="Misc: "+String:C10($misc; "$###,##0")+"   Die: "+String:C10($die; "$###,##0")+"   Counter: "+String:C10($counter; "$###,##0")
	//1/11/95 upr 1382
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		COPY NAMED SELECTION:C331([Estimates_Machines:20]; "mach")
		
		
	Else 
		
		ARRAY LONGINT:C221($_mach; 0)
		LONGINT ARRAY FROM SELECTION:C647([Estimates_Machines:20]; $_mach)
		
	End if   // END 4D Professional Services : January 2019 
	qryMachEst
	If (Records in selection:C76([Estimates_Machines:20])=1)
		Case of 
			: ([Estimates_Materials:29]CostCtrID:2="461")
				$repeatForm:=[Estimates_Machines:20]Flex_field6:37
			: ([Estimates_Materials:29]CostCtrID:2="465")
				$repeatForm:=[Estimates_Machines:20]Flex_Field5:25
			Else 
				$repeatForm:=False:C215
				BEEP:C151
				MESSAGE:C88("COMMODITY 71 USED ON NEITHER 461 OR 465")
		End case 
		
	Else 
		BEEP:C151
		MESSAGE:C88("COMMODITY 71 USED ON UNSPECIFIED OPERATION")
		$repeatForm:=False:C215
	End if 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("mach")
		CLEAR NAMED SELECTION:C333("mach")
		
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Estimates_Machines:20]; $_mach)
		
	End if   // END 4D Professional Services : January 2019 
	
	If ($repeatForm)
		[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Cost:11/2
		[Estimates_Materials:29]CalcDetails:24:=[Estimates_Materials:29]CalcDetails:24+"; 50% reduction for repeat form."
	End if 
	//end upr 1382
	
Else 
	$matlError:=-7101
	$0:=$matlError
End if 

$0:=0