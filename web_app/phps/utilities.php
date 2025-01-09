<?php

/**
 * Reindirizza all'URL specificato.
 */
function redirect($url, $permanent = false) {
    header("Location: $url", true, $permanent ? 301 : 302);
    exit();
}


/**
 * Apre una connessione pg_connection al database utilizzando le credenziali specificate nel
 * file di configurazione (config.php).
 */
function pg_open_connection() {
    require_once("../../config.php");
    $conn_string = "host=$host port=$port dbname=$dbname user=$username password=$password";
    $db = pg_connect($conn_string);
    return $db;
}


/**
 * Chiude la connessione pg_connection specificata.
 */
function pg_close_connection($db) {
    pg_close($db);
}

/**
 * Verifica le credenziali di accesso. (cf, password)
 * Restituisce un array contenente un flag e i dati dell'utente.
 * Il flag è true se il login ha successo, false altrimenti.
 */
function check_login($cf, $password) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.check_login($1, $2)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($cf, $password));
    if (pg_num_rows($result) == 0) {
        pg_close_connection($db);
        return array(false, null);
    }
    $user_data = pg_fetch_assoc($result);
    pg_close_connection($db);
    return array(true, $user_data); 
}

/**
 * Cambia la password dell'utente con il cf contenuto in $SESSION["cf"].
 * Restituisce true se l'operazione ha successo, array(false, error_message) altrimenti.
 */
function change_password($id, $old_password, $new_password) {
    $db = pg_open_connection();
    $query = "CALL biblioteca.utente_update_password($1::uuid, $2::text, $3::text)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($id, $old_password, $new_password));
    if (!$result) {
        pg_close_connection($db);
        return array(false, "Errore durante la modifica della password.");
    }
    pg_close_connection($db);
    return array(true, "password cambiata con successo.");
}

/**
 * Salva i dati dell'utente nella sessione.
 * I dati dell'utente sono un array associativo contenente i seguenti
 * campi: cf, ruolo, nome, cognome.
 */
function save_user_data($user_data) {
    $_SESSION["id"] = $user_data["id"];
    $_SESSION["cf"] = $user_data["cf"];
    $_SESSION["ruolo"] = $user_data["ruolo"];
    $_SESSION["nome"] = $user_data["nome"];
    $_SESSION["cognome"] = $user_data["cognome"];
}

/**
 * Restituisce un array contenente i libri presi in prestito dal lettore con l'id specificato.
 * Ogni elemento dell'array è un array associativo contenente i seguenti campi:
 * isbn, titolo, autore, casa_editrice, inizio_prestito, scadenza, stato.
 * Il campo stato può essere "in corso", "scaduto" o "riconsegnato".
 * L'array è vuoto se l'utente non ha preso in prestito alcun libro.
 * L'array è null se si verifica un errore.
 */
function get_prestiti_lettore($id) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_prestiti_lettore($1)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($id));
    if (!$result) {
        pg_close_connection($db);
        return null;
    }
    $prestiti = pg_fetch_all($result);
    pg_close_connection($db);
    return $prestiti;
}

/**
 * Restituisce la categoria del lettore con il cf specificato.
 * Restituisce null se si verifica un errore. 
 */
function get_categoria_ritardi($id) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_categoria_ritardi_lettore($1)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($id));
    if (!$result) {
        pg_close_connection($db);
        return null;
    }
    $return= pg_fetch_assoc($result);
    pg_close_connection($db);
    return $return;
}

/**
 * Restituisce un array contenente le sedi della biblioteca.
 * Ogni elemento dell'array è un array associativo contenente i seguenti campi:
 * città, indirizzo, civico.
 * L'array è null se si verifica un errore.
 */
function get_sedi() {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_sedi()";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array());
    if (!$result) {
        pg_close_connection($db);
        return null;
    }
    $sedi = pg_fetch_all($result);
    pg_close_connection($db);
    return $sedi;
}

/**
 * Restituisce un array contenente i libri disponibili con l'isbn e la sede specificati.
 * Ogni elemento dell'array è un array associativo contenente i seguenti campi:
 * isbn, titolo, autore, casa_editrice, indirizzo sede.
 * L'array è null se si verifica un errore.
 */

function get_libri_disponibili_by_isbn_sede($isbn, $sede) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_libri_disponibili_by_isbn_sede($1, $2)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($isbn, $sede));
    if (!$result) {
        pg_close_connection($db);
        return null;
    }
    $libri = pg_fetch_all($result);
    pg_close_connection($db);
    return $libri;
}

/**
 * Restituisce un array contenente i libri disponibili con il titolo e la sede specificati.
 * Ogni elemento dell'array è un array associativo contenente i seguenti campi:
 * isbn, titolo, autore, casa_editrice, indirizzo sede.
 * L'array è null se si verifica un errore.
 */

function get_libri_disponibili_by_titolo_sede($titolo, $sede) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_libri_disponibili_by_titolo_sede($1, $2)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($titolo, $sede));
    if (!$result) {
        pg_close_connection($db);
        return null;
    }
    $libri = pg_fetch_all($result);
    pg_close_connection($db);
    return $libri;
}

/**
 * Restituisce un array contenente i libri disponibili con titolo.
 * Ogni elemento dell'array è un array associativo contenente i seguenti campi:
 * isbn, titolo, autore, casa_editrice, indirizzo sede.
 * L'array è null se si verifica un errore.
 */

