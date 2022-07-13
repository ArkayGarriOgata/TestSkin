//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/22/08, 23:06:10
// ----------------------------------------------------
// Method: BOL_ListBox1_revert_release
// Description
// get the list box back to the state before any picks were made
// ----------------------------------------------------

C_LONGINT:C283($1; $release_number; $anyClones; $first; $hit; $0)

$release_number:=$1
$numReleasesOnBOL:=Size of array:C274(aReleases)
$anyClones:=0  //a prior pick may have created additional case-count rows, need to restore to original state

For ($i; 1; $numReleasesOnBOL)
	If (aReleases{$i}=$release_number)  //clear it out to be rebuilt
		aLocation2{$i}:=""
		aRecNo2{$i}:=0
		aNumCases2{$i}:=0
		aPackQty2{$i}:=0
		aTotalPicked2{$i}:=0
		aPallet2{$i}:=""
		aJobit2{$i}:="T.B.D."
		aWgt2{$i}:=0
		$anyClones:=$anyClones+1
	End if 
End for 

If ($anyClones>1)  //then remove them
	$first:=Find in array:C230(aReleases; $release_number)  // this is the first occurance
	Repeat 
		$hit:=Find in array:C230(aReleases; $release_number; $first+1)
		If ($hit>-1)
			DELETE FROM ARRAY:C228(aReleases; $hit; 1)
			DELETE FROM ARRAY:C228(aCPN2; $hit; 1)
			DELETE FROM ARRAY:C228(aLocation2; $hit; 1)
			DELETE FROM ARRAY:C228(aRecNo2; $hit; 1)
			DELETE FROM ARRAY:C228(aNumCases2; $hit; 1)
			DELETE FROM ARRAY:C228(aPackQty2; $hit; 1)
			DELETE FROM ARRAY:C228(aTotalPicked2; $hit; 1)
			DELETE FROM ARRAY:C228(aPallet2; $hit; 1)
			DELETE FROM ARRAY:C228(aJobit2; $hit; 1)
			DELETE FROM ARRAY:C228(arValues; $hit; 1)
			DELETE FROM ARRAY:C228(aWgt2; $hit; 1)
		End if 
	Until ($hit=-1)
End if 

$0:=Size of array:C274(aReleases)