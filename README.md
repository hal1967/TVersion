# TVersion
Delphi Unit in order to get <b>fileversion</b> info from exe file (windows). 

File:       <b>VersionUnit.pas</b>                                                
Function:   TVersion implementation, record than drives Version exe file information. Bring 2 additional functions in order to get version info from exe file or resources                    
                                                                           
<i>Español     TVersion: record (structured type) para manejar la informacion de versión de los archivos ejecutables. Además un par de funciones para obtener esta información via archivo de recursos y por llamada al api de windows.</i>
                                                                           
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
    
    
<i>Spanish</i>

Esto es parte de un artículo docente escrito en https://www.gavidia.org/tversion-i/ 
el mismo instruye respecto a "Record, class operator"

<b>Resumen</b>

En estos momentos tenemos un record de nombre <b>Tversion</b> con un conjunto de campos superpuestos (ver64 superpuesto a vMayor, vMenor, Release y Build). Además contamos con un conjunto de operadores de comparación que nos permite <, >, = y otros que hemos agregado para tener el juego completo. Y por último nuestra estructura acepta que le asignemos un string o lo expresemos como uno según requiramos.

Además un constructor que recibe los cuatro valores de la versión.

