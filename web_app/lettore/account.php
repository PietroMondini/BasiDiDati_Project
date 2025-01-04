<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("../phps/utilities.php");
    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "lettore") {
        redirect("../index.php");
    }
    include("../components/headers.php");
    include("../components/navbar.php");
?>
<section class="section">
    <div class="container">
        <h1 class="title"> Area personale </h1>
        <table>
            <tr>
                <td>Nome</td>
                <td><?= $_SESSION["nome"] ?></td>
            </tr>
            <tr>
                <td>Cognome</td>
                <td><?= $_SESSION["cognome"] ?></td>
            </tr>
            <tr>
                <td>CF</td>
                <td><?= $_SESSION["cf"] ?></td>
            </tr>
            <tr>
                <td>Ruolo</td>
                <td><?= $_SESSION["ruolo"] ?></td>
            </tr>
        </table>
    </div>
</section>
<?php
    include("../components/footer.php");
?>