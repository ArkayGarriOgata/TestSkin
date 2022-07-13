//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/20/10, 13:34:41
// ----------------------------------------------------
// Method: UTIL_CompareAppVersions
// Description
// from kb 76028
//*****************************************************************************
// //
// //  UTIL_CompareAppVersions
// //
// //  Purpose: To compare the version number between Server and Client
// //
// //  $0 - BOOLEAN - Result the comparison of returned strings
// //  $1 - BOOLEAN - Long version or short version
// //  $2 - POINTER - Pointer to the Server Application Version String Var
// //  $3 - POINTER - Pointer to the Local Application Version String Var
// //  $4 - POINTER - Pointer to the Server Application Build Number Int Var
// //  $5 - POINTER - Pointer to the Local Application Build Number Int Var
// //
//*****************************************************************************
// Modified by: Garri (3/9/20) get the build number and compare

$MethodName_T:=Current method name:C684

C_TEXT:C284($MethodName_T)
C_BOOLEAN:C305($0; $Result_B)
C_BOOLEAN:C305($LongVers_B; $1)
C_POINTER:C301($SvrVers_P; $2)
C_POINTER:C301($LocalVers_P; $3)
C_POINTER:C301($SVR_Build_P; $4)
C_POINTER:C301($LOC_Build_P; $5)
C_LONGINT:C283($Ndx; $SOA; $RIS; $Params_L; $SVR_Short_L)
C_LONGINT:C283($LOC_Short_L; $SVR_Long_L; $LOC_Long_L)
C_TEXT:C284($SvrVers_T; $LocalVers_T; $SvrVers__T; $LocalVers_T)

$Params_L:=Count parameters:C259

Case of 
	: ($Params_L=0)
		$SVR_Build:=0
		$SVR_Build_P:=->$SVR_Build
		$LOC_Build:=0
		$LOC_Build_P:=->$LOC_Build
		$SvrVers_T:=OnSVR_GetApplicationVersion($SVR_Build_P; True:C214)
		$LocalVers_T:=Application version:C493($LOC_Build_P->; *)
		
		//: ($Params_L=3)
		//$LongVers_B:=$1
		//$SvrVers_P:=$2
		//$LocalVers_P:=$3
		//If ($LongVers_B)
		//$SvrVers_T:=OnSVR_GetApplicationVersion ($SVR_Long_L;True)
		//$LocalVers_T:=Application version($LOC_Long_L;*)
		//Else 
		//$SvrVers_T:=OnSVR_GetApplicationVersion 
		//$LocalVers_T:=Application version
		//End if 
		//$SvrVers_P->:=$SvrVers_T
		//$LocalVers_P->:=$LocalVers_T
		//
		//: ($Params_L=5)
		//$LongVers_B:=$1
		//$SvrVers_P:=$2
		//$LocalVers_P:=$3
		//$SVR_Build_P:=$4
		//$LOC_Build_P:=$5
		//If ($LongVers_B)
		//$SvrVers_T:=OnSVR_GetApplicationVersion ($SVR_Build_P;True)
		//$LocalVers_T:=Application version($LOC_Build_P->;*)
		//Else 
		//$SvrVers_T:=OnSVR_GetApplicationVersion ($SVR_Build_P)
		//$LocalVers_T:=Application version($LOC_Build_P->)
		//End if 
		//$SvrVers_P->:=$SvrVers_T
		//$LocalVers_P->:=$LocalVers_T
		
	Else 
		ALERT:C41("Bad parameter count: "+String:C10($Params_L)+" must be 0, 3, or 5!")
		
End case 

//$0:=($SvrVers_T=$LocalVers_T)
$0:=(($SvrVers_T=$LocalVers_T) & ($SVR_Build_P->=$LOC_Build_P->))  // Modified by: Garri (3/9/20) get the build number and compare
