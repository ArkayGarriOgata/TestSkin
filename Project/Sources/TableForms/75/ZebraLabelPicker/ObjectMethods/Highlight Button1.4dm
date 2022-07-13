//OM: bOk() -> 
//@author mlb - 11/6/01  13:42
//110905 mlb revise to ip print
// new case Modified by: Mel Bohince (6/11/13)
// Modified by: Mel Bohince (2/4/14) Loreal spl promo requirements, repurpose mh10.8
// Added by: Garri Ogata (1/25/21) Arkay case id labels for Revlon

C_LONGINT:C283($port; $error; $mode; $state)
C_LONGINT:C283($tcp_ID; $error)
C_TEXT:C284($tcp_ipAddress; $buffer)
$buffer:=""

C_OBJECT:C1216($oCase)
$oCase:=New object:C1471()

If (Labl_nArkayCaseID=1)  //Allows them to just print case id labels
	//This happens at beginning when labels have already been created for Revlon
	//or when there is a need for case labels because some got lost or damaged.
	
	C_OBJECT:C1216($oCase)
	
	$oCase:=New object:C1471()
	
	$oCase.tJobNumber:=sJMI
	$oCase.nHowMany:=iCnt  //Number of case labels to print
	$oCase.nCaseQuantity:=wmsCaseQty  //Number of boxes in the case
	
	Zebra_CaseId_Revlon($oCase)
	
