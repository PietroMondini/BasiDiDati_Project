<?php
    ini_set("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();

    include("../phps/utilities.php");

    // Check if the user is a bibliotecario
    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "bibliotecario") {
        redirect("../index.php");
    }

    // Add the new copy to the database
    $result = add_copie_n($_POST["isbnCopie"], $_POST["sede"], $_POST["numeroCopie"]);

    // Set session variables for success and message
    $_SESSION["successo"] = $result["successo"];
    $_SESSION["messaggio"] = $result["messaggio"];

    // Redirect to the gest_libri page
    redirect("../bibliotecario/gest_libri.php");
?>