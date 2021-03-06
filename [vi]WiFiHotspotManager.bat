@echo off
rem chcp 65001
title THIẾT LẬP TRẠM PHÁT WiFi - TADT

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

chcp 65001
CLS

    :begin
@ECHO off
ECHO  ---------------------------------------------------
ECHO  		THIẾT LẬP TRẠM PHÁT WiFi
ECHO  		  Một sản phẩm của TADT
ECHO  ---------------------------------------------------
ECHO  		Bạn muốn làm gì?
ECHO  ---------------------------------------------------
ECHO  		1 Thay đổi cấu hình
ECHO  		2 Bắt đầu phát WiFi
ECHO        3 Ngưng phát WiFi
ECHO  		4 Trạng thái hiện tại của WiFi
ECHO  		5 Thoát
ECHO  ---------------------------------------------------
SET /p option=Please enter one of the options:

if %option%==1  ( goto setup )      else set /a er=1
if %option%==2  ( goto start )     else set /a er=er+1
if %option%==3  ( goto stop )       else set /a er=er+1
if %option%==4  ( goto status )       else set /a er=er+1
if %option%==5  ( exit)

:noOption
if %er% GEQ 3 (
Echo 		Đã xảy ra lỗi!!!
Echo 	Vui lòng nhập lại (1, 2, 3, 4)
@pause
cls
goto start
)

:setup
SET /p ssid=Tên WiFi:
SET /p key=Mật khẩu WiFi (Trên 8 kí tự):
netsh wlan set hostednetwork mode=allow ssid="%ssid%" key="%key%"
if %errorlevel%==0 (
ECHO THIẾT LẬP THÀNH CÔNG!!!
)
@pause
cls
goto start

:start
netsh wlan start hostednetwork
@pause
cls
goto begin

:stop
netsh wlan stop hostednetwork
@pause
cls
goto begin

:status
netsh wlan show hostednetwork
echo SSID Name
netsh wlan show hostednetwork | findstr -i " ssid "
netsh wlan show hostednetwork setting=security
echo Connected clients
rem arp -a | findstr -i 192.168.173 | findstr /V 255 | findstr /V 192.168.173.1
netsh wlan show hostednetwork | findstr -i " Number of clients "
netsh wlan show hostednetwork | findstr -i " Authenticated "
echo.

@pause
cls
goto begin
goto :eof
