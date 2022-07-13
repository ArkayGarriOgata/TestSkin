//%attributes = {"publishedWeb":true}
//(p) sRenameRawMatl, based on sRenameProdCode
//• 4/2/97 cs added clears for sets & selections
//• 6/16/97 cs removed code referencing old req system    
//• 9/30/97 cs aded ability for this system to delete (merge) existing RMs.
//• 1/27/98 cs setup reprting of changes
//• 5/19/98 cs removed stripping of leading spaces from Old RM code
//• 6/11/98 cs removed freerence to [material_Item] & [machine_Item] tables

C_TEXT:C284($oldPC; $newPC; $1)
C_BOOLEAN:C305($fDelete)  //• 9/30/97 cs 
C_LONGINT:C283($type; $len; $Count)
C_DATE:C307($CDate)  //   new 6/22/94 
C_TEXT:C284(xText; xTitle)

READ WRITE:C146([Raw_Materials:21])
READ WRITE:C146([Raw_Materials_Allocations:58])
READ WRITE:C146([Raw_Materials_Components:60])
READ WRITE:C146([Raw_Materials_Locations:25])
READ WRITE:C146([Raw_Materials_Transactions:23])
READ WRITE:C146([Purchase_Orders_Items:12])
READ WRITE:C146([Job_Forms_Materials:55])
READ WRITE:C146([Process_Specs_Materials:56])
READ WRITE:C146([Finished_Goods_PackingSpecs:91])

$CDate:=4D_Current_date

