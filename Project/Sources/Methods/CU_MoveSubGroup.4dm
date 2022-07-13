//%attributes = {"publishedWeb":true}
//(p) x_MoveSubGroup
//temp proc to help in cleaning up RM data
//requests new subgroup and lets user select one or mre existing
//subgroups to move into the primary subgroup
//• 1/27/9 8 cs setup reporting

C_REAL:C285(iComm)
C_TEXT:C284(tSubGroup; xText; xTitle)
ARRAY TEXT:C222(aText; 0)

uWinListCleanup
Repeat 
	uDialog("MoveSubgroup"; 420; 350; 8; "Move Subgroup")
	// iComm:=Num(Request("Please Enter a Commodity Code.";"00"))
Until (OK=0)  //|(iComm # 0)

If (False:C215)  // (OK=1)
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=iComm)
	
	If (Records in selection:C76([Raw_Materials_Groups:22])>0)
		DISTINCT VALUES:C339([Raw_Materials_Groups:22]SubGroup:10; aText)
		uClearSelection(->[Raw_Materials_Groups:22])
		SORT ARRAY:C229(aText; >)
		ARRAY TEXT:C222(aBullet; Size of array:C274(aText))
		xTitle:="From Commodity: "+String:C10(iComm; "00")+"-"
		i4:=iComm
		uDialog("MoveSubgroup"; 420; 350; 8)
		
		If (OK=1)
			If (False:C215)  //new subgroup        
				Repeat 
					sFile:="Do Nothing"
					sComType:=String:C10(i4; "00")+"-"+tSubGroup
					$Created:=fCreateRMgroup(1; sComType)  //group NOT created, loop      
					sFile:=""
					
					If (Not:C34($Created))
						ALERT:C41("You MUST create the New SubGroup Record.")
					End if 
				Until ($Created)
			End if 
			uMsgWindow("")
			CU_LocateSubgrp  //locate records and create sets(named the file name) of those found records
			//xTitle:="Material Subgroup moves"
			//xText:="Moved all materials From subgroup(s):"+Char(13)+xText+Char
			//«(13)+"To subgroup:"+String(iComm;"00")+"_"+tSubgroup
			//rPrintText 
			CU_SubGroupChng(tSubGroup; String:C10(i4))
			CLOSE WINDOW:C154
		End if 
	Else 
		ALERT:C41("Invalid Commodity Code entry ("+String:C10(iComm)+")."+Char:C90(13)+"Please check your entry and try again.")
	End if 
End if 
uWinListCleanup