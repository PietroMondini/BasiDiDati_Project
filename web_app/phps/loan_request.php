<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("utilities.php");

    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "lettore") {
        redirect("../index.php");
    }

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $id = $_POST["id"];
        $isbn = $_POST["isbn"];
        $sede = $_POST["sede"];
        $result = richiedi_prestito($id, $isbn, $sede);
        $_SESSION["loan_request_result"] = $result;
        redirect("../lettore/ricerca.php");
    } else {
        redirect("../index.php");
    }

?>