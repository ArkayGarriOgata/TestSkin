//%attributes = {}
//Method:  Core_PlugIn_GetNameT(vPlugIn)=>tPlugIn
//Description:  This method returns the name or number of a PlugIn

If (True:C214)  //Initialize
	
	C_VARIANT:C1683($1; $vPlugIn)
	C_TEXT:C284($0; $tPlugIn)
	
	$vPlugIn:=$1
	
	$tPlugIn:=CorektBlank
	$nPlugIn:=CoreknNoMatchFound
	
	If (Value type:C1509($vPlugIn)=Is text:K8:3)  //Set value
		
		$tPlugIn:=$vPlugIn
		
	Else   //
		
		$nPlugIn:=$vPlugIn
		
	End if   //Done set value
	
End if   //Done initialize

Case of   //Return
		
	: ($nPlugIn=4D Client SOAP license:K44:7)
		
		$tPlugIn:="4DClientSOAPlicense"
		
	: ($nPlugIn=4D Client Web license:K44:6)
		
		$tPlugIn:="4DClientWeblicense"
		
	: ($nPlugIn=4D for OCI license:K44:5)
		
		$tPlugIn:="4DforOCIlicense"
		
	: ($nPlugIn=4D ODBC Pro license:K44:9)
		
		$tPlugIn:="4DODBCProlicense"
		
	: ($nPlugIn=4D REST Test license:K44:22)
		
		$tPlugIn:="4DRESTTestlicense"
		
	: ($nPlugIn=4D SOAP license:K44:8)
		
		$tPlugIn:="4DSOAPlicense"
		
	: ($nPlugIn=4D View license:K44:4)
		
		$tPlugIn:="4DViewlicense"
		
	: ($nPlugIn=4D Web license:K44:3)
		
		$tPlugIn:="4DWeblicense"
		
	: ($nPlugIn=4D Write license:K44:2)
		
		$tPlugIn:="4DWritelicense"
		
	: ($tPlugIn="4DClientSOAPlicense")
		
		$tPlugIn:=String:C10(4D Client SOAP license:K44:7)
		
	: ($tPlugIn="4DClientWeblicense")
		
		$tPlugIn:=String:C10(4D Client Web license:K44:6)
		
	: ($tPlugIn="4DforOCIlicense")
		
		$tPlugIn:=String:C10(4D for OCI license:K44:5)
		
	: ($tPlugIn="4DODBCProlicense")
		
		$tPlugIn:=String:C10(4D ODBC Pro license:K44:9)
		
	: ($tPlugIn="4DRESTTestlicense")
		
		$tPlugIn:=String:C10(4D REST Test license:K44:22)
		
	: ($tPlugIn="4DSOAPlicense")
		
		$tPlugIn:=String:C10(4D SOAP license:K44:8)
		
	: ($tPlugIn="4DViewlicense")
		
		$tPlugIn:=String:C10(4D View license:K44:4)
		
	: ($tPlugIn="4DWeblicense")
		
		$tPlugIn:=String:C10(4D Web license:K44:3)
		
	: ($tPlugIn="4DWritelicense")
		
		$tPlugIn:=String:C10(4D Write license:K44:2)
		
End case   //Done return

$0:=$tPlugIn

