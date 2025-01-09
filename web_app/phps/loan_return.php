<?php
    ini_set("error_reporting", E_ALL);
    ini_set("display_errors", "On");
    require_once("utilities.php");
    session_start();

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $db = pg_open_connection();
        $query = "CALL biblioteca.prestito_restituzione($1::uuid, $2::INTEGER)";
        $result = pg_prepare($db, "", $query);
        $result = pg_execute($db, "", array($_POST["id"], $_POST["copia_id"]));
        pg_close_connection($db);
        redirect("../phps/search_prestiti_attivi.php");
        exit();
    }

?>