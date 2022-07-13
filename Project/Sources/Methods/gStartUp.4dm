//%attributes = {"publishedWeb":true}
//(P) gStartup: Default startup procdure
//mod 6/7/94 upr 1042
//mod BAK 9/27/94
//mod 10/20/94 chip
//mod 10/25/94 BAK
//1/3/95 chip
//•090195  MLB tweaks
//•021696  mBohince  Inventory Valuation Rpts exclude closed orders
//• 7/29/97 cs added windows list open automagically
//• 3/25/98 cs removed layout - unauthdata - referenced Impact
//• 4/3/98 cs added code to check that ficla calendar is correctly setup
//• 4/23/98 cs added code to start a fax server watching routine 
//• 6/16/98 cs added code to limit Fax server loggin to one occurance
//• 7/6/98 cs added ability for admin NOT to login to fax server
//•022399  MLB  add default century

SET DEFAULT CENTURY:C392(19; 93)  //•022399  MLB 

C_TEXT:C284($version)
C_DATE:C307($msgDate)
C_TEXT:C284($r)
$r:=Char:C90(Carriage return:K15:38)  //"\r"  //


$version:=000_version_number

NewWindow(300; 250; 2; 5; "Launching aMs")  //-722

uInitInterPrsVar  //• 9/22/97 cs do assignments to above vars
$msgDate:=4D_Current_date
MESSAGE:C88($r+String:C10($msgDate; Date RFC 1123:K1:11)+$r)

C_DATE:C307($warningStarts; $warningEnds)  // Modified by: Mel Bohince (1/9/21) 
$currentYear_s:=String:C10(Year of:C25($msgDate))
$warningStarts:=Date:C102("01/01/"+$currentYear_s)
$warningEnds:=Add to date:C393($warningStarts; 0; 0; 10)

Case of 
	: ($msgDate>$warningStarts) & ($msgDate<$warningEnds)
		MESSAGE:C88($r+" "+$r)
		MESSAGE:C88($r+"      Remember:"+$r)
		MESSAGE:C88($r+"         the year is"+$r)
		MESSAGE:C88($r+"            now "+$r)
		MESSAGE:C88($r+"              "+$currentYear_s+"  "+$r+$r)
		MESSAGE:C88($r+"    ----"+$r)
		
	: (False:C215)
		MESSAGE:C88($r+" "+$r)
		MESSAGE:C88($r+"      "+String:C10($msgDate-!2007-01-01!)+$r)
		MESSAGE:C88($r+"         days since"+$r)
		MESSAGE:C88($r+"            last "+$r)
		MESSAGE:C88($r+"                holiday "+$r+$r)
		MESSAGE:C88($r+"    ----"+$r)
		
	: (False:C215)
		MESSAGE:C88("  "+$r)
		MESSAGE:C88($r+" 06/22/2005     "+$r)
		MESSAGE:C88($r+"     U.S. Supreme Court  "+$r)
		MESSAGE:C88($r+"     strikes down 5th Amendment "+$r)
		MESSAGE:C88($r+"     of the U.S. Constitution."+$r)
		MESSAGE:C88($r+"           private property seazure allowed      -  -  "+$r)
		
	: (False:C215)
		MESSAGE:C88("  "+$r)
		MESSAGE:C88($r+" 12/10/2003     "+$r)
		MESSAGE:C88($r+"     U.S. Supreme Court  "+$r)
		MESSAGE:C88($r+"     strikes down 1st Amendment "+$r)
		MESSAGE:C88($r+"     of the U.S. Constitution."+$r)
		MESSAGE:C88($r+"           ban on political speech prior to elections      -  -  "+$r)
		
	: (False:C215)
		MESSAGE:C88("  "+$r)
		MESSAGE:C88($r+" 11/02/2008     "+$r)
		MESSAGE:C88($r+"     America elects  "+$r)
		MESSAGE:C88($r+"     a 'Progressive' (aka socialist) "+$r)
		MESSAGE:C88($r+"     as president."+$r)
		MESSAGE:C88($r+"           Watch your wallet, he's got an eye on it      -  -  "+$r)
		
	: (False:C215)
		MESSAGE:C88("  "+$r)
		MESSAGE:C88($r+" 11/02/2010     "+$r)
		MESSAGE:C88($r+"     Americans make their voices heard,  "+$r)
		MESSAGE:C88($r+"     democrates lose 60 house seats "+$r)
		MESSAGE:C88($r+"     and the majority."+$r)
		MESSAGE:C88($r+"                 -  -  "+$r)
		
	: (False:C215)
		MESSAGE:C88("  "+$r)
		MESSAGE:C88($r+" 01/06/2021     "+$r)
		MESSAGE:C88($r+"     Americans protest unconstitutional election,  "+$r)
		MESSAGE:C88($r+"     small group of rioters occupied the unprotected capitol, "+$r)
		MESSAGE:C88($r+"     one unarmed women veterian slain by police."+$r)
		MESSAGE:C88($r+"                 - see us const.  Art.1,§4, cl. 1-  "+$r)
		//The term “Elections Clause” refers to Art.1,§4, cl. 1, of the United States Constitution that reads as follows: “The Times,;but Congress may at any time make or alter such Regulations, except as to the Pl.”
		//In PA, GA, WI, and MI had their legistures election laws prempted by govenors, attorneys gen, and or state courts while US Congress made no uniform alteration as prescribed in the election clause
		
		
	: (True:C214)
		MESSAGE:C88(" Making ready... "+$r)
		//MESSAGE($r+" Check     "+$r)
		//MESSAGE($r+"                   "+$r)
		
	Else 
		MESSAGE:C88("  "+$r)
		MESSAGE:C88($r+" Procrastinate Now     "+$r)
		MESSAGE:C88($r+"       "+$r)
		MESSAGE:C88($r+"     don't put it off! "+$r)
		MESSAGE:C88($r+"     "+$r)
		MESSAGE:C88($r+"                 - Ellen D. -  "+$r)
