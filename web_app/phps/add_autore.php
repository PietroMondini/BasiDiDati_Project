<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();

    include("../phps/utilities.php");

    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "bibliotecario") {
        redirect("../index.php");
    }

    if ($_POST["dataMorteAutore"] == "") {
        $data_morte = NULL;
    } else {
        $data_morte = $_POST["dataMorteAutore"];
    }

    $result = add_autore($_POST["nomeAutore"], $_POST["cognomeAutore"], $_POST["dataNascitaAutore"], $data_morte, $_POST["biografia"]);

    $_SESSION["successo"] = $result["successo"];
    $_SESSION["messaggio"] = $result["messaggio"];

    redirect("../bibliotecario/gest_libri.php");
?>
