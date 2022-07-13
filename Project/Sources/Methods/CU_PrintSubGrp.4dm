//%attributes = {"publishedWeb":true}
//(p) xPrintSubGroup
//used as a tempory routine to print the subgroup lists for a commodity
//7/29/97 cs created

C_TEXT:C284(xTitle; xText)

Repeat 
	$Comm:=Num:C11(Request:C163("Please Enter a Commodity Code."; "00"))
Until ($Comm#0) | (OK=0)

If (OK=1)
	xTitle:="Subgroups for Commodity - "+String:C10($Comm; "00")
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=$Comm)
	
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		uConfirm("Print Listing to Disk file or Printer?"; "Printer"; "Disk")
		$ToPrinter:=(OK=1)
		
		If ($ToPrinter)
			util_PAGE_SETUP(->[zz_control:1]; "PrintText")
			PRINT SETTINGS:C106
		Else 
			OK:=1
		End if 
		
		If (OK=1)
			ARRAY TEXT:C222($SubGroup; 0)
			DISTINCT VALUES:C339([Raw_Materials_Groups:22]SubGroup:10; $SubGroup)
			SORT ARRAY:C229($SubGroup; >)
			
			For ($i; 1; Size of array:C274($subgroup))
				
				If ($ToPrinter)
					ChkxText2Print($SubGroup{$i}+Char:C90(13))
				Else 
					ChkxText2Print($SubGroup{$i}+Char:C90(13); xTitle)
				End if 
			End for 
			
			If (Length:C16(xText)>0)
				If ($ToPrinter)
					rPrintText
				Else 
					rPrintText(xTitle)
					MESSAGE:C88("Done...")
					DELAY PROCESS:C323(Current process:C322; 60)
				End if 
			End if 
		End if 
	End if 
End if 
uWinListCleanup