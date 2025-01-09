<?php 
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("utilities.php");

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $id = $_POST["id"];
        $copia = $_POST["copia_id"];
        $db = pg_open_connection();
        $query = "CALL biblioteca.prestito_proroga($1::uuid, $2::INTEGER)";
        $result = pg_prepare($db, "", $query);
        $result = pg_execute($db, "", array($_POST["id"], $_POST["copia_id"]));
        pg_close_connection($db);
        redirect("../phps/search_prestiti_attivi.php");
    }

?>