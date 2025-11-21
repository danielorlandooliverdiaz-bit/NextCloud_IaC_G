#!/bin/bash

# --- CONFIGURACIÓN ---
# Lista de usuarios de tu equipo
EQUIPO=("danhery" "andrei" "daniel" "stefan" "budeli")

# Definimos los alias y configuraciones que queremos inyectar
# Usamos EOM para definir un bloque de texto multilínea
read -r -d '' CONFIGURACION << EOM

# --- 🚀 PLATFORM ENGINEER TOOLS (DevEx) ---
# Atajos para Docker
alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up -d"       # Levantar todo en segundo plano
alias dcd="docker compose down"        # Apagar y borrar contenedores
alias dcl="docker compose logs -f"     # Ver logs en tiempo real
alias dps="docker compose ps"          # Ver estado de los contenedores
alias dr="docker restart"

# Herramientas Visuales
alias lazy="lazydocker"                # Panel de control visual
alias ll="ls -lah --color=auto"        # Listado de archivos mejorado
alias ..="cd .."
# ---------------------------------------
EOM

echo "🔧 Iniciando configuración de entornos de usuario..."

# Iteramos por cada usuario de la lista
for usuario in "${EQUIPO[@]}"; do
    USER_HOME="/home/$usuario"
    BASHRC="$USER_HOME/.bashrc"

    # Verificamos si el directorio del usuario existe
    if [ -d "$USER_HOME" ]; then
        echo "Configurando perfil para: $usuario..."

        # 1. Hacemos copia de seguridad del .bashrc original (Buena práctica)
        if [ ! -f "$BASHRC.bak" ]; then
            sudo cp "$BASHRC" "$BASHRC.bak"
        fi

        # 2. Verificamos si ya se inyectó para no duplicar
        if sudo grep -q "PLATFORM ENGINEER TOOLS" "$BASHRC"; then
            echo "  ℹ️  Ya estaba configurado. Saltando."
        else
            # 3. Inyectamos la configuración al final del archivo
            echo "$CONFIGURACION" | sudo tee -a "$BASHRC" > /dev/null
            echo "  ✅ Alias inyectados correctamente."
        fi
        
        # 4. Aseguramos que el dueño del archivo siga siendo el usuario (no root)
        sudo chown $usuario:$usuario "$BASHRC"
        
    else
        echo "⚠️  Atención: No encontré la carpeta home de $usuario"
    fi
done

echo "🎉 ¡Listo! Los cambios se aplicarán la próxima vez que inicien sesión."
