//%attributes = {"publishedWeb":true}
//Procedure: uFGdestroy()  080395  MLB
//`•080395  MLB  UPR 1490
//• cs 3/26/97 upr 1529 - warn if open release(s) exists
//•3/07/00  mlb switch lock test method

C_BOOLEAN:C305($continue)
C_DATE:C307($xactionDate)
C_LONGINT:C283($numFG; $numRels)

$xactionDate:=4D_Current_date
utl_Trace
$numFG:=qryFinishedGood(sCriterion2; sCriterion1)
If ($numFG=0)
	uRejectAlert("Invalid F/G Code!")
Else 
	//• 3/26/97 upr 1529 cs
	$numRels:=qryReleases(sCriterion2; sCriterion1)  //determine if there are open release(s)
	If ($numRels>0)
		CONFIRM:C162("There are open release(s) against this product."+Char:C90(13)+"Do You want to continue scrapping it?"; "Scrap"; "Skip")
	Else 
		OK:=1
	End if 
	
	If (OK=1)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=sCriterion3; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]FG_Key:34=(sCriterion2+":"+sCriterion1); *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Jobit:33=(JMI_makeJobIt(sCriterion5; i1)))
		
		If ((Records in selection:C76([Finished_Goods_Locations:35])=0) & (rReal1>0))
			ALERT:C41("Invalid location."+Char:C90(13)+sCriterion1+":"+sCriterion2+"/"+sCriterion5+"@"+sCriterion3)
			$continue:=False:C215
		Else 
			If (Records in selection:C76([Finished_Goods_Locations:35])=0)
				FG_makeLocation
				[Finished_Goods_Locations:35]Location:2:=sCriterion3
				SAVE RECORD:C53([Finished_Goods_Locations:35])
			End if 
			//•3/07/00  mlb switch lock test method
			If (fLockNLoad(->[Finished_Goods_Locations:35]))  // (Locked([FG_Locations]))  `locked, can't continue `
				//uLockMessage (->[FG_Locations])        
				If (rReal1>[Finished_Goods_Locations:35]QtyOH:9)
					BEEP:C151
					CONFIRM:C162("Warning: Quantity specified is GREATER than quantity on hand!")
					$Continue:=(OK=1)
				Else 
					$continue:=True:C214
				End if 
			Else 
				$continue:=False:C215
			End if 
		End if 
		
		If ($continue)
			uChgFGqty(-1)
			FG_SaveBinLocation($xactionDate)
			FG_loadJobAndOrder
			//next create transfer IN record
			FGX_post_transaction($xactionDate; 1; "Scrap")
		End if 
	End if 
End if 