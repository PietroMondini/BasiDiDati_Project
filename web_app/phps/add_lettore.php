<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("../phps/utilities.php");
    
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $cf = $_POST["codice_fiscale"];
        $nome = $_POST["nome"];
        $cognome = $_POST["cognome"];
        $categoria = $_POST["categoria"];
        $password = $_POST["password"];
        $password_confirm = $_POST["password_confirm"];
        if ($password != $password_confirm) {
            $_SESSION["add_lettore_result"] = array("successo" => false, "message" => "Le password non coincidono");
            redirect("../bibliotecario/add_lettore.php");
        }
        $result = add_lettore($cf, $nome, $cognome, $categoria, $password);
        redirect("../bibliotecario/gest_lettori.php");
    }
?>