//%attributes = {"publishedWeb":true}
//(p) doPurgePspec
//remove pspecs that are NOT attached to either a Job or an Estimate
//• 3/10/98 cs created
//• 3/27/98 cs added default path to file creation
//062300 don;t purge if in FGs

C_TEXT:C284(xText; xTitle; $Filename; $Path)
C_TEXT:C284($Cr)
C_BOOLEAN:C305($Exit)
ARRAY TEXT:C222(aText; 20)

$Path:=<>purgeFolderPath
$Cr:=Char:C90(13)
$Filename:="Pspecs removed"  //used for documentation
xTitle:="PSpecs Purged"+Char:C90(13)+"Process Spec"+(" "*30)+"Description"+(" "*30)+" Customer ID"
xText:=""
SET CHANNEL:C77(10; ($Path+"PSpecs "+String:C10(4D_Current_date; 4)))
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	ALL RECORDS:C47([Process_Specs:18])
	CREATE SET:C116([Process_Specs:18]; "all")
	
	ALL RECORDS:C47([Estimates_PSpecs:57])
	uRelateSelect(->[Process_Specs:18]ID:1; ->[Estimates_PSpecs:57]ProcessSpec:2)
	CREATE SET:C116([Process_Specs:18]; "Est")
	DIFFERENCE:C122("All"; "Est"; "Est")
	
	ALL RECORDS:C47([Job_Forms:42])
	uRelateSelect(->[Process_Specs:18]ID:1; ->[Job_Forms:42]ProcessSpec:46)
	CREATE SET:C116([Process_Specs:18]; "jobs")
	DIFFERENCE:C122("All"; "jobs"; "jobs")
	INTERSECTION:C121("Est"; "Jobs"; "All")
	
	ALL RECORDS:C47([Finished_Goods:26])
	uRelateSelect(->[Process_Specs:18]ID:1; ->[Finished_Goods:26]ProcessSpec:33)
	CREATE SET:C116([Process_Specs:18]; "FG")
	INTERSECTION:C121("FG"; "All"; "All")
	
Else 
	
	ARRAY TEXT:C222($_ProcessSpec; 0)
	
	ALL RECORDS:C47([Process_Specs:18])
	CREATE SET:C116([Process_Specs:18]; "all")
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Process_Specs:18])+" file. Please Wait...")
	ALL RECORDS:C47([Estimates_PSpecs:57])
	RELATE ONE SELECTION:C349([Estimates_PSpecs:57]; [Process_Specs:18])
	CREATE SET:C116([Process_Specs:18]; "Est")
	DIFFERENCE:C122("All"; "Est"; "Est")
	
	ALL RECORDS:C47([Job_Forms:42])
	DISTINCT VALUES:C339([Job_Forms:42]ProcessSpec:46; $_ProcessSpec)
	SET QUERY DESTINATION:C396(Into set:K19:2; "jobs")
	QUERY WITH ARRAY:C644([Process_Specs:18]ID:1; $_ProcessSpec)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	DIFFERENCE:C122("All"; "jobs"; "jobs")
	INTERSECTION:C121("Est"; "Jobs"; "All")
	
	ALL RECORDS:C47([Finished_Goods:26])
	DISTINCT VALUES:C339([Finished_Goods:26]ProcessSpec:33; $_ProcessSpec)
	SET QUERY DESTINATION:C396(Into set:K19:2; "FG")
	QUERY WITH ARRAY:C644([Process_Specs:18]ID:1; $_ProcessSpec)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	INTERSECTION:C121("FG"; "All"; "All")
	zwStatusMsg(""; "")
	
End if   // END 4D Professional Services : January 2019 query selection

