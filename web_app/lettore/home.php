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
        <h1 class="title">Benvenuto, <?= $_SESSION["nome"] ?>!</h1>
        <h2 class="subtitle">In questa sezione puoi visualizzare i libri che hai preso in prestito.</h2>
        <div class="columns is-centered">
            <div class="column is-half">
                <table class="table is-fullwidth is-hoverable">
                    <thead>
                        <tr>
                            <th>ISBN</th>
                            <th>Titolo</th>
                            <th>Autore</th>
                            <th>Casa editrice</th>
                            <th>Inizio prestito</th>
                            <th>Scadenza</th>
                            <th>Stato</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>
<?php
    include("../components/footer.php");
?>