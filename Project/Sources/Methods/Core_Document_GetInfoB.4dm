//%attributes = {}
//Method:  Core_Document_GetInfoB(tPathname;poDocumentInfo)=>bInfoFilled
//Description:  This method fills oDocumentInfo with values.

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bInfoFilled)
	C_TEXT:C284($1; $tFullPathname)
	C_POINTER:C301($2; $poDocumentInfo)
	
	C_BOOLEAN:C305($bLocked; $bInvisible)
	C_DATE:C307($dModifiedOn)
	C_TIME:C306($hCreatedAt; $hModifiedAt)
	
	C_REAL:C285($rSize)
	
	$tFullPathname:=$1
	$poDocumentInfo:=$2
	
	$bInfoFilled:=False:C215
	
End if   //Done Initialize

If (Test path name:C476($tFullPathname)=Is a document:K24:1)
	
	$bInfoFilled:=True:C214
	
	GET DOCUMENT PROPERTIES:C477($tFullPathname; $bLocked; $bInvisible; $dCreatedOn; $hCreatedAt; $dModifiedOn; $hModifiedAt)
	
	$rSize:=Get document size:C479($tFullPathname)
	
	OB SET:C1220($poDocumentInfo->; "bLocked"; $bLocked)
	OB SET:C1220($poDocumentInfo->; "bInvisible"; $bInvisible)
	OB SET:C1220($poDocumentInfo->; "dCreatedOn"; $dCreatedOn)
	OB SET:C1220($poDocumentInfo->; "hCreatedAt"; $hCreatedAt)
	OB SET:C1220($poDocumentInfo->; "dModifiedOn"; $dModifiedOn)
	OB SET:C1220($poDocumentInfo->; "hModifiedAt"; $hModifiedAt)
	
	OB SET:C1220($poDocumentInfo->; "rSize"; $rSize)
	
End if 

$0:=$bInfoFilled
