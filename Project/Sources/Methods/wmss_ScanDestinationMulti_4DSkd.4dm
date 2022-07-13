//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_ScanDestinationMulti_4D_Skd - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($ttSkidNum; $ttSQL; $ttCaseID)
C_BOOLEAN:C305($fFailed)
rft_destination:="skid"
$ttSkidNum:=rft_response

//validate if skid is known to aMs, get jobit
QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5=$ttSkidNum)
If (Records in selection:C76([WMS_SerializedShippingLabels:96])=1)
	sJobit:=[WMS_SerializedShippingLabels:96]Jobit:3
	sCPN:=[WMS_SerializedShippingLabels:96]CPN:2
	
	$ttSQL:="SELECT case_id,skid_number,bin_id,case_status_code,ams_location,jobit FROM cases WHERE skid_number=?"
	
	SQL SET PARAMETER:C823($ttSkidNum; SQL param in:K49:1)
	SQL EXECUTE:C820($ttSQL; $ttCaseID; sToSkid; sToBin; iToCode; ams_location; sJobit)
	
	$fFailed:=True:C214
	Case of 
		: (OK=0)
			
		: (SQL End selection:C821)
			SQL CANCEL LOAD:C824
		Else 
			SQL LOAD RECORD:C822(SQL all records:K49:10)
			SQL CANCEL LOAD:C824
			$fFailed:=False:C215
	End case 
	
	If ($fFailed)
		sToSkid:=$ttSkidNum
		sToBin:="BNVFG_HOLD"
		iToCode:=100
		ams_location:="FG"
	Else 
		
	End if 
	
	If ($ttCaseID#sToSkid)
		tSQL:="UPDATE cases set case_status_code = "+String:C10(iToCode)+", ams_location='"+ams_location+"', bin_id='"+sToBin+"',"
		tSQL:=tSQL+" update_initials = '"+<>zResp+"', skid_number='"+sToSkid+"'"
		
	Else 
		rft_error_log:="Can't add to Supercase"
	End if 
	
Else   //error
	rft_error_log:="Unknown SSCC#"
End if 

