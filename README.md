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

```bash
./crea_utente.sh mario
```

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
