//%attributes = {"publishedWeb":true}
//(p) MkBuildUniques
// setup array of unique CPNs for Mark ay report
//• 1/15/98 cs created

C_LONGINT:C283($ToPrint)

$ToPrint:=Size of array:C274(aCPN)

ARRAY TEXT:C222(aUniqCPN; 0)
ARRAY LONGINT:C221(aUniqPayuse; 0)
ARRAY LONGINT:C221(aUniqProd; 0)
ARRAY LONGINT:C221(aUniqExcess; 0)
ARRAY TEXT:C222(aUniqCPN; $ToPrint)
ARRAY LONGINT:C221(aUniqPayuse; $ToPrint)
ARRAY LONGINT:C221(aUniqProd; $ToPrint)
ARRAY LONGINT:C221(aUniqExcess; $ToPrint)
$Count:=1

For ($i; 1; $ToPrint)  //create and load aUniq CPNs for the orderlines
	$loc:=Find in array:C230(aUniqCPN; aCpn{$i})
	If ($Loc<0)
		aUniqCPn{$Count}:=aCpn{$i}
		$Count:=$Count+1
	End if 
End for 
$Count:=$Count-1
ARRAY TEXT:C222(aUniqCPN; $Count)
ARRAY LONGINT:C221(aUniqPayuse; $Count)
ARRAY LONGINT:C221(aUniqProd; $Count)
ARRAY LONGINT:C221(aUniqExcess; $Count)