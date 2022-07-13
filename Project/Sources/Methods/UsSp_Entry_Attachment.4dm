//%attributes = {}
//Method:  UsSp_Entry_Attachment
//Desciption:  This method will allow a user to attach a document if needed

If (True:C214)  //Initialize
	
	C_TEXT:C284($tDocument; $tWindowTitle)
	
	ARRAY TEXT:C222($atSelectedDocument; 0)
	
	$tWindowTitle:="Select documents to send to aMs User Support"
	
End if   //Done Initialize

$tDocument:=Select document:C905(CorektBlank; "*"; $tWindowTitle; Multiple files:K24:7; $atSelectedDocument)

If (OK=1)
	
	Core_Array_Union(->$atSelectedDocument; ->UsSp_atEntry_Attachment)
	
End if 
