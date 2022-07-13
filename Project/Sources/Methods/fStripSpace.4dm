//%attributes = {"publishedWeb":true}
//(p) fStripSpace
//txt_Trim //see also
//$1 place to strip from - L - left, R - Right, B - Both
//$2 text to strip
//• 11/11/97 cs if this routine is passed all spaces this returns the inital strin
// rewrite to fix this
//• 7/9/98 cs this routine is allowing strings that start with 'illegal' character
//  fix this - use ascii comparisions instead of fixed strings
//   specified ascii characters:
//  ascii 202 = option space
//  ascii 127 = DEL 
//  ascii 64 = '@'  NOT valid in any field - search conflits
//  ascii 33 = '!'
//  ascii 48 = '0' (zero)
//  ascii 35 = '#'
//  This routine now filters out any NON PRINTING characters in Geneva

C_TEXT:C284($2; $0; $Text)
C_LONGINT:C283($i; $len; $Ascii)
C_TEXT:C284($1)

$Text:=""
$len:=Length:C16($2)

Case of 
	: ($1="L")  //from left
		For ($i; 1; $len)  //start at begining of string
			$Ascii:=Character code:C91($2[[$i]])  //• 7/9/98 cs get ascii char
			
			If ($Ascii>=48) & (($Ascii#127) | ($Ascii#202) | ($Ascii#64))  //• 7/9/98 cs ascii 48 = '0' - zero, this is a valid lead character
				$Text:=Substring:C12($2; $i; $len)  //at first valid char, take it and remaining chars
				$i:=$len  //and drop out of the loop
			End if   //valid check        
		End for 
		$0:=$Text
		
	: ($1="R")  //from right
		For ($i; $len; 1; -1)  //start at end of string
			$Ascii:=Character code:C91($2[[$i]])  //• 7/9/98 cs get ascii char      
			
			//If (($2≤$i≥#" ") & ($2≤$i≥#" "))  `check for non-space or option
			//«-space character
			If (($Ascii>=35) & (($Ascii#127) | ($Ascii#202) | ($Ascii#64))) | ($Ascii=33)  //• 7/9/98 cs ascii 35 = '#' this MAY BE a valid end character
				$Text:=Substring:C12($2; 1; $i)  //at first valid char, take it and remaining chars
				$i:=0  //and drop out of the loop
			End if   //valid check        
		End for 
		$0:=$Text
		
	: ($1="B")  //both ends
		//• 11/11/97 cs made recusive
		$Text:=fStripSpace("R"; $2)
		$Text:=fStripSpace("L"; $Text)
		$0:=$Text
		
	: ($1="A")  //all -`• 7/9/98 cs replaces all non printing characters
		$0:=""
		$Text:=fStripSpace("L"; $2)  //• 7/9/98 cs strip front end, slightly different rules, then strip the rest
		
		For ($i; 1; Length:C16($Text))
			$Ascii:=Character code:C91($Text[[$i]])  //• 7/9/98 cs get ascii char      
			
			If (($Ascii>=35) & (($Ascii#127) | ($Ascii#202) | ($Ascii#64))) | ($Ascii=33)  //• 7/9/98 cs ascii 35 = '#' these MAY BE a valid characters
				$0:=$0+$Text[[$i]]
			End if 
		End for 
	Else 
		ALERT:C41("Mr. Programmer, text:=fStripSpace('L'|'R'|'B'|'A';text)")
		$0:=$2
End case 