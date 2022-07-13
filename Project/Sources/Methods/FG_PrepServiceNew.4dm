//%attributes = {"publishedWeb":true}
//PM:  FG_PrepServiceNew()  1/16/01  mlb
//create a prep request
//• mlb - 8/1/02  13:30 carry the Outline number with the control number
//• mlb - 8/29/02  12:25 chk for lock on existing fg
// • mel (10/9/03, 11:09:27) set ord catagory to original
// ----------------------------------------------------

C_TEXT:C284($cpn; $3; $0)
C_TEXT:C284($1; $request)
C_LONGINT:C283($numChrgs)

$0:="*** Canceled ***"
$request:=$1
$pjtId:=$2
$today:=4D_Current_date
If ([Customers_Projects:9]id:1#$pjtId)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$pjtId)
End if 

If (Records in selection:C76([Customers_Projects:9])=1)
	If (Count parameters:C259<=2)
		$cpn:=fStripSpace("B"; Request:C163("What product code is this work order for?"; ""))
	Else 
		$cpn:=$3
		OK:=1
	End if 
	
	If (OK=1)
		READ WRITE:C146([Finished_Goods:26])
		$numFG:=qryFinishedGood([Customers_Projects:9]Customerid:3; $cpn)
		If ($numFG=0)
			CONFIRM:C162("Create a F/G record for "+$cpn+"?")
			If (OK=1)
				CREATE RECORD:C68([Finished_Goods:26])
				[Finished_Goods:26]ProductCode:1:=$cpn
				[Finished_Goods:26]CustID:2:=[Customers_Projects:9]Customerid:3
				[Finished_Goods:26]FG_KEY:47:=[Customers_Projects:9]Customerid:3+":"+$cpn
				[Finished_Goods:26]ClassOrType:28:="20"
				[Finished_Goods:26]GL_Income_Code:22:="130104701"
				[Finished_Goods:26]Acctg_UOM:29:="M"
				[Finished_Goods:26]Status:14:="New"
				[Finished_Goods:26]ProjectNumber:82:=$pjtId
			Else   //abort
				$cpn:=""
			End if 
			
		Else   //existing`• mlb - 8/29/02  12:25
			If (Not:C34(fLockNLoad(->[Finished_Goods:26])))
				$cpn:=""
			End if 
		End if   //found fg
		
		If (Length:C16($cpn)>0)
			If (Length:C16($request)=0)  // make a requests
				//CREATE RECORD([Request])
				//$request:=fGetNextID (->[Request];5)
				//[Request]id:=$request
				//[Request]RequestOn:=$today
				//[Request]ProjectNumber:=$pjtId
				//[Request]Custid:=pjtCustid
				//[Request]RequestType:="Prep"+" - "+$cpn
				//SAVE RECORD([Request])
			End if 
			
			If (Length:C16([Finished_Goods:26]ControlNumber:61)>0)
				READ WRITE:C146([Finished_Goods_Specifications:98])
				QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=[Finished_Goods:26]ControlNumber:61)
				If (Records in selection:C76([Finished_Goods_Specifications:98])=1)
					$comment:=FG_PrepServiceSupercede([Finished_Goods_Specifications:98]ControlNumber:2)  //$ctrlNumOld)
				End if 
			End if 
			
			CREATE RECORD:C68([Finished_Goods_Specifications:98])
			[Finished_Goods_Specifications:98]Status:68:="1 Planning"
			[Finished_Goods_Specifications:98]FG_Key:1:=[Customers_Projects:9]Customerid:3+":"+$cpn
			[Finished_Goods_Specifications:98]ControlNumber:2:=FG_newControlNumber([Customers_Projects:9]Customerid:3)
			[Finished_Goods_Specifications:98]ProductCode:3:=$cpn
			[Finished_Goods_Specifications:98]DateSubmitted:5:=!00-00-00!  //4D_Current_date
			[Finished_Goods_Specifications:98]ProjectNumber:4:=$pjtId
			//[Finished_Goods_Specifications]RequestNumber:=$request
			[Finished_Goods_Specifications:98]PreflightBy:58:=""
			C_DATE:C307($received)  // • mel (2/6/04, 10:30:00)
			//If (False)
			//$winRef:=Open form window([FG_Specification];"ArtReceived_dio")
			//DIALOG([FG_Specification];"ArtReceived_dio")
			//CLOSE WINDOW($winRef)
			//$received:=dDate
			//Else 
			//  `[FG_Specification]DateArtReceived:=$today
			//
			//$received:=Date(Request("When would you like to say art was received?";String($today;Short );"Back date";"Today"))
			//Case of 
			//: ($received=!00/00/00!)
			//$received:=$today
			//
			//: (OK=0)
			$received:=$today
			//End case 
			//End if 
			
			FG_PrepServiceProofRead
			[Finished_Goods_Specifications:98]DateArtEntered:71:=$today
			[Finished_Goods_Specifications:98]DateArtReceived:63:=$received
			[Finished_Goods_Specifications:98]OutLine_Num:65:=[Finished_Goods:26]OutLine_Num:4  //• mlb - 8/1/02  13:30
			[Finished_Goods_Specifications:98]UPC_encoded:76:=[Finished_Goods:26]UPC:37
			[Finished_Goods_Specifications:98]ServiceRequested:54:="1"
			[Finished_Goods_Specifications:98]GlueDirection:73:="Regular"
			SAVE RECORD:C53([Finished_Goods_Specifications:98])
			UNLOAD RECORD:C212([Finished_Goods_Specifications:98])
			READ ONLY:C145([Finished_Goods_Specifications:98])
			LOAD RECORD:C52([Finished_Goods_Specifications:98])
			
			$numChrgs:=FG_PrepAddCharges([Finished_Goods_Specifications:98]ControlNumber:2)
			
			[Finished_Goods:26]ArtReceivedDate:56:=$received
			[Finished_Goods:26]HaveArt:51:=True:C214
			JMI_CheckControlNumber([Finished_Goods:26]ControlNumber:61)
			[Finished_Goods:26]ControlNumber:61:=[Finished_Goods_Specifications:98]ControlNumber:2
			[Finished_Goods:26]Preflight:66:=False:C215
			[Finished_Goods:26]PreflightBy:67:=""
			[Finished_Goods:26]OriginalOrRepeat:71:="Original"
			[Finished_Goods:26]GlueDirection:104:="Regular"
			If (Length:C16([Finished_Goods:26]ProjectNumber:82)=0)
				[Finished_Goods:26]ProjectNumber:82:=$pjtId
			End if 
			SAVE RECORD:C53([Finished_Goods:26])
			UNLOAD RECORD:C212([Finished_Goods:26])
			READ ONLY:C145([Finished_Goods:26])
			LOAD RECORD:C52([Finished_Goods:26])
			//REDUCE SELECTION([Finished_Goods];0)
			$0:=$cpn
			
			$sFile:=sFile  //cover a side effect of Viewsetter
			<>PassThrough:=True:C214
			CREATE SET:C116([Finished_Goods_Specifications:98]; "◊PassThroughSet")
			REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
			ViewSetter(2; ->[Finished_Goods_Specifications:98])
			sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit
			
		End if 
	End if 
End if 