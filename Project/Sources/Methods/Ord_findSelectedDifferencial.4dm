//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/04/06, 14:02:54
// ----------------------------------------------------
// Method: Ord_findSelectedDifferencial
// Description
// used by [zz_control];"OpenOrder" to load a differential after clicking in a list
// ----------------------------------------------------

QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=$1; *)
QUERY:C277([Estimates_Differentials:38];  & ; [Estimates_Differentials:38]diffNum:3=$2)
If (Records in selection:C76([Estimates_Differentials:38])#0)
	If ([Estimates_Differentials:38]BreakOutSpls:18)
		OBJECT SET ENABLED:C1123(rInclDups; False:C215)
		OBJECT SET ENABLED:C1123(rInclDies; False:C215)
		OBJECT SET ENABLED:C1123(rInclPlates; False:C215)
		rInclDies:=1
		rInclPlates:=1
		rInclDups:=1
		rInclPnD:=0
		If ([Estimates_Differentials:38]Prc_Dups:24=0)
			OBJECT SET ENABLED:C1123(rIncldups; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(rInclDups; False:C215)
		End if 
		If ([Estimates_Differentials:38]Prc_Plates:23=0)
			OBJECT SET ENABLED:C1123(rInclPlates; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(rInclPlates; False:C215)
		End if 
		If ([Estimates_Differentials:38]Prc_Dies:22=0)
			OBJECT SET ENABLED:C1123(rInclDies; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(rInclDies; False:C215)
		End if 
		
	Else 
		OBJECT SET ENABLED:C1123(rIncldies; True:C214)
		OBJECT SET ENABLED:C1123(rInclplates; True:C214)
		OBJECT SET ENABLED:C1123(rIncldups; True:C214)
		OBJECT SET ENABLED:C1123(rInclPnD; True:C214)
	End if 
	
	If ([Estimates_Differentials:38]PrepCharges:34=0)
		rInclPrep:=0
		OBJECT SET ENABLED:C1123(rInclPrep; True:C214)
	Else 
		rInclPrep:=1
		OBJECT SET ENABLED:C1123(rInclPrep; False:C215)
	End if 
	
End if 