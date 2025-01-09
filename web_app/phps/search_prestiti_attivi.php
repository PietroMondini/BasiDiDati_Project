<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("utilities.php");

   
    $lettore = $_SESSION["lettore"];
    $id_lettore = $lettore["id"];
    $prestiti_lettore = get_prestiti_attivi_lettore($id_lettore);
    $_SESSION["prestiti_lettore"] = $prestiti_lettore;
    redirect("../bibliotecario/gest_lettori.php");
?>