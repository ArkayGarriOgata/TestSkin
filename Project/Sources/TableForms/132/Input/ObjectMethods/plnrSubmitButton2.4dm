// ----------------------------------------------------
// Object Method: [Finished_Goods_SizeAndStyles].Input.plnrSubmitButton
// ----------------------------------------------------
// Modified by: Mel Bohince (12/29/15) chg email validation

C_BOOLEAN:C305($continue)

If ([Finished_Goods_SizeAndStyles:132]DateSubmitted:5=!00-00-00!)
	If ([Finished_Goods_SizeAndStyles:132]DateWanted:42>=4D_Current_date)
		If ([Finished_Goods_SizeAndStyles:132]EstimatingOnly:55 | [Finished_Goods_SizeAndStyles:132]Samples:28 | [Finished_Goods_SizeAndStyles:132]DieOnDisk:29 | [Finished_Goods_SizeAndStyles:132]EngDrawing:30 | [Finished_Goods_SizeAndStyles:132]ArtBoardOverlay:31 | [Finished_Goods_SizeAndStyles:132]ConveryFromDisk:32 | [Finished_Goods_SizeAndStyles:132]DieSamples:33 | [Finished_Goods_SizeAndStyles:132]EmailFile:34)
			If ([Finished_Goods_SizeAndStyles:132]EmailFile:34)
				If (email_validate_address([Finished_Goods_SizeAndStyles:132]EmailAddress:41))  //(Length([Finished_Goods_SizeAndStyles]EmailAddress)>=6) & (Position(".";[Finished_Goods_SizeAndStyles]EmailAddress)>3) & (Position(Char(At sign);[Finished_Goods_SizeAndStyles]EmailAddress)>1)
					$continue:=True:C214
				Else 
					$continue:=False:C215
				End if 
				
			Else 
				$continue:=True:C214
			End if 
			
			If ($continue)
				If (4d_Current_time<=?12:00:00?)  // • mel (2/25/04, 12:34:25)
					[Finished_Goods_SizeAndStyles:132]DateSubmitted:5:=4D_Current_date
				Else 
					[Finished_Goods_SizeAndStyles:132]DateSubmitted:5:=4D_Current_date+1
				End if 
				
				If ([Finished_Goods_SizeAndStyles:132]DateSubmitted:5#!00-00-00!)
					Case of   // • mel (2/25/04, 12:34:25)
						: (Day number:C114([Finished_Goods_SizeAndStyles:132]DateSubmitted:5)=7)  //saturday
							[Finished_Goods_SizeAndStyles:132]DateSubmitted:5:=[Finished_Goods_SizeAndStyles:132]DateSubmitted:5+2
						: (Day number:C114([Finished_Goods_SizeAndStyles:132]DateSubmitted:5)=1)  //sundaty
							[Finished_Goods_SizeAndStyles:132]DateSubmitted:5:=[Finished_Goods_SizeAndStyles:132]DateSubmitted:5+1
					End case 
				End if 
				
				SetObjectProperties("product@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
				OBJECT SET ENABLED:C1123(*; "product@"; False:C215)
				SetObjectProperties("spec@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
				OBJECT SET ENABLED:C1123(*; "spec@"; False:C215)
				SetObjectProperties("plnr@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
				OBJECT SET ENABLED:C1123(*; "plnr@"; False:C215)
				SetObjectProperties("Dim@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
				SetObjectProperties(""; ->[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
				SetObjectProperties(""; ->bSubmit; True:C214; "Kill")  // Modified by: Mark Zinke (5/13/13)
				OBJECT SET ENABLED:C1123(bSubmit; True:C214)
				rfc_OptionsHide
				
			Else 
				uConfirm("You need to enter the email address to send to."; "OK"; "Help")
				GOTO OBJECT:C206([Finished_Goods_SizeAndStyles:132]EmailAddress:41)
			End if 
		Else 
			uConfirm("You need to specify what Products and Quantities you want."; "OK"; "Help")
			GOTO OBJECT:C206([Finished_Goods_SizeAndStyles:132]Samples:28)
		End if 
		
	Else 
		uConfirm("You need to specify a Want date."; "OK"; "Help")
		[Finished_Goods_SizeAndStyles:132]DateWanted:42:=!00-00-00!
		GOTO OBJECT:C206([Finished_Goods_SizeAndStyles:132]DateWanted:42)
	End if 
	
Else 
	[Finished_Goods_SizeAndStyles:132]DateSubmitted:5:=!00-00-00!
	OBJECT SET ENABLED:C1123(*; "product@"; True:C214)
	SetObjectProperties("product@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	OBJECT SET ENABLED:C1123(*; "plnrWant@"; True:C214)
	SetObjectProperties("plnrWant@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	If ([Finished_Goods_SizeAndStyles:132]AdditionalRequest:54=0)
		OBJECT SET ENABLED:C1123(*; "spec@"; True:C214)
		SetObjectProperties("spec@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties("Dim@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		
	Else   //can't change specs or dimension on an add req
		OBJECT SET ENABLED:C1123(bShowOL; True:C214)  //should be something to see
	End if 
	rfc_OptionsShow
	SetObjectProperties(""; ->bSubmit; True:C214; "Submit"; True:C214)  // Modified by: Mark Zinke (5/13/13)
	OBJECT SET ENABLED:C1123(bAddRequest; False:C215)
End if 