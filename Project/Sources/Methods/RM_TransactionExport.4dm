//%attributes = {}
// -------
// Method: RM_TransactionExport   ( ) ->
// By: Mel Bohince @ 07/12/17, 09:14:16
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (8/31/17) set begin and end if in arg list, duh

C_DATE:C307(dDateEnd; dDateBegin; $1; $2)
C_LONGINT:C283($i; $numElements)
C_TEXT:C284($title; $text; $docName)
C_TIME:C306($docRef)

READ ONLY:C145([Raw_Materials_Transactions:23])

If (Count parameters:C259=3)
	dDateBegin:=$1
	dDateEnd:=$2
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDateBegin; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=dDateEnd)
	$distributionList:=$3
Else 
	qryByDateRange(->[Raw_Materials_Transactions:23]XferDate:3)
End if 

$numElements:=Records in selection:C76([Raw_Materials_Transactions:23])


$title:="RM TRANSACTIONS Between "+String:C10(dDateBegin; Internal date short special:K1:4)+" and "+String:C10(dDateEnd; Internal date short special:K1:4)
$text:="Date,Type,CommodityKey,RawMatlCode,POitem,JobForm,Qty,ExtCost,CommodityCode,Tag/Recvr\r"
$docName:="RM_TRANSACTIONS_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $title+"\r\r")
	
	
	If ($numElements>0)
		SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $aDate; [Raw_Materials_Transactions:23]Xfer_Type:2; $aType; [Raw_Materials_Transactions:23]Commodity_Key:22; $aComKey; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; $aRM; [Raw_Materials_Transactions:23]POItemKey:4; $aPO; [Raw_Materials_Transactions:23]JobForm:12; $aJF; [Raw_Materials_Transactions:23]Qty:6; $aQty; [Raw_Materials_Transactions:23]ActExtCost:10; $aCost; [Raw_Materials_Transactions:23]CommodityCode:24; $aComm; [Raw_Materials_Transactions:23]ReceivingNum:23; $aTagNo)
		MULTI SORT ARRAY:C718($aDate; >; $aComKey; >; $aRM; >; $aType; >; $aPO; $aJF; $aQty; $aCost; $aComm; $aTagNo)
		
		$numElements:=Size of array:C274($aDate)
		
		uThermoInit($numElements; "Exporting RM Transactions")
		For ($i; 1; $numElements)
			$text:=$text+String:C10($aDate{$i}; Internal date short special:K1:4)+","+$aType{$i}+","+$aComKey{$i}+","+$aRM{$i}+","+$aPO{$i}+","+$aJF{$i}+","+String:C10($aQty{$i})+","+String:C10(Round:C94($aCost{$i}; 0))+","+String:C10($aComm{$i})+","+String:C10($aTagNo{$i})+"\r"
			uThermoUpdate($i)
		End for 
		uThermoClose
		
	Else 
		$text:="No Transactions found in that date range."
	End if 
	
	SEND PACKET:C103($docRef; $text)
	SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	If (Count parameters:C259=0)
		$err:=util_Launch_External_App($docName)
	Else   //send email
		EMAIL_Sender("RM Transactions "+fYYMMDD(Current date:C33); ""; "Open attached with Excel"; $distributionList; $docName)
		util_deleteDocument($docName)
	End if 
	
End if 

REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
