//%attributes = {}
//Method:  Core_ListBox_SelectedRowB(pListBox{;pnSelectedRow})=>bSelectedRow
//Description:  This method will return true if the listbox has a selected row
//   that is a valid row.

C_BOOLEAN:C305($0; $bSelectedRow)
C_POINTER:C301($1; $pListBox; $2; $pnSelectedRow)

C_LONGINT:C283($nNumberOfParameters)
$nNumberOfParameters:=Count parameters:C259

$pListBox:=$1

If ($nNumberOfParameters>1)
	$pnSelectedRow:=$2
End if 

$bSelectedRow:=False:C215

Case of 
		
	: (Is nil pointer:C315($pListBox))
		
	: (Find in array:C230($pListBox->; True:C214)<=0)  //No Selected row
		
	Else   //selected a valid row
		
		$bSelectedRow:=True:C214
		
		If ($nNumberOfParameters>1)
			$pnSelectedRow->:=Find in array:C230($pListBox->; True:C214)
		End if 
		
End case 

$0:=$bSelectedRow