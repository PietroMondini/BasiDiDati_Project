<?php
    ini_set ("display_errors", "On");
    ini_set("error_reporting", E_ALL);
    session_start();
    require_once("../phps/utilities.php");
    if (!isset($_SESSION["ruolo"]) || $_SESSION["ruolo"] != "bibliotecario") {
        redirect("../index.php");
    }
    include("../components/headers.php");
    include("../components/navbar.php");
?>
<section class="section">
    <div class="container">
        <h1 class="title">Benvenuto, <?= $_SESSION["nome"] ?>!</h1>
        <h2 class="subtitle">Profilo personale bibliotecario</h2>
        <div class="columns is-centered">
            <div class="column is-half">
                <table class="table is-fullwidth is-hoverable">
                    <thead>
                        <tr>
                            <th></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Nome</td>
                            <td><?= $_SESSION["nome"] ?></td>
                        </tr>
                        <tr>
                            <td>Cognome</td>
                            <td><?= $_SESSION["cognome"] ?></td>
                        </tr>
                        <tr>
                            <td>Codice fiscale</td>
                            <td><?= $_SESSION["cf"] ?></td>
                        </tr>
                        <tr>
                            <td>Password</td>
                            <td>
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                                    Cambia password
                                </button>
                                <!-- Modal -->
                                <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="changePasswordModalLabel">Cambia password</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <?php
                                                    if (isset($_SESSION["change_password_feedback"])) {
                                                        ?>
                                                        <script>
                                                            var myModal = new bootstrap.Modal(document.getElementById('changePasswordModal'), {
                                                                keyboard: false
                                                            });
                                                            myModal.show();
                                                        </script>
                                                        <?php
                                                        if ($_SESSION["change_password_feedback"]) {
                                                            ?>
                                                                <div class="alert alert-success" role="alert">
                                                                    <?= $_SESSION["change_password_feedback_message"] ?>
                                                                </div>
                                                            <?php
                                                        } else {
                                                            ?>
                                                                <div class="alert alert-danger" role="alert">
                                                                    <?= $_SESSION["change_password_feedback_message"] ?>
                                                                </div>
                                                            <?php
                                                        }
                                                        unset($_SESSION["change_password_feedback"]);
                                                        unset($_SESSION["change_password_feedback_message"]);
                                                    }
                                                ?>
                                                <form action="../phps/change_password.php" method="POST">
                                                    <div class="mb-3">
                                                        <label for="oldPassword" class="form-label">Vecchia password</label>
                                                        <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="newPassword" class="form-label">Nuova password</label>
                                                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="confirmNewPassword" class="form-label">Conferma nuova password</label>
                                                        <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary">Cambia password</button>
                                                </form>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Chiudi</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>
<?php
    include("../components/footer.php");
?>