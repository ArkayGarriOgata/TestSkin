//%attributes = {}
//Method:  Compiler_0000_ConstantsToDo
//Description:  This method is used to store names of constants that need to be created.
//   This allows us to use constants when we need to without having to previously create them
//   We are using the constants component by 4D in the 4D Pop set.

//  Constants General Information
//     a. Constants in component are accessable from host.
//     b. If a host constant and the component constant share the same name.
//          The host will use the host constant value and the
//          component will use the components constant value.
//     c. If you create a constants file with 4D Pop make sure it is a seperate database.
//           In otherwords create a database with just 4dPop and have it create all the seperate
//           constant.xlf files and then copy and paste these xliff documents into the resource
//           folder of the database they are to be used.

//  How to use this:
//     1.  Call this method at the top of any method that needs a constant
//     2.  Make sure to declare them here as well

//   After the constants have been created and added as a plugin:
//     0.  Make sure the constants (variables) are now all underlined and look like a constant
//            instead of a variable.  If not go back and add the missing ones.
//     1.  Find in design for all occurrences of Compiler_0000_ConstantsToDo and replace with nothing
//            This will safely remove the call and just leave a blank line
//     2.  Clear everything from this method and it is ready to be used again

C_TEXT:C284(AdrsktStyleFlat)
AdrsktStyleFlat:="Flat"

C_TEXT:C284(ArkyktAmsHelpEmail)
ArkyktAmsHelpEmail:="garri.ogata@arkay.com"

C_TEXT:C284(ArkyktLctnHauppauge)
ArkyktLctnHauppauge:="Hauppauge"

C_TEXT:C284(ArkyktLctnRoanoke)
ArkyktLctnRoanoke:="Roanoke"

C_TEXT:C284(ArkyktLctnWarehouse)
ArkyktLctnWarehouse:="Warehouse"

C_TEXT:C284(ArkyktLctnRemote)
ArkyktLctnRemote:="Remote"

C_LONGINT:C283(CoreknQuryRowMax)
CoreknQuryRowMax:=6

C_LONGINT:C283(CoreknQuryRowHeight)
CoreknQuryRowHeight:=30

C_LONGINT:C283(CoreknHListRelateNone)
CoreknHListRelateNone:=0

C_LONGINT:C283(CoreknHListRelateOne)
CoreknHListRelateOne:=1

C_LONGINT:C283(CoreknHListRelateMany)
CoreknHListRelateMany:=2

C_LONGINT:C283(CoreknMaxAlias)
CoreknMaxAlias:=5

C_TEXT:C284(CorektExtensionMovie)
CorektExtensionMovie:="Mov"

C_TEXT:C284(CorektExtensionPDF)
CorektExtensionPDF:="PDF"
