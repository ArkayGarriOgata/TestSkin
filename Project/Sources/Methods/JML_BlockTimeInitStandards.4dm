//%attributes = {}
// Method: JML_BlockTimeInitStandards () -> 
// ----------------------------------------------------
// by: mel: 01/28/05, 09:39:23
// ----------------------------------------------------
// Description:
// these are simplified standards to help calculate durations
//use by JML_BlockTimeCalcMachine (Self;iSheets) when there is a data chg or click
// ----------------------------------------------------

C_TEXT:C284($1)
ARRAY INTEGER:C220(aCCid; 9)
ARRAY INTEGER:C220(aRate; 9)
ARRAY REAL:C219(aMR; 9)

Case of 
	: (Count parameters:C259=0)  //init
		aCCid{1}:=428
		aRate{1}:=16000
		aMR{1}:=1
		aCCid{2}:=415
		aRate{2}:=5000
		aMR{2}:=1
		aCCid{3}:=412
		aRate{3}:=8000
		aMR{3}:=2
		aCCid{4}:=452
		aRate{4}:=2500
		aMR{4}:=1
		aCCid{5}:=453
		aRate{5}:=2500
		aMR{5}:=1
		aCCid{6}:=475
		aRate{6}:=2000
		aMR{6}:=1
		aCCid{7}:=461
		aRate{7}:=5000
		aMR{7}:=1
		aCCid{8}:=468
		aRate{8}:=5000
		aMR{8}:=1
		aCCid{9}:=478
		aRate{9}:=20000
		aMR{9}:=3
		
	: ($1="Roanoke")
		aCCid{4}:=452
		aRate{4}:=2500
		aMR{4}:=1
		aCCid{5}:=455
		aRate{5}:=2500
		aMR{5}:=1
		aCCid{6}:=475
		aRate{6}:=2000
		aMR{6}:=1
		aCCid{7}:=469
		aRate{7}:=5000
		aMR{7}:=1
		aCCid{8}:=468
		aRate{8}:=5000
		aMR{8}:=1
		aCCid{9}:=478
		aRate{9}:=20000
		aMR{9}:=3
		
	: ($1="Hauppauge")
		aCCid{4}:=453
		aRate{4}:=2500
		aMR{4}:=1
		aCCid{5}:=454
		aRate{5}:=2500
		aMR{5}:=1
		aCCid{6}:=474
		aRate{6}:=2000
		aMR{6}:=1
		aCCid{7}:=461
		aRate{7}:=5000
		aMR{7}:=1
		aCCid{8}:=462
		aRate{8}:=5000
		aMR{8}:=1
		aCCid{9}:=481
		aRate{9}:=20000
		aMR{9}:=3
		
End case 