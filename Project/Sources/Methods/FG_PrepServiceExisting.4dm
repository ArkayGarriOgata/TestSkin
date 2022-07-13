//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceExisting() -> 
//@author mlb - 8/20/01  15:44

If (Length:C16([Finished_Goods:26]ControlNumber:61)>0)
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=[Finished_Goods:26]ControlNumber:61)
	If (Records in selection:C76([Finished_Goods_Specifications:98])=0) & ([Finished_Goods:26]ControlNumber:61#"REJECT")
		CREATE RECORD:C68([Finished_Goods_Specifications:98])
		[Finished_Goods_Specifications:98]FG_Key:1:=[Finished_Goods:26]FG_KEY:47
		[Finished_Goods_Specifications:98]ControlNumber:2:=[Finished_Goods:26]ControlNumber:61
		[Finished_Goods_Specifications:98]ProductCode:3:=[Finished_Goods:26]ProductCode:1
		[Finished_Goods_Specifications:98]DateSubmitted:5:=<>MAGIC_DATE  //4D_Current_date
		[Finished_Goods_Specifications:98]DatePrepDone:6:=<>MAGIC_DATE
		[Finished_Goods_Specifications:98]DateProofRead:7:=<>MAGIC_DATE
		[Finished_Goods_Specifications:98]DateSentToCustomer:8:=<>MAGIC_DATE
		[Finished_Goods_Specifications:98]DateReturned:9:=<>MAGIC_DATE
		[Finished_Goods_Specifications:98]Approved:10:=True:C214
		[Finished_Goods_Specifications:98]ServiceRequested:54:="pre-existing Ctrl #"
		[Finished_Goods_Specifications:98]ModWho:55:=<>zresp
		[Finished_Goods_Specifications:98]ModDate:56:=4D_Current_date
		[Finished_Goods_Specifications:98]ProjectNumber:4:=[Finished_Goods:26]ProjectNumber:82
		//[Finished_Goods_Specifications]RequestNumber:=""
		[Finished_Goods_Specifications:98]CommentsFromPlanner:19:="Pre-existing control number, created via FG screen "+"so repeat services may be ordered."
		SAVE RECORD:C53([Finished_Goods_Specifications:98])
		$numChrgs:=FG_PrepAddCharges([Finished_Goods_Specifications:98]ControlNumber:2)
	End if 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=[Finished_Goods:26]FG_KEY:47)
		
		$sFile:=sFile  //cover a side effect of Viewsetter
		<>PassThrough:=True:C214
		CREATE SET:C116([Finished_Goods_Specifications:98]; "◊PassThroughSet")
		REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=[Finished_Goods:26]FG_KEY:47)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
			REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
		End if 
		$sFile:=sFile  //cover a side effect of Viewsetter
		<>PassThrough:=True:C214
		
	End if   // END 4D Professional Services : January 2019 
	
	ViewSetter(2; ->[Finished_Goods_Specifications:98])
	sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit
	
End if 