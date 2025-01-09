<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("utilities.php");
    
   /**
    * Receives the old and new password from the form and changes the password of the user.
    */
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $id = $_SESSION["id"];
        $oldPassword = $_POST["oldPassword"];
        $newPassword = $_POST["newPassword"];
        $confirmNewPassword = $_POST["confirmNewPassword"];
        if ($newPassword != $confirmNewPassword) {
            $_SESSION["change_password_feedback"] = false;
            $_SESSION["change_password_feedback_message"] = "Le password non corrispondono.";
            redirect("../lettore/account.php");
        }
        $change_password_result = change_password($id, $oldPassword, $newPassword);
        if ($change_password_result[0]) {
            $_SESSION["change_password_feedback"] = true;
            $_SESSION["change_password_feedback_message"] = $change_password_result[1];
        } else {
            $_SESSION["change_password_feedback"] = false;
            $_SESSION["change_password_feedback_message"] = $change_password_result[1];
        }
        if ($_SESSION["ruolo"] == "lettore") {
            redirect("../lettore/account.php");
        } else {
            redirect("../bibliotecario/account.php");
        }
    }
?>