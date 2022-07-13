//%attributes = {"publishedWeb":true}
//uDefaultMatls  upr 1211 & 68  10/5/94
//upr 1305 11/2/94
//upr 1429, 1443 3/13/95
//•062796  MLB  add the 412, 462, and 468
//•072396  MLB  add the 411
//•072396  MLB  create uDefaultMatCre for shared code
//•031197  mBohince  Make a couple of slighe modifications matl defaults
//•071699  mlb  hidden dialog
//•071503  mlb  change to 04-Plates for all presses
// • mel (4/8/05, 15:35:59) use ip group everywhere possible, includeing new embossing series
C_LONGINT:C283($1; $X)
C_TEXT:C284($commkey)
$X:=$1
Case of 
	: (Position:C15(asCC{$x}; <>SHEETERS)#0)  // (Position("426";asCC{$x})#0) | (Position("428";asCC{$x})#0)
		$commkey:="01-"+[Process_Specs:18]Stock:7+"."
		If (([Process_Specs:18]Caliper:8*1000)=(Int:C8([Process_Specs:18]Caliper:8*1000)))
			$commkey:=$commkey+String:C10([Process_Specs:18]Caliper:8*1000)  //.018
		Else 
			$commkey:=$commkey+String:C10([Process_Specs:18]Caliper:8*10000)  //.0187
		End if 
		uDefaultMatlCre($commkey; asCC{$x}; aiSeq{$X})
		
		If (asCC{$x}="427")  //air knife
			$commkey:="01-"+[Process_Specs:18]Stock:7+"."
			If (([Process_Specs:18]Caliper:8*1000)=(Int:C8([Process_Specs:18]Caliper:8*1000)))
				$commkey:=$commkey+String:C10([Process_Specs:18]Caliper:8*1000)  //.018
			Else 
				$commkey:=$commkey+String:C10([Process_Specs:18]Caliper:8*10000)  //.0187
			End if 
			uDefaultMatlCre($commkey; asCC{$x}; aiSeq{$X})
			uDefaultMatlCre("02-AIR KNIFE SLURRY"; asCC{$x}; aiSeq{$X})
			uDefaultMatlCre("02-GRAVURE INK"; asCC{$x}; aiSeq{$X})
		End if 
		
	: (Position:C15(asCC{$x}; <>PRESSES)#0)  //•062796  MLB 
		If (asCC{$x}#"417")  //not screen press
			uDefaultMatlCre("02-UV PROCESS"; asCC{$x}; aiSeq{$X})
			uDefaultMatlCre("02-UV SPECIAL"; asCC{$x}; aiSeq{$X})
			uDefaultMatlCre("04-Plates"; asCC{$x}; aiSeq{$X})  //•071503  mBohince
			
			//•071699  mlb  hidden dialog
			CONFIRM:C162("Do you want an 03 Coating for the "+asCC{$x}+" press?"; "Coating"; "None")
			If (ok=1)
				CONFIRM:C162("What type of coating?"; "UV"; "Water")
				If (ok=1)
					uDefaultMatlCre("03-UV Coating, Inlin"; asCC{$x}; aiSeq{$X})
				Else 
					uDefaultMatlCre("03-WB Coating, Inlin"; asCC{$x}; aiSeq{$X})
				End if 
			End if 
		Else   //screen press
			uDefaultMatlCre("02-SCREEN"; asCC{$x}; aiSeq{$X})
			uDefaultMatlCre("04-SCREENS"; asCC{$x}; aiSeq{$X})
		End if 
		
		
	: (Position:C15(asCC{$x}; <>COATERS)#0)
		uDefaultMatlCre("03-WB DULL LACQUER"; asCC{$x}; aiSeq{$X})
		
	: (Position:C15(asCC{$x}; <>STAMPERS)#0)
		uDefaultMatlCre("05-GOLD"; asCC{$x}; aiSeq{$X})
		uDefaultMatlCre("07-Stamping Dies"; asCC{$x}; aiSeq{$X})  //"51-STAMP SUPPLIES")`upr 1429, 1443 3/13/95    
		
	: (Position:C15(asCC{$x}; "581")#0)
		uDefaultMatlCre("04-SCREENS"; asCC{$x}; aiSeq{$X})
		
	: (Position:C15(asCC{$x}; <>BLANKERS)#0)  //•062796  MLB 
		uDefaultMatlCre("13-Laser Dies"; asCC{$x}; aiSeq{$X})  //"71-NORMAL DIE MAKING")  `upr 1429, 1443 3/13/95
		
	: (Position:C15(asCC{$x}; <>GLUERS)#0)  //•031197  mBohince  ralphy says
		uDefaultMatlCre("06-CORR 200#"; asCC{$x}; aiSeq{$X})
		
	: (Position:C15(asCC{$x}; <>LAMINATERS)#0)  //◊EMBOSSERS
		uDefaultMatlCre("08-ACETATE LAM_IN_LB"; asCC{$x}; aiSeq{$X})  //•031197  mBohince  
		uDefaultMatlCre("08-ADHESIVE"; asCC{$x}; aiSeq{$X})  //•031197  mBohince  
		
	: (Position:C15(asCC{$x}; <>EMBOSSERS)#0)
		uDefaultMatlCre("07-EMBOSSING Dies"; asCC{$x}; aiSeq{$X})  //upr 1429, 1443 3/13/95
		
	: (Position:C15("486"; asCC{$x})#0)
		[Process_Specs_Machines:28]OutsideService:23:=True:C214  // • mel (7/22/04, 15:56:46)
		SAVE RECORD:C53([Process_Specs_Machines:28])
		//uDefaultMatlCre ("17-WIND POLY200";asCC{$x};aiSeq{$X})
		uDefaultMatlCre("13-OS WINDOWING"; asCC{$x}; aiSeq{$X})  // • mel (7/22/04, 15:56:46)
		
		
End case 
//