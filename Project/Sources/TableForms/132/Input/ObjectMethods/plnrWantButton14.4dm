// ----------------------------------------------------
// Object Method: [Finished_Goods_SizeAndStyles].Input.plnrWantButton14
// ----------------------------------------------------
C_BOOLEAN:C305($waitingForBrian)  // Modified by: Mel Bohince (6/9/14) don't allow add'l request if waiting for brian
$waitingForBrian:=False:C215
If ([Finished_Goods_SizeAndStyles:132]Brian_Approval:60=!00-00-00!)
	If ([Finished_Goods_SizeAndStyles:132]GlueAppvNumber:53#"001")
		If ([Finished_Goods_SizeAndStyles:132]DateDone:6>!2015-01-02!)
			//If ([Finished_Goods_SizeAndStyles]AdditionalRequest=0)` Modified by: Mel Bohince (3/20/15) 
			$waitingForBrian:=True:C214
			//End if 
		End if 
	End if 
End if 

If (Not:C34($waitingForBrian))
	//Save off original request
	CREATE RECORD:C68([Finished_Goods_SnS_Additions:150])
	[Finished_Goods_SnS_Additions:150]FileOutlineNum:1:=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1
	[Finished_Goods_SnS_Additions:150]Addition_Num:2:=[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54
	rfc_additionalRequest
	SAVE RECORD:C53([Finished_Goods_SnS_Additions:150])
	
	//reset for  the addition request
	rfc_resetWorkflow("don't clear brian")  // Modified by: Mel Bohince (6/18/15) option to skip clearing brian date
	rfc_taskCheckBox(->[Finished_Goods_SizeAndStyles:132]TasksCompleted:56; "set-all")
	[Finished_Goods_SizeAndStyles:132]CreatedBy:57:=<>zResp
	aPriority{0}:=String:C10([Finished_Goods_SizeAndStyles:132]Priority:47)
	[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54:=[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54+1
	[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27:="== AddReq: "+String:C10([Finished_Goods_SizeAndStyles:132]AdditionalRequest:54)+" =="+Char:C90(13)+Char:C90(13)+" _______"+Char:C90(13)+[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27
	SAVE RECORD:C53([Finished_Goods_SizeAndStyles:132])
	
	//reload the list of history
	QUERY:C277([Finished_Goods_SnS_Additions:150]; [Finished_Goods_SnS_Additions:150]FileOutlineNum:1=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
	ORDER BY:C49([Finished_Goods_SnS_Additions:150]; [Finished_Goods_SnS_Additions:150]Addition_Num:2; <)
	
	//reset the form
	OBJECT SET ENABLED:C1123(*; "plnr@"; False:C215)
	SetObjectProperties("plnr@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	OBJECT SET ENABLED:C1123(*; "img@"; False:C215)
	OBJECT SET ENABLED:C1123(*; "task@"; False:C215)
	SetObjectProperties("img@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties("Dim@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	rfc_UpdateByPlanner
	OBJECT SET ENABLED:C1123(bAddRequest; False:C215)
	SetObjectProperties(""; ->[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	
Else 
	uConfirm("Brian needs to approve before Additional Requests can be made."; "Ok"; "Help")
End if 