# 📜 **ModPack-Mina-Craft – Seção de Scripts Atualizada**

## 🔁 Atualizar mods automaticamente

Você pode usar um dos scripts abaixo para baixar ou atualizar os mods deste repositório.

### 🧰 Para quem já tem **Git** instalado:

Crie um arquivo chamado `atualizar_mods_git.bat` com o seguinte conteúdo:

```bat
@echo off
cd /d "%~dp0"
if not exist "mods\.git" (
    echo Clonando repositório de mods...
    git clone https://github.com/BrenoSI03/ModPack-Mina-Craft.git mods
    cd mods
) else (
    cd mods
    echo Atualizando mods...
    git pull
)
pause
```

> 💡 Esse script clona o repositório na pasta `mods` ou atualiza se ele já existir.

---

### 📦 Para quem **não tem Git** instalado:

Crie um arquivo chamado `atualizar_mods_sem_git.bat` com o seguinte conteúdo:

```bat
@echo off
echo Baixando mods em ZIP...
curl -L -o mods.zip https://github.com/BrenoSI03/ModPack-Mina-Craft/archive/refs/heads/main.zip

echo Extraindo mods...
tar -xf mods.zip
xcopy /E /Y "ModPack-Mina-Craft-main\mods" "%APPDATA%\.minecraft\mods"

echo Limpando arquivos temporários...
rd /s /q "ModPack-Mina-Craft-main"
del mods.zip

echo Mods atualizados com sucesso!
pause
```

> 💡 Esse script baixa o conteúdo do repositório como `.zip`, extrai os arquivos da pasta `mods` e copia para a instalação do Minecraft.

---

## 📌 Observações:

* Certifique-se de que os arquivos `.jar` estejam na subpasta `mods/` dentro do repositório.
* O script `.bat` deve ser executado antes de iniciar o Minecraft.
