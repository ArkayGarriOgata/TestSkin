//%attributes = {"publishedWeb":true}
//Procedure: x_PrintText() chip
//•041996  MLB  allow print to disk
//• 5/30/97 cs check that 'xtext' is not empty, and clear
//• 9/4/97 cs set creator type on exported files -> simpletext
//mlb 8/18/03 use util_putfilename so goes to AMS_Documents folder

C_TEXT:C284($1; docName)  //optional to print to disk file
C_LONGINT:C283($Error)

If (Length:C16(xText)>0)  //check that printing values are not empty
	
	If (Count parameters:C259=0)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ALL RECORDS:C47([zz_control:1])
			FIRST RECORD:C50([zz_control:1])
			
			
		Else 
			
			ALL RECORDS:C47([zz_control:1])
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		util_PAGE_SETUP(->[zz_control:1]; "PrintText")
		PDF_setUp("")
		FORM SET OUTPUT:C54([zz_control:1]; "PrintText")
		PRINT SELECTION:C60([zz_control:1]; *)
		FORM SET OUTPUT:C54([zz_control:1]; "List")
	Else   //print to file
		C_TIME:C306($docRef)
		docName:=$1
		$docRef:=util_putFileName(->docName)
		SEND PACKET:C103($docRef; xTitle+Char:C90(13)+Char:C90(13))
		SEND PACKET:C103($docRef; xText)
		SEND PACKET:C103($docRef; Char:C90(13)+Char:C90(13)+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		//$Error:=SetFileCreator (docName;"ttxt")  `makes this a simpletext file instead of 4D
		$err:=util_Launch_External_App(docName)
		
	End if 
	xText:=""
End if 