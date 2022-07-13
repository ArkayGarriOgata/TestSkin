//OM: bShow() -> 
//@author mlb - 9/25/02  16:02

C_LONGINT:C283($winRef)

JMI_CertOfAnal_Stats

$winRef:=Open form window:C675([QA_CertOfAnalysisSpecs:120]; "ShowSpecs.dio"; 5)
DIALOG:C40([QA_CertOfAnalysisSpecs:120]; "ShowSpecs.dio")
CLOSE WINDOW:C154($winRef)