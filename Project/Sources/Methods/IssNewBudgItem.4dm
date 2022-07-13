//%attributes = {"publishedWeb":true}
//(p) IssNewBudgItem
//create a new unbudgeted line item to issue against
//• 1/20/98 cs created
C_LONGINT:C283($Loc)
C_BOOLEAN:C305($New)

$Loc:=0
$New:=True:C214

Repeat   //locate all blank rm codes
	$Loc:=Find in array:C230(aPoPartNo; ""; $Loc+1)
	
	If ($Loc>0)  //if the RM code is blank
		
		If (aCommCode{$Loc}="")  //commodity code is blank also
			$New:=False:C215  //do not allow user to create a new item
			$Loc:=-1
		End if 
	End if 
Until ($Loc<0)

If (Not:C34($New))  //an empty budget item was found
	$Text:="This button is to be used ONLY to issue an un-budgeted material,"
	$Text:=$Text+" AND when there are NO empty budget items available."+Char:C90(13)+Char:C90(13)
	$Text:=$text+"Please issue against one of the existing empty budget items."
	ALERT:C41($Text)
Else 
	uConfirm("Create a New empty budget line item to issue against?")
	
	If (OK=1)
		Repeat 
			$CostCenter:=Request:C163("Please Enter a Cost Center ID."; "xxx")
			
			If (OK=1)
				
				If (Find in array:C230(aCostCenter; $CostCenter)<0)
					ALERT:C41("Entered Cost Center ("+$CostCenter+") is NOT valid."+Char:C90(13)+"Please try your entry again.")
					$CostCEnter:=""
				End if 
			End if 
		Until (($CostCenter#"") & (OK=1)) | (OK=0)
		
		If (OK=1)
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
				
				READ WRITE:C146([Job_Forms_Materials:55])
				CREATE RECORD:C68([Job_Forms_Materials:55])
				[Job_Forms_Materials:55]JobForm:1:=[Job_Forms:42]JobFormID:5
				[Job_Forms_Materials:55]Sequence:3:=0
				[Job_Forms_Materials:55]CostCenterID:2:=$CostCenter
				[Job_Forms_Materials:55]Comments:4:="Non-budgeted item."+Char:C90(13)+"Line inserted by issuing."
				[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
				[Job_Forms_Materials:55]ModWho:11:=<>zResp
				SAVE RECORD:C53([Job_Forms_Materials:55])
				UNLOAD RECORD:C212([Job_Forms_Materials:55])
				READ ONLY:C145([Job_Forms_Materials:55])
				
			Else 
				
				// you don(t need red write on create record
				
				CREATE RECORD:C68([Job_Forms_Materials:55])
				[Job_Forms_Materials:55]JobForm:1:=[Job_Forms:42]JobFormID:5
				[Job_Forms_Materials:55]Sequence:3:=0
				[Job_Forms_Materials:55]CostCenterID:2:=$CostCenter
				[Job_Forms_Materials:55]Comments:4:="Non-budgeted item."+Char:C90(13)+"Line inserted by issuing."
				[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
				[Job_Forms_Materials:55]ModWho:11:=<>zResp
				SAVE RECORD:C53([Job_Forms_Materials:55])
				UNLOAD RECORD:C212([Job_Forms_Materials:55])
				
			End if   // END 4D Professional Services : January 2019 
			
			gSrchBudget
		End if 
	End if 
End if 