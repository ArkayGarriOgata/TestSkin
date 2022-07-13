//%attributes = {}
// Method: Barcode_MapToTriplets () -> 
// ----------------------------------------------------
// by: mel bohince: 01/20/05, 15:50:55
// `mlb 08/23/06 added stop char at element 107 and chg'd element 97
// ----------------------------------------------------
// Description:
// set up the conversion table, each char replaced by 3 to select font character
// ----------------------------------------------------

ARRAY TEXT:C222(<>aSetC128; 107)  //dictionary for translating an ascii to its fonts representation

//note the vba code starts at element 0, so offset when used!
If (False:C215)
	<>aSetC128{1}:=Char:C90(159)
	For ($i; 2; 95)
		<>aSetC128{$i}:=Char:C90($i-1+32)
	End for 
	
	For ($i; 96; 107)
		<>aSetC128{$i}:=Char:C90($i-1+100)
	End for 
	
Else   //new "BETA" universal fonts.
	<>aSetC128{1}:="EFF"
	<>aSetC128{2}:="FEF"
	<>aSetC128{3}:="FFE"
	<>aSetC128{4}:="BBG"
	<>aSetC128{5}:="BCF"
	<>aSetC128{6}:="CBF"
	<>aSetC128{7}:="BFC"
	<>aSetC128{8}:="BGB"
	<>aSetC128{9}:="CFB"
	<>aSetC128{10}:="FBC"
	<>aSetC128{11}:="FCB"
	<>aSetC128{12}:="GBB"
	<>aSetC128{13}:="AFJ"
	<>aSetC128{14}:="BEJ"
	<>aSetC128{15}:="BFI"
	<>aSetC128{16}:="AJF"
	<>aSetC128{17}:="BIF"
	<>aSetC128{18}:="BJE"
	<>aSetC128{19}:="FJA"
	<>aSetC128{20}:="FAJ"
	<>aSetC128{21}:="FBI"
	<>aSetC128{22}:="EJB"
	<>aSetC128{23}:="FIB"
	<>aSetC128{24}:="IEI"
	<>aSetC128{25}:="IBF"
	<>aSetC128{26}:="JAF"
	<>aSetC128{27}:="JBE"
	<>aSetC128{28}:="IFB"
	<>aSetC128{29}:="JEB"
	<>aSetC128{30}:="JFA"
	<>aSetC128{31}:="EEG"
	<>aSetC128{32}:="EGE"
	<>aSetC128{33}:="GEE"
	<>aSetC128{34}:="ACG"
	<>aSetC128{35}:="CAG"
	<>aSetC128{36}:="CCE"
	<>aSetC128{37}:="AGC"
	<>aSetC128{38}:="CEC"
	<>aSetC128{39}:="CGA"
	<>aSetC128{40}:="ECC"
	<>aSetC128{41}:="GAC"
	<>aSetC128{42}:="GCA"
	<>aSetC128{43}:="AEK"
	<>aSetC128{44}:="AGI"
	<>aSetC128{45}:="CEI"
	<>aSetC128{46}:="AIG"
	<>aSetC128{47}:="AKE"
	<>aSetC128{48}:="CIE"
	<>aSetC128{49}:="IIE"
	<>aSetC128{50}:="ECI"
	<>aSetC128{51}:="GAI"
	<>aSetC128{52}:="EIC"
	<>aSetC128{53}:="EKA"
	<>aSetC128{54}:="EII"
	<>aSetC128{55}:="IAG"
	<>aSetC128{56}:="ICE"
	<>aSetC128{57}:="KAE"
	<>aSetC128{58}:="IEC"
	<>aSetC128{59}:="IGA"
	<>aSetC128{60}:="KEA"
	<>aSetC128{61}:="IMA"
	<>aSetC128{62}:="FDA"
	<>aSetC128{63}:="OAA"
	<>aSetC128{64}:="ABH"
	<>aSetC128{65}:="ADF"
	<>aSetC128{66}:="BAH"
	<>aSetC128{67}:="BDE"
	<>aSetC128{68}:="DAF"
	<>aSetC128{69}:="DBE"
	<>aSetC128{70}:="AFD"
	<>aSetC128{71}:="AHB"
	<>aSetC128{72}:="BED"
	<>aSetC128{73}:="BHA"
	<>aSetC128{74}:="DEB"
	<>aSetC128{75}:="DFA"
	<>aSetC128{76}:="HBA"
	<>aSetC128{77}:="FAD"
	<>aSetC128{78}:="MIA"
	<>aSetC128{79}:="HAB"
	<>aSetC128{80}:="CMA"
	<>aSetC128{81}:="ABN"
	<>aSetC128{82}:="BAN"
	<>aSetC128{83}:="BBM"
	<>aSetC128{84}:="ANB"
	<>aSetC128{85}:="BMB"
	<>aSetC128{86}:="BNA"
	<>aSetC128{87}:="MBB"
	<>aSetC128{88}:="NAB"
	<>aSetC128{89}:="NBA"
	<>aSetC128{90}:="EEM"
	<>aSetC128{91}:="EME"
	<>aSetC128{92}:="MEE"
	<>aSetC128{93}:="AAO"
	<>aSetC128{94}:="ACM"
	<>aSetC128{95}:="CAM"
	<>aSetC128{96}:="AMC"
	<>aSetC128{97}:="AOA"  //mlb 08/23/06 chg'd from "AMA"
	<>aSetC128{98}:="MAC"
	<>aSetC128{99}:="MCA"
	<>aSetC128{100}:="AIM"
	<>aSetC128{101}:="AMI"
	<>aSetC128{102}:="IAM"
	<>aSetC128{103}:="MAI"
	<>aSetC128{104}:="EDB"
	<>aSetC128{105}:="EBD"
	<>aSetC128{106}:="EBJ"
	<>aSetC128{107}:="GIAH"  //mlb 08/23/06
End if 