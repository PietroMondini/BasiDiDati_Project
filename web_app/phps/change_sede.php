<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("utilities.php");

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $sede = $_POST["id"];
        $città = $_POST["città"];
        $indirizzo = $_POST["indirizzo"];
        $civico = $_POST["civico"];
        $change_sede_result = change_sede($sede, $città, $indirizzo, $civico);
        $_SESSION["change_sede_feedback"] = $change_sede_result["successo"];
        $_SESSION["change_sede_feedback_message"] = $change_sede_result["messaggio"];
        redirect("../bibliotecario/home.php");
    }
?>