//%attributes = {}
//Method:  Tgsn_PrGb_CreatePipedInvoiceT(nInvoiceNumber)=>tPipedInvoice
//Description:  This method will create the piped invoice information for TgsnoInvoice
//. It also sets the Filename for the object as well.

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nInvoiceNumber)
	C_TEXT:C284($0; $tPipedInvoice)
	
	C_TEXT:C284($tProperty)
	
	$nInvoiceNumber:=$1
	
	$tPipedInvoice:=CorektBlank
	
	Tgsn_Data_Column  //Creates TgsnoColumn
	
End if   //Done Initialize

Tgsn_PrGb_Mandatory($nInvoiceNumber)  //Set Tungsten mandated mandatory columns

Tgsn_PrGb_ArkayOptional($nInvoiceNumber)  //Set Arkay optional columns

For each ($tProperty; TgsnoColumn)  //Loop thru properties
	
	$tPipedInvoice:=$tPipedInvoice+TgsnoColumn[$tProperty]+CorektPipe
	
End for each   //Done looping thru properties

Tgsn_Save($tPipedInvoice)

$0:=$tPipedInvoice