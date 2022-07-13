//%attributes = {}

C_TEXT:C284($result; $tQPlan; $tQPath)
DESCRIBE QUERY EXECUTION:C1044(True:C214)

//Boolean part

QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]BudgetBuster:48=False:C215)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

QUERY:C277([Customers:16]; [Customers:16]Active:15=False:C215)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]NewFromReq:42=False:C215)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"


QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]THC_update_required:115=False:C215)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

QUERY:C277([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]SpecialBilling:38=False:C215)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//end Boolean part

//[Max]=10 [VMax]=00121:Amber Bronze Set 1 [Filed_Type}=Is alpha [NbRecord]:608 [Index_selectivity]:1,737142857143
QUERY:C277([Job_Forms_Production_Histories:121]; [Job_Forms_Production_Histories:121]ProcessSpecKey:1="00121:Amber Bronze Set 1")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=8 [VMax]=27/12/2015 [Filed_Type}=Is date [NbRecord]:519 [Index_selectivity]:6,653846153846
QUERY:C277([ProductionSchedules_Shifts:180]; [ProductionSchedules_Shifts:180]ShiftDate:1=!2015-12-27!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=9 [VMax]=14 [Filed_Type}=Is alpha [NbRecord]:14 [Index_selectivity]:4,666666666667
QUERY:C277([Purchase_Order_Comm_Clauses:83]; [Purchase_Order_Comm_Clauses:83]Clause:2="14")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=9 [VMax]=100-400 [Filed_Type}=Is alpha [NbRecord]:20 [Index_selectivity]:3,333333333333
QUERY:C277([QA_Section:109]; [QA_Section:109]ProcedureId:1="100-400")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=4 [VMax]=W-1827 [Filed_Type}=Is alpha [NbRecord]:166 [Index_selectivity]:2,128205128205
QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Parent_Raw_Matl:1="W-1827")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=3 [VMax]=20110302,16262 [Filed_Type}=Is real [NbRecord]:3 [Index_selectivity]:3
QUERY:C277([ZZ_PNGA_Users:172]; [ZZ_PNGA_Users:172]ModificationDateTime:8=20110302.16262)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=10 [VMax]=00199 [Filed_Type}=Is alpha [NbRecord]:53 [Index_selectivity]:3,533333333333
QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]custId:3="00199")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=10 [VMax]=PressPerf [Filed_Type}=Is alpha [NbRecord]:175 [Index_selectivity]:3,070175438596
QUERY:C277([y_batch_distributions:164]; [y_batch_distributions:164]BatchName:1="PressPerf")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2 [VMax]=JIC_NetChg [Filed_Type}=Is alpha [NbRecord]:6 [Index_selectivity]:1,2
QUERY:C277([z_batch_run_dates:77]; [z_batch_run_dates:77]BatchType:4="JIC_NetChg")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2 [VMax]=Scheduled [Filed_Type}=Is alpha [NbRecord]:4 [Index_selectivity]:1,333333333333
QUERY:C277([Work_Orders:37]; [Work_Orders:37]Status:8="Scheduled")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"


