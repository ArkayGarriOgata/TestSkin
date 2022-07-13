//%attributes = {"publishedWeb":true}
//  //TESTING

//$jobit:="18145.01.05"  //"17329.04.06"

//$fgx_es:=ds.Finished_Goods_Transactions.query("Jobit = :1"; $jobit)
//$when:=$fgx_es.first().getTimeStamp()
//$good:=$fgx_es.getGoodQuantity()
//$shipped:=$fgx_es.getShippedNetQuantity()

//$fgx_es:=ds.Finished_Goods_Transactions.query("ProductCode = :1"; "6FW2-01-0117")
//$good:=$fgx_es.getGoodQuantity()
//$shipped:=$fgx_es.getShippedNetQuantity()

//$jobit_e:=ds.Job_Forms_Items.query("Jobit = :1"; $jobit).first()
//$good:=$jobit_e.quantityGood()

//C_OBJECT($settings)
//$settings:=New object("queryPlan";True;"queryPath";True)
//$invoices_es:=ds.Customers_Invoices.query("Invoice_Date >= :1 and CoGS_Actual = :2 and Quantity # :3";$dateBegin;0;1;$settings)  //qty = 1 on spl billings which normally havn't a cost provided
//SET TEXT TO PASTEBOARD(JSON Stringify($invoices_es.queryPlan;*))
//SET TEXT TO PASTEBOARD(JSON Stringify($invoices_es.queryPath;*))

//C_DATE($date)
//C_OBJECT($release_e)
//$date:=!00-00-00!
//$release_e:=ds.Customers_ReleaseSchedules.query("ReleaseNumber = 4905287").first()
//If ($release_e.Milestones#Null)
//If (OB Is defined($release_e.Milestones;"EDD"))
//$date:=Date($release_e.Milestones.EDD)
//End if 
//End if  If (Not(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
//$body:="This is the first line,\rfollowed by a second,\rand third."
//EMAIL_Transporter ("Test email17";"this is my  preheader";$body;"mel.bohince@arkay.com";"";"no-reply@arkay.com";"no-reply@arkay.com";"";"bohince@gmail.com")
//C_OBJECT($connectTo;$remoteDS)
//$connectTo:=New object("type";"4D Server";"hostname";"192.168.1.136:8080";"user";"Designer";"password";"1147")
//$remoteDS:=Open datastore($connectTo;"Customers")
// ALERT("This remote datastore contains "+String($remoteDS.Customers.all().length)+" Customers")


//C_OBJECT($thePick)
//$thePick:=util_PickOne_UI (ds.Process_Specs.query("ID = :1 and Cust_ID = :2";"BB@";"01780");"ID")

//C_COLLECTION($gluers_c)
//$gluers_c:=CostCtrGroup ("80.FINISHING")



//C_DATE($temp_d)
//C_TEXT($temp_t)
//$number:=CostCtrCurrent ("OOP";"420")

//$number:=CostCtrCurrent ("Dated";"420";->$temp_d)

//$number:=CostCtrCurrent ("Desc";"420";->$temp_t)
// _______
// Method: 0test   ( ) 
//Method:  Adrs_GetAddress(tAddressID;oAddress)
//Description:  This method will return to poAddress the address parts
//C_OBJECT($zzControl)
//$zzControl:=ds.z_administrators.all().first().toObject()

//$currentDate:=!2024-02-15!
//$lastDayOfMonth:=Add to date(date(string(Month of($currentDate))+"/1/"+string(year of($currentDate)));0;1;-1)

//$docRef:=pattern_SaveAs ("pk_ids.csv")
//If (ok=1)
//CLOSE DOCUMENT($docRef)
//End if 
//util_EntitySelection_To_CSV (ds.Customers.all();"")  // 24 25 26 27 28 49

//consolidationType:="PerShipto"
//  //consolidationType:="Parcel"
//consolidationType:="PerASN"
//$lastReleaseNum:=4
//$numberOfCases:=3
//$defaultCasesPerSkid:=24
//$casesPerSkid:=30
//$po:="4500123"

//  //EDI_DESADV_Consolidation ("init";$lastReleaseNum;$defaultCasesPerSkid)
//Case of 
//: (consolidationType="PerASN")
//EDI_DESADV_Consolidation (New object("msg";"init";"lastRelease";$lastReleaseNum;"casesPerPallet";0;"purchaseOrder";$po))