GET FIELD PROPERTIES:C258(->[Raw_Materials:21]Raw_Matl_Code:1; $type; $len)
If (Count parameters:C259=0)
	$oldPC:=Substring:C12(Request:C163("Enter the OLD "+String:C10($len)+" character raw material code:"); 1; $len)  //• 5/19/98 cs remove stripping of leading spaces
	If ($oldPC#"") & (OK=1)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$oldPC)
		
		If (Records in selection:C76([Raw_Materials:21])=1)  //• 9/30/97 cs makes the alerts/confirms look better
			$OldPc:=[Raw_Materials:21]Raw_Matl_Code:1
		Else 
			ALERT:C41("No Material code Found matching - "+$OldPC)
			$OldPc:=""
		End if 
	Else 
		uClearSelection(->[Raw_Materials:21])
	End if 
Else 
	$OldPc:=[Raw_Materials:21]Raw_Matl_Code:1
End if 

If ($oldPC#"")
	If ((Records in selection:C76([Raw_Materials:21])=1) & (Count parameters:C259=0)) | ((Count parameters:C259=1) & ($OldPc#""))
		$newPC:=fStripSpace("B"; Substring:C12(Request:C163("Enter the NEW "+String:C10($len)+" character raw material code:"; $oldPC); 1; $len))
		
		If (($newPC#"") & (ok=1) & ($newPC#$oldPC))  //•11/03/00  mlb 
			BEEP:C151
			CONFIRM:C162("Change all occurrances of "+$oldPC+" to "+$newPC)
			If (OK=1)
				CREATE SET:C116([Raw_Materials:21]; "Old")
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$NewPc)  //check that new code does not exist 03/27/95
				
				If (Records in selection:C76([Raw_Materials:21])>0)
					
					If (Records in selection:C76([Raw_Materials:21])=1)  //• 9/30/97 cs makes the alerts/confirms look better
						$NewPc:=[Raw_Materials:21]Raw_Matl_Code:1
					End if 
					uConfirm("The new Material Code already exists."+Char:C90(13)+"Do You want to Merge the old Material Code ('"+$OldPc+"') to the 'new' one ('"+$NewPc+"') ?"; "Merge"; "Stop")
					//ALERT("The New Raw Material Code Already Exists, Change Canceled.")
					$fDelete:=(OK=1)
				Else 
					$fDelete:=False:C215
					OK:=1
				End if 
			End if 
			
			If (OK=1)
				USE SET:C118("Old")
				CLEAR SET:C117("Old")
				
				$Count:=RMRenameLoc($OldPc)
				
				If ($Count>100)  //• 8/22/97 cs Total  number of records found
					uConfirm("There are a significant number of records to change. ("+String:C10($Count)+")"+Char:C90(13)+"Performing this operation could take Long time."+Char:C90(13)+"Continue?")
				Else 
					OK:=1
				End if 
				
				If (OK=1)  //continue
					$winRef:=NewWindow(350; 250; 6; 1; "")
					MESSAGE:C88("Updating Raw Material Codes…"+Char:C90(13))
					MESSAGE:C88("  10..."+Char:C90(13))
					
					If (Not:C34($fDelete))
						gQuickLockTest(->[Raw_Materials:21])
						[Raw_Materials:21]Raw_Matl_Code:1:=$newPC
						[Raw_Materials:21]ModWho:48:=<>zResp
						[Raw_Materials:21]ModDate:47:=$CDate
						SAVE RECORD:C53([Raw_Materials:21])
					Else 
						DELETE RECORD:C58([Raw_Materials:21])
					End if 
					MESSAGE:C88("  9...Bins…"+Char:C90(13))
					RMReNameWork(->[Raw_Materials_Locations:25]Raw_Matl_Code:1; ->[Raw_Materials_Locations:25]ModDate:21; ->[Raw_Materials_Locations:25]ModWho:22; "Bins"; $NewPc)
					
					MESSAGE:C88("  8...Xfer..."+Char:C90(13))
					RMReNameWork(->[Raw_Materials_Transactions:23]Raw_Matl_Code:1; ->[Raw_Materials_Transactions:23]ModDate:17; ->[Raw_Materials_Transactions:23]ModWho:18; "Xfer"; $NewPc)
					
					MESSAGE:C88("  7...MatEst..."+Char:C90(13))
					RMReNameWork(->[Estimates_Materials:29]Raw_Matl_Code:4; ->[Estimates_Materials:29]ModDate:22; ->[Estimates_Materials:29]ModWho:21; "Est"; $NewPc)
					
					MESSAGE:C88("  6...RmParent..."+Char:C90(13))
					
					If (Records in set:C195("Parent")>0)
						USE SET:C118("Parent")
						$Size:=Records in set:C195("Parent")
						ARRAY TEXT:C222($RM; $Size)
						SELECTION TO ARRAY:C260([Raw_Materials_Components:60]Parent_Raw_Matl:1; $Rm)
						
						For ($i; 1; $Size)
							$Rm{$i}:=$newPC
						End for 
						
						Repeat 
							USE SET:C118("Parent")
							ARRAY TO SELECTION:C261($Rm; [Raw_Materials_Components:60]Parent_Raw_Matl:1)
						Until (uChkLockedSet(->[Raw_Materials_Components:60]; "M"))
					End if 
					uClearSelection(->[Raw_Materials_Components:60])
					CLEAR SET:C117("Parent")
					
					MESSAGE:C88("  5...Component..."+Char:C90(13))
					
					If (Records in set:C195("Component")>0)
						USE SET:C118("Component")
						$Size:=Records in set:C195("Component")
						ARRAY TEXT:C222($RM; $Size)
						SELECTION TO ARRAY:C260([Raw_Materials_Components:60]Parent_Raw_Matl:1; $Rm)
						
						For ($i; 1; $Size)
							$Rm{$i}:=$newPC
						End for 
						
						Repeat 
							USE SET:C118("Component")
							ARRAY TO SELECTION:C261($Rm; [Raw_Materials_Components:60]Parent_Raw_Matl:1)
						Until (uChkLockedSet(->[Raw_Materials_Components:60]; "M"))
					End if 
					uClearSelection(->[Raw_Materials_Components:60])
					CLEAR SET:C117("Component")
					
					MESSAGE:C88("  4...Alloc..."+Char:C90(13))
					RMReNameWork(->[Raw_Materials_Allocations:58]Raw_Matl_Code:1; ->[Raw_Materials_Allocations:58]ModDate:8; ->[Raw_Materials_Allocations:58]ModWho:9; "Alloc"; $NewPc)
					
					MESSAGE:C88("  3...MatJob..."+Char:C90(13))
					RMReNameWork(->[Job_Forms_Materials:55]Raw_Matl_Code:7; ->[Job_Forms_Materials:55]ModDate:10; ->[Job_Forms_Materials:55]ModWho:11; "Job"; $NewPc)
					
					MESSAGE:C88("  2...Pspec..."+Char:C90(13))
					RMReNameWork(->[Process_Specs_Materials:56]Raw_Matl_Code:13; ->[Process_Specs_Materials:56]ModDate:11; ->[Process_Specs_Materials:56]ModWho:10; "Pspec"; $NewPc)
					RMReNameWork(->[Finished_Goods_PackingSpecs:91]RM_Code:36; ->[Finished_Goods_PackingSpecs:91]ModDate:37; ->[Finished_Goods_PackingSpecs:91]ModWho:38; "PakSpec"; $NewPc)
					
					MESSAGE:C88("  1...POItems..."+Char:C90(13))
					
					If (Records in set:C195("Items")>0)
						USE SET:C118("Items")
						$Size:=Records in set:C195("Items")
						$CDate:=4D_Current_date
						ARRAY TEXT:C222($RM; $Size)
						ARRAY DATE:C224($Date; $Size)
						ARRAY TEXT:C222($Who; $Size)
						SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]Raw_Matl_Code:15; $Rm; [Purchase_Orders_Items:12]ModDate:19; $Date; [Purchase_Orders_Items:12]ModWho:20; $Who)
						For ($i; 1; $Size)
							$Rm{$i}:=$newPC
							$Date{$i}:=$CDate
							$Who{$i}:=<>zResp
						End for 
						
						Repeat 
							USE SET:C118("Items")
							ARRAY TO SELECTION:C261($Rm; [Purchase_Orders_Items:12]Raw_Matl_Code:15; $Date; [Purchase_Orders_Items:12]ModDate:19; $Who; [Purchase_Orders_Items:12]ModWho:20)
						Until (uChkLockedSet(->[Purchase_Orders_Items:12]; "M"))
						
					End if 
					CLEAR SET:C117("Items")
					uClearSelection(->[Purchase_Orders_Items:12])
					ARRAY TEXT:C222($Rm; 0)
					ARRAY TEXT:C222($Who; 0)
					ARRAY DATE:C224($Date; 0)
				End if 
			End if 
		End if 
	End if 
End if 