//[Max]=3 [VMax]= [Filed_Type}=Is alpha [NbRecord]:4 [Index_selectivity]:2
QUERY:C277([Purchase_Order_TradeIns:72]; [Purchase_Order_TradeIns:72]VendorId:1="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=12 [VMax]=84 [Filed_Type}=Is integer [NbRecord]:198 [Index_selectivity]:3,6
QUERY:C277([y_accounting_dept_commodities:89]; [y_accounting_dept_commodities:89]CommodityCode:1=84)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=12 [VMax]=00199:91365113 [Filed_Type}=Is alpha [NbRecord]:5847 [Index_selectivity]:1,710649502633
QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13="00199:91365113")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=12 [VMax]=01500:PBX-132 [Filed_Type}=Is alpha [NbRecord]:43893 [Index_selectivity]:1,431091258844
QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1="01500:PBX-132")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=13 [VMax]=0216881 [Filed_Type}=Is alpha [NbRecord]:6463 [Index_selectivity]:1,515002344116
QUERY:C277([Purchase_Orders_Chg_Orders:13]; [Purchase_Orders_Chg_Orders:13]PONo:3="0216881")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=13 [VMax]=7-0309.00AL05 [Filed_Type}=Is alpha [NbRecord]:199596 [Index_selectivity]:5,420858229223
QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1="7-0309.00AL05")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=13 [VMax]=Misc [Filed_Type}=Is alpha [NbRecord]:227 [Index_selectivity]:1,39263803681
QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]SubGroup:10="Misc")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=13 [VMax]= [Filed_Type}=Is alpha [NbRecord]:2283 [Index_selectivity]:1,180455015512
QUERY:C277([Contacts:51]; [Contacts:51]LastName:26="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=15 [VMax]=93469.01 [Filed_Type}=Is alpha [NbRecord]:67765 [Index_selectivity]:5,582880210908
QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1="93469.01")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=16 [VMax]=ICF2-100 [Filed_Type}=Is alpha [NbRecord]:185 [Index_selectivity]:3,083333333333
QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1="ICF2-100")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=18 [VMax]=00566 [Filed_Type}=Is alpha [NbRecord]:2270 [Index_selectivity]:1,546321525886
QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2="00566")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=18 [VMax]=17224.01 [Filed_Type}=Is alpha [NbRecord]:81607 [Index_selectivity]:1,319967650627
QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]OrderLine:4="17224.01")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=21 [VMax]=95807 [Filed_Type}=Is longint [NbRecord]:12139 [Index_selectivity]:1,462353933261
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=95807)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=22 [VMax]=42434810 [Filed_Type}=Is alpha [NbRecord]:3956 [Index_selectivity]:1,515128303332
QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]ProductCode:7="42434810")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=22 [VMax]=00199:42434810 [Filed_Type}=Is alpha [NbRecord]:3956 [Index_selectivity]:1,515128303332
QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]FGKey:8="00199:42434810")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=26 [VMax]=01-Special B&P [Filed_Type}=Is alpha [NbRecord]:123 [Index_selectivity]:4,730769230769
QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Commodity_Key:12="01-Special B&P")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=27 [VMax]=Sig 5+BCK+emb [Filed_Type}=Is alpha [NbRecord]:12000 [Index_selectivity]:5,847953216374
QUERY:C277([Process_Specs_Machines:28]; [Process_Specs_Machines:28]ProcessSpec:1="Sig 5+BCK+emb")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=28 [VMax]=021656101 [Filed_Type}=Is alpha [NbRecord]:536 [Index_selectivity]:6,16091954023
QUERY:C277([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]POitemKey:1="021656101")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=28 [VMax]=A008633 [Filed_Type}=Is alpha [NbRecord]:20838 [Index_selectivity]:2,690510006456
QUERY:C277([Finished_Goods_SnS_Additions:150]; [Finished_Goods_SnS_Additions:150]FileOutlineNum:1="A008633")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=33 [VMax]=Ac1944 [Filed_Type}=Is alpha [NbRecord]:166 [Index_selectivity]:6,64
QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Compnt_Raw_Matl:2="Ac1944")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=35 [VMax]= [Filed_Type}=Is alpha [NbRecord]:53 [Index_selectivity]:2,944444444444
QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]name:2="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=36 [VMax]=Blocked [Filed_Type}=Is alpha [NbRecord]:928 [Index_selectivity]:1,039193729003
QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8="Blocked")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=39 [VMax]=258003 [Filed_Type}=Is alpha [NbRecord]:4230 [Index_selectivity]:2,418524871355
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1="258003")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=39 [VMax]=00074:258003 [Filed_Type}=Is alpha [NbRecord]:4230 [Index_selectivity]:2,417142857143
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34="00074:258003")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=40 [VMax]= [Filed_Type}=Is alpha [NbRecord]:40 [Index_selectivity]:40
QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]PjtNumber:3="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=41 [VMax]=00032 [Filed_Type}=Is alpha [NbRecord]:585 [Index_selectivity]:10,08620689655
QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3="00032")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=42 [VMax]=C144351 [Filed_Type}=Is alpha [NbRecord]:168333 [Index_selectivity]:5,460570279301
QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1="C144351")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=43 [VMax]=18/07/2016 [Filed_Type}=Is date [NbRecord]:22657 [Index_selectivity]:16,2183249821
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PODate:4=!2016-07-18!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=44 [VMax]=0226555 [Filed_Type}=Is alpha [NbRecord]:57110 [Index_selectivity]:2,519855277091
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PONo:2="0226555")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=44 [VMax]=97738 [Filed_Type}=Is longint [NbRecord]:9710 [Index_selectivity]:2,43908565687
QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]OrderNo:5=97738)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=45 [VMax]=7-0535.00 [Filed_Type}=Is alpha [NbRecord]:22629 [Index_selectivity]:1,448626848473
QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1="7-0535.00")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=45 [VMax]=12082.02 [Filed_Type}=Is alpha [NbRecord]:32703 [Index_selectivity]:4,686586414445
QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]JobFormID:2="12082.02")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=46 [VMax]=Sig 5+BCK+emb [Filed_Type}=Is alpha [NbRecord]:25482 [Index_selectivity]:12,47894221352
QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1="Sig 5+BCK+emb")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=47 [VMax]=01-SPECIAL B&P [Filed_Type}=Is alpha [NbRecord]:185 [Index_selectivity]:18,5
QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]commdityKey:13="01-SPECIAL B&P")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=47 [VMax]=-15075 [Filed_Type}=Is longint [NbRecord]:574 [Index_selectivity]:4,381679389313
QUERY:C277([ug_UsersInGroups:142]; [ug_UsersInGroups:142]userID:1=-15075)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=48 [VMax]=8-1387.03 [Filed_Type}=Is alpha [NbRecord]:24421 [Index_selectivity]:1,577074588311
QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2="8-1387.03")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=48 [VMax]=02845 [Filed_Type}=Is alpha [NbRecord]:488 [Index_selectivity]:4,436363636364
QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]PjtNumber:5="02845")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=50 [VMax]=83625.01.03 [Filed_Type}=Is alpha [NbRecord]:144 [Index_selectivity]:7,578947368421
QUERY:C277([Job_Forms_Items_CertOfAnal:117]; [Job_Forms_Items_CertOfAnal:117]Jobit:1="83625.01.03")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=50 [VMax]=116278 [Filed_Type}=Is longint [NbRecord]:80882 [Index_selectivity]:2,948024493366
QUERY:C277([Customers_Bills_of_Lading_Manif:181]; [Customers_Bills_of_Lading_Manif:181]id_added_by_converter:16=116278)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=51 [VMax]=RT SBS.18.28 [Filed_Type}=Is alpha [NbRecord]:536 [Index_selectivity]:13,4
QUERY:C277([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]RM_Code:7="RT SBS.18.28")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=56 [VMax]=promo [Filed_Type}=Is alpha [NbRecord]:1905 [Index_selectivity]:1,097350230415
QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]Name:2="promo")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=56 [VMax]=12300.01 [Filed_Type}=Is alpha [NbRecord]:47820 [Index_selectivity]:3,943592281049
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1="12300.01")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=56 [VMax]=12300.01 [Filed_Type}=Is alpha [NbRecord]:5847 [Index_selectivity]:4,376497005988
QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]JobForm:1="12300.01")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=62 [VMax]=12/03/1994 [Filed_Type}=Is date [NbRecord]:585 [Index_selectivity]:2,457983193277
QUERY:C277([Usage_Problem_Reports:84]; [Usage_Problem_Reports:84]Created:2=!1994-03-12!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=63 [VMax]=12484.01 [Filed_Type}=Is alpha [NbRecord]:4230 [Index_selectivity]:4,504792332268
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19="12484.01")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=65 [VMax]=7-0535.00AA [Filed_Type}=Is alpha [NbRecord]:36902 [Index_selectivity]:1,510581685701
QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1="7-0535.00AA")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=70 [VMax]=452 [Filed_Type}=Is alpha [NbRecord]:928 [Index_selectivity]:33,14285714286
QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1="452")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=70 [VMax]=-15071 [Filed_Type}=Is longint [NbRecord]:574 [Index_selectivity]:7,358974358974
QUERY:C277([ug_UsersInGroups:142]; [ug_UsersInGroups:142]groupID:2=-15071)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=74 [VMax]=E0XF-01-0114 [Filed_Type}=Is alpha [NbRecord]:47820 [Index_selectivity]:3,211120064464
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3="E0XF-01-0114")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=78 [VMax]=414 [Filed_Type}=Is alpha [NbRecord]:519 [Index_selectivity]:64,875
QUERY:C277([ProductionSchedules_Shifts:180]; [ProductionSchedules_Shifts:180]Dept:4="414")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=85 [VMax]=7-0412.00AB01 [Filed_Type}=Is alpha [NbRecord]:128449 [Index_selectivity]:3,502167570957
QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2="7-0412.00AB01")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=85 [VMax]= [Filed_Type}=Is alpha [NbRecord]:85 [Index_selectivity]:85
QUERY:C277([WMS_ItemMasters:123]; [WMS_ItemMasters:123]PalletID:11="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=86 [VMax]=LHC [Filed_Type}=Is alpha [NbRecord]:359 [Index_selectivity]:25,64285714286
QUERY:C277([Customers:16]; [Customers:16]SalesmanID:3="LHC")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=88 [VMax]=7-2083.09AQ06 [Filed_Type}=Is alpha [NbRecord]:479874 [Index_selectivity]:12,85870468126
QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1="7-2083.09AQ06")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=90 [VMax]=00121 [Filed_Type}=Is alpha [NbRecord]:361 [Index_selectivity]:30,08333333333
QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1="00121")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=98 [VMax]=19673 [Filed_Type}=Is longint [NbRecord]:67688 [Index_selectivity]:1,571034002553
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=19673)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=110 [VMax]=23/06/2017 [Filed_Type}=Is date [NbRecord]:11028 [Index_selectivity]:12,61784897025
QUERY:C277([Job_Forms_CloseoutSummaries:87]; [Job_Forms_CloseoutSummaries:87]CloseDate:19=!2017-06-23!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=123 [VMax]=Roanoke [Filed_Type}=Is alpha [NbRecord]:123 [Index_selectivity]:123
QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Location:2="Roanoke")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=123 [VMax]=2 [Filed_Type}=Is alpha [NbRecord]:123 [Index_selectivity]:123
QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]CompanyID:27="2")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=126 [VMax]=02017.01 [Filed_Type}=Is alpha [NbRecord]:181043 [Index_selectivity]:14,77540194238
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1="02017.01")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=130 [VMax]=15/08/2018 [Filed_Type}=Is date [NbRecord]:57110 [Index_selectivity]:40,88045812455
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40=!2018-08-15!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=138 [VMax]=n6P-5500015567 [Filed_Type}=Is alpha [NbRecord]:89293 [Index_selectivity]:1,34168256878
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="n6P-5500015567")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=139 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:928 [Index_selectivity]:10,08695652174
QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=170 [VMax]=GG [Filed_Type}=Is alpha [NbRecord]:361 [Index_selectivity]:90,25
QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]SalesmanId:4="GG")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=185 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:5902 [Index_selectivity]:7,268472906404
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=188 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:12139 [Index_selectivity]:7,1913507109
QUERY:C277([Job_Forms:42]; [Job_Forms:42]Completed:18=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=207 [VMax]=01/01/2001 [Filed_Type}=Is date [NbRecord]:5902 [Index_selectivity]:6,799539170507
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Printed:32=!2001-01-01!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=208 [VMax]=31/07/2017 [Filed_Type}=Is date [NbRecord]:81607 [Index_selectivity]:52,68366688186
QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7=!2017-07-31!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=243 [VMax]=00074 [Filed_Type}=Is alpha [NbRecord]:2270 [Index_selectivity]:21,41509433962
QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1="00074")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=249 [VMax]=62A4-01-011A [Filed_Type}=Is alpha [NbRecord]:89293 [Index_selectivity]:6,72083396056
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11="62A4-01-011A")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=254 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:359 [Index_selectivity]:3,38679245283
QUERY:C277([Customers:16]; [Customers:16]zNotUsed:24=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=254 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:359 [Index_selectivity]:3,38679245283
QUERY:C277([Customers:16]; [Customers:16]z_futureSubfile:25=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=254 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:359 [Index_selectivity]:3,38679245283
QUERY:C277([Customers:16]; [Customers:16]Correspondence:26=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=254 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:359 [Index_selectivity]:3,38679245283
QUERY:C277([Customers:16]; [Customers:16]OtherInfo:27=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=254 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:359 [Index_selectivity]:3,38679245283
QUERY:C277([Customers:16]; [Customers:16]zNotUsed2:28=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=310 [VMax]= [Filed_Type}=Is alpha [NbRecord]:490 [Index_selectivity]:2,707182320442
QUERY:C277([Users:5]; [Users:5]UserName:11="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=333 [VMax]=00074 [Filed_Type}=Is alpha [NbRecord]:1905 [Index_selectivity]:7,904564315353
QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]Customerid:3="00074")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=333 [VMax]=Elizabeth Arden Inc. CT [Filed_Type}=Is alpha [NbRecord]:1905 [Index_selectivity]:7,743902439024
QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]CustomerName:4="Elizabeth Arden Inc. CT")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=336 [VMax]=00074 [Filed_Type}=Is alpha [NbRecord]:1615 [Index_selectivity]:12,05223880597
QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1="00074")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=336 [VMax]=03771 [Filed_Type}=Is alpha [NbRecord]:5902 [Index_selectivity]:15,73866666667
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]ProjectNumber:26="03771")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=359 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:359 [Index_selectivity]:359
QUERY:C277([Customers:16]; [Customers:16]Label_ID:41=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=364 [VMax]=200-48x65 [Filed_Type}=Is alpha [NbRecord]:1764 [Index_selectivity]:7,229508196721
QUERY:C277([WMS_WarehouseOrders:146]; [WMS_WarehouseOrders:146]RawMatlCode:2="200-48x65")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=385 [VMax]=TBC new [Filed_Type}=Is alpha [NbRecord]:226242 [Index_selectivity]:13,25222586692
QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]ProductCode:5="TBC new")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=409 [VMax]=Olay Age Defying [Filed_Type}=Is alpha [NbRecord]:24421 [Index_selectivity]:6,174715549937
QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]ProcessSpec:5="Olay Age Defying")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=409 [VMax]=Olay Age Defying [Filed_Type}=Is alpha [NbRecord]:22629 [Index_selectivity]:4,710449625312
QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2="Olay Age Defying")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=411 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:89293 [Index_selectivity]:39,12927256792
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=411 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:5902 [Index_selectivity]:6,737442922374
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=413 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:5902 [Index_selectivity]:7,52806122449
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]MAD:21=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=427 [VMax]= [Filed_Type}=Is alpha [NbRecord]:3956 [Index_selectivity]:14,23021582734
QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]Location:6="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=432 [VMax]= [Filed_Type}=Is alpha [NbRecord]:5902 [Index_selectivity]:9,628058727569
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Line:5="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=451 [VMax]=21/06/2018 [Filed_Type}=Is date [NbRecord]:67688 [Index_selectivity]:35,62526315789
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13=!2018-06-21!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=466 [VMax]=ph [Filed_Type}=Is alpha [NbRecord]:4189 [Index_selectivity]:64,44615384615
QUERY:C277([Users_Record_Accesses:94]; [Users_Record_Accesses:94]UserInitials:1="ph")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=481 [VMax]=XMAS [Filed_Type}=Is alpha [NbRecord]:2308 [Index_selectivity]:82,42857142857
QUERY:C277([Contacts_Tags:183]; [Contacts_Tags:183]UserID:1="XMAS")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=499 [VMax]= [Filed_Type}=Is alpha [NbRecord]:31580 [Index_selectivity]:3,557908968004
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OutLine_Num:4="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=559 [VMax]=Gabriel Palin [Filed_Type}=is text [NbRecord]:8912 [Index_selectivity]:67,00751879699
QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2="Gabriel Palin")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=662 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:47820 [Index_selectivity]:27,68963520556
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=673 [VMax]=other [Filed_Type}=Is alpha [NbRecord]:67688 [Index_selectivity]:4,732433755156
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5="other")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=696 [VMax]=02540 [Filed_Type}=Is alpha [NbRecord]:8301 [Index_selectivity]:15,3438077634
QUERY:C277([Jobs:15]; [Jobs:15]ProjectNumber:18="02540")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=696 [VMax]=7-1994.02 [Filed_Type}=Is alpha [NbRecord]:226242 [Index_selectivity]:14,47022705469
QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2="7-1994.02")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=696 [VMax]=02540 [Filed_Type}=Is alpha [NbRecord]:12139 [Index_selectivity]:22,39667896679
QUERY:C277([Job_Forms:42]; [Job_Forms:42]ProjectNumber:56="02540")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=708 [VMax]=1 [Filed_Type}=Is integer [NbRecord]:5847 [Index_selectivity]:60,27835051546
QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]ItemNumber:2=1)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=801 [VMax]= [Filed_Type}=Is alpha [NbRecord]:11028 [Index_selectivity]:16,26548672566
QUERY:C277([Job_Forms_CloseoutSummaries:87]; [Job_Forms_CloseoutSummaries:87]Line:3="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=833 [VMax]=01813 [Filed_Type}=Is alpha [NbRecord]:15601 [Index_selectivity]:25,0016025641
QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63="01813")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=928 [VMax]= [Filed_Type}=Is alpha [NbRecord]:928 [Index_selectivity]:928
QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]PurchaseOrder:34="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=990 [VMax]=01813 [Filed_Type}=Is alpha [NbRecord]:15465 [Index_selectivity]:15,74847250509
QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]ProjectNumber:2="01813")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1103 [VMax]=00050 [Filed_Type}=Is alpha [NbRecord]:4230 [Index_selectivity]:136,4516129032
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16="00050")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1117 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:47820 [Index_selectivity]:30,34263959391
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]MAD:37=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1546 [VMax]= [Filed_Type}=Is alpha [NbRecord]:3956 [Index_selectivity]:10,57754010695
QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]ReasonId:15="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1579 [VMax]=10/11/2016 [Filed_Type}=Is date [NbRecord]:110312 [Index_selectivity]:110,6439317954
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3=!2016-11-10!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1622 [VMax]=00000.sb.00 [Filed_Type}=Is alpha [NbRecord]:634587 [Index_selectivity]:27,59313853379
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31="00000.sb.00")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1667 [VMax]=99796.03 [Filed_Type}=Is alpha [NbRecord]:634587 [Index_selectivity]:109,3926909154
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5="99796.03")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1700 [VMax]=DELETE [Filed_Type}=Is alpha [NbRecord]:2157 [Index_selectivity]:8,593625498008
QUERY:C277([JTB_Logs:114]; [JTB_Logs:114]JTBid:1="DELETE")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1709 [VMax]=7-Stamp Copper Die [Filed_Type}=Is alpha [NbRecord]:27393 [Index_selectivity]:2,013007054674
QUERY:C277([Raw_Materials_Suggest_Vendors:173]; [Raw_Materials_Suggest_Vendors:173]Raw_Matl_Code:2="7-Stamp Copper Die")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1828 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:2270 [Index_selectivity]:6,467236467236
QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]UpdateDynamics:5=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=1912 [VMax]=01813 [Filed_Type}=Is alpha [NbRecord]:31580 [Index_selectivity]:37,59523809524
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProjectNumber:82="01813")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2048 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:5902 [Index_selectivity]:6,594413407821
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2225 [VMax]=dfmmddyy [Filed_Type}=Is alpha [NbRecord]:47820 [Index_selectivity]:2,062807350531
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2="dfmmddyy")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2251 [VMax]=97795.01.020 [Filed_Type}=Is alpha [NbRecord]:98201 [Index_selectivity]:3,760329312656
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16="97795.01.020")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2255 [VMax]=97795.01.00 [Filed_Type}=Is alpha [NbRecord]:98201 [Index_selectivity]:3,946192485433
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Jobit:23="97795.01.00")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2314 [VMax]=1 [Filed_Type}=Is longint [NbRecord]:47820 [Index_selectivity]:6,930434782609
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11=1)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2382 [VMax]=06/07/2016 [Filed_Type}=Is date [NbRecord]:98201 [Index_selectivity]:94,24280230326
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5=!2016-07-06!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2428 [VMax]=Customers [Filed_Type}=Is alpha [NbRecord]:4189 [Index_selectivity]:2094,5
QUERY:C277([Users_Record_Accesses:94]; [Users_Record_Accesses:94]TableName:2="Customers")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2639 [VMax]=00199 [Filed_Type}=Is alpha [NbRecord]:8301 [Index_selectivity]:85,57731958763
QUERY:C277([Jobs:15]; [Jobs:15]CustID:2="00199")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2681 [VMax]=00074 [Filed_Type}=Is alpha [NbRecord]:15465 [Index_selectivity]:90,43859649123
QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]CustID:52="00074")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2772 [VMax]=see below [Filed_Type}=Is alpha [NbRecord]:67688 [Index_selectivity]:1,334753115633
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]PONumber:21="see below")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=2934 [VMax]=00199 [Filed_Type}=Is alpha [NbRecord]:12139 [Index_selectivity]:122,6161616162
QUERY:C277([Job_Forms:42]; [Job_Forms:42]cust_id:82="00199")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=3156 [VMax]=Promotional [Filed_Type}=Is alpha [NbRecord]:31580 [Index_selectivity]:45,56998556999
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Line_Brand:15="Promotional")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=3273 [VMax]=02016.02 [Filed_Type}=Is alpha [NbRecord]:98201 [Index_selectivity]:18,76571756163
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1="02016.02")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=3344 [VMax]=tbd [Filed_Type}=Is alpha [NbRecord]:46167 [Index_selectivity]:1,150034874452
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]PONumber:11="tbd")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=3618 [VMax]=AA [Filed_Type}=Is alpha [NbRecord]:8301 [Index_selectivity]:106,4230769231
QUERY:C277([Jobs:15]; [Jobs:15]CaseScenario:7="AA")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=3729 [VMax]= [Filed_Type}=Is alpha [NbRecord]:31580 [Index_selectivity]:1,136339102587
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ControlNumber:61="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=4108 [VMax]=90873437 [Filed_Type}=Is alpha [NbRecord]:634587 [Index_selectivity]:72,94103448276
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1="90873437")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=4215 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:4230 [Index_selectivity]:2115
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]BOL_Pending:31=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=4647 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:81607 [Index_selectivity]:3,013107369665
QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]BillOfLadingNumber:3=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=4647 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:81607 [Index_selectivity]:1,060368238458
QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]ReleaseNumber:5=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=4662 [VMax]=00199 [Filed_Type}=Is alpha [NbRecord]:9710 [Index_selectivity]:127,7631578947
QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]CustID:2="00199")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=4687 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:5847 [Index_selectivity]:8,700892857143
QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]RemainingQuantity:15=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=4882 [VMax]=92006.01.09 [Filed_Type}=Is alpha [NbRecord]:180091 [Index_selectivity]:3,842269206972
QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]Jobit:3="92006.01.09")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=5097 [VMax]=uv special [Filed_Type}=Is alpha [NbRecord]:14541 [Index_selectivity]:90,88125
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]SubGroup:31="uv special")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=5120 [VMax]=00121 [Filed_Type}=Is alpha [NbRecord]:31580 [Index_selectivity]:281,9642857143
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]CustID:2="00121")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=5298 [VMax]=18 [Filed_Type}=Is integer [NbRecord]:14541 [Index_selectivity]:469,064516129
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]CommodityCode:26=18)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=5902 [VMax]=0 [Filed_Type}=Is integer [NbRecord]:5902 [Index_selectivity]:5902
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Priority:33=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=6089 [VMax]=00199 [Filed_Type}=Is alpha [NbRecord]:27554 [Index_selectivity]:313,1136363636
QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]CustID:2="00199")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=6175 [VMax]=Knifed Die [Filed_Type}=Is alpha [NbRecord]:57110 [Index_selectivity]:6,896510083323
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15="Knifed Die")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=6396 [VMax]=04526 [Filed_Type}=Is alpha [NbRecord]:22657 [Index_selectivity]:48,93520518359
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2="04526")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=6396 [VMax]=Lasercam [Filed_Type}=Is alpha [NbRecord]:22657 [Index_selectivity]:49,04112554113
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]VendorName:42="Lasercam")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=6679 [VMax]=1 [Filed_Type}=Is longint [NbRecord]:47820 [Index_selectivity]:478,2
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ItemNumber:7=1)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=7198 [VMax]=00050 [Filed_Type}=Is alpha [NbRecord]:43893 [Index_selectivity]:418,0285714286
QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]cust_id:77="00050")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=7656 [VMax]=AA [Filed_Type}=Is alpha [NbRecord]:24421 [Index_selectivity]:241,7920792079
QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]diffNum:3="AA")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=7729 [VMax]=9999 [Filed_Type}=Is alpha [NbRecord]:22657 [Index_selectivity]:871,4230769231
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Dept:7="9999")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=7885 [VMax]= [Filed_Type}=Is alpha [NbRecord]:46167 [Index_selectivity]:1,517602971631
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]edi_ICN:56="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=8001 [VMax]=02439 [Filed_Type}=Is alpha [NbRecord]:89293 [Index_selectivity]:142,8688
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="02439")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=8342 [VMax]=417 [Filed_Type}=Is alpha [NbRecord]:67765 [Index_selectivity]:778,908045977
QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="417")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=8349 [VMax]=00050 [Filed_Type}=Is alpha [NbRecord]:47820 [Index_selectivity]:483,0303030303
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]CustId:15="00050")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=8359 [VMax]=okwbd000 [Filed_Type}=Is alpha [NbRecord]:110312 [Index_selectivity]:19,32247328779
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1="okwbd000")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=8359 [VMax]=7THL-01-0112 [Filed_Type}=Is alpha [NbRecord]:1038593 [Index_selectivity]:318,3914776211
QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2="7THL-01-0112")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=8843 [VMax]= [Filed_Type}=Is alpha [NbRecord]:89293 [Index_selectivity]:1,499185708769
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=9013 [VMax]=Makeup [Filed_Type}=Is alpha [NbRecord]:46167 [Index_selectivity]:95,58385093168
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]CustomerLine:22="Makeup")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=9103 [VMax]=Makeup [Filed_Type}=Is alpha [NbRecord]:67688 [Index_selectivity]:140,4315352697
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerLine:42="Makeup")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=10187 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:89293 [Index_selectivity]:57,72010342599
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=10254 [VMax]=480 [Filed_Type}=Is alpha [NbRecord]:98201 [Index_selectivity]:2395,146341463
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2="480")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=10597 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:89293 [Index_selectivity]:3,264587598713
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]B_O_L_number:17=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=11154 [VMax]=Makeup [Filed_Type}=Is alpha [NbRecord]:89293 [Index_selectivity]:188,7801268499
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerLine:28="Makeup")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=11542 [VMax]=02986 [Filed_Type}=Is alpha [NbRecord]:46167 [Index_selectivity]:88,10496183206
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]ProjectNumber:53="02986")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=11609 [VMax]=02986 [Filed_Type}=Is alpha [NbRecord]:67688 [Index_selectivity]:129,9193857965
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50="02986")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=14219 [VMax]=02986 [Filed_Type}=Is alpha [NbRecord]:89293 [Index_selectivity]:178,586
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40="02986")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=15340 [VMax]=00113 [Filed_Type}=Is alpha [NbRecord]:46167 [Index_selectivity]:307,78
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]defaultBillTo:5="00113")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=16297 [VMax]=00050 [Filed_Type}=Is alpha [NbRecord]:46167 [Index_selectivity]:480,90625
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]CustID:2="00050")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=16297 [VMax]=Clinique Laboratories, Inc. [Filed_Type}=Is alpha [NbRecord]:46167 [Index_selectivity]:471,0918367347
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]CustomerName:39="Clinique Laboratories, Inc.")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=16926 [VMax]=5 Customer [Filed_Type}=Is alpha [NbRecord]:43893 [Index_selectivity]:4877
QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]Status:68="5 Customer")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=17820 [VMax]=00050 [Filed_Type}=Is alpha [NbRecord]:67688 [Index_selectivity]:712,5052631579
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4="00050")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=17820 [VMax]=Clinique Laboratories, Inc. [Filed_Type}=Is alpha [NbRecord]:67688 [Index_selectivity]:712,5052631579
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24="Clinique Laboratories, Inc.")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=17854 [VMax]=00050 [Filed_Type}=Is alpha [NbRecord]:81607 [Index_selectivity]:877,4946236559
QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]CustomerID:6="00050")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=18838 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:43893 [Index_selectivity]:2,270131885182
QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProofReading:61=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=18998 [VMax]=????? [Filed_Type}=Is alpha [NbRecord]:67688 [Index_selectivity]:196,7674418605
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]defaultShipTo:17="?????")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=19758 [VMax]=13-Laser Dies [Filed_Type}=Is alpha [NbRecord]:57110 [Index_selectivity]:344,0361445783
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Commodity_Key:26="13-Laser Dies")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=19822 [VMax]=5146 [Filed_Type}=Is alpha [NbRecord]:57110 [Index_selectivity]:1189,791666667
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]ExpenseCode:47="5146")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=19908 [VMax]=04526 [Filed_Type}=Is alpha [NbRecord]:57110 [Index_selectivity]:123,0818965517
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]VendorID:39="04526")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=20080 [VMax]=00113 [Filed_Type}=Is alpha [NbRecord]:89293 [Index_selectivity]:437,7107843137
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Billto:22="00113")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=20608 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:31580 [Index_selectivity]:11,56352984255
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]DateLaunchReceived:84=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=21399 [VMax]=2 [Filed_Type}=Is alpha [NbRecord]:22657 [Index_selectivity]:4531,4
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]CompanyID:43="2")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=22066 [VMax]=00050 [Filed_Type}=Is alpha [NbRecord]:89293 [Index_selectivity]:960,1397849462
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12="00050")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=24808 [VMax]=13-Laser Dies [Filed_Type}=Is alpha [NbRecord]:110312 [Index_selectivity]:672,6341463415
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Commodity_Key:22="13-Laser Dies")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=27754 [VMax]=00/00/00 [Filed_Type}=Is date [NbRecord]:67688 [Index_selectivity]:42,01613904407
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateBooked:49=!00-00-00!)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=29142 [VMax]= [Filed_Type}=Is alpha [NbRecord]:181043 [Index_selectivity]:31,34400969529
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=29996 [VMax]=00007 [Filed_Type}=Is alpha [NbRecord]:168333 [Index_selectivity]:4105,682926829
QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]PrepItemNumber:4="00007")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=31485 [VMax]= [Filed_Type}=Is alpha [NbRecord]:31580 [Index_selectivity]:3508,888888889
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ColorSpecMaster:77="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=32138 [VMax]= [Filed_Type}=Is alpha [NbRecord]:67688 [Index_selectivity]:2,424963278759
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_ICN:67="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=34619 [VMax]=01 [Filed_Type}=Is alpha [NbRecord]:226242 [Index_selectivity]:2240,01980198
QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1="01")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=35517 [VMax]=SENT [Filed_Type}=Is alpha [NbRecord]:67688 [Index_selectivity]:13537,6
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_line_status:55="SENT")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=37258 [VMax]=20171130 [Filed_Type}=Is alpha [NbRecord]:1038593 [Index_selectivity]:8443,845528455
QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9="20171130")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=38281 [VMax]= [Filed_Type}=Is alpha [NbRecord]:46167 [Index_selectivity]:5,857269728495
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]EstimateNo:3="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=38468 [VMax]=9999 [Filed_Type}=Is alpha [NbRecord]:57110 [Index_selectivity]:852,3880597015
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]DepartmentID:46="9999")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=38796 [VMax]= [Filed_Type}=Is alpha [NbRecord]:43893 [Index_selectivity]:8778,6
QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]AssignedTo:64="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=39517 [VMax]= [Filed_Type}=Is alpha [NbRecord]:110312 [Index_selectivity]:20,08594319009
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=43195 [VMax]= [Filed_Type}=Is alpha [NbRecord]:226242 [Index_selectivity]:56,0143599901
QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]ProcessSpec:3="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=43314 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:67688 [Index_selectivity]:14,67331454585
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=53246 [VMax]=0 [Filed_Type}=Is real [NbRecord]:57110 [Index_selectivity]:45,61501597444
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Qty_Open:27=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=54327 [VMax]=2 [Filed_Type}=Is alpha [NbRecord]:57110 [Index_selectivity]:11422
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]CompanyID:45="2")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=59429 [VMax]=02-uv special [Filed_Type}=Is alpha [NbRecord]:181043 [Index_selectivity]:2413,906666667
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12="02-uv special")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=64258 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:67688 [Index_selectivity]:19,72835907899
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]InvoiceNum:38=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=73013 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:89293 [Index_selectivity]:40,27649977447
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=97664 [VMax]=00 [Filed_Type}=Is alpha [NbRecord]:226242 [Index_selectivity]:2218,058823529
QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11="00")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=129014 [VMax]= [Filed_Type}=Is alpha [NbRecord]:479874 [Index_selectivity]:35,63068013068
QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]EstimateNo:5="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=169896 [VMax]=02-uv special [Filed_Type}=Is alpha [NbRecord]:479874 [Index_selectivity]:7617,047619048
QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Commodity_Key:6="02-uv special")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=180091 [VMax]=0 [Filed_Type}=Is longint [NbRecord]:180091 [Index_selectivity]:180091
QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]ShippersNumber:14=0)
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=313938 [VMax]= [Filed_Type}=Is alpha [NbRecord]:479874 [Index_selectivity]:138,7320034692
QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]Raw_Matl_Code:4="")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"

//[Max]=496745 [VMax]=00050 [Filed_Type}=Is alpha [NbRecord]:1038593 [Index_selectivity]:86549,41666667
QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Custid:12="00050")
$tQPlan:=Get last query plan:C1046(Description in text format:K19:5)
$tQPath:=Get last query path:C1045(Description in text format:K19:5)
$result:=$result+"\r"+$tQPlan+"\r"+$tQPath+"\r"
DESCRIBE QUERY EXECUTION:C1044(False:C215)
$path:=Get 4D folder:C485(Current resources folder:K5:16)
$path:=$path+"query_export.txt"
TEXT TO DOCUMENT:C1237($path; $result)
