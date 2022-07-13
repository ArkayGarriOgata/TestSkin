//%attributes = {"publishedWeb":true}
//(p) CU_LocateSubGrp  
//$1 - string 20 - commodity key to locate
//• 9/12/97 cs stop the moving/deletion of RM_goup for estimating
//• 1/27/98 cs setup for reporting changes
//• 3/25/98 cs allow this to return # of records found,
//   added parameter 1 - commodity key to locate - allows this to be used
//   locate subgroup record across database - assumes one pass/table
//• 6/11/98 cs removed reference to Machine & Material Item table

C_TEXT:C284($OldKey; $1)
C_POINTER:C301($File; $Field)
C_LONGINT:C283($Count; $i; $0)
C_TEXT:C284(xText)

MESSAGES OFF:C175
READ WRITE:C146([Raw_Materials:21])
READ WRITE:C146([Raw_Materials_Groups:22])
READ WRITE:C146([Raw_Materials_Locations:25])
READ WRITE:C146([Raw_Materials_Transactions:23])
READ WRITE:C146([Purchase_Orders_Items:12])
READ WRITE:C146([Job_Forms_Materials:55])
READ WRITE:C146([Process_Specs_Materials:56])
READ WRITE:C146([Estimates_Materials:29])

For ($i; 1; 8)  //for each table that needs to have an update done, setup searchs
	Case of 
		: ($i=1)
			$File:=->[Raw_Materials_Groups:22]  //must do this one first
			$Field:=->[Raw_Materials_Groups:22]Commodity_Key:3
		: ($i=2)
			$File:=->[Raw_Materials_Locations:25]
			$Field:=->[Raw_Materials_Locations:25]Commodity_Key:12
		: ($i=3)
			$File:=->[Raw_Materials:21]
			$Field:=->[Raw_Materials:21]Commodity_Key:2
		: ($i=4)
			$File:=->[Purchase_Orders_Items:12]
			$Field:=->[Purchase_Orders_Items:12]Commodity_Key:26
		: ($i=5)
			$File:=->[Job_Forms_Materials:55]
			$Field:=->[Job_Forms_Materials:55]Commodity_Key:12
		: ($i=6)
			$File:=->[Process_Specs_Materials:56]
			$Field:=->[Process_Specs_Materials:56]Commodity_Key:8
		: ($i=7)
			$File:=->[Estimates_Materials:29]
			$Field:=->[Estimates_Materials:29]Commodity_Key:6
		: ($i=8)
			$File:=->[Raw_Materials_Transactions:23]
			$Field:=->[Raw_Materials_Transactions:23]Commodity_Key:22
	End case 
	MESSAGE:C88("  Searching File "+Table name:C256($File)+"..."+Char:C90(13))
	
	If (Count parameters:C259=1)  //• 3/25/98 cs
		$Loc:=1
		ARRAY TEXT:C222(abullet; 1)
		aBullet{1}:="√"
	Else 
		$Loc:=Find in array:C230(aBullet; "√")
	End if 
	$Count:=0
	
	While ($Loc>-1)
		$Count:=$Count+1
		
		If (Count parameters:C259=0)  //• 3/25/98 cs 
			$OldKey:=String:C10(iComm; "00")+"-"+aText{$Loc}
			$Loc:=Find in array:C230(aBullet; "√"; $Loc+1)
			xText:=xText+$OldKey+Char:C90(13)
		Else 
			$Loc:=-1
			$OldKey:=$1
		End if 
		
		Case of 
			: ($Loc>-1) & ($Count>1)  //there was a previous search & there will be more
				QUERY:C277($File->;  | ; $Field->=$OldKey; *)
			: ($Loc>-1) & ($Count=1)  //there was NOT a previous search & there will be more
				QUERY:C277($File->; $Field->=$OldKey; *)
			: ($Loc<0) & ($Count>1)  //there was a previous search & there will be NO more
				QUERY:C277($File->;  | ; $Field->=$OldKey)
			: ($Loc<0) & ($Count=1)  //there was NOT a previous search & there will be NO more
				QUERY:C277($File->; $Field->=$OldKey)
		End case 
	End while 
	CREATE SET:C116($File->; Table name:C256($File))
	
	//• 9/12/97 cs stop the moving/deletion of RM_goup records (and related) 
	// which are required for estimating
	If (Table name:C256($File)=Table name:C256(->[Raw_Materials_Groups:22]))  //if this is the Rm_group table
		QUERY SELECTION:C341([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]EffectivityDate:15#!00-00-00!)  //look for any items which may be an Estimate commodity
		
		If (Records in selection:C76([Raw_Materials_Groups:22])>0)  //if there were records
			CREATE SET:C116([Raw_Materials_Groups:22]; "Temp")  //save this selection
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				FIRST RECORD:C50([Raw_Materials_Groups:22])
				
			Else 
				
				//see line 91
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				For ($j; 1; Records in selection:C76([Raw_Materials_Groups:22]))  //for each record found to be an estimating group
					$Loc2:=Find in array:C230(aText; [Raw_Materials_Groups:22]SubGroup:10)  //find it in the arrays
					
					If ($Loc2>0)  //if found
						aBullet{$Loc2}:=""  //remove it from the selected array so that no other records are found and procese
					End if 
					NEXT RECORD:C51([Raw_Materials_Groups:22])
				End for 
				
			Else 
				
				ARRAY TEXT:C222($_SubGroup; 0)
				
				SELECTION TO ARRAY:C260([Raw_Materials_Groups:22]SubGroup:10; $_SubGroup)
				
				For ($j; 1; Size of array:C274($_SubGroup); 1)  //for each record found to be an estimating group
					$Loc2:=Find in array:C230(aText; $_SubGroup{$j})  //find it in the arrays
					
					If ($Loc2>0)  //if found
						aBullet{$Loc2}:=""
					End if 
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			DIFFERENCE:C122(Table name:C256(->[Raw_Materials_Groups:22]); "Temp"; Table name:C256(->[Raw_Materials_Groups:22]))  //remove the estimate groups fro mthe found oness
			CLEAR SET:C117("temp")
			
			If (Count parameters:C259=0)  //• 3/25/98 cs 
				ALERT:C41("One or More RM_Group records found are needed for Estimating."+Char:C90(13)+"These records will NOT be Moved.")
			End if 
		End if 
	End if 
	//• 9/12/97 cs end  
	$0:=$0+Records in set:C195(Table name:C256($File))  //• 3/25/98 cs 
	uClearSelection($File)
End for 