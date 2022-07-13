//%attributes = {}
//Method:  UrWk_GetLocationT=>tArkayLocation
//Description:  This method returns the Arkay location the 
//  user is currently connected to.
//   This needs to be updated and verified with IT see document 900-707 aMs Mac Server
//   See 4d Forums: https://discuss.4d.com/t/get-system-info-compared-to-it-mytcpaddr/21504
//   Edgar Hammond sample code on how $oSystemInfo was parsed.
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_TEXT:C284($0; $tArkayLocation)
	
	C_COLLECTION:C1488($cIPAddress; $cNetwork; $cNetworkAddress)
	
	C_OBJECT:C1216($oSystemInfo)
	
	C_TEXT:C284($tIPAddress; $tNetwork)
	
	$tArkayLocation:=CorektBlank
	
	$cIPAddress:=New collection:C1472()
	$cNetwork:=New collection:C1472()
	$cNetworkAddress:=New collection:C1472()
	
	$oSystemInfo:=Get system info:C1571
	
	$tIPAddress:=$tIPAddress
	$tNetwork:=CorektBlank
	
End if   //Done initialize

Case of   //Network type
		
	: ($oSystemInfo.networkInterfaces=Null:C1517)
		
	: (($oSystemInfo.networkInterfaces.query("type = :1"; "ethernet")).length=1)  //Ethernet
		
		$tNetwork:="ethernet"
		$tIPType:="IPv4"
		
	: (($oSystemInfo.networkInterfaces.query("type = :1"; "wifi")).length=1)  //WiFi
		
		$tNetwork:="IPv6"  //Verify this is correct
		
	Else   //Not supported
		
		$tNetwork:=CorektBlank
		
End case   //Done Network type

C_OBJECT:C1216($arkayFacilityIPs_o)
$arkayFacilityIPs_o:=New object:C1471
$arkayFacilityIPs_o["192.168.1."]:="HauppaugeOffice"
$arkayFacilityIPs_o["192.168.2."]:="HauppaugeImaging"
$arkayFacilityIPs_o["192.168.3."]:="RoanokeOffice"
$arkayFacilityIPs_o["192.168.4."]:="RoanokePlant"
$arkayFacilityIPs_o["192.168.1."]:="RoanokeImaging"
$arkayFacilityIPs_o["192.168.6."]:="RocWarehouse"
$arkayFacilityIPs_o["remote"]:="VPN"

//tests
$tIPAddress:="192.168.3."  //IT_MyTCPAddr($tIPAddress;$tSubmask)
$tArkayLocation:=$arkayFacilityIPs_o[$tIPAddress]
ALERT:C41("you are at "+$tArkayLocation+" with an ip of "+$tIPAddress)

$err:=IT_MyTCPAddr($tIPAddress; $tSubmask)
$tArkayLocation:=$arkayFacilityIPs_o[$tIPAddress]
If (Length:C16($tArkayLocation)=0)
	$tArkayLocation:="remote"
End if 
ALERT:C41("you are at "+$tArkayLocation+" with an ip of "+$tIPAddress)

If ($tNetwork#CorektBlank)  //Network
	
	$cNetwork:=$oSystemInfo.networkInterfaces.query("type = :1"; $tNetwork)
	
	If ($cNetwork.length=1)  //Address
		
		$cNetworkAddress:=$cNetwork[0].ipAddresses
		$cIPAddress:=$cNetworkAddress.query("type = :1"; $tIPType)
		
		If ($cIPAddress#Null:C1517)  //IP
			
			$tIPAddress:=$cIPAddress[0].ip
			
			Case of   //Location
					
				: ((Position:C15("192.168.1."; $tIPAddress)>0) | (Position:C15("192.168.2."; $tIPAddress)>0))  //192.168.1.###. 1 is Hauppauge office and 192.168.2.###.  2 is Hauppauge Imaging subnet
					
					$tArkayLocation:=ArkyktLctnHauppauge
					
				: ((Position:C15("192.168.3."; $tIPAddress)>0) | (Position:C15("192.168.4."; $tIPAddress)>0))  //192.168.3.###. 3 is Roanoke and 192.168.4.###.  4 is Roanoke Imaging subnet
					
					$tArkayLocation:=ArkyktLctnRoanoke
					
				: (Position:C15("192.168.6."; $tIPAddress)>0)  //192.168.6.###.  6 is shipping(Vista)
					
					$tArkayLocation:=ArkyktLctnWarehouse
					
				: ((Position:C15("192.168.0."; $tIPAddress)>0) | (Position:C15("192.168.5."; $tIPAddress)>0))  //192.168.0.###. 0 is remote user and 192.168.5.###.  5 is not used and is open
					
					$tArkayLocation:=ArkyktLctnRemote
					
			End case   //Done location
			
		End if   //Done ip
		
	End if   //Done address
	
End if   //Done network

$0:=$tArkayLocation
