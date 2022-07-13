//%attributes = {"executedOnServer":true}
//*****************************************************************************
// //
// //  OnSVR_GetApplicationVersion
// //
// //  Purpose: To retriever the version number of 4D Server
// //
// //  $0 - TEXT - Returned version string
// //  $1 - POINTER - Pointer to an integer variable for build number
// //  $2 - BOOLEAN - TRUE for long version, FALSE for short version
// //
//*****************************************************************************

C_TEXT:C284($MethodName_T)
C_TEXT:C284($0; $Result_T)
C_POINTER:C301($BuildNo_P; $1)
C_BOOLEAN:C305($GetLongVers_B; $2)
C_LONGINT:C283($Ndx; $SOA; $RIS; $Params_L)

$Params_L:=Count parameters:C259
$MethodName_T:=Current method name:C684

If ($Params_L>0)
	$BuildNo_P:=$1
	If ($Params_L=1)
		$Result_T:=Application version:C493($BuildNo_P->)
	Else 
		$GetLongVers_B:=$2
		If ($GetLongVers_B)
			$Result_T:=Application version:C493($BuildNo_P->; *)
		Else 
			$Result_T:=Application version:C493($BuildNo_P->)
		End if 
	End if 
Else 
	$Result_T:=Application version:C493
End if 

$0:=$Result_T