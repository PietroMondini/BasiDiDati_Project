<?php
    ini_set("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();

    include("../phps/utilities.php");

    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "bibliotecario") {
        redirect("../index.php");
    }

    if ($_POST["trama"] == "") {
        $trama = NULL;
    } else {
        $trama = $_POST["trama"];
    }

    if ($_POST["casaEditrice"] == "") {
        $casaEditrice = NULL;
    } else {
        $casaEditrice = $_POST["casaEditrice"];
    }

    $result = add_libro($_POST["isbn"], $_POST["titolo"], $_POST["autore"], $trama, $casaEditrice);

    $_SESSION["successo"] = $result["successo"];
    $_SESSION["messaggio"] = $result["messaggio"];

    redirect("../bibliotecario/gest_libri.php");
?>