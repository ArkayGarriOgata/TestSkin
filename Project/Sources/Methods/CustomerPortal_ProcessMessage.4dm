//%attributes = {}
//© 2020 Footprints Inc. All Rights Reserved.
//Method: Method: CustomerPortal_ProcessMessage - Created `v1.0.3-PJK (2/26/20)
// Modified by: Mel Bohince (3/12/20) chg fmt in calloff from "###,###,0" to "###,###,##0"

C_TEXT:C284($1; $ttCookie; $ttQuery; $ttAction; $ttImageData; $ttPassword; $ttUsername; $ttAttribs; $table; $ttPath; $ttFile)
C_POINTER:C301($2; $pReturn)
C_OBJECT:C1216($obCookieData; $oReturn; $enUserRec; $oStats; $esItems; $esUser; $tableInfo; $oReturnSessionObject; $enAccess)
C_BLOB:C604($obPacket)
C_BOOLEAN:C305($0)
C_DATE:C307($cut_off)
C_COLLECTION:C1488($coPublishedTables; $colTables; $coCustIDs)
C_DATE:C307($dDate)


SET BLOB SIZE:C606($obPacket; 0)


$ttCookie:=$1
$pReturn:=$2

//$obCookieData:=FPWeb_GetData ($ttCookie)
$obCookieData:=FPWeb_GetData($ttCookie)
If ($obCookieData=Null:C1517)
	$obCookieData:=New object:C1471
End if 

If (Not:C34(OB Is defined:C1231($obCookieData; "SessionObject")))  // If not defined
	$obCookieData.SessionObject:=New object:C1471
End if 
If (Not:C34(OB Is defined:C1231($obCookieData; "tableProperties")))  // If not defined
	$obCookieData.tableProperties:=New object:C1471
	$obCookieData.tableProperties.List:=API_Load_Tables
End if 
//$ttCookie:=FPWeb_SetData ($ttCookie;$obCookieData)

$coPublishedTables:=$obCookieData.tableProperties.List

$fIsLoggedIn:=FPWeb_IsLoggedIn($ttCookie)



$ttAction:=FPWeb_GetParameterByKey("Action")  // Designates new image

$oReturn:=New object:C1471("isLoggedIn"; $fIsLoggedIn)
$oReturn.errorText:=""
$oReturn.success:=True:C214

