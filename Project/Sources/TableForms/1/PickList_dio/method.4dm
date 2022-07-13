// ----------------------------------------------------
// User name (OS): cs
// Date: 10/7/97
// ----------------------------------------------------
// Form Method: [zz_control].PickList.dio
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Size of array:C274(asPrimKey)=1)  //• 10/7/97 cs 
			asPrimKey:=1
			asDesc1:=1
			asDesc2:=1
			alRecNo:=1
			ListBox1{1}:=True:C214
			LISTBOX SELECT ROW:C912(ListBox1; 1)
			OBJECT SET ENABLED:C1123(bPick; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bPick; False:C215)
		End if 
		
		SetObjectProperties(""; ->Header1; True:C214; sHead1)
		SetObjectProperties(""; ->Header2; True:C214; sHead2)
		SetObjectProperties(""; ->Header3; True:C214; sHead3)
		SetObjectProperties(""; ->Header4; True:C214; "RecordNumber")
End case 