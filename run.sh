#!/usr/bin/env bash
# Start script generated by ServerPackCreator.
# Note: The above statement is false, I just copied someone elses script from their modpack after I got their permission - StormDragon_64
# This script checks for the Minecraft and Forge JAR-files, and if they are not found, they are downloaded and installed.
# If everything is in order, the server is started.

JAVA="java"
MINECRAFT="1.18.2"
FORGE="40.2.0"
ARGS=""
OTHERARGS="-Dlog4j2.formatMsgNoLookups=true"

if [[ ! -s "libraries/net/minecraftforge/forge/$MINECRAFT-$FORGE/forge-$MINECRAFT-$FORGE-server.jar" ]];then

  echo "Forge Server JAR-file not found. Downloading installer...";
  wget -O forge-installer.jar https://files.minecraftforge.net/maven/net/minecraftforge/forge/$MINECRAFT-$FORGE/forge-$MINECRAFT-$FORGE-installer.jar;

  if [[ -s "forge-installer.jar" ]]; then

    echo "Installer downloaded. Installing...";
    java -jar forge-installer.jar --installServer;

    if [[ -s "libraries/net/minecraftforge/forge/$MINECRAFT-$FORGE/forge-$MINECRAFT-$FORGE-server.jar" ]];then
      rm -f forge-installer.jar;
      echo "Installation complete. forge-installer.jar deleted.";
    fi

  else
    echo "forge-installer.jar not found. Maybe the Forges servers are having trouble.";
    echo "Please try again in a couple of minutes.";
  fi
else
  echo "Forge server present. Moving on..."
fi

if [[ ! -s "libraries/net/minecraft/server/$MINECRAFT/server-$MINECRAFT.jar" ]];then
  echo "Minecraft Server JAR-file not found. Downloading...";
  wget -O libraries/net/minecraft/server/$MINECRAFT/server-$MINECRAFT.jar https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar;
else
  echo "Minecraft server present. Moving on..."
fi

if [[ ! -s "eula.txt" ]];then
  echo "Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA."
  echo "Type 'I agree' to indicate that you agree to Mojang's EULA."
  echo "Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula"
  echo "Do you agree to Mojang's EULA? [I agree/I disagree]"
  read ANSWER
  if [[ "$ANSWER" = "I agree" ]]; then
    echo "User agreed to Mojang's EULA."
    echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." > eula.txt;
    echo "eula=true" >> eula.txt;
  else
    echo "User did not agree to Mojang's EULA."
  fi
else
  echo "eula.txt present. Moving on...";
fi

echo "Starting server...";
echo "Minecraft version: $MINECRAFT";
echo "Forge version: $FORGE";
echo "Java args in user_jvm_args.txt: $ARGS";

# Forge requires a configured set of both JVM and program arguments.
# Add custom JVM arguments to the user_jvm_args.txt
# Add custom program arguments {such as nogui} to this file in the next line before the "$@" or
#  pass them to this script directly

$JAVA $OTHERARGS @user_jvm_args.txt @libraries/net/minecraftforge/forge/$MINECRAFT-$FORGE/unix_args.txt nogui "$@"

echo "Press any button to exit..."
read