//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Macro_0000Explain
//Description:  This method will explain how the macros folder works and where
//              the marcos folder should reside

//  Brief intro.  In the 4D application on the mac, 4D has the following 4d:Contents:Resources:en.lproj:Macros.xml and MacrosEN.xlf
//   4D will copy the Macros.xml document to the Users:Current User:Library:Preferences:4D:Macros v2:Macros.xml
//   Whenever the 4D application is launched it will have the Macros that 4D installed.

//  In our applications we have the NucleusMacros.xml file.  This document is stored in the databases Resources folder.
//  We put them here so that it can then be copied to the Users Macros v2 folder.

//  It is ok to have multiple Macro.xml files in the Macros v2 folder.  4D will display them in the macros dropdown.

//  In order to make sure a developer has the Nucleus macros simply run Core_Macro_Install.
