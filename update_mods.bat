@echo off
setlocal EnableDelayedExpansion
:: -----------------------------------------------------------
::  Atualizador ModPack-Mina-Craft
:: -----------------------------------------------------------
::  - Detecta se já está dentro do repo
::  - pull ou clone/zip
::  - copia mods + config para .minecraft
:: -----------------------------------------------------------

rem === CONFIGURÁVEIS =======================================
set "REPO_URL=https://github.com/BrenoSI03/ModPack-Mina-Craft.git"
set "ZIP_URL=https://github.com/BrenoSI03/ModPack-Mina-Craft/archive/refs/heads/main.zip"
set "REPO_NAME=ModPack-Mina-Craft"
set "MC_DIR=%APPDATA%\.minecraft"
rem =========================================================

rem --------- Onde está/ficará o repositório ---------------
set "SCRIPT_DIR=%~dp0"
if exist "%SCRIPT_DIR%.git" (
    rem Script dentro do repo já clonado
    set "BASE_DIR=%SCRIPT_DIR%"
) else if exist "%SCRIPT_DIR%%REPO_NAME%\mods" (
    rem Script fora, mas repo já clonado ao lado
    set "BASE_DIR=%SCRIPT_DIR%%REPO_NAME%"
) else (
    rem Não há repo ainda; usaremos subpasta ao lado do script
    set "BASE_DIR=%SCRIPT_DIR%%REPO_NAME%"
)

echo =====================================================
echo  ModPack-Mina-Craft – atualizador
echo  Pasta do repo: %BASE_DIR%
echo =====================================================
echo.

rem --------- Git disponível? ------------------------------
where git >nul 2>nul
if !ERRORLEVEL! EQU 0 (
    set "GIT_OK=1"
) else (
    set "GIT_OK=0"
)

rem --------- Se a pasta já existe -------------------------
if exist "%BASE_DIR%\mods" (
    echo Repositório já presente.
    if "%GIT_OK%"=="1" (
        echo Fazendo git pull...
        pushd "%BASE_DIR%"
        git pull
        popd
    ) else (
        echo Git nao encontrado – baixando ZIP para atualizar...
        curl -L -o "%BASE_DIR%\repo.zip" %ZIP_URL%
        tar -xf "%BASE_DIR%\repo.zip" -C "%BASE_DIR%" --strip-components=1
        del "%BASE_DIR%\repo.zip"
    )
) else (
    rem --------- Pasta não existe ainda -------------------
    if "%GIT_OK%"=="1" (
        echo Clonando repositório...
        git clone %REPO_URL% "%BASE_DIR%"
    ) else (
        echo Git nao encontrado – baixando ZIP...
        mkdir "%BASE_DIR%"
        curl -L -o "%BASE_DIR%\repo.zip" %ZIP_URL%
        tar -xf "%BASE_DIR%\repo.zip" -C "%BASE_DIR%" --strip-components=1
        del "%BASE_DIR%\repo.zip"
    )
)

echo.
echo Copiando mods...
xcopy /E /I /Y "%BASE_DIR%\mods"   "%MC_DIR%\mods"   >nul
echo Copiando config...
xcopy /E /I /Y "%BASE_DIR%\config" "%MC_DIR%\config" >nul

echo.
echo ✅  Mods e configs atualizados com sucesso!
pause
endlocal