//: (consolidationType="Parcel")
//EDI_DESADV_Consolidation (New object("msg";"init";"lastRelease";$lastReleaseNum;"casesPerPallet";0))

//Else 
//EDI_DESADV_Consolidation (New object("msg";"init";"lastRelease";$lastReleaseNum;"casesPerPallet";$defaultCasesPerSkid))
//End case 

//For ($i;1;3)
//$numberOfCases:=(Random%100)+2
//  //EDI_DESADV_Consolidation ("incrementCases";$numberOfCases)
//EDI_DESADV_Consolidation (New object("msg";"incrementCases";"incrementCases";$numberOfCases))

//$casesPerSkid:=((Random%4)+2)*10
//$cpn:=((Random%9000)+2000)

//$poNumber:="450060"+String((Random%400)+200)
//$consolidationDetail_o:=New object("po";$poNumber;"cpn";$cpn;"numCases";$numberOfCases;"caseSpaces";$casesPerSkid)
//  //EDI_DESADV_ConsolidationItem ($consolidationDetail_o)
//EDI_DESADV_Consolidation (New object("msg";"addDetail";"consolDetail";$consolidationDetail_o))

//End for 

//EDI_DESADV_Consolidation (New object("msg";"close?";"currentRelease";4))  // callse $pallets:=EDI_DESADV_ConsolidationSkidTTL 




//C_OBJECT($form_o)
//$form_o:=New object
//$form_o.elcOpenFirm:=ds.Customers_ReleaseSchedules.query("CUSTOMER.ParentCorp = :1 and CustomerRefer # :2 and OpenQty > :3";"Estée Lauder Companies";"<@";0)

//C_COLLECTION($shipTos_c;$verboseShipTos_c)
//  //for the Search popup, create a collection of (addressid+country,city,addr_name) to choose from
//$shipTos_c:=$form_o.elcOpenFirm.distinct("Billto")
//ARRAY TEXT($aAddresses;0)
//COLLECTION TO ARRAY($shipTos_c;$aAddresses)

//QUERY WITH ARRAY([Addresses]ID;$aAddresses)



//$pjtEntity:=ds.Customers_Projects.query("id = :1";"02708")
//C_OBJECT($obj)  //  //[Customers_ReleaseSchedules]Milestones
//$obj:=ds.Customers_ReleaseSchedules.query("Milestones.EPD = :1 and Milestones.RKD < :2";"07/01/20";"07/01/20")

//$obj:=CUST_getCustomerObj ("00199")
// Modified by: Mel Bohince (6/24/20) 

//WMS_API_LoginLookup 
//If (WMS_API_4D_DoLogin )
//$dInventory:=current date
//$ttWareHouse:="R"
//$ttLocation:="BNV-01-01-1"
//$ttJobit:="993300106"
//WMS_API_4D_compareToAMS_Match ($dInventory;$ttWarehouse;$ttLocation;$ttLocation;$ttJobit)
//WMS_API_4D_DoLogout 

//end if


//$when:=TSTimeStamp +10
//Que_AddToQueue ($when;"Que_test";"client";"repeat")

//$when:=$when+60
//For (i;1;10)
//Que_AddToQueue ($when;"Que_test";"client";String(i))
//uConfirm ("quit?";"Yes";"No")
//If (ok=1)
//i:=i+10
//Else 
//$when:=$when+60
//End if 
//End for 

//$i:=JIC_Relieve (("01780"+":"+"EE1Y-01-0111");6500;->[Finished_Goods_Transactions]CoGSextendedMatl;->[Finished_Goods_Transactions]CoGSextendedLabor;->[Finished_Goods_Transactions]CoGSextendedBurden)

//ams_FindWithoutHeaderRecord (->[Finished_Goods_SizeAndStyles]CustID;->[Customers]ID) 
//distributionList:="mel.bohince@arkay.com"
//PS_PrintGoal ("Printing")
//PS_PrintGoal ("Blanking")
//PS_PrintGoal ("Stamping")

