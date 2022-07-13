//%attributes = {}
// Method: FG_PrepServiceSetFGrecord () -> 
// ----------------------------------------------------
// by: mel: 12/29/04, 13:32:38
// ----------------------------------------------------
// Description:
// Make the F/G record look like the FG spec record, if its the same control number
// ----------------------------------------------------

If (Count parameters:C259=1)  //then do the search if necessary, see 1version122904
	If ([Finished_Goods:26]ControlNumber:61#$1)
		READ WRITE:C146([Finished_Goods:26])
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ControlNumber:61=$1)
	End if 
	
	If (Records in selection:C76([Finished_Goods:26])>0)  //its an active control number
		If ([Finished_Goods_Specifications:98]ControlNumber:2#$1)
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$1)
		End if 
		
	Else 
		uConfirm($1+" is not the current Control number on "+[Finished_Goods_Specifications:98]FG_Key:1; "OK"; "Dang")
	End if 
	
Else   //call from fg_spec trigger
	LOAD RECORD:C52([Finished_Goods:26])
End if 

//make sure this is the rite control record, not an old one, could have been set by FG_PrepServiceApprove
If ([Finished_Goods:26]ControlNumber:61=[Finished_Goods_Specifications:98]ControlNumber:2)
	
	If ([Finished_Goods:26]OutLine_Num:4#[Finished_Goods_Specifications:98]OutLine_Num:65)
		[Finished_Goods:26]OutLine_Num:4:=[Finished_Goods_Specifications:98]OutLine_Num:65
		QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=[Finished_Goods_Specifications:98]OutLine_Num:65)
		[Finished_Goods:26]Width:7:=[Finished_Goods_SizeAndStyles:132]Dim_A:17
		[Finished_Goods:26]Depth:8:=[Finished_Goods_SizeAndStyles:132]Dim_B:18
		[Finished_Goods:26]Height:9:=[Finished_Goods_SizeAndStyles:132]Dim_Ht:19
		[Finished_Goods:26]PackingSpecification:103:=[Finished_Goods:26]OutLine_Num:4
	End if 
	
	If ([Finished_Goods:26]UPC:37#[Finished_Goods_Specifications:98]UPC_encoded:76) & (Length:C16([Finished_Goods_Specifications:98]UPC_encoded:76)#0)
		//uConfirm ("Change FG upc from "+[Finished_Goods]UPC+" to "+[Finished_Goods_Specifications]UPC_encoded)
		//If (ok=1)
		[Finished_Goods:26]UPC:37:=[Finished_Goods_Specifications:98]UPC_encoded:76
		//End if 
	End if 
	
	If ([Finished_Goods:26]ColorSpecMaster:77#[Finished_Goods_Specifications:98]ColorSpecMaster:70)
		[Finished_Goods:26]ColorSpecMaster:77:=[Finished_Goods_Specifications:98]ColorSpecMaster:70
	End if 
	
	If ([Finished_Goods:26]GlueDirection:104#[Finished_Goods_Specifications:98]GlueDirection:73)
		[Finished_Goods:26]GlueDirection:104:=[Finished_Goods_Specifications:98]GlueDirection:73
	End if 
	
	If ([Finished_Goods:26]BoardCOC_Type:109#[Finished_Goods_Specifications:98]BoardCOC_Type:86)  // Added by: Mel Bohince (1/29/20) 
		[Finished_Goods:26]BoardCOC_Type:109:=[Finished_Goods_Specifications:98]BoardCOC_Type:86
	End if 
	
	If ([Finished_Goods_Specifications:98]DateArtReceived:63#!00-00-00!) & ([Finished_Goods:26]ArtReceivedDate:56<[Finished_Goods_Specifications:98]DateArtReceived:63)
		[Finished_Goods:26]ArtReceivedDate:56:=[Finished_Goods_Specifications:98]DateArtReceived:63
	End if 
	
	If ([Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!) & ([Finished_Goods:26]PrepDoneDate:58<[Finished_Goods_Specifications:98]DatePrepDone:6)
		[Finished_Goods:26]PrepDoneDate:58:=[Finished_Goods_Specifications:98]DatePrepDone:6
	End if 
	
	If ([Finished_Goods_Specifications:98]DateSentToCustomer:8#!00-00-00!) & ([Finished_Goods:26]DateArtSent:101<[Finished_Goods_Specifications:98]DateSentToCustomer:8)
		[Finished_Goods:26]DateArtSent:101:=[Finished_Goods_Specifications:98]DateSentToCustomer:8
	End if 
	
	If ([Finished_Goods_Specifications:98]DateReturned:9#!00-00-00!)
		If ([Finished_Goods_Specifications:98]Approved:10)
			If ([Finished_Goods:26]DateArtApproved:46<[Finished_Goods_Specifications:98]DateReturned:9)
				[Finished_Goods:26]DateArtApproved:46:=[Finished_Goods_Specifications:98]DateReturned:9
			End if 
			
		Else   //a rejection! see also FG_PrepServiceCustomerRejection
			If (Count parameters:C259=0)
				[Finished_Goods:26]ArtReceivedDate:56:=!00-00-00!
				[Finished_Goods:26]DateArtSent:101:=!00-00-00!
				[Finished_Goods:26]PrepDoneDate:58:=!00-00-00!
				[Finished_Goods:26]ArtWorkNotes:60:="Customer Rejected on "+String:C10(4D_Current_date)+Char:C90(13)+[Finished_Goods:26]ArtWorkNotes:60
				[Finished_Goods:26]ControlNumber:61:="REJECT"
				[Finished_Goods:26]DateArtApproved:46:=!00-00-00!
			End if 
			
			If ([Finished_Goods:26]Preflight:66)
				[Finished_Goods:26]Preflight:66:=False:C215
			End if 
			
			If (Length:C16([Finished_Goods:26]PreflightBy:67)>0)
				[Finished_Goods:26]PreflightBy:67:=""
			End if 
			
		End if 
	End if 
	
	If (Modified record:C314([Finished_Goods:26]))
		[Finished_Goods:26]ModDate:24:=4D_Current_date
		[Finished_Goods:26]ModWho:25:=[Finished_Goods_Specifications:98]ModWho:55
		SAVE RECORD:C53([Finished_Goods:26])
	End if 
	
	UNLOAD RECORD:C212([Finished_Goods:26])
End if 