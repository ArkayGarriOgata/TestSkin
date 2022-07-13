//FM: ZebraLabelPicker() -> 
//@author mlb - 11/6/01  09:49
// Modified by: Mel Bohince (3/27/18) move obj scripts to on-data-change in form method
// Modified by: Mel Bohince (5/14/18) remove '*' from elc v4 label
// Modified by: Garri Ogata (8/23/21)
//.     Form deleted rb2 button changed rb1 to invisible by default
//.     Added set visible under "Designer" (77, 78), set rb# 205-207
//.     

Case of 
	: (Form event code:C388=On Data Change:K2:15)  // Modified by: Mel Bohince (3/26/18) 
		
		If (PK_isQtyValid([Finished_Goods_PackingSpecs:91]FileOutlineNum:1; wmsCaseQty))
			$caseID:=WMS_CaseId(""; "set"; sJMI; wmsCaseNumber1; wmsCaseQty)
			wmsCaseId1:=WMS_CaseId($caseID; "barcode")
			wmsHumanReadable1:=WMS_CaseId($caseID; "human")
		Else 
			wmsCaseQty:=iQty
		End if 
		
		If (tToName#tTo)
			Zebra_CustShortNameChg
			tToName:=tTo
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		C_LONGINT:C283(tcpID)
		tcpID:=0
		C_TEXT:C284(tcpAddress)
		C_LONGINT:C283(tcpPort)
		$prefs:=User_ZebraPreferences(<>zResp)  // `util_UserPreference ("get";"ZebraIP")
		bSendToWMS:=1
		
		Case of 
			: (Length:C16($prefs)>0)
				//12345678901234567890
				//001192.168.003.03909100E00
				//1234567890 1234567 8901234
				rb1:=Num:C11(Substring:C12($prefs; 1; 1))
				rb2:=Num:C11(Substring:C12($prefs; 2; 1))
				rb3:=Num:C11(Substring:C12($prefs; 3; 1))
				tcpAddress:=Substring:C12($prefs; 4; 15)  //"192.168.3.39xxx"
				tcpAddress:=Replace string:C233(tcpAddress; "x"; "")
				tcpAddress:=Replace string:C233(tcpAddress; " "; "")
				tcpPort:=Num:C11(Substring:C12($prefs; 19; 5))  //09100  `default "Raw data port" on Zebra 105SL
				sCriterion1:=Substring:C12($prefs; 24; 2)  //"E"  `Print speed
				sCriterion2:=Substring:C12($prefs; 26; 2)  //"0"  `x origin
				sCriterion3:=Substring:C12($prefs; 28; 2)  //"0"  `y origin
				lValue1:=Num:C11(Substring:C12($prefs; 30; 3))
				// Modified by: Mel Bohince (5/14/19)
				
				
				If (lValue1=0)
					lValue1:=203
				End if 
				//$prefs:=User_ZebraPreferences (◊zResp;String(rb1)+String(rb2)+String(rb3)+txt_Pad (tcpAddress;"x";1;15)+String(tcpPort;"00000")+sCriterion1+sCriterion2+sCriterion3)
				
			: (User in group:C338(Current user:C182; "Roanoke"))
				rb1:=0
				rb2:=0
				rb3:=1
				tcpAddress:="192.168.3.39"
				tcpPort:=9100  //default "Raw data port" on Zebra 105SL
				sCriterion1:="E"  //Print speed
				sCriterion2:="0"  //x origin
				sCriterion3:="0"  //y origin
			: (Current user:C182="Designer")
				rb1:=0
				rb2:=0
				rb3:=1
				tcpAddress:="192.168.168.17"
				tcpPort:=9100  //default "Raw data port" on Zebra 105SL
				sCriterion1:="2"  //Print speed
				sCriterion2:="0"  //x origin
				sCriterion3:="13"  //y origin
				
				OBJECT SET VISIBLE:C603(rb2; True:C214)
				OBJECT SET VISIBLE:C603(*; "Round Rectangle3"; True:C214)
				
			Else 
				rb1:=1  //serial
				rb2:=0
				rb3:=0
				tcpAddress:=""
				tcpPort:=9100  //default "Raw data port" on Zebra 105SL
				sCriterion1:="E"  //Print speed
				sCriterion2:="0"  //x origin
				sCriterion3:="0"  //y origin
		End case 
		//sCriterion4:=""  `certified
		//sCriterion5:=""  `item
		
		ARRAY TEXT:C222(tcpAddresses; 0)
		LIST TO ARRAY:C288("ZebraLabelPrinters"; tcpAddresses)
		tcpAddresses{0}:=tcpAddress
		//OBJECT SET ENABLED(tcpAddresses;False)
		
		
		zwStatusMsg("LABEL STYLE"; labelStyle)
		Case of 
			: (labelStyle="Arkay")
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 1)
				FORM GOTO PAGE:C247(1)
				
			: (labelStyle="P&G")
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 2)
				FORM GOTO PAGE:C247(2)
				
			: (labelStyle="Lauder")
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 3)
				FORM GOTO PAGE:C247(3)
				
			: (labelStyle="L’Oréal") | (labelStyle="loreal") | (labelStyle="l'oreal")
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 4)
				FORM GOTO PAGE:C247(4)
				
			: (labelStyle="MH10.8")
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 5)
				FORM GOTO PAGE:C247(5)
				
			: (labelStyle="Custom")
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 6)
				FORM GOTO PAGE:C247(6)
				
				//: (labelStyle="Printer Settings")
				//SELECT LIST ITEMS BY POSITION(iTabs;7)
				//FORM GOTO PAGE(7)
				
			: (labelStyle="Skid Labels")
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 7)
				FORM GOTO PAGE:C247(7)
				
			: (labelStyle="ShsdoChntcl")
				If (Position:C15("PO# "; sPO)>0)
					sPO:=Replace string:C233(sPO; "PO# "; "")
				End if 
				sCriterion4:="*"+[Finished_Goods:26]UPC:37+"*"
				sCriterion5:=[Finished_Goods:26]UPC:37
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 8)
				FORM GOTO PAGE:C247(8)
				
			: (labelStyle="Revlon")
				If (Position:C15("PO# "; sPO)>0)
					sPO:=Replace string:C233(sPO; "PO# "; "")
				End if 
				sCriterion4:=(Char:C90(64+Month of:C24(wmsDateMfg)))+String:C10(Day of:C23(wmsDateMfg); "00")+Substring:C12(String:C10(Year of:C25(wmsDateMfg); "0000"); 3)
				sCriterion5:=[Finished_Goods:26]AliasCPN:106
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 9)
				FORM GOTO PAGE:C247(9)
				
			: (labelStyle="ELC-v4")
				sCriterion1:="02"  //slow it down for quality
				If (Position:C15("PO# "; sPO)>0)
					sPO:=Replace string:C233(sPO; "PO# "; "")
				End if 
				mfg_code:=ELC_getMfgCode([Job_Forms_Items:44]ProductCode:3)
				$alias:=Replace string:C233([Finished_Goods:26]AliasCPN:106; "-"; "")
				Case of 
					: (Length:C16($alias)=10)  //just add the code
						sCriterion4:=""+$alias+mfg_code+""  // Modified by: Mel Bohince (5/14/18) remove '*'
						sCriterion5:=$alias+mfg_code
						
					: (Length:C16($alias)=13)
						sCriterion4:=""+$alias+""
						sCriterion5:=$alias
					Else 
						$cpn:=Replace string:C233([Finished_Goods:26]ProductCode:1; "-"; "")
						sCriterion4:=""+$cpn+mfg_code+""
						sCriterion5:=$cpn+mfg_code
				End case 
				
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 10)
				FORM GOTO PAGE:C247(10)
				
			: (labelStyle="LVMH")
				If (Position:C15("PO# "; sPO)>0)
					sPO:=Replace string:C233(sPO; "PO# "; "")
				End if 
				mfg_code:=Substring:C12([Job_Forms_Items:44]JobForm:1; 2; 4)  //ELC_getMfgCode ([Job_Forms_Items]ProductCode)
				$alias:=[Finished_Goods:26]AliasCPN:106
				sCriterion4:="02"+$alias+"10"+mfg_code+"37"+String:C10(wmsCaseQty)
				skidLableText:="(02)"+$alias+"(10)"+mfg_code+"(37)"+String:C10(wmsCaseQty)
				sCriterion5:=$alias
				
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 10)
				FORM GOTO PAGE:C247(11)
				
			: (labelStyle="Nest")
				If (Position:C15("PO# "; sPO)>0)
					sPO:=Replace string:C233(sPO; "PO# "; "")
				End if 
				sCriterion5:=[Finished_Goods:26]UPC:37
				C_LONGINT:C283(iWgtPerCase)
				iWgtPerCase:=[Finished_Goods_PackingSpecs:91]WeightPerCase:40
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 8)
				FORM GOTO PAGE:C247(12)
				
			Else 
				labelStyle:="Arkay"
				SELECT LIST ITEMS BY POSITION:C381(iTabs; 1)
				FORM GOTO PAGE:C247(1)
		End case 
		wmsCaseNumber1:=Zebra_CaseNumberManager("last"; sJMI)
		
		rb1:=0
		rb2:=0
		rb3:=1  //Enforce this On Load this is the only option except for developers
		
	: (Form event code:C388=On Unload:K2:2)
		$prefs:=User_ZebraPreferences(<>zResp; String:C10(rb1)+String:C10(rb2)+String:C10(rb3)+txt_Pad(tcpAddress; "x"; 1; 15)+String:C10(tcpPort; "00000")+String:C10(Num:C11(sCriterion1); "00")+String:C10(Num:C11(sCriterion2); "00")+String:C10(Num:C11(sCriterion3); "00")+String:C10(lValue1))
End case 