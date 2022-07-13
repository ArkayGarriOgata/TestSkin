//%attributes = {"publishedWeb":true}
//(p) xPrintRM
//used as a tempory routine to print the Rm list lists for a Subgroup
//7/29/97 cs created
//• 9/29/97 cs added dept & expense codes

C_TEXT:C284(xTitle; xText)
C_TEXT:C284($Comm)

Repeat 
	$Comm:=Request:C163("Please Enter a Commodity Key."; "00-xxxx")
Until (($Comm#"00-xxxx") & ($Comm#"")) | (OK=0)

If (OK=1)
	xTitle:="RMs for Comm Key - "+$Comm+"    Description"+(" "*30)+" Dept"+(" "*5)+"Expense"  //• 9/29/97 cs 
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2=$Comm)
	
	If (Records in selection:C76([Raw_Materials:21])>0)
		uConfirm("Print Listing to Disk file or Printer?"; "Printer"; "Disk")
		$ToPrinter:=(OK=1)
		
		If ($ToPrinter)
			util_PAGE_SETUP(->[zz_control:1]; "PrintText")
			PRINT SETTINGS:C106
		Else 
			OK:=1
		End if 
		
		If (OK=1)
			$Count:=Records in selection:C76([Raw_Materials:21])
			ARRAY TEXT:C222($CommKey; $Count)
			ARRAY TEXT:C222($Desc; $Count)
			ARRAY TEXT:C222($Dept; $Count)  //• 9/29/97 cs 
			ARRAY TEXT:C222($Exp; $Count)  //• 9/29/97 cs 
			//add the deprt and exp code 
			SELECTION TO ARRAY:C260([Raw_Materials:21]Raw_Matl_Code:1; $CommKey; [Raw_Materials:21]Description:4; $Desc; [Raw_Materials:21]DepartmentID:28; $Dept; [Raw_Materials:21]Obsolete_ExpCode:29; $Exp)  //• 9/29/97 cs 
			SORT ARRAY:C229($CommKey; $Desc; $Exp; $Dept; >)
			
			For ($i; 1; Size of array:C274($CommKey))
				$Length:=Length:C16($Desc{$i})
				$Spaces:=50-$Length+8
				
				If ($ToPrinter)
					ChkxText2Print($CommKey{$i}+(" "*(30-Length:C16($Commkey{$i})))+"- "+Substring:C12($Desc{$i}; 1; 50)+(" "*$Spaces)+$Dept{$i}+(" "*8)+$Exp{$i}+Char:C90(13))
				Else 
					ChkxText2Print($CommKey{$i}+(" "*(30-Length:C16($Commkey{$i})))+"- "+Substring:C12($Desc{$i}; 1; 50)+(" "*$Spaces)+$Dept{$i}+(" "*8)+$Exp{$i}+Char:C90(13); xTitle)
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