Else   //Do normal labels
	
	If (bSendToWMS=1)
		wms_api_SendJobits
	End if 
	
	//open connection to printer or output stream
	Case of 
		: (rb1=1)  //to serial port
			SET CHANNEL:C77(21; 29706)
			zebraPrint:=False:C215
		: (rb2=1)  //to file
			docName:=sJMI+".zpl"
			util_deleteDocument(util_DocumentPath("get")+docName)
			docRef:=util_putFileName(->docName)
			//SET CHANNEL(10;sJMI+".zpl")  //String(TSTimeStamp )
			zebraPrint:=False:C215
		: (rb3=1)  //to ip address
			zebraPrint:=Zebra_SetUp(0; tcpAddress; tcpPort; sCriterion1; sCriterion2; sCriterion3)
			$mode:=0  //Synchronous
			$error:=TCP_Open(tcpAddress; tcpPort; tcpID; $mode)
			If ($error#0)
				uConfirm("Error: "+String:C10($error)+" on TCP_Open"; "huh?"; "Help")
			End if 
	End case 
	
	//$i:=Current form page
	
	
	//set label format
	Case of 
		: (labelStyle="MH10.8")
			If (sCustId="00765")  //L’Oréal
				sPO:=Replace string:C233(sPO; "PO# "; "")  // Modified by: Mel Bohince (2/4/14) Loreal spl promo requirements, repurpose mh10.8
				$buffer:=Zebra_Style_MH10_Loreal
			Else 
				$buffer:=Zebra_Style_MH10
			End if 
			//$buffer:=Zebra_Style_Lauder_SAP_Lot   // new case Modified by: Mel Bohince (6/11/13)
			
			//: (labelStyle="Old Landscape")
			//$buffer:=Zebra_Style_Landscape 
			//
			//: (labelStyle="Old Lauder")
			//$buffer:=Zebra_Style_Lauder 
			
		: (labelStyle="p&g")
			$buffer:=Zebra_Style_PnG
			
		: (labelStyle="Arkay")
			$buffer:=Zebra_Style_Arkay
			
		: (labelStyle="Lauder")
			$buffer:=Zebra_Style_Lauder08012000  //` (labelStyle="mki") `Zebra_Style_MaryKay 
			
		: (labelStyle="Custom")
			If (Length:C16(sDesc)>0)
				$buffer:=Zebra_Style_Custom
			Else 
				Case of 
					: (rb1=1)  //to serial port
						
					: (rb2=1)  //to file
						CLOSE DOCUMENT:C267(docRef)
						//SET CHANNEL(11)
					: (rb3=1)  //to ip address
						$error:=TCP_Close(tcpID)
						If ($error#0)
							ALERT:C41("Error: "+String:C10($error)+" on TCP_Close")
						End if 
				End case 
				REJECT:C38
			End if 
			
		: (labelStyle="L’Oréal") | (labelStyle="loreal") | (labelStyle="l'oreal")
			$buffer:=Zebra_Style_LOreal
			
		: (labelStyle="Skid Labels")
			$buffer:=Zebra_Style_Skid_SSCC
			
		: (labelStyle="ShsdoChntcl")
			$buffer:=Zebra_Style_Shiseido
			
		: (labelStyle="ELC-v4")
			$buffer:=Zebra_Style_ELCv4
			
		: (labelStyle="Revlon")
			$buffer:=Zebra_Style_Revlon
			
		: (labelStyle="LVMH")
			$buffer:=Zebra_Style_LVMH
			
		: (labelStyle="Nest")
			$buffer:=Zebra_Style_Nest
	End case 
	
	//send label format
	Case of 
		: (Length:C16($buffer)=0)
			
		: (rb1=1)  //to serial port
			SEND PACKET:C103($buffer)
		: (rb2=1)  //to file
			SEND PACKET:C103(docRef; $buffer)
			$buffer:=""
		: (rb3=1)  //to ip address
			$error:=TCP_Send(tcpID; $buffer)
			If ($error#0)
				ALERT:C41("Error: "+String:C10($error)+" on TCP_Send")
			End if 
			$buffer:=""
	End case 
	
	//generate labels
	Case of 
		: (wmsCaseQty>0)
			wmsCaseQtyString:=String:C10(wmsCaseQty)
		: (wmsCaseQty=0)
			wmsCaseQtyString:=""
		Else   //the barcode is likely messed up
			wmsCaseQtyString:="PARTIAL"
	End case 
	
	//save counter info before it gets mangled by the printing
	If (labelStyle#"Skid Labels")
		$error:=Zebra_CaseNumberManager("update"; sJMI; wmsCaseNumber1; iCnt)
	End if 
	
	Case of 
		: (labelStyle="MH10.8")
			//$buffer:=Zebra_Print_MH10 // Modified by: Mel Bohince (2/4/14) Loreal spl promo requirements, repurpose mh10.8
			If (sCustId="00765")  // Modified by: Mel Bohince (2/4/14) Loreal spl promo requirements, repurpose mh10.8
				Zebra_ArkayBarcodePrint(9)
			Else 
				Zebra_ArkayBarcodePrint(1)  // new case 7, was 1 Modified by: Mel Bohince (6/11/13) back to 1
			End if 
			
		: (labelStyle="Old Landscape")
			$buffer:=Zebra_Print_Landscape
			
		: (labelStyle="Old Lauder")
			$buffer:=Zebra_Print_Lauder
			
		: (labelStyle="p&g")
			//$buffer:=Zebra_Print_PnG 
			Zebra_ArkayBarcodePrint(4)
			
		: (labelStyle="Arkay")
			Zebra_ArkayBarcodePrint(5)
			
		: (labelStyle="Lauder")
			Zebra_ArkayBarcodePrint(6)
			
		: (labelStyle="Custom")
			//$buffer:=Zebra_Print_Custom
			
		: (labelStyle="L’Oréal") | (labelStyle="loreal") | (labelStyle="l'oreal")
			Zebra_ArkayBarcodePrint(8)
			
		: (labelStyle="Skid Labels")
			Zebra_Print_Skid_SSCC
			
		: (labelStyle="ShsdoChntcl")
			Zebra_ArkayBarcodePrint(10)
			
		: (labelStyle="ELC-v4")
			Zebra_ArkayBarcodePrint(11)
			
		: (labelStyle="Revlon")
			Zebra_ArkayBarcodePrint(12)
			
		: (labelStyle="LVMH")
			Zebra_ArkayBarcodePrint(13)
			
		: (labelStyle="Nest")
			Zebra_ArkayBarcodePrint(14)
	End case 
	
	
	//send label data
	Case of 
		: (Length:C16($buffer)=0)
			//already sent
		: (rb1=1)  //to serial port
			SEND PACKET:C103($buffer)
		: (rb2=1)  //to file
			SEND PACKET:C103(docRef; $buffer)
		: (rb3=1)  //to ip address
			$error:=TCP_Send(tcpID; $buffer)
			If ($error#0)
				ALERT:C41("Error: "+String:C10($error)+" on TCP_Send")
			End if 
	End case 
	
	//close connection
	Case of 
		: (rb1=1)  //to serial port
			
		: (rb2=1)  //to file
			CLOSE DOCUMENT:C267(docRef)
			//SET CHANNEL(11)
		: (rb3=1)  //to ip address
			$error:=TCP_Close(tcpID)
			If ($error#0)
				ALERT:C41("Error: "+String:C10($error)+" on TCP_Close")
			End if 
	End case 
	
	Case of   //Additional Labels 
			
		: (labelStyle="Revlon")
			
			C_OBJECT:C1216($oCase)
			
			$oCase:=New object:C1471()
			
			$oCase.tJobNumber:=sJMI
			
			//iCnt should always be a multitude of 2
			
			iCnt:=Choose:C955(Mod:C98(iCnt; 2)=0; \
				iCnt; \
				iCnt+1)
			
			$oCase.nHowMany:=iCnt/2
			$oCase.nCaseQuantity:=wmsCaseQty
			
			Zebra_CaseId_Revlon($oCase)
			
	End case   //Done additional labels
	
End if   //Done just do revlon case labels
