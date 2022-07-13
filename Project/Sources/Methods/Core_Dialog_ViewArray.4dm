//%attributes = {}
//Method:  Core_Dialog_ViewArray(papColumn;patColumnHeader;panListBoxColumnTrait;tWindowTitle) 
//Description:  This method will View arrays that are in papColumn it will also use the headers in patColumnHeader
//  

//      ColumnTrait        Meaning

//             1           Column is enterable
//             2           Use best column size otherwise default.
//             4           Invisible
//             8           Align Right
//            16           Center
//            32           Align Left

//Example:

//   ARRAY POINTER($apColumn;0)
//   ARRAY TEXT($atHeader;0)
//   ARRAY LONGINT($anTrait;0)
//   C_TEXT($tTitle)

//   APPEND TO ARRAY($apColumn;->$atSKU)
//   APPEND TO ARRAY($apColumn;->$atProductKey)
//   APPEND TO ARRAY($apColumn;->$atProductName)

//   APPEND TO ARRAY($atHeader;"SKU")
//   APPEND TO ARRAY($atHeader;"Key")
//   APPEND TO ARRAY($atHeader;"Name")

//   APPEND TO ARRAY($anTrait;2+16)  //Best size and center
//   APPEND TO ARRAY($anTrait;1+2+8)  //Best size, enterable and align right
//   APPEND TO ARRAY($anTrait;2)

//   $tTitle:="My Window Title"

//   Core_Dialog_ViewArray (->$apColumn;->$atHeader;->$anTrait;$tTitle)

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $2; $3)
	C_TEXT:C284($4)
	
	C_OBJECT:C1216($oWindow)
	
	Core_papViewArray_Column:=$1
	Core_patViewArray_Header:=$2
	Core_panViewArray_Trait:=$3
	
	Core_tViewArray_Title:=$4
	
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:="Core_ViewArray"
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Core_ViewArray")
