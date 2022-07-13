//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_SendSkidCheck - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fProceed)
C_POINTER:C301($1; $2; $pstxManifest; $pttError)
C_TEXT:C284($ttError; $ttCaseID; $ttSQL)
C_LONGINT:C283($xlNumCases)
ARRAY TEXT:C222($sttBinID; 0)
ARRAY TEXT:C222($sttSkidNum; 0)
$pstxManifest:=$1
$pttError:=$2
$ttError:=$pttError->
$fProceed:=True:C214

$xlNumCases:=Size of array:C274($pstxManifest->)
For ($i; 1; $xlNumCases)
	$ttCaseID:=$pstxManifest->{$i}
	$ttSQL:="SELECT bin_id,skid_number FROM cases WHERE case_id=?"
	SQL SET PARAMETER:C823($ttCaseID; SQL param in:K49:1)
	SQL EXECUTE:C820($ttSQL; $sttBinID; $sttSkidNum)
	
	If (OK=1)
		If (Not:C34(SQL End selection:C821))
			SQL LOAD RECORD:C822(SQL all records:K49:10)
			If (Size of array:C274($sttBinID)>0)
				$ttError:=$ttError+$ttCaseID+" is already saved in WMS"
				$ttError:=$ttError+" in bin "+$sttBinID{1}+" on skid "+$sttSkidNum{1}+(2*Char:C90(Carriage return:K15:38))
				$fProceed:=False:C215
				$i:=Size of array:C274($sttBinID)+1
			End if 
			
		End if 
	End if 
	SQL CANCEL LOAD:C824
	
End for 

$pttError->:=$ttError
$0:=$fProceed