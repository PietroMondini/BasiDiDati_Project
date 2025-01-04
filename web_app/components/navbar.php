<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand mr-auto" href="../index.php">BUI - Biblioteche Universitarie Italiane</a>
    <div class="d-flex">
      <a class="nav-link active" aria-current="page" href="<?php 
        if ($_SESSION["ruolo"] == "lettore") {
          echo "../lettore/account.php";
        } else {
          echo "../bibliotecario/account.php";
        }
      ?>">Account</a>
      <button class="btn btn-outline-success" type="submit">
        <a href="../phps/logout.php">Logout</a>
      </button>
    </div>
  </div>
</nav>