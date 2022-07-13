//%attributes = {}
//Method: Core_Vrsn_VerifyB=bVersionVerified
//Description: This method will verify that the users OS and RAM
//. meet minimal recommendations for 4D server being run
//. It uses the table [Core_Version]

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bVersionVerified)
	
	C_OBJECT:C1216($oSystemInfo)
	C_OBJECT:C1216($enVersion)
	
	$oSystemInfo:=New object:C1471()
	$oSystemInfo:=Get system info:C1571
	
	$tMacOSNumber:=Core_Vrsn_GetNumberT(Windows:K25:3; "Microsoft Windows 10 Pro 1809 (17763.253)")
	
	$bVersionVerified:=False:C215
	
	$enVersion:=New object:C1471()
	$enVersion:=ds:C1482.Core_Version.all().first()
	
End if   //Done initialize

Case of   //Verify
		
	: ($enVersion=Null:C1517)  //Not implemented
		
		$bVersionVerified:=True:C214
		
	: ($enVersion.IgnoreCheck)  //Force OK
		
		$bVersionVerified:=True:C214
		
	: (Is macOS:C1572)  //Mac
		
		$tMacOSNumber:=Core_Vrsn_GetNumberT(Mac OS:K25:2; $oSystemInfo.osVersion)
		
		Case of   //Verify
				
			: (Not:C34(($enVersion.MacOSMin>=$tMacOSNumber) & ($tMacOSNumber<=$enVersion.MacOSMax)))  //OS range
			: (($oSystemInfo.physicalMemory/1000000)<$enVersion.MacRAMRecommend)  //Memory
				
			Else   //Verified
				
				$bVersionVerified:=True:C214
				
		End case   //Done verify
		
	: (Is Windows:C1573)  //Windows "Microsoft Windows 10 Pro 1809 (17763.253)"
		
		$tWinOSNumber:=Core_Vrsn_GetNumberT(Windows:K25:3; $oSystemInfo.osVersion)
		
		Case of   //Verify
				
			: (Not:C34(($enVersion.WinOSMin<=$tWinOSNumber) & ($tWinOSNumber<=$enVersion.WinOSMax)))  //OS range
			: (($oSystemInfo.physicalMemory/1000000)<$enVersion.WinRAMRecommend)  //Memory
				
			Else   //Verified
				
				$bVersionVerified:=True:C214
				
		End case   //Done verify
		
	Else   //Other platform
		
		//Decide what to do here
		
End case   //Done verify

$0:=$bVersionVerified