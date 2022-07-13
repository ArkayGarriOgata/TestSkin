//%attributes = {"publishedWeb":true}
//(p) MoveRmSubGrpCtl
//$1 string - process for array 'A', process for Field 'F'
//• 8/22/97 cs created

C_TEXT:C284($1)
C_BOOLEAN:C305($Continue)
C_TEXT:C284($Subgroup)
C_LONGINT:C283($Loc)

If ($1="A")  //array processing 
	If (axText#0)
		$Continue:=True:C214
		$Subgroup:=axText{axText}
	Else 
		$Continue:=False:C215
		$Subgroup:=""
	End if 
Else   //field processing
	$SubGroup:=tSubgroup
	
	If (Find in array:C230(axText; tSubgroup)>0)
		$Continue:=True:C214
	Else 
		$Continue:=False:C215
	End if 
End if 

If ($Continue)  //entry was valid
	If (i4>0)
		MESSAGES OFF:C175
		uMsgWindow("Building Lists...")
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2=String:C10(i4; "00")+"-"+$Subgroup)  //locate Rawmaterials to display
		
		If (Records in selection:C76([Raw_Materials:21])>0)  //if there is something, build arrays to display it
			SELECTION TO ARRAY:C260([Raw_Materials:21]; aRmRecNo; [Raw_Materials:21]Raw_Matl_Code:1; aRmCode; [Raw_Materials:21]Description:4; asText)
			ARRAY TEXT:C222(aBullet; Size of array:C274(aRmRecNo))
			SORT ARRAY:C229(aRmCode; astext; aRmRecNo; aBullet; >)
			asText:=0
			aRmCode:=0
			aRmRecNo:=0
			aBullet:=0
			$Loc:=Find in array:C230(aBullet; "√")
			
			While ($Loc>0)  //remove any previously selected items
				aBullet{$Loc}:=""
				$Loc:=Find in array:C230(aBullet; "√"; $Loc+1)
			End while 
			OBJECT SET ENABLED:C1123(bSort; True:C214)  //allow user to sort materials
		Else   //no materials found
			ALERT:C41("No Materials in Subgroup "+$Subgroup)
			RM_MoveClear
		End if 
		CLOSE WINDOW:C154
		MESSAGES ON:C181
	Else   //no Commodity entered
		ALERT:C41("Please enter a Commodity BEFORE entering a subgroup.")
		RM_MoveClear
	End if 
Else   //invalid entry
	If ($Subgroup#"")
		ALERT:C41("Invalid Subgroup Entry.")
		RM_MoveClear
	End if 
End if 