//%attributes = {"publishedWeb":true}
//(p) BeforePSpec
//• 10/8/97 cs created moved code from Layout Proc before to here

If (Not:C34(User_AllowedCustomer([Process_Specs:18]Cust_ID:4; ""; "via PS:"+[Process_Specs:18]ID:1)))
	bDone:=1
	CANCEL:C270
End if 
wWindowTitle("push"; "Process Spec "+[Process_Specs:18]ID:1+" for Customer: "+[Process_Specs:18]Cust_ID:4)

Case of 
		//: (Current user="Designer")  //| (Current user="Kris Koertge")
		//uConfirm ("Simulate Saleman/SaleCoordinator mode?";"Yes";"No")
		//If (OK=1)
		//testRestrictions:=True
		//Else 
		//testRestrictions:=False
		//End if 
	: (<>fisSalesRep)
		testRestrictions:=True:C214
	: (<>fisCoord)
		testRestrictions:=True:C214
	Else 
		testRestrictions:=False:C215
End case 

OBJECT SET ENABLED:C1123(bDelete; False:C215)
OBJECT SET ENABLED:C1123(bRename; False:C215)
OBJECT SET ENABLED:C1123(bSetupOps; False:C215)
OBJECT SET ENABLED:C1123(bSetupPMat; False:C215)
OBJECT SET ENABLED:C1123(bFixForms; False:C215)
If (sFile="Process_Specs")
	OBJECT SET ENABLED:C1123(bDupPSpec2; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bDupPSpec2; False:C215)
End if 
OBJECT SET ENABLED:C1123(bMatch; False:C215)
OBJECT SET ENABLED:C1123(bGetRM; False:C215)

Case of 
	: (Is new record:C668([Process_Specs:18]))
		[Process_Specs:18]LastUsed:5:=4D_Current_date
		[Process_Specs:18]Cust_ID:4:=[Estimates:17]Cust_ID:2
		[Process_Specs:18]zCount:101:=1
		[Process_Specs:18]Status:2:="New"
		
End case 

Case of 
	: (iMode>2)
		//don't activate buttons
		READ ONLY:C145([Process_Specs_Materials:56])
		READ ONLY:C145([Process_Specs_Machines:28])
		
	: ([Process_Specs:18]Status:2="New")
		OBJECT SET ENABLED:C1123(bDelete; True:C214)
		OBJECT SET ENABLED:C1123(bRename; True:C214)
		OBJECT SET ENABLED:C1123(bSetupOps; True:C214)
		OBJECT SET ENABLED:C1123(bSetupPMat; True:C214)
		OBJECT SET ENABLED:C1123(bFixForms; True:C214)
		OBJECT SET ENABLED:C1123(bMatch; True:C214)
		OBJECT SET ENABLED:C1123(bGetRM; True:C214)
		
	: (testRestrictions)  //their chance to modify is over
		uSetEntStatus(->[Process_Specs:18]; False:C215)
		READ ONLY:C145([Process_Specs_Materials:56])
		READ ONLY:C145([Process_Specs_Machines:28])
		
	: ([Process_Specs:18]Status:2="Estimated")
		OBJECT SET ENABLED:C1123(bRename; True:C214)
		OBJECT SET ENABLED:C1123(bSetupOps; True:C214)
		OBJECT SET ENABLED:C1123(bSetupPMat; True:C214)
		OBJECT SET ENABLED:C1123(bFixForms; True:C214)
		OBJECT SET ENABLED:C1123(bMatch; True:C214)
		OBJECT SET ENABLED:C1123(bGetRM; True:C214)
		
	: ([Process_Specs:18]Status:2="Final")
		If (User in group:C338(Current user:C182; "AccountManager"))
			OBJECT SET ENABLED:C1123(bRename; True:C214)
			OBJECT SET ENABLED:C1123(bSetupOps; True:C214)
			OBJECT SET ENABLED:C1123(bSetupPMat; True:C214)
			OBJECT SET ENABLED:C1123(bFixForms; True:C214)
			OBJECT SET ENABLED:C1123(bMatch; True:C214)
			OBJECT SET ENABLED:C1123(bGetRM; True:C214)
			
		Else 
			BEEP:C151
			zwStatusMsg("WARNING"; "This PSpec is in 'Final' Status, you may not edit it.")
			uSetEntStatus(->[Process_Specs:18]; False:C215)
			READ ONLY:C145([Process_Specs_Materials:56])
			READ ONLY:C145([Process_Specs_Machines:28])
		End if 
		
	Else 
		uSetEntStatus(->[Process_Specs:18]; False:C215)
End case 


If (testRestrictions)
	ARRAY TEXT:C222(aStat; 0)
	//ARRAY TEXT(aStat;1)
	//aStat{1}:="New"  `
Else 
	ARRAY TEXT:C222(aStat; 3)
	LIST TO ARRAY:C288("PSPEC_Status"; aStat)
End if 
util_ComboBoxSetup(->astat; [Process_Specs:18]Status:2)

//get related records
PSpecEstimateLd("Machines"; "Materials")
ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Sequence:4; >)
ORDER BY:C49([Process_Specs_Machines:28]; [Process_Specs_Machines:28]Seq_Num:3; >)
COPY NAMED SELECTION:C331([Process_Specs_Materials:56]; "Related")

sIntro:=PSpec_DescriptionInText

$recNum:=Job_ProdHistory("find"; ([Process_Specs:18]Cust_ID:4+":"+[Process_Specs:18]ID:1); "Specs")


//
