# Manuale utente, Basi di dati 2024-25

## Requisiti

## Requisiti software

Per utilizzare questa repository, è necessario soddisfare i seguenti requisiti software:

- **Database**: PostgreSQL 13 o superiore
- **PHP**: vers. 8+
- **Estensioni PostgreSQL**: `pg_crypto`
- **Web server** (anche integrato di PHP)

### Configurazione del progetto

1. Clona la repository GitHub sul tuo computer locale:

```sh
git clone https://github.com/PietroMondini/biblioteca.git
```

2. Naviga nella directory del progetto:

```sh
cd biblioteca
```

3. Importa gli script SQL nel tuo database PostgreSQL utilizzando pgAdmin 4 o il tuo client PostgreSQL.

### Configurazione dell'applicazione

1. Apri il file di configurazione `config.php` nella directory principale del progetto.
2. Modifica i parametri di connessione al database secondo le tue impostazioni locali:

```php
// file: /config.php

define('DB_HOST', 'localhost');
define('DB_NAME', 'nome_del_tuo_database');
define('DB_USER', 'tuo_utente');
define('DB_PASSWORD', 'tua_password');

```

### Esecuzione del progetto

1. Assicurati che PostgreSQL sia in esecuzione.
2. Apri il tuo client PostgreSQL e connettiti al database.
3. Esegui le query SQL necessarie per interagire con il database.

### Browser web

Spostati nella repository `/web_app`

```sh
cd web_app
```

Attiva il web server:

```sh
php -S localhost:80
```

Per accedere all'applicazione web, collegati all'URL: `http://localhost`

Assicurati che il tuo browser sia aggiornato all'ultima versione per garantire la compatibilità e la sicurezza.

### Supporto

Per ulteriori informazioni o supporto, consulta la documentazione tecnica inclusa nella repository.

