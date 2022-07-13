//%attributes = {"publishedWeb":true}
//(p) x_MoveRMLocate
//• 8/22/97 cs created
//• 1/27/98 cs setup for reporting
//• 6/11/98 cs removed reference to Machine & Material Item table

C_TEXT:C284(xText)
C_TEXT:C284($OldKey)
C_POINTER:C301($File; $Field)
C_LONGINT:C283($Count; $i)

MESSAGES OFF:C175
READ WRITE:C146([Raw_Materials:21])
READ WRITE:C146([Raw_Materials_Groups:22])
READ WRITE:C146([Raw_Materials_Locations:25])
READ WRITE:C146([Raw_Materials_Transactions:23])
READ WRITE:C146([Purchase_Orders_Items:12])
READ WRITE:C146([Job_Forms_Materials:55])
READ WRITE:C146([Process_Specs_Materials:56])
READ WRITE:C146([Estimates_Materials:29])

For ($i; 1; 9)  //for each table that needs to have an update done, setup searchs
	Case of 
		: ($i=1)
			$File:=->[Raw_Materials_Locations:25]
			$Field:=->[Raw_Materials_Locations:25]Raw_Matl_Code:1
		: ($i=2)
			$File:=->[Purchase_Orders_Items:12]
			$Field:=->[Purchase_Orders_Items:12]Raw_Matl_Code:15
		: ($i=3)
			$File:=->[Job_Forms_Materials:55]
			$Field:=->[Job_Forms_Materials:55]Raw_Matl_Code:7
		: ($i=4)
			$File:=->[Process_Specs_Materials:56]
			$Field:=->[Process_Specs_Materials:56]Raw_Matl_Code:13
		: ($i=5)
			$File:=->[Estimates_Materials:29]
			$Field:=->[Estimates_Materials:29]Raw_Matl_Code:4
		: ($i=6)
			$File:=->[Raw_Materials_Transactions:23]
			$Field:=->[Raw_Materials_Transactions:23]Raw_Matl_Code:1
		: ($i=7)
			$File:=->[Raw_Materials:21]
			$Field:=->[Raw_Materials:21]Raw_Matl_Code:1
		: ($i=8)
			CREATE EMPTY SET:C140([Raw_Materials_Groups:22]; Table name:C256(->[Raw_Materials_Groups:22]))
	End case 
	
	If ($i<=7)  //skip last two files not needed here - but update code needs the sets
		MESSAGE:C88("  Searching File "+Table name:C256($File)+"..."+Char:C90(13))
		$Loc:=Find in array:C230(aBullet; "√")
		$Count:=0
		
		While ($Loc>0)
			$Count:=$Count+1
			GOTO RECORD:C242([Raw_Materials:21]; aRMRecNo{$Loc})
			$OldKey:=[Raw_Materials:21]Raw_Matl_Code:1
			$Loc:=Find in array:C230(aBullet; "√"; $Loc+1)
			xText:=xText+$OldKey+Char:C90(13)
			
			Case of 
				: ($Loc>0) & ($Count>1)  //there was a previous search & there will be more
					QUERY:C277($File->;  | ; $Field->=$OldKey; *)
				: ($Loc>0) & ($Count=1)  //there was NOT a previous search & there will be more
					QUERY:C277($File->; $Field->=$OldKey; *)
				: ($Loc<0) & ($Count>1)  //there was a previous search & there will be NO more
					QUERY:C277($File->;  | ; $Field->=$OldKey)
				: ($Loc<0) & ($Count=1)  //there was NOT a previous search & there will be NO more
					QUERY:C277($File->; $Field->=$OldKey)
			End case 
		End while 
		CREATE SET:C116($File->; Table name:C256($File))
		uClearSelection($File)
	End if 
End for 