End case 


//MESSAGE($r+"      ... "+Char(Carriage return))
uInitArrays
//MESSAGE($r+"      1..2.. "+$r)

//MESSAGE($r+"         check... "+$r)
//•••DESIGNER NOTE: Change value during update
<>sAPPNAME:="Arkay Management System "+Application version:C493  //••• Set this for app
zwStatusMsg("Version: "+<>sVERSION; <>sAPPNAME+" "+<>PLATFORM)

Case of 
	: (Current user:C182="Designer")
		gDsgnEntry
		util_MainWindowVisible("Show")
		//SET ABOUT("About aMs...";"uAbout")  `••• Set this for app
		
	: (Records in table:C83([zz_control:1])=0)
		BEEP:C151
		BEEP:C151
		ALERT:C41("You may NOT create a new datafile."+$r+"Please contact your database designer.")
		QUIT 4D:C291
		
	: (Current user:C182="Administrator")
		If (Records in table:C83([z_administrators:2])=0)
			CREATE RECORD:C68([z_administrators:2])
			[z_administrators:2]Administrator:1:="not avail"
			[z_administrators:2]CompanyName:2:="not avail"
			[z_administrators:2]AppVersion:3:=<>sVERSION
			[z_administrators:2]LastUpdate:4:=<>dLASTUPDATE
			SAVE RECORD:C53([z_administrators:2])
		End if 
		util_MainWindowVisible("Show")
		
	Else 
		//SET ABOUT("About aMs...";"uAbout")  `••• Set this for app
		util_MainWindowVisible("Hide")
End case 

//GENERAL STARTUP  
READ ONLY:C145([x_id_numbers:3])
//MESSAGE($r+"  Validating User Identity...")
uStartRespSetup
//MESSAGE($r+" Authorizing")
uTest4Security  //calls uInitPopUps procs

uInitSelectArra  //•090195  MLB 
//MESSAGE($r+"    Testing "+<>sVERSION+$r)
uInitPageLists  //Build Paging Pop-up arrays
//MESSAGE($r+"    1.2.3 "+$r)
uInit_Lists  //Execute List to Arrays, selection to lists
app_FormulaEditorSetup

BEEP:C151

REDUCE SELECTION:C351([z_administrators:2]; 0)
REDUCE SELECTION:C351([zz_control:1]; 0)
REDUCE SELECTION:C351([Users:5]; 0)
CLOSE WINDOW:C154
zwStatusMsg("Version: "+<>sVERSION; <>sAPPNAME+" "+<>PLATFORM)