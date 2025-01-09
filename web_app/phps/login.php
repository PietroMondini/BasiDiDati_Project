<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("utilities.php");
    
    /**
     * Receives the login data from the form and checks if they are correct.
     */
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $cf = $_POST["cf"];
        $password = $_POST["password"];
        $login_result = check_login($cf, $password);
        if ($login_result[0]) {
            save_user_data($login_result[1]);
            if (isset($_SESSION["ruolo"])) {
                switch ($_SESSION["ruolo"]) {
                    case "lettore":
                        redirect("../lettore/home.php");
                    case "bibliotecario":
                        redirect("../bibliotecario/home.php");
                }
            }

        } else {
                $_SESSION["login_feedback"] = false;
                redirect("../index.php");
        }   
    }
?>