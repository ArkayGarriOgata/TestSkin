//%attributes = {"publishedWeb":true}
//gEstMakeDiffID()    -JML   9/29/93, mod mlb 11.12.93
//Makes a 2 character label used to uniquely Identify a differential 
//within an estimate

C_TEXT:C284($0)

[Estimates:17]Last_Differential_Number:31:=[Estimates:17]Last_Differential_Number:31+1
SAVE RECORD:C53([Estimates:17])

$0:=util_base26([Estimates:17]Last_Differential_Number:31-1)