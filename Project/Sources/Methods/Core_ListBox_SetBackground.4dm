//%attributes = {}
//Method:  Core_ListBox_SetBackground(pabListBox{;pabListBoxCheckBox})
//Description:  This method will set the background color for selected

//Setting background color for a listbox array based
//   In the Property List do the following:
//     Background and Border:Row Background Color Array
//        Modl_anListBox_RowBackground
//   See: Core_ListBox_SetBackground
//   Make sure to size the array after the listbox columns are filled
//   Make sure to include if the lisbox rows are being added or deleted
//   Make sure to use the CoreknBackground colors:
//        CoreknBackgroundRed
//        CoreknBackgroundGreen
//        CoreknBackgroundBlue
//        CoreknBackgroundOrange

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pabListBox)
	C_POINTER:C301($2; $pabListBoxCheckBox)
	
	C_POINTER:C301($panRowBackground)
	C_LONGINT:C283($nRow; $nNumberOfRows)
	C_BOOLEAN:C305($bUseCheckBox)
	C_LONGINT:C283($nNumberOfParameters)
	
	$pabListBox:=$1
	
	$nNumberOfParameters:=Count parameters:C259
	$bUseCheckBox:=False:C215
	
	If ($nNumberOfParameters>=2)  //Optional
		$pabListBoxCheckBox:=$2
		$bUseCheckBox:=True:C214
	End if   //Done optional
	
	$panRowBackground:=Get pointer:C304(LISTBOX Get property:C917($pabListBox->; lk background color expression:K53:47))
	
	$nNumberOfRows:=Size of array:C274($panRowBackground->)
	
End if   //Done Initialize

For ($nRow; 1; $nNumberOfRows)  // Loop thru rows
	
	If ($bUseCheckBox)  //Use checkbox
		
		$panRowBackground->{$nRow}:=Choose:C955($pabListBoxCheckBox->{$nRow}; CoreknBackgroundGreen; lk inherited:K53:26)
		
	Else   //Use listbox
		
		$panRowBackground->{$nRow}:=Choose:C955($pabListBox->{$nRow}; CoreknBackgroundGreen; lk inherited:K53:26)
		
	End if   //Done use checkbox
	
End for   // Done looping thru rows