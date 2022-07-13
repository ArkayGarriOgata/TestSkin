//FM: INCLD4eBag() -> 
//@author mlb - 5/30/02  15:27
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		If (Length:C16([Job_Forms_Items:44]CustId:15)=5)
			qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
			If (FG_LaunchItem("is"; [Job_Forms_Items:44]ProductCode:3))
				tText:="Launch"
			Else 
				tText:=""
			End if 
			
			If ([Job_Forms_Items:44]Completed:39#!00-00-00!)
				Core_ObjectSetColor(->[Job_Forms_Items:44]Qty_Want:24; -(Red:K11:4+(256*Light grey:K11:13)); True:C214)
			Else 
				Core_ObjectSetColor(->[Job_Forms_Items:44]Qty_Want:24; -(Black:K11:16+(256*Light grey:K11:13)); True:C214)
			End if 
		End if 
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Job_Forms_Items:44]; "clickedIncluded")
		
	: ($e=On Double Clicked:K2:5)
		
End case 