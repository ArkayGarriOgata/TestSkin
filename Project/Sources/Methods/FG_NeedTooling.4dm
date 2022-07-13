//%attributes = {}
// Method: FG_NeedTooling ($cust;$cpn) -> text
// ----------------------------------------------------
// by: mel: 01/29/04, 15:48:10
// ----------------------------------------------------
// Description:
// check for art and any other stuff
// ----------------------------------------------------

C_LONGINT:C283($numFG)
C_TEXT:C284($1)
C_TEXT:C284($fgKey; $2)
C_TEXT:C284($0; $return)

$fgKey:=$1+":"+$2
$return:="....."
$numFG:=qryFinishedGood("#KEY"; $fgKey)

If ($numFG>0)
	If ([Finished_Goods:26]DateSnS_Approved:83=!00-00-00!)
		$return[[1]]:="S"
	End if 
	
	If ([Finished_Goods:26]DateColorApproved:86=!00-00-00!)
		$return[[2]]:="C"
	End if 
	
	If ([Finished_Goods:26]DateArtApproved:46=!00-00-00!)
		$return[[3]]:="A"
	End if 
	
	If ([Finished_Goods:26]DateSpecApproved:89=!00-00-00!)
		$return[[4]]:="$"
	End if 
	
	If ([Finished_Goods:26]DateClosingMet:80=!00-00-00!)
		$return[[5]]:="M"
	End if 
	
Else 
	$return:="-n/f-"
End if 

$0:=$return