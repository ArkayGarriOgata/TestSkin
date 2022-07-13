//%attributes = {"publishedWeb":true}
//PM: JTB_LogJPSI() -> 
//@author mlb - 2/7/02  14:52

C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

CREATE RECORD:C68([JPSI_Logs:115])
[JPSI_Logs:115]JPSIid:1:=$1
[JPSI_Logs:115]tsTimeStamp:2:=TSTimeStamp
[JPSI_Logs:115]Description:3:=$2+"  ["+<>zResp+"]"
SAVE RECORD:C53([JPSI_Logs:115])
If (Count parameters:C259=3)
	QUERY:C277([JPSI_Logs:115]; [JTB_Logs:114]JTBid:1=$1)
	ORDER BY:C49([JPSI_Logs:115]; [JPSI_Logs:115]tsTimeStamp:2; <)
	REDRAW:C174([JPSI_Logs:115])
End if 