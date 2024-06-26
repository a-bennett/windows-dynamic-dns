@echo off
setlocal

@REM Dynamic DNS for Namecheap.
@REM Update HOST, DOMAIN, DNSPASSWORD with the values from your namecheap account.
@REM This script uses nslookup and myip.opendns.com to get your machine's public IP address.

set HOST=[your_sub_domain]
set DOMAIN=[your_main_domain]
set DNSPASSWORD=[your_password]

@REM You can stop editing now.
set current_ip=ip.txt
set last_ip=lastip.txt

@REM allows script to be called from any directory.
cd /d "%~dp0"

for /f "usebackq skip=4 tokens=2" %%a in (`nslookup myip.opendns.com resolver1.opendns.com`) do echo %%a>%current_ip%

@REM Check if lastip.txt exists, if not, create it
if not exist %last_ip% (
    echo Creating lastip.txt...
    echo.>%last_ip%
)

@REM Compare ip.txt with lastip.txt
fc /b %current_ip% %last_ip% > nul

set /p ip=<%current_ip%

@REM If the files are different, run the curl command and update lastip.txt
if errorlevel 1 (
    echo IP has changed. Updating IP...
	echo "%ip%"
    curl "https://dynamicdns.park-your-domain.com/update?host=%HOST%&domain=%DOMAIN%&password=%DNSPASSWORD%&ip=%ip%" > nul
    copy /y %current_ip% %last_ip%
) else (
    echo IP has not changed.
)

echo Done.

endlocal