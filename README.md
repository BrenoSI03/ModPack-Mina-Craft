
# 🎮 ModPack-Mina-Craft – Atualizador de Mods

Este repositório contém scripts de **atualização automática** dos mods e configurações do **ModPack-Mina-Craft**. Com apenas um clique ou comando, você garante que seu Minecraft está sempre com os arquivos mais recentes do repositório oficial!

---

## 📥 Pré-requisitos

- **Git** (opcional, mas recomendado): Se não estiver instalado, os scripts baixam o repositório como ZIP.
- **Minecraft já instalado.**
- **Conexão com a internet.**

---

## 🪟 Instruções para Windows

1. Baixe o arquivo `update_mods_win.bat`.
2. Coloque o `.bat` em qualquer pasta onde deseja que o repositório seja salvo **ou dentro do próprio repositório se já tiver clonado.**
3. **Execute com um duplo clique.**
4. O script irá:
   - Usar `git pull` se o Git estiver instalado.
   - Caso contrário, fará download do ZIP do repositório.
   - Copiará os arquivos `mods` e `config` para a pasta `%APPDATA%\.minecraft`.
   - Abrirá a pasta de `mods` no final.

> 💡 Dica: Execute o script novamente sempre que quiser atualizar os mods.

---

## 🍎 Instruções para macOS / Linux

1. Baixe o arquivo `update_mods_mac.sh`.
2. Dê permissão de execução:
   ```bash
   chmod +x update_mods_mac.sh
    ```

3. Execute no terminal:

   ```bash
   ./update_mods_mac.sh
   ```
4. O script irá:

   * Usar `git pull` se o Git estiver instalado.
   * Caso contrário, baixará o ZIP.
   * Copiará os arquivos `mods` e `config` para a pasta:

     * macOS: `~/Library/Application Support/minecraft`
     * Linux: troque a variável `MC_DIR` para `~/.minecraft` dentro do script.
   * Abrirá a pasta `mods` automaticamente (via `open` no macOS ou `xdg-open` no Linux).

---

## 🚀 O que os scripts fazem?

* Detectam se o repositório já existe.
* Atualizam via Git ou download ZIP.
* Copiam os diretórios `mods` e `config` para o Minecraft.
* Abrem a pasta de `mods` ao final.
* São seguros e não apagam seus saves nem outros arquivos pessoais.

---

## 🛠️ Personalização

Se quiser adaptar os scripts para outras versões do Minecraft ou diretórios personalizados:

* Edite o caminho da pasta do Minecraft:

  * Windows: `set "MC_DIR=%APPDATA%\.minecraft"`
  * Mac/Linux: `MC_DIR="~/Library/Application Support/minecraft"`

---


## 📜 Código do Script para Windows (`update_mods_win.bat`)

```bat
@echo off
setlocal EnableDelayedExpansion
:: =========================================================
::  Atualizador ModPack-Mina-Craft (distribua so este .bat)
:: =========================================================

:: -------- configuracoes ----------------------------------
set "REPO_URL=https://github.com/BrenoSI03/ModPack-Mina-Craft.git"
set "ZIP_URL=https://github.com/BrenoSI03/ModPack-Mina-Craft/archive/refs/heads/main.zip"
set "REPO_NAME=ModPack-Mina-Craft"
set "MC_DIR=%APPDATA%\.minecraft"
:: ---------------------------------------------------------

:: Caminho onde o .bat esta rodando
set "SCRIPT_DIR=%~dp0"

:: Identificar se o .bat esta dentro do repo ou ao lado
if exist "%SCRIPT_DIR%.git" (
    rem --> .bat foi colocado DENTRO do repositorio
    set "BASE_DIR=%SCRIPT_DIR%"
) else if exist "%SCRIPT_DIR%%REPO_NAME%\.git" (
    rem --> repositorio ja esta na MESMA pasta que o .bat
    set "BASE_DIR=%SCRIPT_DIR%%REPO_NAME%"
) else (
    rem --> ainda nao ha repositorio
    set "BASE_DIR=%SCRIPT_DIR%%REPO_NAME%"
)

echo =====================================================
echo  ModPack-Mina-Craft - atualizador
echo  Diretorio do repo: %BASE_DIR%
echo =====================================================
echo.

:: Git instalado?
where git >nul 2>nul
if !ERRORLEVEL! EQU 0 (
    set "GIT_OK=1"
) else (
    set "GIT_OK=0"
)

:: -------- Fluxo principal --------------------------------
if exist "%BASE_DIR%\.git" (
    rem Repo ja presente
    if "%GIT_OK%"=="1" (
        echo Fazendo git pull...
        pushd "%BASE_DIR%"
        git pull --ff-only
        popd
    ) else (
        echo Git nao encontrado - atualizando via ZIP...
        call :DownloadExtractZip
    )
) else (
    rem Repo ainda nao existe
    if "%GIT_OK%"=="1" (
        echo Clonando repositorio...
        git clone --depth 1 %REPO_URL% "%BASE_DIR%"
    ) else (
        echo Git nao encontrado - baixando ZIP...
        call :DownloadExtractZip
    )
)

:: -------- Copiar mods e config ---------------------------
echo.
echo Copiando mods...
xcopy /E /I /Y "%BASE_DIR%\mods"   "%MC_DIR%\mods"   >nul
echo Copiando config...
xcopy /E /I /Y "%BASE_DIR%\config" "%MC_DIR%\config" >nul

:: -------- Abrir a pasta mods para conferencia ------------
start "" "%MC_DIR%\mods"

echo.
echo :)  Mods e configs atualizados com sucesso!
pause
endlocal
exit /b

:: =========================================================
::  Funcao: baixar ZIP + extrair sobrescrevendo repo
:: =========================================================
:DownloadExtractZip
    rem Garante pasta alvo
    if not exist "%BASE_DIR%" mkdir "%BASE_DIR%"
    echo Baixando ZIP do repo...
    curl -L -o "%BASE_DIR%\repo.zip" %ZIP_URL%
    echo Extraindo...
    tar -xf "%BASE_DIR%\repo.zip" -C "%BASE_DIR%" --strip-components=1
    del "%BASE_DIR%\repo.zip"
    goto :eof
```

