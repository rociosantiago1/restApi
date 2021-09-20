@ECHO off
CLS
ECHO Date format = %date%

REM Breaking down the format 
REM FOR /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set datetime=%%G
for /f "skip=1" %%i in ('wmic os get localdatetime') do if not defined fulldate set fulldate=%%i

set year=%fulldate:~0,4%
set month=%fulldate:~4,2%
set day=%fulldate:~6,2%
set hour=%fulldate:~8,9%
set foldername=%year%.%month%.%day%.%hour%

ECHO Creando carpeta: %foldername%
MKDIR salida\%foldername%

ECHO/

ECHO Generando reporte jmeter...
apache-jmeter-5.3\bin\jmeter.sh -p ./jmeteronline1.properties -f -n -t ./rocio_DummyRestApi_v2.jmx -l ./salida/%foldername%/resultados.jtl -j ./salida/%foldername%/resultados.log
ECHO Generando html...
apache-jmeter-5.3\bin\jmeter.sh -g  ./salida/%foldername%/resultados.jtl -o ./salida/%foldername%/html/
ECHO Generando csv...
apache-jmeter-5.3\bin\JMeterPluginsCMD.sh --generate-csv ./salida/%foldername%/resultados.csv --input-jtl ./salida/%foldername%/resultados.jtl   --plugin-type AggregateReport


PAUSE