//$date:=fYYMMDD (4D_Current_date;4;"")
//$stime:=Replace string(String(Current time;HH MM SS);":";"")
//$rand:=String(((Random%21)+10))
//$id:=txt_quote ($date+$stime+$rand+"virtual.factory@arkay.com")
//ALERT("msg-id: "+$id+" in quotes")



//JIC_Regenerate ("00050:7PL2-01-0112")
//$numBH:=FG_Bill_and_Hold_Collection ("init")
//
//$numBH:=FG_Bill_and_Hold_Collection ("missing")
//$numBH:=FG_Bill_and_Hold_Collection ("remaining")
//
//$numBH:=FG_Bill_and_Hold_Collection ("kill")

//QUERY([Job_Forms_Items])
//$error:=THC_calc_one_item ([Job_Forms_Items]CustId;[Job_Forms_Items]ProductCode)

//REL_getRecertificationRequired ("init")
//$ink:=Ink_get_cost ("P&G 1457")
//$pid:=New Process("app_event_scheduler";32*1028;"$Event Scheduler";*)
//$pid:=New Process("pattern_Listener_descrete";32*1028;"$Listener_des")
//$pid:=New Process("pattern_Listener_Interval";32*1028;"$Listener_int")
//app_event_scheduler ("kill")

//ARRAY REAL($datetime;10)
//For ($i;1;10)
//DELAY PROCESS(Current process;30)
//$datetime{$i}:=PNGA_ConvertDateTimeToReal 
//End for 
//TS2iso 

//JIC_Regenerate ("00074:166732")
//test unicode
//ARRAY TEXT($cpn;0)
//ALL RECORDS([Finished_Goods])
//SELECTION TO ARRAY([Finished_Goods]ProductCode;$cpn)
//For ($i;1;50)
//$cpn{$i}:="~"+Replace string($cpn{$i};" ";"")
//End for 
//SORT ARRAY($cpn;>)
//$hit:=Find in array($cpn;"~@")
//ALERT(String($hit))

//test external sql via odbc, need to set up the driver first
//ARRAY TEXT($cpn;0)
//ARRAY TEXT($pspec;0)
//ARRAY LONGINT($id;0)
//update item_masters
//          set packing_spec='0x0=0'
//          where packing_spec = 'not defined';
//SQL LOGIN("CustomerPortal";"mel_at_work";"Y-had-I-8-so-much";*)
//$db:=Get current data source
//Begin SQL
//select id, product_code, packing_spec 
//          from item_masters 
//          where packing_spec = '0x0=0' 
//          order by product_code 
//          into :$id, :$cpn, :$pspec;
//End SQL
//SQL LOGOUT


//$limitor:=Add to date(4D_Current_date;0;-6;0)

//$text:=ADDR_CrossIndexLauder ("GET_SPL";"1550";"ESTEE LAUDER COSMETICS, LTD.:161 COMMANDER BLVD.:AGINCOURT, ONTARIO:CANADA M1S3K9")
//$text:=ADDR_CrossIndexLauder ("GET_SPL";"1550";"UK HUB:Fulfood Road:Havant, HA PO0 5AX GB")
//$text:=ADDR_CrossIndexLauder ("GET_SPL";"1550";"NORTHTEC KEYSTONE:150 RITTENHOUSE CIRCLE:BRISTOL, PA 19007")
//CUSTPORT_Export ("mel.bohince@arkay.com")

//FG_Inventory_Array ("show")

//path:=Select folder("TET")
//groupID:=-15005
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)

//groupID:=-15011
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)
//
//groupID:=-15015
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)
//
//groupID:=-15023
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)
//
//groupID:=-15024
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)
//
//groupID:=-15031
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)
//
//groupID:=-15038
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)
//
//groupID:=-15053
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)
//
//groupID:=-15054
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)
//
//groupID:=-15073
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)
//
//
//groupID:=-15084
//GET GROUP PROPERTIES(groupID;name;owner;members)
//$groupid:=Set group properties(groupID;name;owner;members)

//$start:=†24:00:00†-0
//For ($i;1;100000)
//$id:=app_Id_Encoder 
//End for 
//ALERT(String(Current time-$start))
//
//$start:=Current time
//For ($i;1;10000)
//$id:=app_Id_Encoder 
//MESSAGE($id)
//End for 
//ALERT(String(Current time-$start))
//
//$lastid:="~~~"
//$start:=Current time
//For ($i;1;100000)
//$id:=app_Id_Encoder 
//If ($lastid=$id)
//ALERT("dup")
//End if 
//$lastid:=$id
//End for 
//ALERT(String(Current time-$start))

