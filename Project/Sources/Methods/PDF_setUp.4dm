//%attributes = {"publishedWeb":true}
//PM: PDF_setUp({path};{osx do it}) -> 
//@author mlb - 4/25/01  06:16
//set up the preference folder that PrintToPDF uses for naming docs
//see also PDF_onOff, PDF_printSimple

C_TEXT:C284($1; $pdfDocName)
C_BOOLEAN:C305($2; $forcePDF)
C_TEXT:C284($prefPath; $0)
C_TIME:C306($docRef)

$forcePDF:=False:C215
$0:=""

If (Count parameters:C259>=1)
	If (Length:C16($1)>0)
		$pdfDocName:=$1
	Else 
		$pdfDocName:="aMsOutput"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".pdf"
	End if 
	
Else 
	$pdfDocName:="aMsOutput"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".pdf"
End if 

If (Is macOS:C1572)
	C_LONGINT:C283($macPDF; $printer)
	If (Count parameters:C259>=2)
		$forcePDF:=$2
	End if 
	
	If (<>PrintToPDF) | ($forcePDF)
		$prefPath:=util_DocumentPath
		util_deleteDocument($prefPath+$pdfDocName)
		$macPDF:=3
		SET PRINT OPTION:C733(Destination option:K47:7; $macPDF; ($prefPath+$pdfDocName))
		$0:=$prefPath+$pdfDocName
	Else   //restore
		$printer:=1
		SET PRINT OPTION:C733(Destination option:K47:7; $printer; "")
	End if 
End if 