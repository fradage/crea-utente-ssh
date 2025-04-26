# Crea Utente SSH Sicuro

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

1. Clona questa repository:
   ```bash
   git clone https://github.com/tuo-username/crea-utente-ssh.git
   cd crea-utente-ssh
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

## 📜 Licenza

Questo progetto è distribuito sotto licenza MIT.

---

> Creato con ❤️ da [Tuo Nome o Nickname]
