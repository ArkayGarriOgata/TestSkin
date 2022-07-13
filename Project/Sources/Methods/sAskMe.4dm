//%attributes = {"publishedWeb":true}
//sAskMe   ` uSpawnProcess ("sAskMe";64000;"AskMe:"+Filename($2))
//4/25/95 make scrollable see sAskMeCPN
//•080495  MLB  UPR 1691
//•022597  MLB  clear out selections in the end
//•031297  mBohince  UPR §
//zSetUsageStat ("AskMe";"Open";String(Current process))
//Open window(2;40;828;582;8;"Finished Goods Supply & Demand";"wCloseWinBox")  `screen size=832x624

C_LONGINT:C283(iAskMeTabControl)

windowTitle:="Finished Goods Supply & Demand"
$winRef:=OpenFormWindow(->[Finished_Goods:26]; "AskMe"; ->windowTitle; windowTitle)
FORM SET INPUT:C55([Finished_Goods:26]; "AskMe")
SET MENU BAR:C67(<>DefaultMenu)
iMode:=3
filePtr:=->[Finished_Goods:26]
sFile:=Table name:C256(filePtr)
fileNum:=Table:C252(filePtr)
fromDelete:=False:C215
fromZoom:=False:C215
bModMany:=False:C215
fAdHoc:=False:C215
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Customers:16])  //••
READ ONLY:C145([Jobs:15])  //••
READ ONLY:C145([Job_Forms:42])  //••
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods_Transactions:33])  //•022597  MLB  
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Customers_Order_Lines:41])  // need to make changes
READ ONLY:C145([Customers_ReleaseSchedules:46])  // need to make changes

MESSAGES OFF:C175

allOrderlines:=0
allReleases:=0
allinventory:=0
allJobs:=0

ADD RECORD:C56([Finished_Goods:26]; *)  //never to be saved`4/25/95 make scrollable, 091195 react scllbar

MESSAGES ON:C181
uClearSelection(->[Finished_Goods:26])  //•022597  MLB  
uClearSelection(->[Finished_Goods_Locations:35])  //•022597  MLB 
uClearSelection(->[Job_Forms_Items:44])  //•022597  MLB  
uClearSelection(->[Customers_ReleaseSchedules:46])  //•022597  MLB  
uClearSelection(->[Customers_Order_Lines:41])  //•022597  MLB  
uClearSelection(->[Finished_Goods_Transactions:33])  //•022597  MLB 
uClearSelection(->[Customers:16])  //•022597  MLB 
CLEAR SET:C117("displayOrders")  //•020896  MLB  make sure all the sets are cleared
CLEAR SET:C117("displayRels")
CLEAR SET:C117("threeLoaded")
CLEAR SET:C117("fourLoaded")
CLEAR SET:C117("CurrentSet")
REDUCE SELECTION:C351([Job_Forms:42]; 0)  //•031297  mBohince  UPR §
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)  //•031297  mBohince  UPR §
REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)  //•031297  mBohince  UPR §
tText:=""  //•031297  mBohince  UPR §
ARRAY TEXT:C222(aBilltos; 0)
ARRAY TEXT:C222(aShiptos; 0)
sBrand:=""
sDesc:=""
sCustName:=""
totalDemand:=0
totalSupply:=0
totalStatus:=0
iitotal1:=0
iitotal2:=0
iitotal3:=0
iitotal4:=0
FORM SET INPUT:C55([Finished_Goods:26]; "Input")
CLOSE WINDOW:C154($winRef)
uWinListCleanup