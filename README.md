# Crea Utente SSH Sicuro
![Versione](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Licenza](https://img.shields.io/badge/license-MIT-green.svg)

Script Bash per creare un utente Linux con:
- Accesso **solo tramite chiave pubblica SSH**
- **Privilegi sudo senza richiesta di password**
- **Login SSH disabilitato con password**
- **Generazione automatica** della coppia di chiavi SSH

---

## 📋 Requisiti

- Linux (Ubuntu, Debian, CentOS, RHEL, AlmaLinux, Rocky...)
- Permessi `sudo`
- Pacchetto `openssh-client` installato (`ssh-keygen`)

---

## ⚙️ Installazione

1. Crea un file crea_utente.sh
   ```bash
   sudo nano /usr/local/bin/crea_utente.sh
   copia ed incolla il testo o se preferisci scarica il file sh del progetto
   ```

2. Rendi eseguibile lo script:
   ```bash
   chmod +x crea_utente.sh
   ```

---

## 🚀 Utilizzo

```bash
./crea_utente.sh nome_utente
```

### Esempio

#### 1. Sul server: crea l'utente

```bash
sudo ./crea_utente.sh mario
```

Output atteso (la parte di `ssh-keygen` è abbreviata):

```
[INFO] Creazione dell'utente mario...
[INFO] Utente mario creato.
[INFO] Creazione directory .ssh...
[INFO] Generazione chiave SSH per l'utente mario...
Generating public/private rsa key pair.
Your identification has been saved in /home/mario/.ssh/id_rsa
Your public key has been saved in /home/mario/.ssh/id_rsa.pub
...
[INFO] Aggiunta ai sudoers...
[INFO] Utente aggiunto al gruppo sudo.
[INFO] Configurazione sudo senza richiesta password...
/etc/sudoers.d/mario: parsed OK
[INFO] Configurazione sudoers valida.
[INFO] Disabilitazione login tramite password...
[INFO] Aggiornamento configurazione SSHD...
[INFO] Servizio ssh ricaricato.
[INFO] Utente mario configurato correttamente.
[INFO] La chiave privata si trova in /home/mario/.ssh/id_rsa. Salvala in un posto sicuro!
```

Su CentOS, RHEL, AlmaLinux o Rocky vedrai "gruppo wheel" e "Servizio sshd".

#### 2. Copia la chiave privata sul tuo PC

Il login con password per `mario` è disabilitato, quindi la chiave va recuperata con un utente che ha già accesso (qui `admin`):

```bash
# sul server: rendi la chiave leggibile temporaneamente
sudo cp /home/mario/.ssh/id_rsa /tmp/mario_key && sudo chown admin /tmp/mario_key

# sul tuo PC
scp admin@192.168.1.50:/tmp/mario_key ~/.ssh/mario_server
chmod 600 ~/.ssh/mario_server

# sul server: rimuovi la copia temporanea
rm /tmp/mario_key
```

#### 3. Collegati come mario

```bash
ssh -i ~/.ssh/mario_server mario@192.168.1.50
```

In alternativa aggiungi a `~/.ssh/config` sul tuo PC:

```
Host server-mario
    HostName 192.168.1.50
    User mario
    IdentityFile ~/.ssh/mario_server
```

e collegati con `ssh server-mario`.

#### 4. Verifica

```bash
sudo whoami        # risponde "root" senza chiedere la password
```

Il login con password deve essere rifiutato:

```bash
ssh -o PubkeyAuthentication=no mario@192.168.1.50
# → Permission denied (publickey)
```

> 💡 Dopo aver copiato la chiave privata sul tuo PC, cancellala dal server con
> `sudo rm /home/mario/.ssh/id_rsa`: per l'accesso basta `authorized_keys`.

---

## 🛠️ Cosa fa lo script

- Crea un nuovo utente Linux con shell Bash
- Genera chiavi SSH senza passphrase (`id_rsa`, `id_rsa.pub`)
- Imposta autorizzazioni corrette sulla directory `.ssh`
- Aggiunge l'utente a `sudo` o `wheel`
- Configura `sudo` senza richiesta password (`NOPASSWD`)
- Disabilita il login tramite password
- Configura SSHD per richiedere solo certificato

---

## 📝 CHANGELOG

- **v1.0.0**: Prima versione stabile pubblicata.

---

## 📈 Roadmap

Consulta la [Roadmap di sviluppo](./ROADMAP.md) per vedere le funzionalità pianificate e gli obiettivi futuri.

---

## 📜 Licenza

Questo progetto è distribuito sotto licenza MIT.

---

> Creato da [Tuo Nome o Nickname]
