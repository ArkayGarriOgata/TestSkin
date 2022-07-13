// ----------------------------------------------------
// Form Method: [Job_Forms].DieBoard
// SetObjectProperties, Mark Zinke (5/15/13)
// Modified by: Garri Ogata (07/07/21) added query for plastic 20@ (78)
// Modified by: Mel Bohince (7/9/21) fix AND/OR query, ORDAize it
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		<>jobform:=[Job_Forms:42]JobFormID:5
		
		[Job_Forms:42]zCount:12:=1  //trigger the validate phase
		READ WRITE:C146([Job_DieBoards:152])
		QUERY:C277([Job_DieBoards:152]; [Job_DieBoards:152]JobformId:1=[Job_Forms:42]JobFormID:5)
		If (Records in selection:C76([Job_DieBoards:152])=0)
			CREATE RECORD:C68([Job_DieBoards:152])
			[Job_DieBoards:152]JobformId:1:=[Job_Forms:42]JobFormID:5
			[Job_DieBoards:152]UsingDie:6:="New"
		End if 
		bool1:=(Not:C34([Job_DieBoards:152]DateDieOH:19=!00-00-00!))
		bool2:=(Not:C34([Job_DieBoards:152]DateBlankerOH:20=!00-00-00!))
		bool3:=(Not:C34([Job_DieBoards:152]DateCounterOH:21=!00-00-00!))
		bool4:=(Not:C34([Job_DieBoards:152]DateFSB_OH:22=!00-00-00!))
		SetObjectProperties(""; ->[Job_DieBoards:152]DateDieOH:19; bool1)
		SetObjectProperties(""; ->[Job_DieBoards:152]DateBlankerOH:20; bool2)
		SetObjectProperties(""; ->[Job_DieBoards:152]DateCounterOH:21; bool3)
		SetObjectProperties(""; ->[Job_DieBoards:152]DateFSB_OH:22; bool4)
		
		ARRAY TEXT:C222(aProvided; 0)
		ARRAY TEXT:C222(aStandard; 0)
		ARRAY TEXT:C222(aStyle; 0)
		LIST TO ARRAY:C288("Die_HowTrans"; aProvided)
		LIST TO ARRAY:C288("Die_IsToBe"; aStandard)
		LIST TO ARRAY:C288("Die_Counters"; aStyle)
		aProvided{0}:=[Job_DieBoards:152]HowTrans:12
		aStandard{0}:=[Job_DieBoards:152]Knifed:13
		aStyle{0}:=[Job_DieBoards:152]Counters:14
		
		If ([Job_DieBoards:152]DateBinOut:5=!00-00-00!)
			SetObjectProperties(""; ->bPut; True:C214; "Take Out")
		Else 
			SetObjectProperties(""; ->bPut; True:C214; "Put Away")
		End if 
		
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms:42]JobFormID:5)
		
		ARRAY LONGINT:C221(aSubForm; 0)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms:42]JobFormID:5)
		JBNSubFormRatio
		
		$hits:=JOB_getOutlineNumbers([Job_Forms:42]JobFormID:5)  //aOutlineNum;aNumberUp
		
		
		If (Size of array:C274(aOutlineNum)=1)  // Modified by: Mel Bohince (6/6/19) 
			READ ONLY:C145([Job_DieBoard_Inv:168])
			QUERY:C277([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]OutlineNumber:4=aOutlineNum{1}; *)
			QUERY:C277([Job_DieBoard_Inv:168];  & ; [Job_DieBoard_Inv:168]UpNumber:5=aNumberUp{1})
			ttCatelogIDs:=""  // PJK-11/13/19 Added ability to view multiple
			For ($i; 1; Records in selection:C76([Job_DieBoard_Inv:168]))  // PJK-11/13/19
				GOTO SELECTED RECORD:C245([Job_DieBoard_Inv:168]; $i)  // PJK-11/13/19
				ttCatelogIDs:=ttCatelogIDs+[Job_DieBoard_Inv:168]CatelogID:10+Char:C90(13)  // PJK-11/13/19
			End for   // PJK-11/13/19
			ttCatelogIDs:=StripChars(ttCatelogIDs; Char:C90(13))  // PJK-11/13/19
			If (Records in selection:C76([Job_DieBoard_Inv:168])>0)
				sGroup:=String:C10(Records in selection:C76([Job_DieBoard_Inv:168]))
			Else 
				sGroup:=""
			End if 
			
			
		Else 
			REDUCE SELECTION:C351([Job_DieBoard_Inv:168]; 0)  // Modified by: Mel Bohince (8/28/19) 
			sGroup:="n/a"
		End if 
		
		tText:=""
		
		// Modified by: Mel Bohince (7/9/21) fix AND/OR query, ORDAize it
		//zwStatusMsg ("eBag";"Getting Stock for: "+sCriterion1)
		//QUERY([Job_Forms_Materials];[Job_Forms_Materials]JobForm=[Job_Forms]JobFormID;*)
		//QUERY([Job_Forms_Materials]; & ;[Job_Forms_Materials]Commodity_Key="01@";*)
		//QUERY([Job_Forms_Materials]; | ;[Job_Forms_Materials]Commodity_Key="20@")
		//If (Records in selection([Job_Forms_Materials])>0)
		//If (Length([Job_Forms_Materials]Raw_Matl_Code)>0)
		//t7:=[Job_Forms_Materials]Raw_Matl_Code
		//If (Position("LF";[Job_Forms_Materials]UOM)#0)
		//t9:="LF = "+String([Job_Forms_Materials]Planned_Qty;"|Int_no_zero")
		//Else 
		//t9:=""
		//End if 
		//Else 
		//t7:="Board not specified"
		//End if 
		//Else 
		//t7:="Board not budgeted"
		//End if 
		
		C_TEXT:C284($jobform)
		$jobform:=[Job_Forms:42]JobFormID:5
		
		C_OBJECT:C1216($jfm_en)
		$jfm_en:=ds:C1482.Job_Forms_Materials.query\
			("(Commodity_Key = :1 or Commodity_Key = :2) and JobForm = :3"\
			; "01@"; "20@"; $jobform)\
			.first()
		
		If ($jfm_en#Null:C1517)
			If (Length:C16($jfm_en.Raw_Matl_Code)>0)
				t7:=$jfm_en.Raw_Matl_Code
			Else 
				t7:="Board rmCode not specified"
			End if 
		Else 
			t7:="Board not budgeted"
		End if 
		// Modified by: Mel Bohince (7/9/21) end fix
		
		If ([Job_Forms:42]ShortGrain:48)
			Core_ObjectSetColor(->sBin; -(Red:K11:4+(256*Yellow:K11:2)))
			sBin:=" Short Grain! "
		Else 
			Core_ObjectSetColor(->sBin; -(Light grey:K11:13+(256*Light grey:K11:13)))
			sBin:=""
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		[Job_DieBoards:152]Mod_Date:3:=4D_Current_date
		[Job_DieBoards:152]Mod_Who:2:=<>zResp
		SAVE RECORD:C53([Job_DieBoards:152])
		
End case 