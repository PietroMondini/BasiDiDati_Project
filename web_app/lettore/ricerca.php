<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("../phps/utilities.php");
    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "lettore") {
        redirect("../index.php");
    }
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $libro_scelta = $_POST["libro_scelta"];
        $libro_ricerca = $_POST["libro_ricerca"];
        $sede = $_POST["sede"];
        if ($sede == 0) {
            if ($libro_scelta == "isbn") {
                $libri = get_libri_disponibili_by_isbn($libro_ricerca);
            } else {
                $libri = get_libri_disponibili_by_titolo($libro_ricerca);
            }
        } else {
            if ($libro_scelta == "isbn") {
                $libri = get_libri_disponibili_by_isbn_sede($libro_ricerca, $sede);
            } else {
                $libri = get_libri_disponibili_by_titolo_sede($libro_ricerca, $sede);
            }
        }
    } else {
        $sedi = get_sedi();
        $_SESSION["sedi"] = $sedi;
    }

    include("../components/headers.php");
    include("../components/navbar.php");

    if (isset($_SESSION["loan_request_result"])) {
        $loan_request_result = $_SESSION["loan_request_result"];
        unset($_SESSION["loan_request_result"]);
    ?>
        <div class="toast-container position-fixed bottom-0 end-0 p-3">
            <div id="loanRequestToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false">
                <div class="toast-header">
                    <strong class="me-auto">Richiesta di prestito</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    <?= $loan_request_result["messaggio"] ?>
                </div>
            </div>
        </div>
        <script>
            var toastEl = document.getElementById('loanRequestToast');
            var toast = new bootstrap.Toast(toastEl);
            toast.show();
        </script>
    <?php
    }
?>
<section class="section">
    <div class="container">
        <form action="ricerca.php" method="POST">
            <div class="row mb-3">
                <label for="inputEmail3" class="col-sm-2 col-form-label">ISBN o Titolo</label>
                <div class="col-sm-10">
                    <input class="form-control" type="text" name="libro_ricerca" placeholder="ISBN o titolo" value="<?php if (isset($_POST["libro_ricerca"])) { echo $_POST["libro_ricerca"]; } ?>">
                </div>
            </div>
            <fieldset class="row mb-3">
                <legend class="col-form-label col-sm-2 pt-0">Ricerca per</legend>
                <div class="col-sm-10">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="libro_scelta" id="libro_scelta_isbn" value="isbn" checked>
                        <label class="form-check-label" for="libro_scelta_isbn">
                        ISBN
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="libro_scelta" id="libro_scelta_titolo" value="titolo" <?php if (isset($libro_scelta) && $libro_scelta == "titolo"){echo "checked";}  ?>>
                        <label class="form-check-label" for="libro_scelta_titolo">
                        Titolo
                        </label>
                    </div>
                </div>
            </fieldset>
            <div class="row mb-3">
                <label for="inputPassword3" class="col-sm-2 col-form-label">Sede di preferenza</label>
                <div class="col-sm-10">
                    <select class="form-select" name="sede">
                        <option value="0">Qualsiasi</option>
                        <?php
                            if ($_SESSION["sedi"] == null) {
                                ?>
                                    <div class="notification is-danger">
                                        Si è verificato un errore durante il recupero dei dati.
                                    </div>
                                <?php
                            } else {
                                foreach ($_SESSION["sedi"] as $sede) {
                                    ?>
                                        <option value="<?= $sede["id"] ?>" <?php if (isset($_POST["sede"]) && $_POST["sede"] == $sede["id"]) { echo "selected"; } ?>><?= $sede["città"] . ", " . $sede["indirizzo"] . ", " . $sede["civico"] ?></option>
                                    <?php
                                }
                            }
                        ?>
                    </select>
                </div>
            </div>
            <div class="d-flex justify-content-center justify-content-md-end mt-4">
                <button type="submit" class="btn btn-lg btn-primary">Cerca</button>
            </div>
        </form>
    </div>
<?php
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        ?>
            <div class="container">
                <div class="mb-5"></div>
                <hr>
            </div>
        <?php
        if ($libri == null || count($libri) == 0) {
            if ($_POST["sede"] == "0") {
                ?>
                    <div class="d-flex justify-content-center notification is-info has-text-centered h3">
                        Nessun libro trovato.
                    </div>
                <?php
            } else {
                ?>
                    <div class="d-flex justify-content-center notification is-info has-text-centered h3">
                        Nessun libro trovato nella sede selezionata.
                    </div>
                    <div class="container">
                        <hr>
                    </div>
                <?php
                
            }
        } else {
            ?>
                <section class="section">
                    <div class="container">
                        <div class="columns is-centered">
                            <div class="column is-half">
                                <table class="table is-fullwidth is-hoverable">
                                    <thead>
                                        <tr>
                                            <th>ISBN</th>
                                            <th>Titolo</th>
                                            <th>Autore</th>
                                            <th>Casa editrice</th>
                                            <th>Sede</th>
                                            <th>Trama</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php
                                            foreach ($libri as $libro) {
                                                ?>
                                                    <tr>
                                                        <td><?= $libro["isbn"] ?></td>
                                                        <td><?= $libro["titolo"] ?></td>
                                                        <td><?= $libro["autore"] ?></td>
                                                        <td><?= $libro["casaeditrice"] ?></td>
                                                        <td><?= $libro["città"] . ", " . $libro["indirizzo"] . ", " . $libro["civico"] ?></td>
                                                        <td><?= $libro["trama"] ?></td>
                                                    <td>
                                                        <form action="../phps/loan_request.php" method="POST">
                                                            <input name="id" value=<?= $_SESSION["id"]?> hidden>
                                                            <input name="isbn" value=<?= $libro["isbn"]?> hidden>
                                                            <input name="sede" value=<?= $libro["sede_id"]?> hidden>
                                                            <button type="submit" class="btn btn-primary">Richiedi prestito</button>
                                                        </form>
                                                    </td>
                                                    </tr>
                                                <?php
                                            }
                                        ?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </section>
                <?php
            }
        }                                                   
?>
<?php
    include("../components/footer.php");
?>
