//%attributes = {}
//Method:  RMTr_Quik_Query
//Description:  This method gets executed for the ReceiptIssued report.
//   It helps find the correct receipt record based on all isssued board in 
//   a given time period

If (True:C214)  //Initialize
	
	C_TEXT:C284($tOmitDates)
	C_TEXT:C284($tOmitDate)
	
	ARRAY TEXT:C222($atQueryPOItemKey; 0)
	
	ARRAY TEXT:C222($atOmitDate; 0)
	
	C_OBJECT:C1216($oAsk)
	
	$oAsk:=New object:C1471()
	
	$oAsk.tMessage:="Enter dates to omit separated by commas."
	
	$oAsk.tDefault:="Omit"
	$oAsk.tCancel:="Continue"
	
	$tOmitDates:=CorektBlank
	$tOmitDate:=CorektBlank
	
End if   //Done initialize

DISTINCT VALUES:C339([Raw_Materials_Transactions:23]POItemKey:4; $atQueryPOItemKey)

QUERY WITH ARRAY:C644([Raw_Materials_Transactions:23]POItemKey:4; $atQueryPOItemKey)

If (Core_Dialog_RequestN($oAsk; ->$tOmitDates)=CoreknDefault)  //Omit
	
	Core_Text_ParseToArray($tOmitDates; ->$atOmitDate; CorektComma)
	
	For ($nOmitDate; 1; Size of array:C274($atOmitDate))  //OmitDate
		
		$tOmitDate:=$atOmitDate{$nOmitDate}
		
		QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3#$tOmitDate)
		
	End for   //Done omit date
	
End if   //Done omit
