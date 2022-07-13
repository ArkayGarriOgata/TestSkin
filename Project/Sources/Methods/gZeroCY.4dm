//%attributes = {"publishedWeb":true}
//(P) gZeroCY

rSheets:=0
rAct_MR:=0
rStd_MR:=0
rEff_MR:=0
rAct_Run:=0
rStd_Run:=0
rEff_Run:=0
rAct_Tot:=0
rStd_Tot:=0
rEff_Tot:=0
rDown_Hrs:=0
rDown_Pct:=0
rDown_Bud:=0
rAct_Imp:=0
rStd_Imp:=0

ARRAY REAL:C219(aySheets; 12)
ARRAY REAL:C219(ayAct_MR; 12)
ARRAY REAL:C219(ayStd_MR; 12)
ARRAY REAL:C219(ayEff_MR; 12)
ARRAY REAL:C219(ayAct_Run; 12)
ARRAY REAL:C219(ayStd_Run; 12)
ARRAY REAL:C219(ayEff_Run; 12)
ARRAY REAL:C219(ayAct_Tot; 12)
ARRAY REAL:C219(ayStd_Tot; 12)
ARRAY REAL:C219(ayEff_Tot; 12)
ARRAY REAL:C219(ayDown_Hrs; 12)
ARRAY REAL:C219(ayDown_Pct; 12)
ARRAY REAL:C219(ayDown_Bud; 12)
ARRAY REAL:C219(ayAct_Imp; 12)
ARRAY REAL:C219(ayStd_Imp; 12)

For ($i; 1; 12)
	aySheets{$i}:=0
	ayAct_MR{$i}:=0
	ayStd_MR{$i}:=0
	ayEff_MR{$i}:=0
	ayAct_Run{$i}:=0
	ayStd_Run{$i}:=0
	ayEff_Run{$i}:=0
	ayAct_Tot{$i}:=0
	ayStd_Tot{$i}:=0
	ayEff_Tot{$i}:=0
	ayDown_Hrs{$i}:=0
	ayDown_Pct{$i}:=0
	ayDown_Bud{$i}:=0
	ayAct_Imp{$i}:=0
	ayStd_Imp{$i}:=0
End for 