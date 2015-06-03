SET TIMESTAMP="%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
"..\..\PortableApps\7-ZipPortable\App\7-Zip64\7z.exe" a ..\ServerBackup\%timestamp%.7z *
"..\..\PortableApps\Java64\bin\java.exe" -jar forge-1.7.10-10.13.2.1291-universal.jar nogui
"..\..\PortableApps\7-ZipPortable\App\7-Zip64\7z.exe" a ..\ServerBackup\%timestamp%.7z *