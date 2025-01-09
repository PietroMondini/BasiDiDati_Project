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
                <!-- Tabella dei libri in prestito -->  
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
                        <?php
                            include_once("../phps/utilities.php");
                            $prestiti = get_prestiti_lettore($_SESSION["id"]);
                            if ($prestiti == null) {
                                ?>
                                    <div class="notification is-danger">
                                        Si è verificato un errore durante il recupero dei dati.
                                    </div>
                                <?php
                            } else if (count($prestiti) == 0) {
                                ?>
                                    <div class="notification is-info">
                                        Non hai libri in prestito.
                                    </div>
                                <?php
                            } else {
                                foreach ($prestiti as $prestito) {
                                    ?>
                                        <tr>
                                            <td><?= $prestito["isbn"] ?></td>
                                            <td><?= $prestito["titolo"] ?></td>
                                            <td><?= $prestito["autore"] ?></td>
                                            <td><?= $prestito["casaeditrice"] ?></td>
                                            <td><?= $prestito["datainizio"] ?></td>
                                            <td><?= $prestito["scadenza"] ?></td>
                                            <td>
                                                <?php
                                                    /**
                                                     * Mette un colore diverso a seconda dello stato del prestito.
                                                     */
                                                    switch ($prestito["stato"]) {
                                                        case "in corso":
                                                            ?>
                                                                <span class="tag is-info">In corso</span>
                                                            <?php
                                                            break;
                                                        case "in ritardo":
                                                            echo '<span class="tag is-danger">In ritardo</span>';
                                                            break;
                                                        case 'riconsegnato in ritardo':
                                                            echo '<span class="tag is-danger">Riconsegnato in ritardo</span>';
                                                            break;
                                                        case "riconsegnato":
                                                            echo '<span class="tag is-success">Riconsegnato</span>';
                                                            break;
                                                    }
                                                ?>
                                            </td>
                                        </tr>
                                    <?php
                                }
                            }
                        ?>
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