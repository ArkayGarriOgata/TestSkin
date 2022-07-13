//%attributes = {}
//Method:  Cust_Name_ColorO(tName/tID)=>oNameColor
//Description:  This method returns the colors that can be used
//.  when coloring a customers name. Cust ID is "00###"

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tNameOrId)
	C_OBJECT:C1216($0; $oNameColor)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	C_OBJECT:C1216($oResult)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tNameOrId:=CorektBlank
	
	If ($nNumberOfParameters>=1)  //Parameters
		$tNameOrId:=$1
	End if   //Done parameters
	
	$oNameColor:=New object:C1471()
	$oResult:=New object:C1471()
	
End if   //Done initialize

Case of   //Parameters
		
	: ($nNumberOfParameters=0)
		
		C_COLLECTION:C1488($cNameColor)
		C_COLLECTION:C1488(CustcNameColor)
		
		C_OBJECT:C1216($esCustomer)
		
		$cNameColor:=New collection:C1472()
		CustcNameColor:=New collection:C1472()
		
		$esCustomer:=New object:C1471()
		
		$cNameColor.push("ID")
		$cNameColor.push("Name")
		$cNameColor.push("ColorForeground")
		$cNameColor.push("ColorBackground")
		
		$esCustomer:=ds:C1482.Customers.query("ColorForeground > 0 or ColorBackground > 0")
		
		CustcNameColor:=$esCustomer.toCollection($cNameColor)
		
	: ($nNumberOfParameters=1)
		
		If (CustcNameColor=Null:C1517)  //Undefined
			
			$oResult:=Cust_Name_ColorO
			
		End if   //Done undefined
		
		If (Num:C11($tNameOrId)=0)  //Name
			
			$cColor:=CustcNameColor.query("Name = :1"; $tNameOrID)
			
		Else   //Id
			
			$cColor:=CustcNameColor.query("ID = :1"; $tNameOrID)
			
		End if   //Done name
		
		If ($cColor.length=1)  //Unique
			
			$oNameColor.nForeground:=$cColor[0].ColorForeground
			$oNameColor.nBackground:=$cColor[0].ColorBackground
			
			$oNameColor.tForeground:=Core_Color_DecToHexT($cColor[0].ColorForeground)
			$oNameColor.tBackground:=Core_Color_DecToHexT($cColor[0].ColorBackground)
			
		Else   //Default
			
			$oNameColor.nForeground:=Foreground color:K23:1
			$oNameColor.nBackground:=Background color:K23:2
			
			$oNameColor.tForeground:=Core_Color_DecToHexT(Black:K11:16)
			$oNameColor.tBackground:=Core_Color_DecToHexT(White:K11:1)
			
		End if   //Done unique
		
End case   //Done parameters

$0:=$oNameColor