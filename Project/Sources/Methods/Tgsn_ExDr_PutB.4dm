//%attributes = {}
//Method:  Tgsn_ExDr_PutB(tPipedInvoice)=>bPutOnExpanDrive
//Description:  This method will put a document in ExpanDrive

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPipedInvoice)
	
	C_BOOLEAN:C305($0; $bPutOnExpanDrive)
	
	C_TEXT:C284($tTungstenExpanDrive)
	C_TEXT:C284($tPathName)
	
	C_LONGINT:C283($nExpanDrive)
	
	C_OBJECT:C1216($oTungsten)
	C_OBJECT:C1216($oAlert)
	
	ARRAY TEXT:C222($atVolume; 0)
	
	$tPipedInvoice:=$1
	
	$oTungsten:=New object:C1471()
	$oAlert:=New object:C1471()
	
	$oAlert.tMessage:="Please mount the ExpanDrive. Contact IT if you have questions."
	
	$tTungstenExpanDrive:="ft.tungsten-network.com"
	
	//$tPathName:="Macintosh HD:Users:garriogata:Desktop:" //Used for testing 
	//$tPathName:=$tTungstenExpanDrive+Folder separator+"DX001"+Folder separator //Full pathname if ExpanDrive is not used
	
	$tPathName:=$tTungstenExpanDrive+Folder separator:K24:12  //Using ExpanDrive pathname
	
End if   //Done Initialize

Case of   //Put on Tungsten server
		
	: (Not:C34(Tgsn_ExDr_ConnectB($tTungstenExpanDrive)))
		
		Core_Dialog_Alert($oAlert)
		
	Else   //Document Placed
		
		$oTungsten.tDocumentInfo:=$tPipedInvoice
		$oTungsten.tPathname:=$tPathname
		$oTungsten.tFilename:=Tgsn_FilenameT
		$oTungsten.bUseBOM:=False:C215
		
		$bPutOnExpanDrive:=Core_Document_UTF8B($oTungsten)
		
End case   //Done put on Tungsten server

$0:=$bPutOnExpanDrive