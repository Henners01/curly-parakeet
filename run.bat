:: Start script generated by ServerPackCreator.
:: Note: The above statement is false, I just copied someone elses script from their modpack after I got their permission - StormDragon_64
:: This script checks for the Minecraft and Forge JAR-files, and if they are not found, they are downloaded and installed.
:: If everything is in order, the server is started.
@ECHO off
SetLocal EnableDelayedExpansion

SET JAVA="java"
SET MINECRAFT="1.18.2"
SET FORGE="40.2.0"
SET ARGS=
SET OTHERARGS="-Dlog4j2.formatMsgNoLookups=true"

SET AGREE="I agree"

IF NOT EXIST libraries/net/minecraftforge/forge/%MINECRAFT%-%FORGE%/forge-%MINECRAFT%-%FORGE%-server.jar (

  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://files.minecraftforge.net/maven/net/minecraftforge/forge/%MINECRAFT%-%FORGE%/forge-%MINECRAFT%-%FORGE%-installer.jar', 'forge-installer.jar')"

  IF EXIST forge-installer.jar (

    ECHO Installer downloaded. Installing...
    java -jar forge-installer.jar --installServer

    IF EXIST libraries/net/minecraftforge/forge/%MINECRAFT%-%FORGE%/forge-%MINECRAFT%-%FORGE%-server.jar (
      DEL forge-installer.jar
      ECHO Installation complete. forge-installer.jar deleted.
    )

  ) ELSE (
    ECHO forge-installer.jar not found. Maybe the Forges servers are having trouble.
    ECHO Please try again in a couple of minutes.
  )
) ELSE (
  ECHO Forge server present. Moving on...
)

IF NOT EXIST libraries/net/minecraft/server/%MINECRAFT%/server-%MINECRAFT%.jar (
  ECHO Minecraft Server JAR-file not found. Downloading...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar', 'libraries/net/minecraft/server/%MINECRAFT%/server-%MINECRAFT%.jar')"
) ELSE (
  ECHO Minecraft server present. Moving on...
)

IF NOT EXIST eula.txt (
  ECHO Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO Type "I agree" to indicate that you agree to Mojang's EULA.
  ECHO Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO Do you agree to Mojang's EULA [I agree/I disagree]?
  set /P "Response="
  IF "%Response%" == "%AGREE%" (
    ECHO User agreed to Mojang's EULA.
    ECHO #By changing the setting below to TRUE you are indicating your agreement to our EULA ^(https://account.mojang.com/documents/minecraft_eula^).> eula.txt
    ECHO eula=true>> eula.txt
  ) else (
    ECHO User did not agree to Mojang's EULA. 
  )
) ELSE (
  ECHO eula.txt present. Moving on...
)

ECHO Starting server...
ECHO Minecraft version: %MINECRAFT%
ECHO Forge version: %FORGE%
ECHO Java args in user_jvm_args.txt: %ARGS%

REM Forge can use a configured set of both JVM and program arguments.
REM Add custom JVM arguments to the user_jvm_args.txt
REM Add custom program arguments {such as nogui} to this file in the next line before the %* or
REM  pass them to this script directly

%JAVA% %OTHERARGS% @user_jvm_args.txt @libraries/net/minecraftforge/forge/%MINECRAFT%-%FORGE%/win_args.txt nogui %*

PAUSE