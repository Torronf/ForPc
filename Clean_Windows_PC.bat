<# : batch script
@echo off
chcp 65001 > nul
goto :start
#>

:start
@echo off
:menu
cls
echo          Mantenimiento y Limpieza de Windows
echo Recomendamos usar estas Opciones en MODO ADMINISTRADOR.
echo.
echo 1. Limpieza Temporeros
echo 2. Limpieza Basurero
echo 3. Limpieza de Basura Aplicaciones instaladas
echo 4. Limpieza / Mantenimineto Sistema Operativo
echo 5. Limpieza Windows (Disk Cleanup)
echo 6. Limpieza Disco Duro
echo 7. Ejecutar todas las anteriores
echo 8. Salir

set /p opcion="Seleccione una opción (1-8): "

if "%opcion%"=="1" (
    call :confirmacion "Limpieza Temporeros" :limpiezaTemporeros
) else if "%opcion%"=="2" (
    call :confirmacion "Limpiezas Basurero" :limpiezasBasurero
) else if "%opcion%"=="3" (
    call :confirmacion "Limpieza Basura Aplicaciones" :limpiezaBasuraAplicaciones
) else if "%opcion%"=="4" (
    call :confirmacion "Limpieza Sistema Operativo" :limpiezaSistemaOperativo
) else if "%opcion%"=="5" (
    call :confirmacion "Limpieza Windows (Disk Cleanup)" :limpiezaRegistro
) else if "%opcion%"=="6" (
    call :confirmacion "Limpieza Disco Duro" :limpiezaDiscoDuro
) else if "%opcion%"=="7" (
    call :ejecutarTodas
) else if "%opcion%"=="8" (
    exit
) else (
    echo Opción no válida. Presiona cualquier tecla para volver al menú.
    pause >nul
    goto menu
)

goto menu

:confirmacion
set "respuesta="
set /p "respuesta=Iniciará el proceso de %1 en tu disco, ¿estás de acuerdo? (Sí/No): "
if /i "%respuesta%"=="S" (
    call %2
) else (
    echo Operación cancelada. Presiona cualquier tecla para volver al menú.
    pause >nul
)
goto :eof

:limpiezaTemporeros
echo Iniciando Limpieza Temporeros...
cd /D %temp%
for /d %%D in (*) do rd /s /q /f "%%D"
del /s /f /q %userprofile%\Recent\*.*
del /s /f /q C:\Windows\Prefetch\*.*
del /s /f /q C:\Windows\Temp\*.*
del /s /f /q %USERPROFILE%\appdata\local\temp\*.*
echo Proceso Terminado. Presiona cualquier tecla para continuar.
pause >nul
goto :eof

:limpiezasBasurero
echo Iniciando Limpiezas Basurero...
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /f
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /f
echo Proceso Terminado. Presiona cualquier tecla para continuar.
pause >nul
goto :eof

:limpiezaBasuraAplicaciones
echo Iniciando Limpieza Basura Aplicaciones...
wmic product get name,version /format:csv > "%temp%\InstalledPrograms.csv"
for /f "skip=1 tokens=1,2 delims=," %%a in ('type "%temp%\InstalledPrograms.csv"') do (
    start /wait wmic product where "name='%%a' and version='%%b'" call uninstall /nointeractive
)
del /q "%temp%\InstalledPrograms.csv"
echo Proceso Terminado. Presiona cualquier tecla para continuar.
pause >nul
goto :eof

:limpiezaSistemaOperativo
if exist "C:\Windows\Logs\CBS\CBS.log" (
    del /q "C:\Windows\Logs\CBS\CBS.log"
)
echo Iniciando Limpieza Sistema Operativo...
echo Esta Opción Requiere Tener Conexión a Internet (Proceso Dura 10m promedio)
echo Estos comandos son útiles para mantener la integridad del sistema operativo
echo y corregir posibles problemas con los archivos del sistema.Sin embargo, 
echo ten en cuenta que el uso de estos comandos puede llevar algún tiempo y 
echo genealmente requiere privilegios de administrador. (Presiones una Tecla Para Continuar).
pause >nul

Dism /Online /Cleanup-Image /ScanHealth
Dism /online /cleanup-image /restorehealth
Dism /Online /Cleanup-Image /CheckHealth
sfc /scannow

cls
type "C:\Windows\Logs\CBS\CBS.log"
pause

echo Proceso Terminado. Presiona cualquier tecla para continuar.
pause >nul
goto :eof

:limpiezaRegistro
echo Iniciando Limpieza Windows (Disk Cleanup)...
cleanmgr /sagerun:1
echo Proceso Terminado. Presiona cualquier tecla para continuar.
pause >nul
goto :eof

:limpiezaDiscoDuro
echo Iniciando Limpieza Disco Duro...
chkdsk /f
echo Proceso Terminado. Presiona cualquier tecla para continuar.
pause >nul
goto :eof

:ejecutarTodas
call :limpiezaTemporeros
call :limpiezasBasurero
call :limpiezaBasuraAplicaciones
call :limpiezaSistemaOperativo
call :limpiezaRegistro
call :limpiezaDiscoDuro
goto :eof
