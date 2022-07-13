//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/08/17, 16:28:16
// ----------------------------------------------------
// Method: WebAPI_ProcessRequest
// Description
// 
//
// Parameters
// ----------------------------------------------------
//$1=Request
C_TEXT:C284($1; $ttRequest; $0; $ttJSON)

// starts with api/

//http://127.0.0.1/api/jobs
//utl_LogIt ("init")
//utl_LogIt ($req)
//utl_LogIt ("---")
//utl_LogIt ($2)
//utl_LogIt ($3)
//utl_LogIt ($4)
//utl_LogIt ($5)
//utl_LogIt ($6)
//utl_LogIt ("show")

// GET REQUEST
//  api/pluralThing --> collection
//  api/pluralThing?attribute=qualifier --> collection, filtered
//  api/pluralThing/name --> object
//  api/pluralThing/name/pluralThing --> object's children
$req:=Substring:C12($1; 5)  // strip the api/ cause web auth already checked or you wouldnt be here
$ttJSON:=""
$hook:=Position:C15("?"; $req)  //qualifiers like ?status=wip&version>yesterday

Case of 
	: ($req="jobs")
		$ttJSON:=api_Jobs
		
	: ($req="jobs/@")
		$jobform:=Substring:C12($req; 6; 8)
		$ttJSON:=api_Jobs($jobform)
		
	Else 
		$ttJSON:="404"
End case 

//utl_LogIt ("init")
//utl_LogIt ($res)
//utl_LogIt ("show")

$0:=$ttJSON