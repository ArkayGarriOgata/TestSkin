//%attributes = {}
//Method:  Quik_List_Report (oQuickReport;lQuickReport)
//Description:  This method will  

If (True:C214)  //Initialize 
	
	C_OBJECT:C1216($1; $oQuickReport)
	C_BLOB:C604($2; $lQuikReport)
	
	C_LONGINT:C283($nQuickReportArea)
	C_TEXT:C284($tPathDesktop)
	C_TEXT:C284($tPathHTMLReport)
	C_TEXT:C284($tPathHTMLTemplate)
	
	$oQuickReport:=New object:C1471()
	
	$oQuickReport:=$1
	$lQuikReport:=$2
	
	$nParentTable:=0
	$tDocumentName:="MyReport"
	
	If (OB Is defined:C1231($oQuickReport; "nParentTable"))
		$nParentTable:=$oQuickReport.nParentTable
	End if 
	
	If (OB Is defined:C1231($oQuickReport; "tDocumentName"))
		$tDocumentName:=$oQuickReport.tDocumentName
	End if 
	
	$tPathDesktop:=System folder:C487(Desktop:K41:16)
	$tPathHTMLTemplate:=$tPathDesktop+"HTMLTemplate.txt"
	
	$tHTMLTemplate:=QkRp_GetHTMLTemplateT
	
End if   //Done Initialize

Case of   //QR
		
	: (Not:C34(Is table number valid:C999($nParentTable)))
	: (BLOB size:C605($lQuikReport)=0)
		
	Else   //Valid
		
		$tPathHTMLReport:=$tPathDesktop+$tDocumentName+".html"
		
		$nQuickReportArea:=QR New offscreen area:C735
		
		QR SET REPORT TABLE:C757($nQuickReportArea; $nParentTable)
		
		QR BLOB TO REPORT:C771($nQuickReportArea; $lQuikReport)  //1. Load report
		
		QR SET DESTINATION:C745($nQuickReportArea; qr HTML file:K14903:5; $tPathHTMLReport)  //2. Must follow QR BLOB TO REPORT
		
		QR SET HTML TEMPLATE:C750($nQuickReportArea; $tHTMLTemplate)  //3. Must follow QR SET DESTINATION
		
		QR RUN:C746($nQuickReportArea)
		
		QR DELETE OFFSCREEN AREA:C754($nQuickReportArea)
		
		OPEN URL:C673($tPathHTMLReport; "Microsoft Excel"; *)
		
End case   //Done QR
