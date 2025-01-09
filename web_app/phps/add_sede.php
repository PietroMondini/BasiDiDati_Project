<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("utilities.php");

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $città = $_POST["città"];
        $indirizzo = $_POST["indirizzo"];
        $civico = $_POST["civico"];
        $change_sede_result = add_sede($città, $indirizzo, $civico);
        $_SESSION["add_sede_feedback"] = $add_sede_result["successo"];
        $_SESSION["add_sede_feedback_message"] = $add_sede_result["messaggio"];
        redirect("../bibliotecario/home.php");
    }
?>