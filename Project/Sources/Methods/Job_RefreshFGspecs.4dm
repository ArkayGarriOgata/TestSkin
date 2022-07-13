//%attributes = {"publishedWeb":true}
//Job_RefreshFGspecs
//update all the cartonSpecs to the current info in the FG record

uConfirm("Update ALL Job Items to match their FinishedGood record?"; "Refresh"; "Cancel")
If (OK=1)
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "refresh")
		
		
	Else 
		
		ARRAY LONGINT:C221($_refresh; 0)
		LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Items:44]; $_refresh)
		
	End if   // END 4D Professional Services : January 2019 
	ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3; >)
	For ($i; 1; Records in selection:C76([Job_Forms_Items:44]))
		$Found:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
		If ($Found>0)
			[Job_Forms_Items:44]SqInches:22:=[Finished_Goods:26]SquareInch:6
			[Job_Forms_Items:44]ControlNumber:26:=[Finished_Goods:26]ControlNumber:61
			[Job_Forms_Items:44]OutlineNumber:43:=[Finished_Goods:26]OutLine_Num:4
			[Job_Forms_Items:44]Category:31:=[Finished_Goods:26]OriginalOrRepeat:71
			SAVE RECORD:C53([Job_Forms_Items:44])
		End if 
		NEXT RECORD:C51([Job_Forms_Items:44])
	End for 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("refresh")
		CLEAR NAMED SELECTION:C333("refresh")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_refresh)
		
	End if   // END 4D Professional Services : January 2019 
	
End if 