//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 10/24/13, 09:41:37
// ----------------------------------------------------
// Method: PackingSpecComments
// Description:
// Opens a dialog to allow authorized users to input comments.
// A date/time/user initials stamp will be added to the comments.
// The comments will be added to the top of the existing comments.
// Parameters:
// $1 = Which field to add the comments to.
// ----------------------------------------------------

C_TEXT:C284(tField; $1; $tStamp)
C_LONGINT:C283($xlRef)

tField:=$1

Case of 
	: (tField="Init")
		Case of 
			: (User in group:C338(Current user:C182; "PackingSpecMgr"))  //Access thru dialog and directly in fields.
				//Buttons and fields enabled. 
				//May or may not contain the stamp depending on how the user edits the field.
				
			: (User in group:C338(Current user:C182; "PackingSpecComment"))  //Access thru dialog only, just the buttons are enabled.
				SetObjectProperties(""; ->[Finished_Goods_PackingSpecs:91]CaseComment:21; True:C214; ""; False:C215)
				SetObjectProperties(""; ->[Finished_Goods_PackingSpecs:91]Variations:10; True:C214; ""; False:C215)
				
			Else   //No access at all.
				OBJECT SET ENABLED:C1123(bAddComment; False:C215)
				OBJECT SET ENABLED:C1123(bAddVariations; False:C215)
				SetObjectProperties(""; ->[Finished_Goods_PackingSpecs:91]CaseComment:21; True:C214; ""; False:C215)
				SetObjectProperties(""; ->[Finished_Goods_PackingSpecs:91]Variations:10; True:C214; ""; False:C215)
				
		End case 
		
	: ((tField="Comments") | (tField="Variations"))
		$xlRef:=OpenSheetWindow(->[Finished_Goods_PackingSpecs:91]; "CommentDialog"; tField+" Dialog")
		DIALOG:C40([Finished_Goods_PackingSpecs:91]; "CommentDialog")
		CLOSE WINDOW:C154
		
		If (bOK=1)
			READ WRITE:C146([Finished_Goods_PackingSpecs:91])
			
			$tStamp:=String:C10(Current date:C33)+", "+String:C10(Current time:C178)+", "+<>zResp+<>CR
			
			If (tField="Comments")
				[Finished_Goods_PackingSpecs:91]CaseComment:21:=$tStamp+tText+<>CR+<>CR+[Finished_Goods_PackingSpecs:91]CaseComment:21
			Else   //Variations
				[Finished_Goods_PackingSpecs:91]Variations:10:=$tStamp+tText+<>CR+<>CR+[Finished_Goods_PackingSpecs:91]Variations:10
			End if 
		End if 
End case 