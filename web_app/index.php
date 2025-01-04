<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    session_start();
    require_once("phps/utilities.php");
    if (isset($_SESSION["ruolo"])) {
        switch ($_SESSION["ruolo"]) {
            case "lettore":
                redirect("lettore/home.php");
            case "bibliotecario":
                redirect("bibliotecario/home.php");
        }
    }
?>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/custom.css" rel="stylesheet">
    </head>
    <body>
        <!-- Bootstrap card vertically and horizontally centered -->
        <div class="container" style="height: 100vh;">
            <?php
                if (isset($_SESSION['login_feedback'])){
                    if ($_SESSION['login_feedback'] == false){
                        ?>
                            <div class="alert alert-danger" role="alert">
                                Login errato! Reinserisci le credenziali grazie
                            </div>
                        <?php
                    }
                }
            ?>
            <div class="d-flex justify-content-center align-items-center">
                <div class="card customCard">
                    <div class="card-body">
                        <h5 class="card-title">Accesso SBUM</h5>
                        <form class="customForm" action="\phps\login.php" method="POST">
                            <div class="form-outline mb-4">
                                <input type="cf" id="cf" class="form-control" placeholder="Codice fiscale" name="cf" required/>
                            </div>
                            <div class="form-outline mb-4">
                                <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Login</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