$0:=True:C214
Case of 
	: ($ttAction="GetSessionObject")
		$oReturn.SessionObject:=$obCookieData.SessionObject
		$ttImageData:=JSON Stringify:C1217($oReturn)
		TEXT TO BLOB:C554($ttImageData; $obPacket; UTF8 text without length:K22:17)
		
	: ($ttAction="doLogin")
		$ttUsername:=FPWeb_GetParameterByKey("Username")  // Designates new image
		$ttPassword:=FPWeb_GetParameterByKey("Password")  // Designates new image
		
		
		$obCookieData.SessionObject.userUUIDKey:=""
		$obCookieData.SessionObject.userRecord:=New object:C1471()
		
		$obCookieData.SessionObject.success:=False:C215
		
		$oReturn.errorText:="Invalid Email address or Password"
		$oReturn.success:=False:C215
		
		$enAccess:=Null:C1517
		
		//  $esUser:=ds.Customer_Portal_Extracts.query("(Username = :1) AND (Password = :2) AND (Active = True)";$ttUsername;$ttPassword)
		$esUser:=ds:C1482.Customer_Portal_Logins.query("(Username = :1) AND (Password = :2) AND (Active = True)"; $ttUsername; $ttPassword)
		If ($esUser.length>0)
			$enAccess:=$esUser.first().LOGINS_TO_EXTRACT
		End if 
		
		
		If ($enAccess#Null:C1517)
			If ($enAccess.Active)
				$oReturn.errorText:=""
				$oReturn.success:=True:C214
				
				$ttCookie:=FPWeb_SetLoggedIn($ttCookie; True:C214)
				//$obCookieData:=FPWeb_GetData ($ttCookie)
				$obCookieData.SessionObject.IsLoggedIn:=True:C214
				$obCookieData.SessionObject.userUUIDKey:=$enAccess.pk_id
				$obCookieData.SessionObject.userRecord:=$enAccess.toObject()
			End if 
		End if 
		
		
		$ttImageData:=JSON Stringify:C1217($oReturn)
		TEXT TO BLOB:C554($ttImageData; $obPacket; UTF8 text without length:K22:17)
		
		
	: ($ttAction="gotoCalloff")
		$ttProduct:=FPWeb_GetParameterByKey("ProductCode")  // Designates new image
		$xlOnHand:=Num:C11(FPWeb_GetParameterByKey("OnHand"))  // Designates new image
		$xlDay:=Day number:C114(Current date:C33(*))
		$ttDay:=("Sunday"*Num:C11($xlDay=Sunday:K10:19))+("Monday"*Num:C11($xlDay=Monday:K10:13))+("Tuesday"*Num:C11($xlDay=Tuesday:K10:14))+("Wednesday"*Num:C11($xlDay=Wednesday:K10:15))+("Thursday"*Num:C11($xlDay=Thursday:K10:16))+("Friday"*Num:C11($xlDay=Friday:K10:17))+("Saturday"*Num:C11($xlDay=Saturday:K10:18))
		
		$oReturn.callOffSubject:="Calloff on "+$ttProduct+" Requested"
		// Modified by: Mel Bohince (3/12/20) chg fmt below from "###,###,0" to "###,###,##0"
		$oReturn.callOffBody:="Need "+String:C10($xlOnHand; "###,###,##0")+" by "+$ttDay+", "+String:C10(Current date:C33(*)+7; System date short:K1:1)+" delivered to"
		
		$ttImageData:=JSON Stringify:C1217($oReturn)
		TEXT TO BLOB:C554($ttImageData; $obPacket; UTF8 text without length:K22:17)
		
		
	: ($ttAction="sendCallOffEmail")
		
		$ttSubject:=FPWeb_GetParameterByKey("subject")  // Designates new image
		$ttBody:=FPWeb_GetParameterByKey("body")  // Designates new image
		
		
		$ttRecepients:="arkay.portal@arkay.com"
		$ttFrom:="arkay.portal@arkay.com"
		$enUserRec:=ds:C1482.Customer_Portal_Extracts.get($obCookieData.SessionObject.userUUIDKey)
		If ($enUserRec#Null:C1517)
			If (Length:C16($enUserRec.Username)>0)
				$ttFrom:=$enUserRec.Username
				$ttRecepients:=$ttRecepients+","+$ttFrom
				
				$ttBody:=$ttBody+Char:C90(13)+Char:C90(13)+$enUserRec.Name+Char:C90(13)+$ttFrom
			End if 
		End if 
		
		// Send email now
		$ttError:=EMAIL_Sender($ttSubject; ""; $ttBody; $ttRecepients; ""; ""; $ttFrom)
		
		If (Length:C16($ttError)>0)
			$oReturn.errorText:=$ttError
			$oReturn.success:=False:C215
		End if 
		
		$ttImageData:=JSON Stringify:C1217($oReturn)
		TEXT TO BLOB:C554($ttImageData; $obPacket; UTF8 text without length:K22:17)
		
		
		
	: ($ttAction="logout")
		$obCookieData.SessionObject.userUUIDKey:=""
		$obCookieData.SessionObject.userRecord:=New object:C1471()
		$obCookieData.SessionObject.IsLoggedIn:=False:C215
		
		
		//$ttCookie:=FPWeb_SetData ($ttCookie;$obCookieData)
		$ttImageData:=JSON Stringify:C1217($oReturn)
		TEXT TO BLOB:C554($ttImageData; $obPacket; UTF8 text without length:K22:17)
		
		
		
	: ($ttAction="IsLoggedIn")
		$fIsLoggedIn:=OB Get:C1224($obCookieData.SessionObject; "IsLoggedIn"; Is boolean:K8:9)
		$oReturn:=New object:C1471("isLoggedIn"; $fIsLoggedIn)
		$ttImageData:=JSON Stringify:C1217($oReturn)
		TEXT TO BLOB:C554($ttImageData; $obPacket; UTF8 text without length:K22:17)
		
	: ($ttAction="GetVersion")
		$dDate:=Current date:C33(*)
		$ttImageData:=String:C10(Year of:C25($dDate); "0000")+String:C10(Month of:C24($dDate); "00")+String:C10(Day of:C23($dDate); "00")  // Set Default
		
		
		$ttPath:=Get 4D folder:C485(HTML Root folder:K5:20)+"Portal"+GetPlatformFileDelimiter
		ARRAY TEXT:C222($sttFiles; 0)
		DOCUMENT LIST:C474($ttPath; $sttFiles)
		For ($i; 1; Size of array:C274($sttFiles))
			$ttFile:=$sttFiles{$i}
			If ($ttFile="version_@")
				$ttImageData:=Replace string:C233($ttFile; "version_"; "")
			End if 
		End for 
		TEXT TO BLOB:C554($ttImageData; $obPacket; UTF8 text without length:K22:17)
		
		
	: (($ttAction="navproductcode") | ($ttAction="navproductline") | ($ttAction="navdescription") | ($ttAction="navcanship"))
		$colTables:=$coPublishedTables.query("tableName == :1"; "Portal_ItemMaster")
		If ($colTables.length=1)
			$tableInfo:=$colTables[0]
			$table:=$tableInfo.tableName
			$ttAttribs:=$tableInfo.fields.query("publish = :1"; True:C214).extract("fieldName").join(",")
		End if 
		
		$ttQuery:=FPWeb_GetParameterByKey("queryString")  // Designates new image
		$esItems:=ds:C1482.Portal_ItemMaster.newSelection()
		If ((OB Is defined:C1231($obCookieData.SessionObject; "userUUIDKey") & ($ttQuery#"")) | (OB Is defined:C1231($obCookieData.SessionObject; "userUUIDKey") & ($ttAction="navcanship")))  // If something to query
			$enUserRec:=ds:C1482.Customer_Portal_Extracts.get($obCookieData.SessionObject.userUUIDKey)
			If ($enUserRec#Null:C1517)
				
				$coCustIDs:=OB Get:C1224($enUserRec.Customers; "List"; Is collection:K8:32)
				If ($coCustIDs.length>0)
					
					If ($ttAction="navcanship")  //PJK-3/16/20 
						$esItems:=ds:C1482.Portal_ItemMaster.query("(AccessID = :1) AND (qty_onhand >= qty_open_order) AND (qty_onhand # 0)"; $enUserRec.pk_id)
					Else   //PJK-3/16/20 Changed so that the query uses ALL 3 fields
						$esItems:=ds:C1482.Portal_ItemMaster.query("(AccessID = :1) AND ((product_code = :2) OR (product_line = :2) OR (description = :2))"; $enUserRec.pk_id; wildcardSurround($ttQuery))
					End if 
					
					
					
					
					//Case of 
					//: ($ttAction="navproductcode")
					//$esItems:=ds.Portal_ItemMaster.query("(AccessID = :1) AND (product_code = :2)";$enUserRec.pk_id;wildcardSurround ($ttQuery))
					
					//: ($ttAction="navproductline")
					//$esItems:=ds.Portal_ItemMaster.query("(AccessID = :1) AND (product_line = :2)";$enUserRec.pk_id;wildcardSurround ($ttQuery))
					
					//: ($ttAction="navdescription")
					//$esItems:=ds.Portal_ItemMaster.query("(AccessID = :1) AND (description = :2)";$enUserRec.pk_id;wildcardSurround ($ttQuery))
					
					//: ($ttAction="navcanship")
					//$esItems:=ds.Portal_ItemMaster.query("(AccessID = :1) AND (qty_onhand >= qty_open_order) AND (qty_onhand # 0)";$enUserRec.pk_id)
					//End case 
					
					If ($esItems.length>0)
						$esItems:=$esItems.orderBy("product_code asc")
					End if 
					
				End if 
				
			End if 
		End if 
		
		$oStats:=New object:C1471("total"; $esItems.length; "offset"; 0; "limit"; $esItems.length; "length"; $esItems.length)
		
		$obResponse:=New object:C1471("stats"; $oStats; "data"; $esItems.toCollection())
		$ttImageData:=JSON Stringify:C1217($obResponse; *)
		WEB SEND TEXT:C677($ttImageData; "application/json")
		
		
		
		
		
		
	Else 
		$0:=False:C215
End case 

$ttCookie:=FPWeb_SetData($ttCookie; $obCookieData)

$pReturn->:=$obPacket

