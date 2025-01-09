<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("utilities.php");

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $id_lettore = $_SESSION["lettore"]["id"];
        reset_ritardi($id_lettore);
        $_SESSION["lettore"]["riconsegne_ritardo"] = 0;
        redirect("../bibliotecario/gest_lettori.php");
    }
    else {
        redirect("../index.php");
    }
?>
