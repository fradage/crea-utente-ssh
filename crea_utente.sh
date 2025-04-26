#!/bin/bash

################################################################################
# Script per creare un utente Linux con accesso SSH solo tramite chiave pubblica
# L'utente avra' privilegi sudo senza richiesta di password.
# La chiave SSH viene generata automaticamente senza passphrase.
# Autore: [Tuo Nome]
# Versione: 2.2
################################################################################

# === CONFIGURAZIONE ==========================================================

USERNAME="$1"

# === FUNZIONI =================================================================

errore() {
    echo -e "\033[0;31m[ERRORE]\033[0m $1" >&2
}

info() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

uso() {
    echo "Utilizzo corretto:"
    echo "  $0 nome_utente"
    echo "Esempio:"
    echo "  $0 mario"
    exit 1
}

# === CONTROLLO PARAMETRI ======================================================

if [[ -z "$USERNAME" ]]; then
    errore "Parametro nome utente mancante."
    uso
fi

# === CREAZIONE UTENTE =========================================================

info "Creazione dell'utente $USERNAME..."

if id "$USERNAME" &>/dev/null; then
    errore "L'utente $USERNAME esiste gia'."
    exit 1
fi

sudo useradd -m -s /bin/bash "$USERNAME"
info "Utente $USERNAME creato."

# === CREAZIONE DIRECTORY SSH ==================================================

info "Creazione directory .ssh..."

sudo mkdir -p /home/"$USERNAME"/.ssh
sudo chmod 700 /home/"$USERNAME"/.ssh
sudo chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh

# === GENERAZIONE CHIAVE SSH ===================================================

info "Generazione chiave SSH per l'utente $USERNAME..."

sudo -u "$USERNAME" ssh-keygen -t rsa -b 4096 -f /home/"$USERNAME"/.ssh/id_rsa -N ""

sudo cp /home/"$USERNAME"/.ssh/id_rsa.pub /home/"$USERNAME"/.ssh/authorized_keys
sudo chmod 600 /home/"$USERNAME"/.ssh/authorized_keys
sudo chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh/authorized_keys

# === PRIVILEGI SUDO ===========================================================

info "Aggiunta ai sudoers..."

if getent group sudo > /dev/null; then
    sudo usermod -aG sudo "$USERNAME"
    info "Utente aggiunto al gruppo sudo."
elif getent group wheel > /dev/null; then
    sudo usermod -aG wheel "$USERNAME"
    info "Utente aggiunto al gruppo wheel."
else
    errore "Nessun gruppo sudo o wheel trovato. Devi configurare manualmente i privilegi."
fi

# === CONFIGURAZIONE SUDO NO PASSWORD ==========================================

info "Configurazione sudo senza richiesta password..."

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$USERNAME" > /dev/null
sudo chmod 440 /etc/sudoers.d/"$USERNAME"

# Controllo sintassi sudoers
if sudo visudo -cf /etc/sudoers.d/"$USERNAME"; then
    info "Configurazione sudoers valida."
else
    errore "Errore nella configurazione sudoers. Controlla il file /etc/sudoers.d/$USERNAME."
    exit 1
fi

# === DISABILITAZIONE PASSWORD =================================================

info "Disabilitazione login tramite password..."

sudo passwd -d "$USERNAME"
sudo passwd -l "$USERNAME"

# === CONFIGURAZIONE SSHD ======================================================

info "Aggiornamento configurazione SSHD..."

if ! grep -q "Match User $USERNAME" /etc/ssh/sshd_config; then
    echo "
Match User $USERNAME
    PasswordAuthentication no
    AuthenticationMethods publickey
" | sudo tee -a /etc/ssh/sshd_config > /dev/null
else
    info "Configurazione SSHD gia' presente."
fi

sudo systemctl reload sshd

info "Utente $USERNAME configurato correttamente."
info "La chiave privata si trova in /home/$USERNAME/.ssh/id_rsa. Salvala in un posto sicuro!"
