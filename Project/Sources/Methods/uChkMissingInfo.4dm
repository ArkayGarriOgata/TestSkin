//%attributes = {"publishedWeb":true}
//Procedure: uChkMissingInfo(est num;type)  010699  MLB
//look for missing data before allowing status change
//•060195  MLB  UPR 184

C_TEXT:C284($1)
C_LONGINT:C283($0)

$0:=0  //assume nothing is missing

QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$1)
SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]ProductCode:5; $aCPN; [Estimates_Carton_Specs:19]OutLineNumber:15; $aOutline; [Estimates_Carton_Specs:19]Width_Dec:20; $aW; [Estimates_Carton_Specs:19]Height_Dec:22; $aH; [Estimates_Carton_Specs:19]Style:4; $aStyle; [Estimates_Carton_Specs:19]PONumber:73; $aPO; [Estimates_Carton_Specs:19]OriginalOrRepeat:9; $aCat; [Estimates_Carton_Specs:19]SquareInches:16; $aSqIn)

READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
SET QUERY LIMIT:C395(1)
$can_advance_status:=True:C214
$bad_a_number:=""
ARRAY TEXT:C222($aAlready_Looked_Up; 0)

For ($i; 1; Size of array:C274($aCPN))
	If (Replace string:C233($aCPN{$i}; " "; "")="")
		$0:=$0-1
		uConfirm("Specify the product code for each carton."; "OK"; "Help")
	End if 
	
	If (Replace string:C233($aOutline{$i}; " "; "")="")
		If (($aW{$i}=0) | ($aH{$i}=0) | ($aStyle{$i}=""))
			$0:=$0-1
			uConfirm("Specify outline (or size{w&h} and style) for each carton."; "OK"; "Help")
		End if 
		
	Else   //see if outline is approved
		
		If (Find in array:C230($aAlready_Looked_Up; $aOutline{$i})=-1)
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$aOutline{$i})
			If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
				If (Length:C16([Finished_Goods_SizeAndStyles:132]GlueAppvNumber:53)=0) & ([Finished_Goods_SizeAndStyles:132]DateSubmitted:5>!2010-09-03!)
					If (User in group:C338(Current user:C182; "SalesManager"))
						uConfirm("Warning: "+$aOutline{$i}+" for "+$aCPN{$i}+" has no GA#."; "Continue"; "OK")
					Else 
						$0:=$0-1
						uConfirm($aOutline{$i}+" for "+$aCPN{$i}+" has no GA#."; "OK"; "Darn")
					End if 
				End if 
				
			Else   //bad reference
				If (User in group:C338(Current user:C182; "SalesManager"))
					uConfirm("Warning: "+$aOutline{$i}+" for "+$aCPN{$i}+" was not found."; "Continue"; "OK")
				Else 
					$0:=$0-1
					uConfirm($aOutline{$i}+" for "+$aCPN{$i}+" was not found."; "OK"; "Darn")
				End if 
			End if 
			APPEND TO ARRAY:C911($aAlready_Looked_Up; $aOutline{$i})
		End if 
		
	End if 
	
	If ($aSqIn{$i}=0)  // • mel (7/22/04, 16:25:16)
		$0:=$0-1
		uConfirm("Specify square inches for each carton."; "OK"; "Help")
	End if 
	
	If ($2="Contract")
		If ($aPO{$i}="")
			$0:=$0-1
			uConfirm("Please specify the purchase order number for each carton."; "OK"; "Help")
		End if 
		
		If ($aCat{$i}="")
			$0:=$0-1
			uConfirm("Please specify the order category for each carton."; "OK"; "Help")
		End if 
	End if   //contract
	
End for 

SET QUERY LIMIT:C395(0)