//utl_LogIt ("init")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRCC")+" for "+"BNRCC")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRFG")+" for "+"BNRFG")
//utl_LogIt (wms_convert_bin_id ("ams";"BNREX")+" for "+"BNREX")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRXC")+" for "+"BNRXC")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRFG_HOLD")+" for "+"BNRFG_HOLD")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRPX")+" for "+"BNRPX")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRXC_RETURN")+" for "+"BNRXC_RETURN")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRFG_SHIPPED")+" for "+"BNRFG_SHIPPED")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRFG_DOCK")+" for "+"BNRFG_DOCK")
//utl_LogIt (wms_convert_bin_id ("ams";"BNR-17-001-01")+" for "+"BNR-17-001-01")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRFG_SAMPLES")+" for "+"BNRFG_SAMPLES")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRSC_QA")+" for "+"BNRSC_QA")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRSC_REJECT")+" for "+"BNRSC_REJECT")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRSC_Kill")+" for "+"BNRSC_Kill")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRSC_Bill_n_Destroy")+" for "+"BNRSC_Bill_n_Destroy")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRFG_UNKNOWN")+" for "+"BNRFG_UNKNOWN")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRFG_CUSTOMER_WHS")+" for "+"BNRFG_CUSTOMER_WHS")
//utl_LogIt (wms_convert_bin_id ("ams";"BNRFG_OUTSIDE_SERVICE")+" for "+"BNRFG_OUTSIDE_SERVICE")
//
//utl_LogIt ("show")

//utl_LogIt ("init")
//utl_LogIt (wms_convert_bin_id ("wms";"CC:R")+" for "+"CC:R")
//utl_LogIt (wms_convert_bin_id ("wms";"FG:R")+" for "+"FG:R")
//utl_LogIt (wms_convert_bin_id ("wms";"EX:R")+" for "+"EX:R")
//utl_LogIt (wms_convert_bin_id ("wms";"XC:R")+" for "+"XC:R")
//utl_LogIt (wms_convert_bin_id ("wms";"FG:R_HOLD")+" for "+"FG:R_HOLD")
//utl_LogIt (wms_convert_bin_id ("wms";"PX:R")+" for "+"PX:R")
//utl_LogIt (wms_convert_bin_id ("wms";"XC:R_RETURN")+" for "+"XC:R_RETURN")
//utl_LogIt (wms_convert_bin_id ("wms";"FG:R_SHIPPED")+" for "+"FG:R_SHIPPED")
//utl_LogIt (wms_convert_bin_id ("wms";"FG:R_DOCK")+" for "+"FG:R_DOCK")
//utl_LogIt (wms_convert_bin_id ("wms";"FG:R17-001-01")+" for "+"FG:R17-001-01")
//utl_LogIt (wms_convert_bin_id ("wms";"FG:R_SAMPLES")+" for "+"FG:R_SAMPLES")
//utl_LogIt (wms_convert_bin_id ("wms";"SC:R_QA")+" for "+"SC:R_QA")
//utl_LogIt (wms_convert_bin_id ("wms";"SC:R_REJECT")+" for "+"SC:R_REJECT")
//utl_LogIt (wms_convert_bin_id ("wms";"SC:R_Kill")+" for "+"SC:R_Kill")
//utl_LogIt (wms_convert_bin_id ("wms";"SC:R_Bill_n_Destroy")+" for "+"SC:R_Bill_n_Destroy")
//utl_LogIt (wms_convert_bin_id ("wms";"FG:R_UNKNOWN")+" for "+"FG:R_UNKNOWN")
//utl_LogIt (wms_convert_bin_id ("wms";"FG:R_CUSTOMER_WHS")+" for "+"FG:R_CUSTOMER_WHS")
//utl_LogIt (wms_convert_bin_id ("wms";"FG:R_OUTSIDE_SERVICE")+" for "+"FG:R_OUTSIDE_SERVICE")
//utl_LogIt (wms_convert_bin_id ("wms";"PX:R17-001-01")+" for "+"PX:R17-001-01")
//utl_LogIt ("show")

