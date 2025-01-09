<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("../phps/utilities.php");
    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "bibliotecario") {
        redirect("../index.php");
    }
    $sedi = get_sedi();
    $_SESSION["sedi"] = $sedi;
    include("../components/headers.php");
    include("../components/navbar.php");
?>
<section class="section">
    <div class="container">
        <h1 class="title">Dashboard bibliotecario</h1>
        <h2 class="subtitle">In questa sezione puoi gestire le sedi della biblioteca.</h2>
        <!-- Button trigger modal all on the right -->
        <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSedeModal">
            Aggiungi sede
            </button>
        </div>
        <!-- Modal -->
        <div class="modal fade" id="addSedeModal" tabindex="-1" aria-labelledby="addSedeModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addSedeModalLabel">Aggiungi nuova sede</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-start">
                        <?php
                            if (isset($_SESSION["add_sede_feedback"])) {
                                ?>
                                    <script>
                                        var myModal = new bootstrap.Modal(document.getElementById('addSedeModal'), {
                                            keyboard: false
                                        });
                                        myModal.show();
                                    </script>
                                    <?php
                                    if ($_SESSION["add_sede_feedback"]) {
                                        ?>
                                            <div class="alert alert-success" role="alert">
                                                <?= $_SESSION["add_sede_feedback_message"] ?>
                                            </div>
                                        <?php
                                    } else {
                                        ?>
                                            <div class="alert alert-danger" role="alert">
                                                <?= $_SESSION["add_sede_feedback_message"] ?>
                                            </div>
                                        <?php
                                    }
                                    unset($_SESSION["add_sede_feedback"]);
                                    unset($_SESSION["add_sede_feedback_message"]);
                                }
                            ?>
                        <form action="../phps/add_sede.php" method="POST">
                            <div class="mb-3">
                                <label for="città" class="form-label mb-2">Città</label>
                                <input type="text" class="form-control" name="città" required>
                            </div>
                            <div class="mb-3">
                                <label for="indirizzo" class="form-label mb-2">Indirizzo</label>
                                <input type="text" class="form-control" name="indirizzo" required>
                            </div>
                            <div class="mb-3">
                                <label for="civico" class="form-label mb-2">Civico</label>
                                <input type="text" class="form-control" name="civico" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Conferma</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="columns is-centered">
            <div class="column is-half">
                <!-- Tabella delle sedi -->  
                <table class="table is-fullwidth is-hoverable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Città</th>
                            <th>Indirizzo</th>
                            <th>Civico</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                            foreach ($_SESSION["sedi"] as $sede) {
                                ?>
                                    <tr>
                                        <td><?= $sede["id"] ?></td>
                                        <td><?= $sede["città"] ?></td>
                                        <td><?= $sede["indirizzo"] ?></td>
                                        <td><?= $sede["civico"] ?></td>
                                        <td>
                                            <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#updateSedeModal<?= $sede["id"] ?>">Modifica</button>
                                            <div class="modal fade" id="updateSedeModal<?= $sede["id"] ?>" tabindex="-1" aria-labelledby="updateSede<?= $sede["id"]?>Label" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="updateSede<?= $sede["id"]?>Label">Modifica dati sede</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <?php
                                                                if (isset($_SESSION["change_sede_feedback"])) {
                                                                    ?>
                                                                    <script>
                                                                        var myModal = new bootstrap.Modal(document.getElementById('updateSedeModal<?= $sede["id"] ?>'), {
                                                                            keyboard: false
                                                                        });
                                                                        myModal.show();
                                                                    </script>
                                                                    <?php
                                                                    if ($_SESSION["change_sede_feedback"]) {
                                                                        ?>
                                                                            <div class="alert alert-success" role="alert">
                                                                                <?= $_SESSION["change_sede_feedback_message"] ?>
                                                                            </div>
                                                                        <?php
                                                                    } else {
                                                                        ?>
                                                                            <div class="alert alert-danger" role="alert">
                                                                                <?= $_SESSION["change_sede_feedback_message"] ?>
                                                                            </div>
                                                                        <?php
                                                                    }
                                                                    unset($_SESSION["change_sede_feedback"]);
                                                                    unset($_SESSION["change_sede_feedback_message"]);
                                                                }
                                                            ?>
                                                            <form action="../phps/change_sede.php" method="POST">
                                                                <input type="hidden" name="id" value="<?= $sede["id"] ?>">
                                                                <div class="mb-3">
                                                                    <label for="città" class="form-label mb-2">Città</label>
                                                                    <input type="text" class="form-control" name="città" value="<?= $sede["città"] ?>" required>    
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="indirizzo" class="form-label mb-2">Indirizzo</label>
                                                                    <input type="text" class="form-control" name="indirizzo" value="<?= $sede["indirizzo"] ?>" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="civico" class="form-label mb-2">Civico</label>
                                                                    <input type="text" class="form-control" name="civico" value="<?= $sede["civico"] ?>" required>
                                                                </div>
                                                                <button type="submit" class="btn btn-primary">Conferma modifiche</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
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
    include("../components/footer.php");
?>

        