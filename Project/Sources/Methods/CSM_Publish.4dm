//%attributes = {}
// Method: CSM_Publish() -> 
// ----------------------------------------------------
// by: mel: 10/30/03, 10:09:47
// ----------------------------------------------------
// Description:
// Export CSM to html and publish on intranet server

C_LONGINT:C283($i; $numColors)
C_TEXT:C284(xText; $temp)
C_TEXT:C284($t; $cr)
C_TEXT:C284($sp)

$sp:="&nbsp;"
zwStatusMsg("Saving"; "ColorSpecMaster:"+[Finished_Goods_Color_SpecMaster:128]name:2)

READ ONLY:C145([Users:5])
READ ONLY:C145([x_html_templates:130])

QUERY:C277([x_html_templates:130]; [x_html_templates:130]name:1="ColorSpecMaster")
If (Records in selection:C76([x_html_templates:130])=1)
	xText:=[x_html_templates:130]template:2
	REDUCE SELECTION:C351([x_html_templates:130]; 0)
	xText:=Replace string:C233(xText; "%name%"; [Finished_Goods_Color_SpecMaster:128]name:2+$sp)
	$temp:=[Finished_Goods_Color_SpecMaster:128]name:2+" Color Specifications, #"+[Finished_Goods_Color_SpecMaster:128]id:1+" for "+[Customers:16]Name:2+" as defined in the "+[Customers_Projects:9]Name:2+"' project are defined as follows:"
	xText:=Replace string:C233(xText; "%intro%"; $temp)
	$temp:="firstname lastname phonenumber email"
	xText:=Replace string:C233(xText; "%custRep%"; $temp+$sp)
	
	QUERY:C277([Users:5]; [Users:5]Initials:1=[Customers:16]SalesmanID:3)  //• mlb - 2/21/02  11:34
	If (Records in selection:C76([Users:5])>0)
		$temp:=Email_WhoAmI([Users:5]UserName:11)+"  631/273.2000"
	End if 
	xText:=Replace string:C233(xText; "%rkRep%"; $temp+$sp)
	
	QUERY:C277([Users:5]; [Users:5]Initials:1=[Customers:16]PlannerID:5)  //• mlb - 2/21/02  11:34
	If (Records in selection:C76([Users:5])>0)
		$temp:=Email_WhoAmI([Users:5]UserName:11)+"  631/273.2000"
	End if 
	xText:=Replace string:C233(xText; "%rkPlanner%"; $temp+$sp)
	xText:=Replace string:C233(xText; "%stockType%"; [Finished_Goods_Color_SpecMaster:128]stockType:5+$sp)
	xText:=Replace string:C233(xText; "%stockCal%"; String:C10([Finished_Goods_Color_SpecMaster:128]stockCaliper:6; "0.000##")+$sp)
	xText:=Replace string:C233(xText; "%stockRM%"; [Finished_Goods_Color_SpecMaster:128]stockRMcode:10+$sp)
	xText:=Replace string:C233(xText; "%stockVend%"; [Finished_Goods_Color_SpecMaster:128]stockVendor:7+$sp)
	xText:=Replace string:C233(xText; "%stockPrecoat%"; [Finished_Goods_Color_SpecMaster:128]stockPrecoat:8+$sp)
	
	
	$temp:=""
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		FIRST RECORD:C50([Finished_Goods_Color_SpecSolids:129])
		For ($i; 1; Records in selection:C76([Finished_Goods_Color_SpecSolids:129]))
			$temp:=$temp+"<tr>"
			$temp:=$temp+"<td>"+[Finished_Goods_Color_SpecSolids:129]side:15+"/"+String:C10([Finished_Goods_Color_SpecSolids:129]pass:13)+"-"+String:C10([Finished_Goods_Color_SpecSolids:129]rotation:7)+"</td>"
			$temp:=$temp+"<td>"+[Finished_Goods_Color_SpecSolids:129]colorName:10+"</td>"
			$temp:=$temp+"<td>"+[Finished_Goods_Color_SpecSolids:129]inkRMcode:4+"</td>"
			$temp:=$temp+"<td>"+String:C10([Finished_Goods_Color_SpecSolids:129]approved:6; System date short:K1:1)  //util_iif ([ColorSpecSolid]approved;"Yes";"")+"</td>"
			$temp:=$temp+"<td>"+[Finished_Goods_Color_SpecSolids:129]vpn:5+"</td>"
			$temp:=$temp+"<td>"+[Finished_Goods_Color_SpecSolids:129]operationType:9+"</td>"
			$temp:=$temp+"<td>"+[Finished_Goods_Color_SpecSolids:129]coveragePercent:12+"</td>"
			$temp:=$temp+"</tr>"
			NEXT RECORD:C51([Finished_Goods_Color_SpecSolids:129])
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_side; 0)
		ARRAY LONGINT:C221($_pass; 0)
		ARRAY LONGINT:C221($_rotation; 0)
		ARRAY TEXT:C222($_colorName; 0)
		ARRAY TEXT:C222($_inkRMcode; 0)
		ARRAY DATE:C224($_approved; 0)
		ARRAY TEXT:C222($_vpn; 0)
		ARRAY TEXT:C222($_operationType; 0)
		ARRAY TEXT:C222($_coveragePercent; 0)
		
		SELECTION TO ARRAY:C260([Finished_Goods_Color_SpecSolids:129]side:15; $_side; [Finished_Goods_Color_SpecSolids:129]pass:13; $_pass; [Finished_Goods_Color_SpecSolids:129]rotation:7; $_rotation; [Finished_Goods_Color_SpecSolids:129]colorName:10; $_colorName; [Finished_Goods_Color_SpecSolids:129]inkRMcode:4; $_inkRMcode; [Finished_Goods_Color_SpecSolids:129]approved:6; $_approved; [Finished_Goods_Color_SpecSolids:129]vpn:5; $_vpn; [Finished_Goods_Color_SpecSolids:129]operationType:9; $_operationType; [Finished_Goods_Color_SpecSolids:129]coveragePercent:12; $_coveragePercent)
		
		For ($i; 1; Size of array:C274($_side); 1)
			$temp:=$temp+"<tr>"
			$temp:=$temp+"<td>"+$_side{$i}+"/"+String:C10($_pass{$i})+"-"+String:C10($_rotation{$i})+"</td>"
			$temp:=$temp+"<td>"+$_colorName{$i}+"</td>"
			$temp:=$temp+"<td>"+$_inkRMcode{$i}+"</td>"
			$temp:=$temp+"<td>"+String:C10($_approved{$i}; System date short:K1:1)
			$temp:=$temp+"<td>"+$_vpn{$i}+"</td>"
			$temp:=$temp+"<td>"+$_operationType{$i}+"</td>"
			$temp:=$temp+"<td>"+$_coveragePercent{$i}+"</td>"
			$temp:=$temp+"</tr>"
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	xText:=Replace string:C233(xText; "%color%"; $temp+$sp)
	$temp:=""
	FIRST RECORD:C50([Finished_Goods_Color_SpecSolids:129])
	
	xText:=Replace string:C233(xText; "%finishType%"; [Finished_Goods_Color_SpecMaster:128]finishType:11+$sp)
	xText:=Replace string:C233(xText; "%finishProcess%"; [Finished_Goods_Color_SpecMaster:128]finishProcess:12+$sp)
	xText:=Replace string:C233(xText; "%finishGloss%"; [Finished_Goods_Color_SpecMaster:128]finishGlossLevel:13+", glossometer = "+String:C10([Finished_Goods_Color_SpecMaster:128]finishGlossometer:16))
	xText:=Replace string:C233(xText; "%finishStamps%"; [Finished_Goods_Color_SpecMaster:128]finishStamps:14+$sp)
	xText:=Replace string:C233(xText; "%finishLam%"; [Finished_Goods_Color_SpecMaster:128]finishLaminationRMcode:15+$sp)
	xText:=Replace string:C233(xText; "%comments%"; [Finished_Goods_Color_SpecMaster:128]comment:9+$sp)
	
	$shortName:="CMS"+[Finished_Goods_Color_SpecMaster:128]id:1+".html"
	docName:=$shortName
	C_TIME:C306($docRef)
	$docRef:=util_putFileName(->docName)
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	
	zwStatusMsg("Open"; docName)
	$ftpId:=ftp_intranetLogin("specs")
	If ($ftpId#0)
		$err:=ftp_intranetDeleteFile($shortName)
		zwStatusMsg("Sending"; docName)
		$err:=ftp_intranetSendFile(docName; $shortName)
		If ($err=0)
			OPEN URL:C673("http://intranet.arkay.com/ams/specs/"+$shortName; *)
		End if 
	Else 
		BEEP:C151
		ALERT:C41("Couldn't connect to the Intranet server. Spec was not published.")
	End if 
	$ftpId:=ftp_intranetLogout
	zwStatusMsg("Published"; docName)
Else 
	BEEP:C151
	ALERT:C41("template not found")
End if 