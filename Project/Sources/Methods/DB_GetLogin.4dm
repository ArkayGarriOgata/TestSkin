//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/09/08, 13:57:53
// ----------------------------------------------------
// Method: DB_GetLogin
// ----------------------------------------------------

C_TEXT:C284($1; $0)
C_TEXT:C284(<>ttWMS_CONFIG_MySQL; <>ttWMS_CONFIG_4D; <>WMS_ALT_LABELS; $ttConfigText)
C_BOOLEAN:C305(<>fWMS_Use4D)

If (<>fWMS_Use4D)  //v1.0.3-PJK (6/23/16)
	$ttConfigText:=<>ttWMS_CONFIG_4D  //v1.0.3-PJK (6/23/16)
Else   //v1.0.3-PJK (6/23/16)
	$ttConfigText:=<>ttWMS_CONFIG_MySQL  //v1.0.3-PJK (6/23/16)
End if   //v1.0.3-PJK (6/23/16)

Case of 
	: (Count parameters:C259=0)
		
		//fetch the config from DBA screen's field
		If (Length:C16(<>ttWMS_CONFIG_MySQL)=0)
			READ ONLY:C145([zz_control:1])
			ALL RECORDS:C47([zz_control:1])
			
			<>fWMS_Use4D:=[zz_control:1]wms_connection_Use4D:66
			<>ttWMS_CONFIG_4D:=[zz_control:1]wms_connection_4D:65
			<>ttWMS_CONFIG_MySQL:=[zz_control:1]wms_connection_mysql:58
			<>ttWMS_4D_URL:=[zz_control:1]wms_4D_url:67
			<>WMS_ALT_LABELS:=[zz_control:1]wms_alternateLabel:59
		End if 
		
		If (<>fWMS_Use4D)
			$0:=<>ttWMS_CONFIG_4D
		Else 
			$0:=<>ttWMS_CONFIG_MySQL
		End if 
		
	: ($1="user")
		$colon:=Position:C15(":"; $ttConfigText)
		$0:=Substring:C12($ttConfigText; 1; ($colon-1))
		
		
	: ($1="password")
		$colon:=Position:C15(":"; $ttConfigText)
		$atSign:=Position:C15(Char:C90(At sign:K15:46); $ttConfigText)
		$0:=Substring:C12($ttConfigText; ($colon+1); ($atSign-$colon-1))
		
	: ($1="hostname")
		$atSign:=Position:C15(Char:C90(At sign:K15:46); $ttConfigText)
		$uri:=Substring:C12($ttConfigText; ($atSign+1))
		$colon:=Position:C15(":"; $uri)
		$0:=Substring:C12($uri; 1; ($colon-1))
		
	: ($1="port")
		$atSign:=Position:C15(Char:C90(At sign:K15:46); $ttConfigText)
		$uri:=Substring:C12($ttConfigText; ($atSign+1))
		$colon:=Position:C15(":"; $uri)
		$slash:=Position:C15("/"; $uri)
		$0:=Substring:C12($uri; ($colon+1); ($slash-$colon-1))
		
	: ($1="database")
		$slash:=Position:C15("/"; $ttConfigText)
		$0:=Substring:C12($ttConfigText; ($slash+1))
		
	Else 
		BEEP:C151
End case 


If (False:C215)  // Modified by: Mel Bohince (6/23/16) 
	//C_TEXT($1;$0)
	
	//Case of 
	//: (Count parameters=0)
	
	//  //fetch the config from DBA screen's field
	//C_TEXT(<>ttWMS_CONFIG_MySQL;<>WMS_ALT_LABELS)
	//If (Length(<>ttWMS_CONFIG_MySQL)=0)
	//READ ONLY([zz_control])
	//ALL RECORDS([zz_control])
	//<>ttWMS_CONFIG_MySQL:=[zz_control]wms_connection_mysql  //"mel:1147@roanokeams.arkay.com:3306/wms"
	//<>WMS_ALT_LABELS:=[zz_control]wms_alternateLabel  //00125 and any other cust using an alternate label
	//End if 
	
	//$0:=<>ttWMS_CONFIG_MySQL
	
	//: ($1="user")
	//$colon:=Position(":";<>ttWMS_CONFIG_MySQL)
	//$0:=Substring(<>ttWMS_CONFIG_MySQL;1;($colon-1))
	
	
	//: ($1="password")
	//$colon:=Position(":";<>ttWMS_CONFIG_MySQL)
	//$atSign:=Position(Char(At sign);<>ttWMS_CONFIG_MySQL)
	//$0:=Substring(<>ttWMS_CONFIG_MySQL;($colon+1);($atSign-$colon-1))
	
	//: ($1="hostname")
	//$atSign:=Position(Char(At sign);<>ttWMS_CONFIG_MySQL)
	//$uri:=Substring(<>ttWMS_CONFIG_MySQL;($atSign+1))
	//$colon:=Position(":";$uri)
	//$0:=Substring($uri;1;($colon-1))
	
	//: ($1="port")
	//$atSign:=Position(Char(At sign);<>ttWMS_CONFIG_MySQL)
	//$atSign:=Position(Char(At sign);<>ttWMS_CONFIG_MySQL)
	//$uri:=Substring(<>ttWMS_CONFIG_MySQL;($atSign+1))
	//$colon:=Position(":";$uri)
	//$slash:=Position("/";$uri)
	//$0:=Substring($uri;($colon+1);($slash-$colon-1))
	
	//: ($1="database")
	//$slash:=Position("/";<>ttWMS_CONFIG_MySQL)
	//$0:=Substring(<>ttWMS_CONFIG_MySQL;($slash+1))
	
	//Else 
	//BEEP
	//End case 
	
End if   //false  // Modified by: Mel Bohince (6/23/16) 