uClearSelection(->[Process_Specs:18])
uClearSelection(->[Job_Forms:42])
uClearSelection(->[Estimates_PSpecs:57])
CLEAR SET:C117("Est")
CLEAR SET:C117("jobs")
CLEAR SET:C117("FG")
CLEAR SET:C117("OpSeq")
CLEAR SET:C117("MatP")
USE SET:C118("All")

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	uRelateSelect(->[Process_Specs_Materials:56]ProcessSpec:1; ->[Process_Specs:18]ID:1)  //collect related material and machine definitions
	CREATE SET:C116([Process_Specs_Materials:56]; "MatP")
	uRelateSelect(->[Process_Specs_Machines:28]ProcessSpec:1; ->[Process_Specs:18]ID:1)
	
Else 
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Process_Specs_Materials:56])+" file. Please Wait...")
	RELATE MANY SELECTION:C340([Process_Specs_Materials:56]ProcessSpec:1)
	CREATE SET:C116([Process_Specs_Materials:56]; "MatP")
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Process_Specs_Machines:28])+" file. Please Wait...")
	RELATE MANY SELECTION:C340([Process_Specs_Machines:28]ProcessSpec:1)
	zwStatusMsg(""; "")
	
End if   // END 4D Professional Services : January 2019 query selection
CREATE SET:C116([Process_Specs_Machines:28]; "OpSeq")
uClearSelection(->[Process_Specs_Machines:28])
uClearSelection(->[Process_Specs_Materials:56])
CLEAR SET:C117("All")
$File:="Process Specs removed"
$TextIndex:=1
ORDER BY:C49([Process_Specs:18]; [Process_Specs:18]Cust_ID:4; >; [Process_Specs:18]ID:1; >)
For ($i; 1; Records in selection:C76([Process_Specs:18]))
	SEND RECORD:C78([Process_Specs:18])
	
	If (Length:C16(aText{$TextIndex})>30000)
		$TextIndex:=$TextIndex+1
		
		If ($TextIndex>Size of array:C274(aText))
			ARRAY TEXT:C222(aText; $TextIndex+$TextIndex)
		End if 
	End if 
	aText{$TextIndex}:=aText{$TextIndex}+[Process_Specs:18]Cust_ID:4+" "+[Process_Specs:18]ID:1+" "+Char:C90(13)
	NEXT RECORD:C51([Process_Specs:18])
End for 
SET CHANNEL:C77(11)

SET CHANNEL:C77(10; ($Path+"MatPspec "+String:C10(4D_Current_date; 4)))
USE SET:C118("MatP")

For ($i; 1; Records in selection:C76([Process_Specs_Materials:56]))
	SEND RECORD:C78([Process_Specs_Materials:56])
	NEXT RECORD:C51([Process_Specs_Materials:56])
End for 
SET CHANNEL:C77(11)

SET CHANNEL:C77(10; ($Path+"OperSeq "+String:C10(4D_Current_date; 4)))
USE SET:C118("OpSeq")

For ($i; 1; Records in selection:C76([Process_Specs_Machines:28]))
	SEND RECORD:C78([Process_Specs_Machines:28])
	NEXT RECORD:C51([Process_Specs_Machines:28])
End for 
SET CHANNEL:C77(11)
$TextIndex:=1
$Exit:=False:C215

Repeat 
	xText:=aText{$TextIndex}
	rPrintText($Filename+String:C10($TextIndex))
	$TextIndex:=$TextIndex+1
	
	If ($TextIndex)>Size of array:C274(aText)
		$TextIndex:=$TextIndex-1
		$Exit:=True:C214
	End if 
Until (Length:C16(aText{$TextIndex})=0) | ($Exit)

MESSAGE:C88("Deleting Process specs")
DELETE SELECTION:C66([Process_Specs:18])
FLUSH CACHE:C297

USE SET:C118("OpSeq")
CLEAR SET:C117("OpSeq")
DELETE SELECTION:C66([Process_Specs_Machines:28])
FLUSH CACHE:C297

USE SET:C118("MatP")
CLEAR SET:C117("MatP")
DELETE SELECTION:C66([Process_Specs_Materials:56])
FLUSH CACHE:C297
ARRAY TEXT:C222(aText; 0)