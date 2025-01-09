<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("../phps/utilities.php");
    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "bibliotecario") {
        redirect("../index.php");
    }
    
    if (isset($_SESSION["lettore"]) && isset($_SESSION["prestiti_lettore"])) {
        $lettore = $_SESSION["lettore"];
        $prestiti_lettore = $_SESSION["prestiti_lettore"];
    }

    include("../components/headers.php");
    include("../components/navbar.php");
?>
<div class="container my-4 justify-content-end">
    <div class="row mb-3">
        <h2 class="subtitle col-sm-5">Aggiungi un lettore</h2>
        <button class="btn btn-primary col-sm-3" id="btnAddLettore" data-bs-toggle="modal" data-bs-target="#addLettoreModal">Aggiungi lettore</button>
    </div>
</div>

<div class="modal fade" id="addLettoreModal" tabindex="-1" aria-labelledby="addLettoreModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addLettoreModalLabel">Aggiungi un nuovo lettore</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-start">
                <form action="../phps/add_lettore.php" method="POST">
                    <div class="mb-3">
                        <label for="codiceFiscale" class="form-label">Codice fiscale</label>
                        <input type="text" class="form-control" id="codiceFiscale" name="codice_fiscale" required>
                    </div>
                    <div class="mb-3">
                        <label for="nome" class="form-label">Nome</label>
                        <input type="text" class="form-control" id="nome" name="nome" required>
                    </div>
                    <div class="mb-3">
                        <label for="cognome" class="form-label">Cognome</label>
                        <input type="text" class="form-control" id="cognome" name="cognome" required>
                    </div>
                    <div class="mb-3">
                        <label for="categoria" class="form-label">Tipo</label>
                        <select class="form-select" id="categoria" name="categoria" required>
                            <option value="base">Base</option>
                            <option value="premium">Premium</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="mb-3">
                        <label for="passwordConfirm" class="form-label">Conferma password</label>
                        <input type="password" class="form-control" id="passwordConfirm" name="password_confirm" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Conferma</button>
                </form>
            </div>
        </div>
    </div>
</div>

<hr>
<section class="section my-4">
    <div class="container">
        <h2 class="subtitle">Gestione lettore</h2>
        <form action="../phps/search_lettore.php" method="POST">

            <div class="row mb-3 align-items-center my-4">
                <label for="inputCF" class="col-sm-2 col-form-label">Codice fiscale</label>
                <div class="col-sm-8">
                    <input class="form-control" type="text" name="codice_fiscale" placeholder="CF" value="<?php if (isset($_POST["codice_fiscale"])) { echo $_POST["codice_fiscale"]; } ?>">
                </div>
                <div class="col-sm-2">
                    <button type="submit" class="btn btn-primary">Cerca</button>
                </div>
            </div>
        </form>
        <hr>
    </div>
    <?php
    if (isset($lettore)) {
        if ($lettore == null || count($lettore) == 0) {
            ?>
                <div class="d-flex justify-content-center notification is-info has-text-centered h3">
                    Nessun lettore trovato con il codice fiscale inserito.
                </div>
            <?php
        } else {
            ?>
                <div class="container">
                    <div class="row">
                        <div class="col">
                            <h3 class="subtitle">Dati lettore</h3>
                            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
                                <thead>
                                    <tr>
                                        <th>CF</th>
                                        <th>Nome</th>
                                        <th>Cognome</th>
                                        <th>Categoria</th>
                                        <th>Riconsegne in ritardo</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><?= $lettore["cf"] ?></td>
                                        <td><?= $lettore["nome"] ?></td>
                                        <td><?= $lettore["cognome"] ?></td>
                                        <td><?= $lettore["categoria"] ?></td>
                                        <td><?= $lettore["riconsegne_ritardo"] ?></td>
                                        <td>
                                            <form action="../phps/reset_ritardi.php" method="POST">
                                                <input name="id" value=<?= $lettore["id"]?> hidden>
                                                <button type="submit" class="btn btn-outline-primary">Reset ritardi</button>
                                            </form>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <h3 class="subtitle">Prestiti attivi</h3>
                            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
                                <thead>
                                    <tr>
                                        <th>ISBN</th>
                                        <th>Titolo</th>
                                        <th>Autore</th>
                                        <th>Casa editrice</th>
                                        <th>Data inizio</th>
                                        <th>Scadenza</th>
                                        <th>Stato</th>
                                        <th class="text-center" colspan=2>Azioni</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                        foreach ($prestiti_lettore as $prestito) {
                                            ?>
                                                <tr>
                                                    <td><?= $prestito["isbn"] ?></td>
                                                    <td><?= $prestito["titolo"] ?></td>
                                                    <td><?= $prestito["autore"] ?></td>
                                                    <td><?= $prestito["casaeditrice"] ?></td>
                                                    <td><?= $prestito["datainizio"] ?></td>
                                                    <td><?= $prestito["scadenza"] ?></td>
                                                    <td><?= $prestito["stato"] ?></td>
                                                    <td>
                                                        <form action="../phps/loan_return.php" method="POST">
                                                            <input name="id" value=<?= $lettore["id"]?> hidden>
                                                            <input name="copia_id" value=<?= $prestito["copia"]?> hidden>
                                                            <button type="submit" class="btn btn-primary">Riconsegna</button>
                                                        </form>
                                                    </td>
                                                    <td>
                                                        <form action="../phps/loan_extension.php" method="POST">
                                                            <input name="id" value=<?= $lettore["id"]?> hidden>
                                                            <input name="copia_id" value=<?= $prestito["copia"]?> hidden>
                                                            <button type="submit" class="btn btn-primary">Proroga</button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            <?php
                                        }
                                    ?>
                                </tbody>
                            </table>
                        </div>
                <?php
            }
        }                                                   
?>
<?php
    include("../components/footer.php");
?>
