<?php

/**
 * Redirects to the specified URL.
 */
function redirect($url, $permanent = false) {
    header("Location: $url", true, $permanent ? 301 : 302);
    exit();
}


/**
 * Opens a pg_connection to the database using the credentials specified in the
 * configuration file (config.php).
 */
function pg_open_connection() {
    require_once("../../config.php");
    $conn_string = "host=$host port=$port dbname=$dbname user=$username password=$password";
    $db = pg_connect($conn_string);
    return $db;
}


/**
 * Closes the specified pg_connection.
 */
function pg_close_connection($db) {
    pg_close($db);
}

/**
 * Checks login credentials. (cf, password)
 * Returns an array containing a flag and the user's data.
 * The flag is true if the login is successful, false otherwise.
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
 * Changes the password of the user with the cf contained in $SESSION["cf"].
 * Returns true if the operation is successful, array(false, error_message) otherwise.
 */
function change_password($old_password, $new_password) {
    $db = pg_open_connection();
    $query = "CALL change_password($1, $2, $3)";
    $result = pg_query_params($db, $query, array($_SESSION["cf"], $old_password, $new_password));
    if (!$result) {
        pg_close_connection($db);
        return array(false, "Errore durante la modifica della password.");
    }
    pg_close_connection($db);
    return true;
}

/**
 * Saves the user's data in the session.
 * The user's data is an associative array containing the following
 * fields: cf, ruolo, nome, cognome).
 */

function save_user_data($user_data) {
    $_SESSION["cf"] = $user_data["cf"];
    $_SESSION["ruolo"] = $user_data["ruolo"];
    $_SESSION["nome"] = $user_data["nome"];
    $_SESSION["cognome"] = $user_data["cognome"];
}
