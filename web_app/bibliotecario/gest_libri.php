<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();

    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "bibliotecario") {
        redirect("../index.php");
    }

    if(!isset($_SESSION["autori"]) || !isset($_SESSION["libri"]) || !isset($_SESSION["sedi"])) {
        include_once("../phps/utilities.php");
        $data = getData();
        $autori = $data["autori"];
        $libri = $data["libri"];
        $sedi = $data["sedi"];
    } else {
        $autori = $_SESSION["autori"];
        $libri = $_SESSION["libri"];
        $sedi = $_SESSION["sedi"];
    }

    include("../components/headers.php");
    include("../components/navbar.php");
?>
<?php
    if (isset($_SESSION["successo"]) && isset($_SESSION["messaggio"])) {
        $successo = $_SESSION["successo"];
        $messaggio = $_SESSION["messaggio"];
        unset($_SESSION["successo"]);
        unset($_SESSION["messaggio"]);
    ?>
<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="loanRequestToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false">
        <div class="toast-header">
            <strong class="me-auto">Feedback operazione</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body">
            <?php
                if ($successo) {
                    echo '<div class="alert alert-success" role="alert">' . $messaggio . '</div>';
                } else {
                    echo '<div class="alert alert-danger" role="alert">' . $messaggio . '</div>';
                }
            ?>
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
<!-- Accordion per la gestione dei libri -->
<div class="container my-4 justify-content-end">
    <h1 class="text-center">Gestione libri</h1>
</div>
<div class="container accordion " id="gestioneLibriAccordion">
    <div class="accordion-item">
        <h2 class="accordion-header" id="autoreHeader">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#autoreCollapse" aria-expanded="false" aria-controls="autoreCollapse">
                Aggiungi Autore
            </button>
        </h2>
        <div id="autoreCollapse" class="accordion-collapse collapse" aria-labelledby="autoreHeader" data-bs-parent="#gestioneLibriAccordion">
            <div class="accordion-body">
                <form action="../phps/add_autore.php" method="post">
                    <div class="row mb-3">
                        <div class="col">
                            <input type="text" class="form-control" id="nomeAutore" name="nomeAutore" placeholder="Nome" required>
                        </div>
                        <div class="col">
                            <input type="text" class="form-control" id="cognomeAutore" name="cognomeAutore" placeholder="Cognome" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label for="dataNascitaAutore" class="form-label col-form-label">Data di nascita</label>
                            <input type="date" class="form-control" id="dataNascitaAutore" name="dataNascitaAutore" placeholder="Data di nascita" required>
                        </div>
                        <div class="col">
                            <label for="dataMorteAutore" class="form-label col-form-label">Data di morte</label>
                            <input type="date" class="form-control" id="dataMorteAutore" name="dataMorteAutore" placeholder="Data di morte">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="biografia" class="form-label">Biografia</label>
                        <textarea class="form-control" id="biografia" name="biografia" rows="3"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Aggiungi</button>
                </form>
            </div>
        </div>
    </div>
    <div class="accordion-item">
        <h2 class="accordion-header" id="libroHeader">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#libroCollapse" aria-expanded="false" aria-controls="libroCollapse">
                Aggiungi Libro
            </button>
        </h2>
        <div id="libroCollapse" class="accordion-collapse collapse" aria-labelledby="libroHeader" data-bs-parent="#gestioneLibriAccordion">
            <div class="accordion-body">
                <form action="../phps/add_libro.php" method="post">
                    <div class="row mb-3">
                        <div class="col">
                            <input type="text" class="form-control" id="isbn" name="isbn" placeholder="ISBN" required>
                        </div>
                        <div class="col">
                            <input type="text" class="form-control" id="titolo" name="titolo" placeholder="Titolo" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label for="autore" class="form-label">Autore</label>
                            <input class="form-control" list="autoriList" id="autore" name="autore" placeholder="Scrivi per cercare..." required>
                            <datalist id="autoriList">
                                <?php
                                    foreach ($autori as $autore) {
                                        echo '<option value="' . $autore["id"] . '">' . $autore["nome"] . ' ' . $autore["cognome"] . '</option>';
                                    }
                                ?>
                            </datalist>
                        </div>
                        <div class="col">
                            <label for="casaEditrice" class="form-label">Casa Editrice</label>
                            <input type="text" class="form-control" id="casaEditrice" name="casaEditrice" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label for="trama" class="form-label">Trama</label>
                            <textarea class="form-control" id="trama" name="trama" rows="3"></textarea>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Aggiungi</button>
                </form>
            </div>
        </div>
    </div>
    <div class="accordion-item">
        <h2 class="accordion-header" id="copieHeader">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#copieCollapse" aria-expanded="false" aria-controls="copieCollapse">
                Aggiungi Copie
            </button>
        </h2>
        <div id="copieCollapse" class="accordion-collapse collapse" aria-labelledby="copieHeader" data-bs-parent="#gestioneLibriAccordion">
            <div class="accordion-body">
                <form action="../phps/add_copie.php" method="post">
                    <div class="row mb-3">
                        <div class="col">
                            <input list="libriList" class="form-control" id="isbnCopie" name="isbnCopie" placeholder="ISBN" required>
                            <datalist id="libriList">
                                <?php
                                    include_once("../phps/utilities.php");
                                    foreach ($libri as $libro) {
                                        echo '<option value="' . $libro["isbn"] . '">' . $libro["titolo"] . '</option>';
                                    }
                                ?>
                            </datalist>
                        </div>
                        <div class="col">
                            <input type="number" class="form-control" id="numeroCopie" name="numeroCopie" placeholder="Numero copie" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label for="sede" class="form-label">Sede</label>
                            <input list="sediList" class="form-control" id="sede" name="sede" placeholder="Sede" required>
                            <datalist id="sediList">
                                <?php
                                    foreach ($sedi as $sede) {
                                        echo '<option value="' . $sede["id"] . '">' . $sede["città"] . ", " . $sede["indirizzo"] . ", " . $sede["civico"] . '</option>';
                                    }
                                ?>
                            </datalist>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Aggiungi</button>
                </form>
            </div>
        </div>
    </div>
</div>