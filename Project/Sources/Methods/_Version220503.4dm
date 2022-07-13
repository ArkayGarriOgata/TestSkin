//%attributes = {}
// ----------------------------------------------------
// Method: _version2203XX
// By: Garri Ogata
// Description:  This method change [Addresses] records by 
//   modifying Country and adding road mileage
//
// ----------------------------------------------------

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bSave)
	C_OBJECT:C1216($esAddress; $eAddress)
	
	$esAddress:=New object:C1471()
	$eAddress:=New object:C1471()
	
End if   //Done initialize

$esAddress:=ds:C1482.Addresses.all()

For each ($eAddress; $esAddress)  //Address
	
	$bSave:=True:C214
	
	Case of   //Country
			
		: (Length:C16($eAddress.Country)=1)
			
			$eAddress.Country:=CorektBlank
			
		: ($eAddress.Country="Corp")
			
			$eAddress.Country:=CorektBlank
			
		: ($eAddress.Country="@France@")
			
			$eAddress.Country:="FR"
			
		: (($eAddress.Country="Espana") | ($eAddress.Country="Spain"))
			
			$eAddress.Country:="SP"
			
		: ($eAddress.Country="Greece")
			
			$eAddress.Country:="GR"
			
		: ($eAddress.Country="Hong Kong")
			
			$eAddress.Country:="HK"
			
		: ($eAddress.Country="@Japan@")
			
			$eAddress.Country:="JP"
			
		: (($eAddress.Country="@Korea@") | ($eAddress.Country="SOUTH KOREEA"))
			
			$eAddress.Country:="KR"
			
		: ($eAddress.Country="@Mexico@")
			
			$eAddress.Country:="MX"
			
		: ($eAddress.Country="M.21")
			
			$eAddress.Country:=CorektBlank
			
		: ($eAddress.Country="Netherlands")
			
			$eAddress.Country:="NL"
			
		: ($eAddress.Country="New Zealand")
			
			$eAddress.Country:="NZ"
			
		: ($eAddress.Country="@china@")
			
			$eAddress.Country:="CN"
			
		: ($eAddress.Country="Philippines")
			
			$eAddress.Country:="PH"
			
		: ($eAddress.Country="Poland")
			
			$eAddress.Country:="PL"
			
		: ($eAddress.Country="Singapore")
			
			$eAddress.Country:="SG"
			
		: ($eAddress.Country="@Africa@")
			
			$eAddress.Country:="ZA"
			
		: ($eAddress.Country="Suffolk")
			
			$eAddress.Country:="GB"
			
		: ($eAddress.Country="Sweden")
			
			$eAddress.Country:="SE"
			
		: ($eAddress.Country="@TAIWAN@")
			
			$eAddress.Country:="TW"
			
		: ($eAddress.Country="@Thailand@")
			
			$eAddress.Country:="TH"
			
		Else 
			
			$bSave:=False:C215
			
	End case   //Done country
	
	If ($bSave)  //Save
		
		$oResult:=$eAddress.save()
		
	End if   //Done save
	
End for each   //Done address

ALERT:C41("Done changing addresses")