---

## 📜 Código do Script para macOS/Linux (`update_mods_mac.sh`)

```bash
#!/usr/bin/env bash
# =========================================================
#  Atualizador ModPack-Mina-Craft – macOS / Linux
#  Distribua apenas este .sh
# =========================================================
set -euo pipefail

# ------------ configuracoes ------------------------------
REPO_URL="https://github.com/BrenoSI03/ModPack-Mina-Craft.git"
ZIP_URL="https://github.com/BrenoSI03/ModPack-Mina-Craft/archive/refs/heads/main.zip"
REPO_NAME="ModPack-Mina-Craft"

# Pasta do Minecraft (macOS).  No Linux troque por ~/.minecraft
MC_DIR="$HOME/Library/Application Support/minecraft"
# ---------------------------------------------------------

# Caminho onde o .sh esta rodando
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Descobrir se o .sh esta dentro do repo ou ao lado dele
if [[ -d "$SCRIPT_DIR/.git" ]]; then
    BASE_DIR="$SCRIPT_DIR"
elif [[ -d "$SCRIPT_DIR/$REPO_NAME/.git" ]]; then
    BASE_DIR="$SCRIPT_DIR/$REPO_NAME"
else
    BASE_DIR="$SCRIPT_DIR/$REPO_NAME"
fi

echo "===================================================="
echo "  ModPack-Mina-Craft - atualizador"
echo "  Diretorio do repo: $BASE_DIR"
echo "===================================================="
echo

# Git instalado?
if command -v git >/dev/null 2>&1; then
    GIT_OK=1
else
    GIT_OK=0
fi

# ------------ fluxo principal ---------------------------
if [[ -d "$BASE_DIR/.git" ]]; then
    if [[ $GIT_OK -eq 1 ]]; then
        echo "Fazendo git pull..."
        (cd "$BASE_DIR" && git pull --ff-only)
    else
        echo "Git ausente - atualizando via ZIP..."
        download_extract_zip() {
            curl -L -o "$BASE_DIR/repo.zip" "$ZIP_URL"
            unzip -qo "$BASE_DIR/repo.zip" -d "$BASE_DIR-temp"
            rsync -a --delete "$BASE_DIR-temp/" "$BASE_DIR/"
            rm -rf "$BASE_DIR-temp" "$BASE_DIR/repo.zip"
        }
        download_extract_zip
    fi
else
    if [[ $GIT_OK -eq 1 ]]; then
        echo "Clonando repositorio..."
        git clone --depth 1 "$REPO_URL" "$BASE_DIR"
    else
        echo "Git ausente - baixando ZIP..."
        mkdir -p "$BASE_DIR"
        download_extract_zip() {
            curl -L -o "$BASE_DIR/repo.zip" "$ZIP_URL"
            unzip -qo "$BASE_DIR/repo.zip" -d "$BASE_DIR-temp"
            rsync -a "$BASE_DIR-temp/" "$BASE_DIR/"
            rm -rf "$BASE_DIR-temp" "$BASE_DIR/repo.zip"
        }
        download_extract_zip
    fi
fi

# ------------ copiar mods e config ----------------------
echo
echo "Copiando mods..."
rsync -a --delete "$BASE_DIR/mods/"   "$MC_DIR/mods/"
echo "Copiando config..."
rsync -a --delete "$BASE_DIR/config/" "$MC_DIR/config/"

# ------------ abrir pasta mods --------------------------
open "$MC_DIR/mods"      # Finder (macOS)
# xdg-open "$MC_DIR/mods"   # use esta linha em Linux

echo
echo ":)  Mods e configs atualizados com sucesso!"
```
