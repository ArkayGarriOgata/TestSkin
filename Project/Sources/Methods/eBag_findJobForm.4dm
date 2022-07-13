//%attributes = {"publishedWeb":true}
//PM: eBag_findJobForm() -> 
//@author mlb - 5/30/02  13:03
// Modified by: Garri Ogata (07/07/21) added query for plastic 20@ (60)

MESSAGES OFF:C175

ARRAY LONGINT:C221(aSubForm; 0)
ARRAY LONGINT:C221(aSubFormQty; 0)
ARRAY REAL:C219(aRatio; 0)
ARRAY TEXT:C222(aOutlineNum; 0)

sCriterion2:=""
sCriterion3:=""
sCriterion4:=""
sCriterion5:=""
sCriterion6:=""
tTitle:=""
tMessage1:=""
sLocation:=""
t7:=""
t8:=""
t9:=""
tText:=""
xComment:=""
sBin:=""

zSetUsageLog(->[Job_Forms:42]; "eBag"; sCriterion1)

If (Length:C16(sCriterion1)=6)
	zwStatusMsg("eBag"; "Getting JobForm number of JTB: "+sCriterion1)
	sCriterion1:=eBag_JTBtoJobForm(sCriterion1)
End if 

If (Length:C16(sCriterion1)=8)
	<>jobform:=sCriterion1
	
	zwStatusMsg("eBag"; "Loading JobForm: "+sCriterion1)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sCriterion1)
	If (Records in selection:C76([Job_Forms:42])=1)
		SET WINDOW TITLE:C213("eBag for Job form "+sCriterion1)
		zwStatusMsg("eBag"; "Loading details of: "+sCriterion1)
		eBag_loadRelated
		
		JBNSubFormRatio
		$hits:=JOB_getOutlineNumbers
		
		If ([Job_Forms:42]ShortGrain:48)
			Core_ObjectSetColor(->sBin; -(Red:K11:4+(256*Yellow:K11:2)))
			sBin:=" Short Grain! "
		Else 
			Core_ObjectSetColor(->sBin; -(Light grey:K11:13+(256*Light grey:K11:13)))
			sBin:=""
		End if 
		
		xComment:=""
		
		zwStatusMsg("eBag"; "Getting Stock for: "+sCriterion1)
		USE SET:C118("materials")
		READ ONLY:C145([Raw_Material_Labels:171])
		QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12="01@"; *)
		QUERY SELECTION:C341([Job_Forms_Materials:55];  | ; [Job_Forms_Materials:55]Commodity_Key:12="20@")
		
		If (Records in selection:C76([Job_Forms_Materials:55])>0)
			If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)>0)
				t7:=[Job_Forms_Materials:55]Raw_Matl_Code:7
				If (Position:C15("LF"; [Job_Forms_Materials:55]UOM:5)#0)
					t9:="LF = "+String:C10([Job_Forms_Materials:55]Planned_Qty:6; "|Int_no_zero")
					QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Raw_Matl_Code:4=t7)
					ORDER BY:C49([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2; >)
					
				Else 
					REDUCE SELECTION:C351([Raw_Material_Labels:171]; 0)
					t9:=""
				End if 
			Else 
				t7:="Board not specified"
			End if 
		Else 
			t7:="Board not budgeted"
		End if 
		USE SET:C118("materials")
		
		If ([Job_Forms:42]ColorStdSheets:60#0)  //• mlb - 5/15/02  11:36 add for Color Standard"
			xComment:=String:C10([Job_Forms:42]ColorStdSheets:60; "|Int_no_zero")+" for Color Standards"
		Else 
			xComment:=""
		End if 
		
		USE SET:C118("machines")
		SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $aCC; [Job_Forms_Machines:43]Planned_Qty:10; $aQty)
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
		For ($i; 1; Size of array:C274($aCC))
			If (Position:C15($aCC{$i}; <>SHEETERS)>0)
				t8:=String:C10($aQty{$i}; "|Int_no_zero")
			End if 
		End for 
		
		zwStatusMsg("eBag"; "Finding location of the JobTransferBag for: "+sCriterion1)
		tText:=""
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; Records in selection:C76([JTB_Job_Transfer_Bags:112]))
				tText:=tText+"JTB: "+[JTB_Job_Transfer_Bags:112]ID:1+" at "+[JTB_Job_Transfer_Bags:112]Location:4+"  "
				NEXT RECORD:C51([JTB_Job_Transfer_Bags:112])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_ID; 0)
			ARRAY TEXT:C222($_Location; 0)
			
			SELECTION TO ARRAY:C260([JTB_Job_Transfer_Bags:112]ID:1; $_ID; [JTB_Job_Transfer_Bags:112]Location:4; $_Location)
			
			For ($i; 1; Size of array:C274($_ID); 1)
				
				tText:=tText+"JTB: "+$_ID{$i}+" at "+$_Location{$i}+"  "
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
	Else 
		BEEP:C151
		ALERT:C41("Job Form "+sCriterion1+" was not found")
		sCriterion1:=""
		SET WINDOW TITLE:C213("eBag")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Scan a JTB or enter a Jobform number")
	sCriterion1:=""
	SET WINDOW TITLE:C213("eBag")
End if 

eBag_MakeTabs(sCriterion1)


OBJECT SET ENABLED:C1123(bMT; False:C215)