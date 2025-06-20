#!/bin/bash

# Beállítások
REPO_URL="https://github.com/valaki/ssh-keys.git"  # Git repository URL
TARGET_USER="deployuser"                           # A rendszerfelhasználó neve
TMP_DIR="/tmp/ssh-keys"                            # Ideiglenes könyvtár

# 1. Repo klónozása
rm -rf "$TMP_DIR"
git clone "$REPO_URL" "$TMP_DIR" || { echo "Repo klónozás sikertelen"; exit 1; }

# 2. Célszemély home könyvtára
USER_HOME=$(eval echo "~$TARGET_USER")
SSH_DIR="$USER_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

# 3. SSH könyvtár előkészítése
mkdir -p "$SSH_DIR"
touch "$AUTHORIZED_KEYS"
chmod 700 "$SSH_DIR"
chmod 600 "$AUTHORIZED_KEYS"
chown -R "$TARGET_USER:$TARGET_USER" "$SSH_DIR"

# 4. Kulcsok hozzáadása
cat "$TMP_DIR"/keys/*.pub >> "$AUTHORIZED_KEYS"

# 5. Duplikált sorok eltávolítása
sort -u "$AUTHORIZED_KEYS" -o "$AUTHORIZED_KEYS"

# 6. Tulajdonos újraállítása (ha változott volna)
chown "$TARGET_USER:$TARGET_USER" "$AUTHORIZED_KEYS"

echo "SSH kulcsok sikeresen hozzáadva $TARGET_USER felhasználónak."
