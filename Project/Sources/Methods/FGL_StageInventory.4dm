//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/01/08, 15:56:15
// ----------------------------------------------------
// Method: FGL_StageInventory
// Description
// Prep thing to move to new warehouse
// ----------------------------------------------------

C_BOOLEAN:C305($continue)

$continue:=True:C214

Case of 
	: (User in group:C338(Current user:C182; "Physical Inv"))
	: (Current user:C182="Designer")
		
	Else 
		$continue:=False:C215
End case 

If ($continue)
	zwStatusMsg("STAGING BINS"; "Changing location to fg:vStage")
	CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "hold")
	USE SET:C118("UserSet")  //use user selected to process
	
	
	Case of 
		: (Records in set:C195("UserSet")=0)
			uConfirm("You Need to Select (highlight) the Bins you wish to Stage."; "OK"; "Help")
			USE NAMED SELECTION:C332("Hold")
			
		Else   //lets do it...
			$area:="A"
			$area:=Uppercase:C13(Substring:C12(Request:C163("Letter designation for this staging area?"; $area; "OK"; "Cancel"); 1; 1))
			If (OK=1)
				$stagingArea:="fg:vStage-"+$area
				$Count:=Records in selection:C76([Finished_Goods_Locations:35])
				ARRAY TEXT:C222($aJobit; 0)  //later use this to test jobit exists in wms
				
				uThermoInit($Count; "Staging Bins to area "+$stagingArea)
				For ($i; 1; $Count)
					If ([Finished_Goods_Locations:35]AdjTo:13#$stagingArea)
						[Finished_Goods_Locations:35]AdjTo:13:=$stagingArea
						//[Finished_Goods_Locations]Location:=$stagingArea
						$hit:=Find in array:C230($aJobit; [Finished_Goods_Locations:35]Jobit:33)  //below use this to test jobit exists in wms
						If ($hit=-1)
							APPEND TO ARRAY:C911($aJobit; [Finished_Goods_Locations:35]Jobit:33)
						End if 
					Else 
						uConfirm("Clear the "+$stagingArea+" tag from bin "+[Finished_Goods_Locations:35]Location:2+"?"; "Clear"; "Keep")
						If (OK=1)
							[Finished_Goods_Locations:35]AdjTo:13:=""
						End if 
					End if 
					SAVE RECORD:C53([Finished_Goods_Locations:35])
					
					//if no case for jobit exists ask to print labels
					
					NEXT RECORD:C51([Finished_Goods_Locations:35])
					uThermoUpdate($i; 1)
				End for 
				uThermoClose
				
				If (Size of array:C274($aJobit)>0)  // make sure jobit exists in wms
					READ WRITE:C146([Job_Forms_Items:44])
					QUERY WITH ARRAY:C644([Job_Forms_Items:44]Jobit:4; $aJobit)
					wms_api_SendJobits
					REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
				End if 
				
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]AdjTo:13=$stagingArea)
				ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Row:37; >; [Finished_Goods_Locations:35]Tier:39; >; [Finished_Goods_Locations:35]Bin:38; >)
				//print pick
				BEEP:C151
				
				USE NAMED SELECTION:C332("hold")
				HIGHLIGHT RECORDS:C656
				SET WINDOW TITLE:C213(String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" Staging Bins")
				
			End if   //staging letter
			
	End case 
	
Else 
	ALERT:C41("Not Authorized")
End if 