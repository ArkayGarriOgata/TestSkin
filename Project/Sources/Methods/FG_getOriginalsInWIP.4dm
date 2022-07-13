//%attributes = {}
// Method: FG_getOriginalsInWIP () -> 
// ----------------------------------------------------
// by: mel: 05/13/04, 10:47:33
// ----------------------------------------------------
// Description:
// QA needs to know about originals and launches
// to manage samples
// ----------------------------------------------------

MESSAGES OFF:C175
//READ ONLY([JobForm])
//READ ONLY([JobMakesItem])
//READ WRITE([Finished_Goods])

QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6="wip")
zwStatusMsg("Get Originals"; String:C10(Records in selection:C76([Job_Forms:42]))+" [JobForm]")
If (Records in selection:C76([Job_Forms:42])>0)
	RELATE MANY SELECTION:C340([Job_Forms_Items:44]JobForm:1)
	zwStatusMsg("Get Originals"; String:C10(Records in selection:C76([Job_Forms_Items:44]))+" [JobMakesItem] ")
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Finished_Goods:26])
		If (Records in selection:C76([Finished_Goods:26])>0)
			QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]OriginalOrRepeat:71="Original")
			zwStatusMsg("Get Originals"; String:C10(Records in selection:C76([Finished_Goods:26]))+" [Finished_Goods] ")
			If (Records in selection:C76([Finished_Goods:26])>0)
				uConfirm("Hide Originals that have had Samples submitted?"; "Hide"; "Show")
				If (OK=1)
					QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]DateLaunchSubmitted:93=!00-00-00!)
					zwStatusMsg("Get Originals"; String:C10(Records in selection:C76([Finished_Goods:26]))+" [Finished_Goods] ")
				End if 
				ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]PressDate:64; >)
			End if   //fg's found
		End if   //fg's found
	End if   //items in wip
End if   //job is wip