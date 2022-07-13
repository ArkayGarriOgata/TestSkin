//%attributes = {}
// _______
// Method: EDI_DESADV_FindBy   ( ) ->
// By: Mel Bohince @ 06/16/20, 08:35:21
// Description
// 
// ----------------------------------------------------

// called by: [Customers_ReleaseSchedules].ShipMgmt.queryList
// ----------------------------------------------------
// Modified by: Mel Bohince (6/25/20) resize array to 6
// Modified by: Mel Bohince (7/16/20) use Form.elcOpenFirm as query base, don't test Milestone attributes
// Modified by: Mel Bohince (7/18/20) add search for last 7 days
// Modified by: Mel Bohince (8/13/20) remove ASN id criteria from the waiting pickup
// Modified by: Mel Bohince (1/18/21) chg menu text, add allowance for hte text "rfm" used for tagging when request has been made
// Modified by: Mel Bohince (1/20/21) Waiting Pickup to look for our EPD and mode not contains rfm
// Modified by: Mel Bohince (1/26/21) on Pickup Ready & Requested ignore the ReadyOnly cb's $base_es and use Form.elcOpenFirm because asn already sent so asn > 0

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(asQueryTypes; 0)
		COLLECTION TO ARRAY:C1562(Form:C1466.verboseShipTos_c; asQueryTypes)
		INSERT IN ARRAY:C227(asQueryTypes; 1; 8)
		asQueryTypes{1}:="All Open Firm"
		asQueryTypes{2}:="Waiting Open PO Notification"
		asQueryTypes{3}:="Waiting ASN"
		asQueryTypes{4}:="Waiting Auth#,Mode,Load#"
		asQueryTypes{5}:="Pickup Reqested (ASN sent)"
		asQueryTypes{6}:="Pickup Ready (ASN & Mode/Load)"
		asQueryTypes{7}:="Shipped Last 7 days"  // Modified by: Mel Bohince (7/18/20) add search for last 7 days
		asQueryTypes{8}:="-"
		asQueryTypes{0}:="Quick search..."
		
	: (Form event code:C388=On Data Change:K2:15)
		$choice:=asQueryTypes
		utl_LogIt(Timestamp:C1445+"\t EDI_DESADV_FindBy "+asQueryTypes{$choice}; 0)
		
		C_OBJECT:C1216($base_es)  //what to base the query on
		$onlyReady:=OBJECT Get pointer:C1124(Object named:K67:5; "showReadyOnly")
		If ($onlyReady->=0)
			$base_es:=Form:C1466.elcOpenFirm
		Else 
			$base_es:=Form:C1466.openReady
		End if 
		
		If ($choice<8)
			
			Case of 
				: ($choice=1)  //edi msg = 0 "All Open Firm"
					//reload base query
					Form:C1466.elcOpenFirm:=Form:C1466.masterClass.query("CUSTOMER.ParentCorp = :1 and CustomerRefer # :2 and OpenQty > :3"; "Estée Lauder Companies"; "<@"; 0)
					Form:C1466.listBoxEntities:=Form:C1466.elcOpenFirm.orderBy(Form:C1466.defaultOrderBy)
					zwStatusMsg("Search"; "CUSTOMER.ParentCorp = Estée Lauder Companies and CustomerRefer # <@ and OpenQty > 0; found: "+String:C10(Form:C1466.listBoxEntities.length))
					
				: ($choice=2)  //edi msg = 0 "Waiting Open PO Notification"
					$criterian_i:=0
					Form:C1466.listBoxEntities:=$base_es.query("ediASNmsgID = :1"; $criterian_i).orderBy(Form:C1466.defaultOrderBy)
					zwStatusMsg("Search"; "AllOpenFirm and ediASNmsgID = 0; found: "+String:C10(Form:C1466.listBoxEntities.length))
					
				: ($choice=3)  //edi msg = -1 "Waiting ASN"
					$criterian_i:=-1
					Form:C1466.listBoxEntities:=$base_es.query("ediASNmsgID = :1"; $criterian_i).orderBy(Form:C1466.defaultOrderBy)
					zwStatusMsg("Search"; "AllOpenFirm and ediASNmsgID = -1; found: "+String:C10(Form:C1466.listBoxEntities.length))
					
				: ($choice=4)  //edi msg  > 0 "Waiting Booking Confirmation" aka Mode
					$criterian_i:=0  //asn was requested or sent, but not still waiting for OPN
					//Form.listBoxEntities:=Form.elcOpenFirm.query("ediASNmsgID > :1 and Mode = :2 and Milestones.OPN != :3";$criterian_i;"";Null).orderBy(Form.defaultOrderBy)
					Form:C1466.listBoxEntities:=$base_es.query("ediASNmsgID # :1 and (Mode = :2 or Mode = :3)"; $criterian_i; ""; "@rfm@").orderBy(Form:C1466.defaultOrderBy)
					zwStatusMsg("Search"; "AllOpenFirm and ediASNmsgID # 0  and Mode is blank or contains rfm; found: "+String:C10(Form:C1466.listBoxEntities.length))
					
				: ($choice=5)  //edi msg  > 0 "Pickup Reqested"
					$criterian_i:=0
					//$onlyReady->:=0
					// Modified by: Mel Bohince (1/26/21) ignore the ReadyOnly cb's $base_es and use Form.elcOpenFirm because asn already sent so asn > 0
					Form:C1466.listBoxEntities:=Form:C1466.elcOpenFirm.query("ediASNmsgID > :1"; $criterian_i).orderBy(Form:C1466.defaultOrderBy)  //user_date_2 is the EPD sent on the ASN
					zwStatusMsg("Search"; "AllOpenFirm with ASN sent (EPD set); found: "+String:C10(Form:C1466.listBoxEntities.length))
					
				: ($choice=6)  //edi msg  > 0 "Pickup Ready"
					$criterian_i:=0
					//$onlyReady->:=0
					// Modified by: Mel Bohince (1/26/21) ignore the ReadyOnly cb's $base_es and use Form.elcOpenFirm because asn already sent so asn > 0
					Form:C1466.listBoxEntities:=Form:C1466.elcOpenFirm.query("ediASNmsgID > :1 and Mode # :2 and Mode # :3"; $criterian_i; "@rfm@"; "").orderBy(Form:C1466.defaultOrderBy)  //user_date_2 is the EPD sent on the ASN
					zwStatusMsg("Search"; "AllOpenFirm with EPD set and Mode or Load# given, mode doesn't contain 'rfm'; found: "+String:C10(Form:C1466.listBoxEntities.length))
					
				: ($choice=7)  //edi msg  > 0 "Shipped Last 7 days" 
					C_DATE:C307($beginDate)
					$beginDate:=Add to date:C393(Current date:C33; 0; 0; -7)
					Form:C1466.listBoxEntities:=Form:C1466.masterClass.query("Actual_Date > :1 and CUSTOMER.ParentCorp = :2"; $beginDate; "Estée Lauder Companies").orderBy("Shipto asc, Actual_Date desc")
					zwStatusMsg("Search"; "Actual_Date > (Current date-7) and CUSTOMER.ParentCorp = Estée Lauder Companies; found: "+String:C10(Form:C1466.listBoxEntities.length))
			End case 
			
		Else 
			
			$criterian_t:=Substring:C12(asQueryTypes{$choice}; 1; 5)
			Form:C1466.listBoxEntities:=$base_es.query(Form:C1466.searchBoxQueryActive; $criterian_t).orderBy(Form:C1466.defaultOrderBy)
			zwStatusMsg("Search"; "AllOpenFirm and CustomerRefer or ProductCode or Shipto or Mode = "+$criterian_t+"; found: "+String:C10(Form:C1466.listBoxEntities.length))
			
		End if 
		
		Form:C1466.message:="PO's "+asQueryTypes{$choice}
		utl_LogIt(Timestamp:C1445+"\t EDI_DESADV_FindBy "+asQueryTypes{$choice}+" End"; 0)
		asQueryTypes:=0
End case 
