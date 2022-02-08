# TVersion
Delphi Unit in order to get <b>fileversion</b> info from exe file (windows). 

File:       <b>VersionUnit.pas</b>                                                
Function:   TVersion implementation, record than drives Version exe file information. Bring 2 additional functions in order to get version info from exe file or resources                    
                                                                           
Language:   <b>Delphi</b> version XE2 or later                                    
Author:     Alirio Gavidia
                                                                           
Credits (Thanks):                                                                   
         StackOverflow:                                                    
            Stijn Sanders                                                  
            Get version form resources                                     
            How to determine Delphi Application Version                    
            https://stackoverflow.com/users/87971/stijn-sanders            
                                                                           
            - https://stackoverflow.com/questions/1717844/how-to-determine-delphi-application-version/1720501   
                                                                           
    
This is part of a teaching article written at https://www.gavidia.org/tversion-i/  (spanish) it instructs about "Record, class operator"


<b>Summary</b>

We currently have a record named <b>Tversion</b> with a set of overlapping fields (ver64 overlapping vMajor, vMinor, Release and Build). We also have a set of comparison operators that allows us <, >, = and others that we have added to have the complete set. And finally our structure accepts that we assign a string

Also a constructor that receives the four version values separated.    
    
    
