// -------
// Method: On Web Connection   ( ) ->
// By: Mel Bohince @ 04/13/17, 17:01:02
// Description
// prototype a route
// ----------------------------------------------------
// Modified by: Phil Keth (8/22/17) 


C_TEXT:C284($1; $2; $3; $4; $5; $6; $req; $res; $url)
C_BLOB:C604($resBlob; $obReturn)
C_TEXT:C284($ttBody; $ttEventMessage; $ttJSON; $ttCookie)
C_BOOLEAN:C305($fIsLoggedIn)
C_OBJECT:C1216($obCookieData; $obJSON; $obRecord)

$url:=$1
$cookie:=WEB Get current session ID:C1162
vtTitle:=""

$fFPWeb:=False:C215
$fAPIRequest:=False:C215


ARRAY TEXT:C222(stt4DWeb_HeaderKeys; 0)
ARRAY TEXT:C222(stt4DWeb_HeaderValues; 0)

WEB GET HTTP HEADER:C697(stt4DWeb_HeaderKeys; stt4DWeb_HeaderValues)


WEB GET HTTP BODY:C814($ttBody)
$ttRequest:=$1

//FPWeb_ParseMobileRequest ($1)

$ttTemp:=FPWeb_ParseRequest($1; $2; $3; $4; $5; $6)
If ($ttTemp="")
	FPWeb_SetCookieKey("FPWebCookie="+Generate UUID:C1066)
End if 
$ttCookie:=FPWeb_GetCookieByKey("FPWebCookie")
$fIsLoggedIn:=FPWeb_IsLoggedIn($ttCookie)
If ($fIsLoggedIn)  // If we are logged in, update the timestamp so we don't timeout
	$obCookieData:=FPWeb_GetData($ttCookie)
	OB SET:C1220($obCookieData; "timestamp"; String:C10(Tickcount:C458))
	$ttCookie:=FPWeb_SetData($ttCookie; $obCookieData)
End if 


$ttEventMessage:=FPWeb_GetEvent
$ttPortal:=FPWeb_GetParameterByKey("portal")
$ttAction:=FPWeb_GetParameterByKey("Action")  // Designates new image

If (($ttEventMessage="customer_Portal") | ($ttPortal="customer_Portal"))  //v1.0.3-PJK (2/26/20)
	$fFPWeb:=CustomerPortal_ProcessMessage($ttCookie; ->$obReturn)  //v1.0.3-PJK (2/26/20)
End if   //v1.0.3-PJK (2/26/20)


