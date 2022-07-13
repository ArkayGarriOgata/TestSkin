//%attributes = {"publishedWeb":true}
//(P) gXferFGwip: allows moving fg between Locations

windowTitle:=nGetPrcsName
$winRef:=OpenFormWindow(->[zz_control:1]; "FGTranfers"; ->windowTitle; windowTitle; Plain fixed size window:K34:6)
SET MENU BAR:C67(<>DefaultMenu)
READ WRITE:C146([Finished_Goods:26])
READ WRITE:C146([Finished_Goods_Locations:35])
READ WRITE:C146([Job_Forms_Items:44])
iMode:=2

<>USE_SUBCOMPONENT:=True:C214
ARRAY TEXT:C222(aAssemblyJobs; 0)
C_BLOB:C604($blob)
SET BLOB SIZE:C606($blob; 0)
$blob:=FG_getAssemblyJobs("Assembly")
BLOB TO VARIABLE:C533($blob; aAssemblyJobs)

DIALOG:C40([zz_control:1]; "FGTranfers")
CLOSE WINDOW:C154



//select distinct(ProductCode) from Job_Forms_Items where JobForm in (select distinct(JobForm) from Job_Forms_Materials where Commodity_Key like '33%')