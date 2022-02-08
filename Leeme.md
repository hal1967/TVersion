# TVersion
Delphi Unit para obtener <b>fileversion</b> archivos ejecutables (windows). 

Archivo:       <b>VersionUnit.pas</b>                                                
                                                                          
Español     TVersion: record (structured type) para manejar la informacion de versión de los archivos ejecutables. Además un par de funciones para obtener esta información via archivo de recursos y por llamada al api de windows.
                                                                           
Lenguaje:   <b>Delphi</b> version XE2 or later                                    
Autor:     Alirio Gavidia
                                                                           
Agradecimientos:  
         StackOverflow:                                                    
            Stijn Sanders                                                  
            Get version form resources                                     
            How to determine Delphi Application Version                    
            https://stackoverflow.com/users/87971/stijn-sanders            
                                                                           
            - https://stackoverflow.com/questions/1717844/how-to-determine-delphi-application-version/1720501   
                                                                           
    
Esto es parte de un artículo docente escrito en https://www.gavidia.org/tversion-i/ 
el mismo instruye respecto a "Record, class operator"

<b>Resumen</b>

En estos momentos tenemos un record de nombre <b>Tversion</b> con un conjunto de campos superpuestos (ver64 superpuesto a vMayor, vMenor, Release y Build). Además contamos con un conjunto de operadores de comparación que nos permite <, >, = y otros que hemos agregado para tener el juego completo. Y por último nuestra estructura acepta que le asignemos un string o lo expresemos como uno según requiramos.

Además un constructor que recibe los cuatro valores de la versión.

