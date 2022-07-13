//%attributes = {"publishedWeb":true}
//(p) sEnterMSDS
//system to allow users to mass populate RM's new MSDS
//• 2/17/98 cs created

C_REAL:C285(iComm)
C_TEXT:C284(xText)
ARRAY TEXT:C222(aText; 0)
ARRAY TEXT:C222(aRmCode; 0)
ARRAY TEXT:C222(aBullet; 0)

uWinListCleanup

Repeat 
	iComm:=Num:C11(Request:C163("Please Enter a Commodity Code."; "00"))
Until (iComm#0) | (OK=0)

If (OK=1)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]CommodityCode:26=iComm)
	
	If (Records in selection:C76([Raw_Materials:21])>0)
		$Count:=Records in selection:C76([Raw_Materials:21])
		ARRAY TEXT:C222(aRmCode; $Count)
		ARRAY TEXT:C222(aBullet; $Count)
		ARRAY TEXT:C222(aText; $Count)
		uMsgWindow("Loading Materials...")
		SELECTION TO ARRAY:C260([Raw_Materials:21]Raw_Matl_Code:1; aRmCode; [Raw_Materials:21]Description:4; aText)
		SORT ARRAY:C229(aRmCode; aText; >)
		uClearSelection(->[Raw_Materials:21])
		CLOSE WINDOW:C154
		
		uDialog("MSDS"; 500; 500; 8)
		
		If (OK=1)  //user OKed Dialog and at least one element marked and an MSDS id enterd
			uMsgWindow("")
			$MSDS:=xText
			xText:=""
			$loc:=Find in array:C230(aBullet; "√")
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				CREATE EMPTY SET:C140([Raw_Materials:21]; "Found")
				MESSAGE:C88("Updating Materials...")
				TRACE:C157
				For ($i; 1; $Count)  //go through arrays, locate RM record for any marked RMs
					QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=aRmCode{$loc})
					CREATE SET:C116([Raw_Materials:21]; "Temp")
					UNION:C120("Temp"; "Found"; "Found")  //add to set of found records
					$loc:=Find in array:C230(aBullet; "√"; $loc+1)
					
					If ($Loc<0)  //if there are no more - exit ffor loop
						$i:=$Count+1
					End if 
				End for 
				
				USE SET:C118("Found")
				CLEAR SET:C117("Temp")
				CLEAR SET:C117("Found")
				
			Else 
				
				CREATE EMPTY SET:C140([Raw_Materials:21]; "Temp")
				CREATE EMPTY SET:C140([Raw_Materials:21]; "Found")
				MESSAGE:C88("Updating Materials...")
				TRACE:C157
				For ($i; 1; $Count)  //go through arrays, locate RM record for any marked RMs
					SET QUERY DESTINATION:C396(Into set:K19:2; "Temp")
					QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=aRmCode{$loc})
					SET QUERY DESTINATION:C396(Into current selection:K19:1)
					UNION:C120("Temp"; "Found"; "Found")  //add to set of found records
					$loc:=Find in array:C230(aBullet; "√"; $loc+1)
					
					If ($Loc<0)  //if there are no more - exit ffor loop
						$i:=$Count+1
					End if 
				End for 
				
				USE SET:C118("Found")
				CLEAR SET:C117("Temp")
				CLEAR SET:C117("Found")
				
			End if   // END 4D Professional Services : January 2019 
			
			READ WRITE:C146([Raw_Materials:21])
			
			Repeat 
				APPLY TO SELECTION:C70([Raw_Materials:21]; [Raw_Materials:21]MSDS_ID:33:=$MSDS)  //set MSDS id
			Until (uChkLockedSet(->[Raw_Materials:21]))  //until no more records are locked
			uClearSelection(->[Raw_Materials:21])
			CLOSE WINDOW:C154
		End if 
	Else 
		ALERT:C41("No Materials were found for Commodity Code "+String:C10(iComm; "00"))
	End if 
End if 

uClearSelection(->[Raw_Materials:21])
uWinListCleanup