Case of 
	: ($url="api/@")
		api_REST_OnWebConnection($url; $2)
		
		$fAPIRequest:=True:C214
		//$ttJSON:=WebAPI_ProcessRequest ($1)
		
	: (FPWeb_ProcBuiltInRequest(->$obReturn; ->$ttRequest))
		//4DWEB_InternalEvent, event already processed by 4DWEB component
		$fFPWeb:=True:C214
		
		//
		//
		//
		// New Rollstock events
	: (($ttEventMessage="ams_WebRequests") & ($ttAction="IsLoggedIn"))
		$ttReturn:=("SUCCESS"*Num:C11($fIsLoggedIn))+("FAILED"*Num:C11(Not:C34($fIsLoggedIn)))
		TEXT TO BLOB:C554($ttReturn; $obReturn; UTF8 text without length:K22:17)
		$fFPWeb:=True:C214
		
	: (($ttEventMessage="ams_WebRequests") & ($ttAction="DieBoard_Lookup"))
		$ttRollStockID:=FPWeb_GetParameterByKey("ID")  // Designates new image
		$ttTemp:=$ttRollStockID
		$ttOutline:=GetNextField(->$ttTemp; "-")
		$xlUpNum:=Num:C11($ttTemp)
		READ WRITE:C146([Job_DieBoard_Inv:168])
		QUERY:C277([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]OutlineNumber:4=$ttOutline; *)
		QUERY:C277([Job_DieBoard_Inv:168];  & ; [Job_DieBoard_Inv:168]UpNumber:5=$xlUpNum)
		
		If (Records in selection:C76([Job_DieBoard_Inv:168])>0)
			
			OB SET:C1220($obJSON; "error"; "SUCCESS")
			OB SET:C1220($obJSON; "Customer"; [Job_DieBoard_Inv:168]Customer:2)
			OB SET:C1220($obJSON; "DieNumber"; [Job_DieBoard_Inv:168]DieNumber:3)
			OB SET:C1220($obJSON; "Outline"; [Job_DieBoard_Inv:168]OutlineNumber:4)
			OB SET:C1220($obJSON; "UpNum"; String:C10([Job_DieBoard_Inv:168]UpNumber:5))
			OB SET:C1220($obJSON; "DieDate"; String:C10([Job_DieBoard_Inv:168]DateEntered:6))
			OB SET:C1220($obJSON; "CatalogID"; [Job_DieBoard_Inv:168]CatelogID:10)
			OB SET:C1220($obJSON; "Type"; [Job_DieBoard_Inv:168]Type:7)
			
		Else 
			OB SET:C1220($obJSON; "error"; "Die Board record was not found with ID = "+$ttRollStockID)
		End if 
		UNLOAD RECORD:C212([Job_DieBoard_Inv:168])
		$ttReturn:=JSON Stringify:C1217($obJSON)
		TEXT TO BLOB:C554($ttReturn; $obReturn; UTF8 text without length:K22:17)
		$fFPWeb:=True:C214
		
		
	: (($ttEventMessage="ams_WebRequests") & ($ttAction="DieBoard_Save"))
		$fNew:=(FPWeb_GetParameterByKey("IsNew")="True")
		$ttCust:=FPWeb_GetParameterByKey("Customer")
		$ttDieNumber:=FPWeb_GetParameterByKey("DieNumber")
		$ttOutline:=FPWeb_GetParameterByKey("Outline")
		$xlUpNum:=Num:C11(FPWeb_GetParameterByKey("UpNum"))
		$ttDate:=FPWeb_GetParameterByKey("DieDate")
		$ttType:=FPWeb_GetParameterByKey("Type")
		$ttCatalog:=FPWeb_GetParameterByKey("Catalog")
		$ttRollStockID:=$ttOutline+"-"+String:C10($xlUpNum)
		READ WRITE:C146([Job_DieBoard_Inv:168])
		QUERY:C277([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]OutlineNumber:4=$ttOutline; *)
		QUERY:C277([Job_DieBoard_Inv:168];  & ; [Job_DieBoard_Inv:168]UpNumber:5=$xlUpNum)
		
		Case of 
			: ((Records in selection:C76([Job_DieBoard_Inv:168])>0) & $fNew)  //trying to create a duplicate
				OB SET:C1220($obJSON; "error"; "Die Board record already exists with ID = "+$ttRollStockID)
				
			: ((Records in selection:C76([Job_DieBoard_Inv:168])=0) & Not:C34($fNew))  //trying to save existing record, NOT FOUND
				OB SET:C1220($obJSON; "error"; "Die Board record was not found with ID = "+$ttRollStockID)
				
			: (Not:C34($fNew) & Locked:C147([Job_DieBoard_Inv:168]))
				OB SET:C1220($obJSON; "error"; "Die Board record with ID = "+$ttRollStockID+" is locked and cannot be updated. Try again later.")
				
			Else 
				OB SET:C1220($obJSON; "error"; "SUCCESS")
				
				If ($fNew)
					CREATE RECORD:C68([Job_DieBoard_Inv:168])
					[Job_DieBoard_Inv:168]OutlineNumber:4:=$ttOutline
					[Job_DieBoard_Inv:168]UpNumber:5:=$xlUpNum
				End if 
				[Job_DieBoard_Inv:168]Customer:2:=$ttCust
				[Job_DieBoard_Inv:168]DieNumber:3:=$ttDieNumber
				[Job_DieBoard_Inv:168]DateEntered:6:=Date:C102($ttDate)
				[Job_DieBoard_Inv:168]Type:7:=$ttType
				[Job_DieBoard_Inv:168]CatelogID:10:=$ttCatalog
				SAVE RECORD:C53([Job_DieBoard_Inv:168])
		End case 
		UNLOAD RECORD:C212([Job_DieBoard_Inv:168])
		$ttReturn:=JSON Stringify:C1217($obJSON)
		TEXT TO BLOB:C554($ttReturn; $obReturn; UTF8 text without length:K22:17)
		$fFPWeb:=True:C214
		
	: (($ttEventMessage="ams_WebRequests") & ($ttAction="DieBoard_Delete"))
		$ttOutline:=FPWeb_GetParameterByKey("Outline")
		$xlUpNum:=Num:C11(FPWeb_GetParameterByKey("UpNum"))
		READ WRITE:C146([Job_DieBoard_Inv:168])
		QUERY:C277([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]OutlineNumber:4=$ttOutline; *)
		QUERY:C277([Job_DieBoard_Inv:168];  & ; [Job_DieBoard_Inv:168]UpNumber:5=$xlUpNum)
		Case of 
			: (Records in selection:C76([Job_DieBoard_Inv:168])=0)  //trying to save existing record, NOT FOUND
				OB SET:C1220($obJSON; "error"; "Die Board record was not found with ID = "+$ttRollStockID)
				
			: (Locked:C147([Job_DieBoard_Inv:168]))
				OB SET:C1220($obJSON; "error"; "Die Board record with ID = "+$ttRollStockID+" is locked and cannot be deleted. Try again later.")
				
			Else 
				DELETE RECORD:C58([Job_DieBoard_Inv:168])
				OB SET:C1220($obJSON; "error"; "SUCCESS")
		End case 
		UNLOAD RECORD:C212([Job_DieBoard_Inv:168])
		
		
		$ttReturn:=JSON Stringify:C1217($obJSON)
		TEXT TO BLOB:C554($ttReturn; $obReturn; UTF8 text without length:K22:17)
		$fFPWeb:=True:C214
		
		
	: (($ttEventMessage="ams_WebRequests") & ($ttAction="RollStk_Lookup"))
		$ttRollStockID:=FPWeb_GetParameterByKey("ID")  // Designates new image
		QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2=$ttRollStockID)
		If (Records in selection:C76([Raw_Material_Labels:171])>0)
			
			OB SET:C1220($obJSON; "error"; "SUCCESS")
			OB SET:C1220($obJSON; "ID"; [Raw_Material_Labels:171]Label_id:2)
			OB SET:C1220($obJSON; "PO"; String:C10(Num:C11([Raw_Material_Labels:171]POItemKey:3); "000 0000 00"))
			OB SET:C1220($obJSON; "UOM"; [Raw_Material_Labels:171]UOM:9)
			OB SET:C1220($obJSON; "Qty"; [Raw_Material_Labels:171]Qty:8)
			OB SET:C1220($obJSON; "MatCode"; [Raw_Material_Labels:171]Raw_Matl_Code:4)
			OB SET:C1220($obJSON; "Location"; [Raw_Material_Labels:171]Location:10)
			
		Else 
			OB SET:C1220($obJSON; "error"; "Roll Stock record was not found with ID = "+$ttRollStockID)
		End if 
		UNLOAD RECORD:C212([Raw_Material_Labels:171])
		$ttReturn:=JSON Stringify:C1217($obJSON)
		TEXT TO BLOB:C554($ttReturn; $obReturn; UTF8 text without length:K22:17)
		$fFPWeb:=True:C214
		
	: (($ttEventMessage="ams_WebRequests") & ($ttAction="RollStk_QtyUpdate"))
		$ttRollStockID:=FPWeb_GetParameterByKey("ID")  // Designates new image
		$xlQty:=Num:C11(FPWeb_GetParameterByKey("Qty"))  // Designates new image
		READ WRITE:C146([Raw_Material_Labels:171])
		QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2=$ttRollStockID)
		Case of 
			: (Records in selection:C76([Raw_Material_Labels:171])=0)  //No record found
				$ttReturn:="Roll Stock record was not found with ID = "+$ttRollStockID
			: (Locked:C147([Raw_Material_Labels:171]))  // Locked
				$ttReturn:="Roll Stock record was locked: "+$ttRollStockID
			Else 
				[Raw_Material_Labels:171]Qty:8:=$xlQty
				SAVE RECORD:C53([Raw_Material_Labels:171])
				$ttReturn:="SUCCESS"
		End case 
		UNLOAD RECORD:C212([Raw_Material_Labels:171])
		TEXT TO BLOB:C554($ttReturn; $obReturn; UTF8 text without length:K22:17)
		$fFPWeb:=True:C214
		
	: (($ttEventMessage="ams_WebRequests") & ($ttAction="RollStk_LocationUpdate"))
		$ttRollStockID:=FPWeb_GetParameterByKey("ID")  // Designates new image
		$ttLocation:=FPWeb_GetParameterByKey("Location")  // Designates new image
		READ WRITE:C146([Raw_Material_Labels:171])
		QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2=$ttRollStockID)
		
		
		Case of 
			: (Records in selection:C76([Raw_Material_Labels:171])=0)  //No record found
				$ttReturn:="Roll Stock record was not found with ID = "+$ttRollStockID
			: (Locked:C147([Raw_Material_Labels:171]))  // Locked
				$ttReturn:="Roll Stock record was locked: "+$ttRollStockID
			Else 
				[Raw_Material_Labels:171]Location:10:=$ttLocation
				SAVE RECORD:C53([Raw_Material_Labels:171])
				$ttReturn:="SUCCESS"
				
				OB SET:C1220($obJSON; "ID"; [Raw_Material_Labels:171]Label_id:2)
				OB SET:C1220($obJSON; "PO"; String:C10(Num:C11([Raw_Material_Labels:171]POItemKey:3); "000 0000 00"))
				OB SET:C1220($obJSON; "UOM"; [Raw_Material_Labels:171]UOM:9)
				OB SET:C1220($obJSON; "Qty"; [Raw_Material_Labels:171]Qty:8)
				OB SET:C1220($obJSON; "MatCode"; [Raw_Material_Labels:171]Raw_Matl_Code:4)
				OB SET:C1220($obJSON; "Location"; [Raw_Material_Labels:171]Location:10)
				
		End case 
		OB SET:C1220($obJSON; "error"; $ttReturn)
		UNLOAD RECORD:C212([Raw_Material_Labels:171])
		UNLOAD RECORD:C212([Raw_Material_Labels:171])
		$ttReturn:=JSON Stringify:C1217($obJSON)
		TEXT TO BLOB:C554($ttReturn; $obReturn; UTF8 text without length:K22:17)
		$fFPWeb:=True:C214
		
		
		
		
		
		
	: (($ttEventMessage="ams_WebRequests") & ($ttAction="Login"))
		$ttUsername:=FPWeb_GetParameterByKey("Username")  // Designates new image
		$ttPassword:=FPWeb_GetParameterByKey("Password")  // Designates new image
		
		If (Validate password:C638($ttUsername; $ttPassword))
			$ttReturn:="SUCCESS"
			$ttCookie:=FPWeb_SetLoggedIn($ttCookie; True:C214)
			$obCookieData:=FPWeb_GetData($ttCookie)
			OB SET:C1220($obCookieData; "username"; $ttUsername)
			$ttCookie:=FPWeb_SetData($ttCookie; $obCookieData)
			FPWeb_SetCookieKey("FPWebCookie="+$ttCookie)
		Else 
			$ttReturn:="FAILED"
		End if 
		
		TEXT TO BLOB:C554($ttReturn; $obReturn; UTF8 text without length:K22:17)
		$fFPWeb:=True:C214
		
		
		
		
	: (($ttEventMessage="ams_WebRequests") & ($ttAction="Logout"))
		$ttReturn:="SUCCESS"
		$ttCookie:=FPWeb_SetLoggedIn($ttCookie; False:C215)
		TEXT TO BLOB:C554($ttReturn; $obReturn; UTF8 text without length:K22:17)
		$fFPWeb:=True:C214
		
		
		
		
		
		
		
		//
		//
		//
		// Old RollStock Events
		
		
		
		
	: ($ttEventMessage="api_NewRollStockRecord")
		
		$ttPOItemKey:=FPWeb_GetParameterByKey("POItemKey")  // Designates new image
		$ttNewRollID:=txt_StripChars(FPWeb_GetParameterByKey("RollStockID"); " ")
		$ttLinearFeet:=FPWeb_GetParameterByKey("LinearFeet")
		api_CreateRollStockRecord(->$obReturn; $ttPOItemKey; $ttNewRollID; Num:C11($ttLinearFeet))
		$fFPWeb:=True:C214
		
	: ($ttEventMessage="api_DeleteRollStockRecord")
		
		$ttPOItemKey:=FPWeb_GetParameterByKey("POItemKey")  // Designates new image
		$ttNewRollID:=txt_StripChars(FPWeb_GetParameterByKey("RollStockID"); " ")
		api_DeleteRollStockRecord(->$obReturn; $ttPOItemKey; $ttNewRollID)
		$fFPWeb:=True:C214
		
		// Old RollStock Events
		//
		//
		//
		
		
		
		// Non 4DWEB CGI BELOW HERE
		
End case 


Case of 
	: ($fFPWeb)  // if FPWeb request, call component to return
		If (BLOB size:C605($obReturn)>0)  //v1.0.3-PJK (2/27/20)
			FPWeb_ReturnBLOB($obReturn)
		End if   //v1.0.3-PJK (2/27/20)
		
	: ($fAPIRequest)  // if Custom Mel api request, return JSON
		// handled by OWC_API at the top of the CaseOf
		
		//TEXT TO BLOB($ttJSON;$resBlob;UTF8 text without length)
		//WEB SEND BLOB($resBlob;"application/json")
		
	Else   // All other requests will be files
		WEB SEND FILE:C619($1)
End case 


