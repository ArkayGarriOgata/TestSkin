//%attributes = {"publishedWeb":true}
//gSetAddrType()  -JML   7/6/93
//•081595  MLB  
//simple procedure which allows user to choose the Address
//type (from list of AddressTypes)
//this is used a few different times within the uLinkRelated() procedure
//and layouts.

C_TEXT:C284($0)
ARRAY TEXT:C222(asAddrTypes; 0)

LIST TO ARRAY:C288("AddressTypes"; asAddrTypes)
asAddrTypes:=1
//uCenterWindow (200;190;1;"")  `•081595  MLB 
$winRef:=Open form window:C675([zz_control:1]; "SelectAddress")  //;Sheet form window )
DIALOG:C40([zz_control:1]; "SelectAddress")
If (ok=1)
	$hit:=Find in array:C230(ListBox1; True:C214)
	$0:=asAddrTypes{$hit}
Else 
	$0:=""
End if 
CLOSE WINDOW:C154($winRef)
