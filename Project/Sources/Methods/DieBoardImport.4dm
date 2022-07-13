//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 07/26/18, 07:40:08
// ----------------------------------------------------
// Method: DieBoardImport
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($ttBS; $ttCatelogID; $ttContents; $ttCR; $ttCustomerCode; $ttCustomerName; $ttFilename; $ttFullPath; $ttJobNum)
C_TEXT:C284($ttLine; $ttOutline; $ttTab)
C_LONGINT:C283($xlUpNum)
C_DATE:C307($dDate)
$0:=False:C215
$ttCR:=Char:C90(13)
$ttTab:=Char:C90(9)
CONFIRM:C162("The file MUST be in .txt format, tab/cr delimited. Continue?")
If (OK=1)
	$ttFilename:=Select document:C905(""; ""; "Select Die board import file"; Allow alias files:K24:10)
	If (OK=1)
		$0:=True:C214
		$ttFullPath:=document
		If (Test path name:C476($ttFullPath)=Is a document:K24:1)
			$ttContents:=Document to text:C1236($ttFullPath)
			$ttLine:=GetNextField(->$ttContents; $ttCR)  // Strip off header
			
			Import_ParseHeaders($ttLine)
			
			
			While (Length:C16($ttContents)>0)
				$ttLine:=GetNextField(->$ttContents; $ttCR)  // Strip off header
				Import_ParseLine($ttLine)
				$ttCatelogID:=StripChars(Import_GetDataForHeader("Location"); " ")
				$ttOutline:=StripChars(Import_GetDataForHeader("A#"); " ")
				$ttCustomerName:=StripChars(Import_GetDataForHeader("Customer"); " ")
				$ttCustomerCode:=$ttCustomerName
				//$ttCatelogID:=GetNextField (->$ttLine;$ttTab)
				//$ttOutline:=GetNextField (->$ttLine;$ttTab)
				//$ttCustomerCode:=GetNextField (->$ttLine;$ttTab)
				// Modified by: Mel Bohince (8/6/18)
				READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
				QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$ttOutline)
				If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
					$ttCustomerCode:=[Finished_Goods_SizeAndStyles:132]CustID:52
					If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
						
						UNLOAD RECORD:C212([Finished_Goods_SizeAndStyles:132])
						
					Else 
						
						// you have read only mode
						
					End if   // END 4D Professional Services : January 2019 
					
				End if 
				//end mod
				$ttJobNum:=StripChars(Import_GetDataForHeader("Job #"); " ")
				$ttBS:=StripChars(Import_GetDataForHeader("B/S"); " ")
				$xlUpNum:=Num:C11(StripChars(Import_GetDataForHeader("#up"); " "))
				$dDate:=Date:C102(StripChars(Import_GetDataForHeader("Date"); " "))
				
				If (Length:C16($ttCustomerCode)>0)
					QUERY:C277([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]OutlineNumber:4=$ttOutline; *)
					QUERY:C277([Job_DieBoard_Inv:168];  & ; [Job_DieBoard_Inv:168]UpNumber:5=$xlUpNum)
					If (Records in selection:C76([Job_DieBoard_Inv:168])=0)
						CREATE RECORD:C68([Job_DieBoard_Inv:168])
						[Job_DieBoard_Inv:168]OutlineNumber:4:=$ttOutline
						[Job_DieBoard_Inv:168]UpNumber:5:=$xlUpNum
					End if 
					[Job_DieBoard_Inv:168]CatelogID:10:=$ttCatelogID
					[Job_DieBoard_Inv:168]Customer:2:=$ttCustomerName
					[Job_DieBoard_Inv:168]DieNumber:3:=$ttJobNum
					[Job_DieBoard_Inv:168]Type:7:=$ttBS
					[Job_DieBoard_Inv:168]Location:8:=""  // Not using location yet
					[Job_DieBoard_Inv:168]DateEntered:6:=$dDate
					[Job_DieBoard_Inv:168]CustomerCode:12:=$ttCustomerCode
					
					SAVE RECORD:C53([Job_DieBoard_Inv:168])
				End if 
				
			End while 
			
			UNLOAD RECORD:C212([Job_DieBoard_Inv:168])
			BEEP:C151
			
		Else 
			ALERT:C41("Document not found")
		End if 
		
	End if 
	
End if 

