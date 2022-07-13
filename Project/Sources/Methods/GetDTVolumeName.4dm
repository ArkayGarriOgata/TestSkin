//%attributes = {"publishedWeb":true}
//PM: GetDTVolumeName(prompt) -> volume's name
//@author mlb - 9/5/02  12:47

C_TEXT:C284($1; $0)

zwStatusMsg("SELECT"; $1)

$0:=""

ARRAY TEXT:C222($aVolumes; 0)
VOLUME LIST:C471($aVolumes)
Case of 
	: (Size of array:C274($aVolumes)=1)
		$0:=$aVolumes{1}
		
	: (Size of array:C274($aVolumes)>1)
		$i:=1
		Repeat 
			CONFIRM:C162("How about: "+$aVolumes{$i}; "OK"; "Next")
			If (OK=1)
				$0:=$aVolumes{$i}
				$i:=1000
			Else 
				$i:=$i+1
			End if 
		Until (OK=1) | ($i>Size of array:C274($aVolumes))
End case 

zwStatusMsg("SELECTED"; $0)