//ALERT(TS2String (TSTimeStamp (!01/01/29!;†23:59:59†)))
//ALERT(String(TSTimeStamp (!01/01/29!;†23:59:59†)))

//ALERT(Table name(35))

//$barcodeValue:=WMS_SkidId ("";"set";"2";0)
//SSCC_HumanReadable:=WMS_SkidId ($barcodeValue;"human")
//SSCC_Barcode:=WMS_SkidId (SSCC_HumanReadable;"barcode")

//ALERT(String(Table(->[Work_Orders])))
//distributionList:=Email_WhoAmI ("";"VS")
//QUERY([Users];[Users]Initials="VS")
//distributionList:=Email_WhoAmI ([Users]UserName)
//utl_LogIt ("init")
//$test1:="x1234Zn"MM DD YYYY
//$assert1:="EBDNBAAIMAFJCAGAMIIGAHABMAIGIAH"
//$result1:=BarCode_128auto ($test1)
//If ($assert1=$result1)
//$pass1:="PASS"
//Else 
//$pass1:="FAIL"
//End if 
//utl_LogIt ($test1+Char(13)+$result1+Char(13)+$assert1+Char(13)+$pass1+Char(13))
//
//$test2:="Ê4021234567890123456"  `~m16"
//$chkMod10:=fBarCodeMod10Digit ($test2)
//$assert2:="EBJMAIGACEJBIEIAIGDAFEEMFEFIEIAIGIMAEEGGIAH"
//$result2:=BarCode_128auto ($test2+$chkMod10)
//If ($assert2=$result2)
//$pass2:="PASS"
//Else 
//$pass2:="FAIL"
//End if 
//utl_LogIt ($test2+Char(13)+$result2+Char(13)+$assert2+Char(13)+$pass2+Char(13))
//
//  `~2148000801~20299999~m05
//$test3:=Char(214)+"8000801"+Char(202)+"99999"  `~m05"
//$chkMod10:=fBarCodeMod10Digit ("99999")
//$assert3:="EBJMAIABNEFFABNAMIBJEMAIAIMAIMAIMMEEAFJGIAH"
//$result3:=BarCode_128auto ($test3+$chkMod10)
//If ($assert3=$result3)
//$pass3:="PASS"
//Else 
//$pass3:="FAIL"
//End if 
//utl_LogIt ($test3+Char(13)+$result3+Char(13)+$assert3+Char(13)+$pass3+Char(13))
//utl_LogIt ("show")
//$x:=Request("Timestamp:";String(TSTimeStamp ))

//◊fContinue:=True
//CONFIRM("Delete unused skids?")
//If (OK=1)
//ams_DeleteWithoutHeaderRecord (->[WMS_ItemMaster]LOT;->[FG_Locations]Jobit)  `{;keepSetName})
//End if 
//JMI_ontimeTest ("@";!07/27/04!)
//Job_GluingStatus ("mel.bohince@arkay.com")

//e_Try 
//x:=12/0
//If (e_Catch (x))
//BEEP
//End if 
//$print:=fBarCode128mix ("9195100613";"3736000")
//xText:=ftp_service 
//Repeat 
//REL_NoWeekEnds 
//JMI_excessPromoGlued (!06/14/05!)
//utl_LogIt ("init")
//utl_LogIt (util_fractionToDecimal ("11~1/8"))
//utl_LogIt (util_fractionToDecimal ("9-1/4"))
//utl_LogIt (util_fractionToDecimal ("11/16"))
//utl_LogIt (util_fractionToDecimal ("6 5/8"))
//utl_LogIt (util_fractionToDecimal ("9.25"))
//For ($sheets;1000;50000;500)
//$noRound:=CostCtr_RunHrsTransient ($sheets;0)
//$qtrRound:=CostCtr_RunHrsTransient ($sheets;25)
//utl_LogIt (String($sheets)+Char(9)+String($noRound)+Char(9)+String($qtrRound))
//End for 

