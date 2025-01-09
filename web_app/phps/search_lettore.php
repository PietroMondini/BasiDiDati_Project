<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("utilities.php");

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $cf_lettore = $_POST["codice_fiscale"];
        $_SESSION["cf_lettore"] = $cf_lettore;
        $lettore = get_lettore($cf_lettore);
        $_SESSION["lettore"] = $lettore;
        redirect("../phps/search_prestiti_attivi.php");
    }
?>