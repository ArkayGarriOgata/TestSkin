//%attributes = {"publishedWeb":true}
//PM:  Pjt_setReferId  5/03/00  mlb
//set up pjt id for pass off

If (<>pjtId#$1)
	$tries:=5
	While (Length:C16(<>pjtId)=5) & ($tries>0)
		zwStatusMsg("PROJECT"; "Waiting to assign pjt id...")
		DELAY PROCESS:C323(Current process:C322; 10)
		IDLE:C311
		$tries:=$tries-1
	End while 
	zwStatusMsg("PROJECT"; $1)
	<>pjtId:=$1
End if 