function get_libri_disponibili_by_isbn($isbn) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_libri_disponibili_by_isbn($1)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($isbn));
    if (!$result) {
        pg_close_connection($db);
        return null;
    }
    $libri = pg_fetch_all($result);
    pg_close_connection($db);
    return $libri;
}

/**
 * Restituisce un array contenente i libri disponibili con titolo.
 * Ogni elemento dell'array è un array associativo contenente i seguenti campi:
 * isbn, titolo, autore, casa_editrice, indirizzo sede.
 * L'array è null se si verifica un errore.
 */

function get_libri_disponibili_by_titolo($titolo) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_libri_disponibili_by_titolo($1)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($titolo));
    if (!$result) {
        pg_close_connection($db);
        return null;
    }
    $libri = pg_fetch_all($result);
    pg_close_connection($db);
    return $libri;
}

/**
 * Tenta di richiedere un prestito per il libro con l'isbn specificato nella sede specificata da parte del lettore con l'id specificato.
 */

function richiedi_prestito($id, $isbn, $sede) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.richiesta_prestito($1, $2, $3)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($id, $isbn, $sede));
    return pg_fetch_assoc($result);
}

/**
 * Cambia i dati della sede con l'id specificato.
 * Restituisce (successo, messaggio).
 */

function change_sede($sede, $città, $indirizzo, $civico) {
    $db = pg_open_connection();
    $query = "CALL biblioteca.sede_update($1, $2, $3, $4)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($sede, $città, $indirizzo, $civico));
    return pg_fetch_assoc($result);
}

/**
 * Aggiunge una sede con i dati specificati.
 * Restituisce (successo, messaggio).
 */

function add_sede($città, $indirizzo, $civico) {
    $db = pg_open_connection();
    $query = "CALL biblioteca.sede_new($1, $2, $3)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($città, $indirizzo, $civico));
    return pg_fetch_assoc($result);
}

/**
 * Restituisce il lettore con il cf specificato.
 * Restituisce null se non esiste alcun lettore con il cf specificato.
 */

function get_lettore($cf) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_lettore_cf($1)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($cf));
    $lettore = pg_fetch_assoc($result);
    pg_close_connection($db);
    return $lettore;
}

/**
 * Restituisce un array contenente i prestiti attivi del lettore con il cf specificato.
 * Ogni elemento dell'array è un array associativo contentente i dati del prestito.
 */

function get_prestiti_attivi_lettore($cf) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_prestiti_attivi_lettore($1)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($cf));
    $prestiti = pg_fetch_all($result);
    pg_close_connection($db);
    return $prestiti;
}


/**
 * Azzera le riconsegne in ritardo del lettore con l'id specificato.
 */

function reset_ritardi($id) {
    $db = pg_open_connection();
    $query = "CALL biblioteca.reset_ritardi($1)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($id));
    pg_close_connection($db);
}

/**
 * Aggiunge un lettore con i dati specificati.
 * Restituisce (successo, messaggio).
 */

function add_lettore($cf, $nome, $cognome, $categoria, $password) {
    $db = pg_open_connection();
    $query = "CALL biblioteca.lettore_new($1, $2, $3, $4, $5)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($cf, $nome, $cognome, $categoria, $password));
    return pg_fetch_assoc($result);
}

/**
 * Aggiunge un autore con i dati specificati.
 * Restituisce (successo, messaggio).
 */

function add_autore($nome, $cognome, $data_nascita, $data_morte, $biografia) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.autore_new_function($1, $2, $3, $4, $5)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($nome, $cognome, $data_nascita, $data_morte, $biografia));
    return pg_fetch_assoc($result);
}

/**
 * Ottiene tutti gli autori in ordine alfabetico "cognome, nome".
 */

function getAutori() {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_autori()";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array());
    $autori = pg_fetch_all($result);
    pg_close_connection($db);
    return $autori;
}

/**
 * Aggiunge un libro con i dati specificati.
 * Restituisce (successo, messaggio).
 */

function add_libro($isbn, $titolo, $autore, $trama, $casa_editrice) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.libro_new_function($1, $2, $3, $4, $5)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($isbn, $titolo, $autore, $trama, $casa_editrice));
    return pg_fetch_assoc($result);
}

/**
 * Ottiene tutti i libri in ordine alfabetico "titolo".
 */

function getLibri() {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_libri()";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array());
    $libri = pg_fetch_all($result);
    pg_close_connection($db);
    return $libri;
}

/**
 * Restituisce un array associativo contenente i risultati di getAutori(), getLibri() e get_sedi().
 */

function getData() {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.get_autori()";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array());
    $autori = pg_fetch_all($result);
    $query = "SELECT * FROM biblioteca.get_libri()";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array());
    $libri = pg_fetch_all($result);
    $query = "SELECT * FROM biblioteca.get_sedi()";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array());
    $sedi = pg_fetch_all($result);
    pg_close_connection($db);
    return array("autori" => $autori, "libri" => $libri, "sedi" => $sedi);
}

/**
 * Aggiunge una copia con i dati specificati.
 * Restituisce (successo, messaggio).
 */

function add_copie_n($isbn, $sede, $copie_n) {
    $db = pg_open_connection();
    $query = "SELECT * FROM biblioteca.copia_new_function($1, $2, $3)";
    $result = pg_prepare($db, "", $query);
    $result = pg_execute($db, "", array($isbn, $copie_n, $sede));
    return pg_fetch_assoc($result);
}