//utl_LogIt ("show")
//ALERT(BarCodeBeta_128b ($data))
//Until ($data="quit")
//ALERT("raw:"+Char(202)+" m2w:"+Mac to Win(Char(202))+" w2m:"+Win to Mac(Char(202)))
//ALERT("raw:"+Char(230)+" m2w:"+Mac to Win(Char(230))+" w2m:"+Win to Mac(Char(230)))
//Begin
//REL_noticeOfOntimeMiss ("";!12/11/03!)
//$e:=Email_WhoAmI ("";"sgb")
//$ftpId:=ftp_intranetLogin ("specs")

//$ftpId:=ftp_intranetLogout 
//CREATE SET([JobMakesItem];"closedJMIs2")
//util_SetSaver ("save";Table(->[JobMakesItem]);"closedJMIs2")
//CLEAR SET("closedJMIs2")
//REDUCE SELECTION([JobMakesItem];0)
//MODIFY SELECTION([JobMakesItem])


//util_SetSaver ("restore";Table(->[JobMakesItem]);"Jimi")
//MODIFY SELECTION([JobMakesItem])
//x:=Current machine owner
//PLATFORM PROPERTIES(p;s;m)
//y:=Current machine
//zwStatusMsg ("0test";"finished")
//◊FloatingAlert_PID:=0
//util_FloatingAlert ("wake up")
//xtext:=util_DocumentPath 
//$winRef:=Open form window([CONTROL];"eBagFlow_dio")
//DIALOG([CONTROL];"eBagFlow_dio")
//$path:=Select folder
//◊mewLeft:=10
//◊mewTop:=48
//◊mewRight:=514
//◊mewBottom:=344
BEEP:C151
If (False:C215)  //$start:=Current time  
	//x:=util_SetSaver ("restore";Table(->[JobMakesItem]);"closedJMIs")
	//MODIFY SELECTION([JobMakesItem])
	//PS_MakeReadyTimer (1)
	
	//PS_MakeReadyTimerSet (5*60)
	//PS_MakeReadyTimerStart 
	//$sec:=PS_MakeReadyTimerStop 
	
	//PS_MakeReadyTimer (0)
	
	FG_PrepServiceSummaryRpt("mel.bohince@arkay.com"; !2002-11-01!; !2002-11-30!)
	
	ALL RECORDS:C47([Raw_Materials:21])
	CREATE SET:C116([Raw_Materials:21]; "all")
	ALL RECORDS:C47([Raw_Materials_Groups:22])
	util_outerJoin(->[Raw_Materials:21]Commodity_Key:2; ->[Raw_Materials_Groups:22]Commodity_Key:3)
	zwStatusMsg("0test"; String:C10(Records in selection:C76([Raw_Materials:21])))
	CREATE SET:C116([Raw_Materials:21]; "good")
	DIFFERENCE:C122("all"; "good"; "orph")
	USE SET:C118("orph")
	CLEAR SET:C117("orph")
	CLEAR SET:C117("good")
	CLEAR SET:C117("all")
	
	
	ALERT:C41(String:C10(util_Stat_NORMDIST(42; 40; 1.5; True:C214))+"")
	$hits:=JOB_getOutlineNumbers("80669.11")
	FG_NoticeOfOldInventory(90; "JCK"; 1)
	$path:=GetDefaultPath
	zwStatusMsg("Test"; $path)
	$EstPath:=Select folder:C670("'Select' the Estimate's folder.")
	$err:=HFSCatToArray2($EstPath; ->aMembers)
	<>volume:=GetDTVolumeName("Pick volume to save [ESTIMATE]'s to.")
	$err:=SetDefaultPath(<>purgeFolderPath)
	$err:=NewFolder("testFolder")
	//$err:=HFSExists ("testFolder")Test path name()
	//$Path:=GetFileName2 ("Select Budget Data";"TEXT")
	xTitle:="Supply & Demand"
	xText:=""
	
	util_outerJoin(->[Finished_Goods:26]ProductCode:1; ->[Customers_ReleaseSchedules:46]ProductCode:11)
	
	FIRST RECORD:C50([Finished_Goods:26])
	For ($i; 1; Records in selection:C76([Finished_Goods:26]))
		xText:=xText+FG_SupplyAndDemand([Finished_Goods:26]FG_KEY:47)
		NEXT RECORD:C51([Finished_Goods:26])
	End for 
	
	
	rPrintText("0test")
	
	READ WRITE:C146([To_Do_Tasks_Sets:99])
	QUERY:C277([To_Do_Tasks_Sets:99]; [To_Do_Tasks_Sets:99]Category:2="")
	DELETE SELECTION:C66([To_Do_Tasks_Sets:99])
	
	ALL RECORDS:C47([To_Do_Tasks_Sets:99])
	While (Not:C34(End selection:C36([To_Do_Tasks_Sets:99])))
		Case of 
			: ([To_Do_Tasks_Sets:99]Category:2="JobBagTooling@")
				[To_Do_Tasks_Sets:99]Task:3:=Substring:C12(Substring:C12([To_Do_Tasks_Sets:99]Category:2; 15; 1)+" "+[To_Do_Tasks_Sets:99]Task:3; 1; 40)
				[To_Do_Tasks_Sets:99]Category:2:="JobBagTooling"
				
			: ([To_Do_Tasks_Sets:99]Category:2="R.)")
				[To_Do_Tasks_Sets:99]Category:2:="Repeat"
				[To_Do_Tasks_Sets:99]Task:3:="Repeat Job - Previous Tooling Located"
				
			: (Length:C16([To_Do_Tasks_Sets:99]Category:2)<7)
				[To_Do_Tasks_Sets:99]Task:3:=Substring:C12([To_Do_Tasks_Sets:99]Category:2+" "+[To_Do_Tasks_Sets:99]Task:3; 1; 40)
				[To_Do_Tasks_Sets:99]Category:2:="Orignal"
		End case 
		SAVE RECORD:C53([To_Do_Tasks_Sets:99])
		NEXT RECORD:C51([To_Do_Tasks_Sets:99])
	End while 
	REDUCE SELECTION:C351([To_Do_Tasks_Sets:99]; 0)
	
	READ WRITE:C146([To_Do_Tasks:100])
	QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]DateDue:10<!2002-04-01!)
	DELETE SELECTION:C66([To_Do_Tasks:100])
	
	READ ONLY:C145([Job_Forms_Machines:43])
	READ WRITE:C146([ProductionSchedules:110])
	//QUERY([PressSchedule];[PressSchedule]PrevOp="")
	ALL RECORDS:C47([ProductionSchedules:110])
	For ($i; 1; Records in selection:C76([ProductionSchedules:110]))
		$err:=Job_getPrevNextOperation([ProductionSchedules:110]JobSequence:8; ->[ProductionSchedules:110]AllOperations:14)
		[ProductionSchedules:110]NumSubForms:16:=JMI_getNumSubforms(Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8))
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=(Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)))
		If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
			If ([Job_Forms_Master_Schedule:67]DateInkRecd:40#!00-00-00!)
				[ProductionSchedules:110]InkReady:20:=[Job_Forms_Master_Schedule:67]DateInkRecd:40
			End if 
		End if 
		
		SAVE RECORD:C53([ProductionSchedules:110])
		NEXT RECORD:C51([ProductionSchedules:110])
	End for 
	
	$color:=util_colorPicker(-15)
	
	
	BEEP:C151
	
	
	If (Current date:C33<=!2002-03-12!)
		READ ONLY:C145([Customers:16])
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Salesman:1="")
		For ($i; 1; Records in selection:C76([Job_Forms_Master_Schedule:67]))
			QUERY:C277([Customers:16]; [Customers:16]Name:2=[Job_Forms_Master_Schedule:67]Customer:2)
			If (Records in selection:C76([Customers:16])>0)
				[Job_Forms_Master_Schedule:67]Salesman:1:=[Customers:16]SalesmanID:3
				REDUCE SELECTION:C351([Customers:16]; 0)
				SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
			End if 
			NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
		End for 
	End if 
	
	$lead:=4D_Current_date
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42#!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42<=$lead; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!)
	
	
	C_TEXT:C284($fo)
	$fo:=ZebraLabelGrid("init")
	
	ALERT:C41(ZebraLabelGrid("at"; 4*8; 6*8))
	ALERT:C41(ZebraLabelGrid("at"; 1*8; 1*8))
	
	
	
	$chkDigit:=fBarCodeMod10Digit("0010808292000002606")
	
	ALL RECORDS:C47([Finished_Goods_PackingSpecs:91])
	util_outerJoin(->[Finished_Goods:26]OutLine_Num:4; ->[Finished_Goods_PackingSpecs:91]FileOutlineNum:1)
	
	
	t1:=util_SelectionToText(->[Purchase_Orders_Items:12]ReqdDate:8)
	utl_LogIt("init")
	utl_LogIt(t1)
	utl_LogIt("show")
	
	$time:=4d_Current_time+(60*2)
	zwStatusMsg("EMAIL"; "Receive scheduled for "+Time string:C180($time))
	
	For ($i; 0; 200)
		$Case:=util_base26($i)
	End for 
	$test:=fBarCodeMod10Digit("0010037000400000001")  //8
	
	$test:=fBarCodeMod10Digit("0010037000400118485")  //4
	
	$test:=fBarCodeMod10Digit("0010073291830003683")  //6
	//ALL RECORDS([MachineTicket])
	//CREATE SET([MachineTicket];"ALL")
	//ALL RECORDS([JobForm])
	//uRelateSelect (->[MachineTicket]JobForm;->[JobForm]JobFormID)
	//CREATE SET([MachineTicket];"RELATIONS")
	//DIFFERENCE("ALL";"RELATIONS";"UNRELATED")
	//USE SET("UNRELATED")
	//DELETE SELECTION([MachineTicket])
	
	//JobCloseOut3rdPage ("77551.01")
	//QM_Sender ("subject";"";"this is the body";"Bohince|Mel";"Bookings000322")
	//C_REAL(malt;labor;burden)
	//JIC_Relieve ("00125:20-036300-03";1;->malt;->labor;->burden)
	
	//QM_Sender ("SubjectHere";"";"BodyHere";"Mel Bohince"+Char(9)+"melbohince@att.net
	
	//ALERT("elapse "+String((Current time-$start);HH MM SS))
	
	//uRelateSelect (->[ReleaseSchedule]ProductCode;->[FG_Locations]ProductCode)
	
	//Est_ChangeRates 
	
	//$test:=Current date
	//Repeat 
	//$PurgeDate:=Date(FiscalYear ("start";$test))
	//TRACE
	//$PurgeDate:=Add to date($PurgeDate;-1;0;0)
	//$test:=Date(Request("date:"))
	//Until ($test=!00/00/00!)
	//uPurgeEstOrphs (->[DifferentialForm]DiffFormId)
	
	//Remove the transaction that are obviously not wanted
	//iBeginAt:=128364323
	//TS2DateTime (iBeginAt;->dDateBegin;->tTimeBegin)
	//  `SET QUERY DESTINATION(Into set;"Candidates")
	//QUERY([FG_Transactions];[FG_Transactions]JobForm # "@.sb";*)  `dont want
	//« special billings
	//QUERY([FG_Transactions]; & ;[FG_Transactions]XactionType # "MOVE";*)  
	//«`don't want move transactions
	//QUERY([FG_Transactions]; & ;[FG_Transactions]JobForm # "Price@";*)  `don't
	//« want price changes
	//QUERY([FG_Transactions]; & ;[FG_Transactions]XactionDate>=dDateBegin;*)  
	//«`not the day before
	//QUERY([FG_Transactions]; & ;[FG_Transactions]JobForm="77416.02")  `not the
	//« day before
	//CREATE SET([FG_Transactions];"Candidates")
	//TRACE
	//  `remove the trans prior to last TIME
	//  `SET QUERY DESTINATION(Into set;"beforeLast")
	//QUERY SELECTION([FG_Transactions];[FG_Transactions]XactionDate=dDateBegin;
	//«*)
	//QUERY SELECTION([FG_Transactions]; & ;[FG_Transactions
	//«]XactionTime<tTimeBegin)
	//CREATE SET([FG_Transactions];"beforeLast")
	//DIFFERENCE("Candidates";"beforeLast";"Candidates")
	//CLEAR SET("beforeLast")
	//  `SET QUERY DESTINATION(Into current selection)
	//USE SET("Candidates")
	
	
	If (Modifiers ?? Option key bit:K16:8)
		BEEP:C151
		OBJECT SET TITLE:C194(bPrint; "Form")
		//REDRAW
		//Else 
		BEEP:C151
		BEEP:C151
		OBJECT SET TITLE:C194(bPrint; "Print")
		//REDRAW
	End if 
End if 

//
//