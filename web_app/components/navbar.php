<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand mr-auto" href="../index.php">BUI - Biblioteche Universitarie Italiane</a>
    <div class="d-flex">
      <?php 
        if ($_SESSION["ruolo"] == "lettore") {
      ?>
        <a class="nav-link active" aria-current="page" href="../lettore/home.php">Home</a>
        <a class="nav-link active" aria-current="page" href="../lettore/ricerca.php">Ricerca</a>
        <a class="nav-link" href="../lettore/account.php">Account</a>
      <?php
        } else if ($_SESSION["ruolo"] == "bibliotecario") {
      ?>
        <a class="nav-link active" aria-current="page" href="../bibliotecario/home.php">Home</a>
        <a class="nav-link" href="../bibliotecario/gest_lettori.php">Lettori</a>
        <a class="nav-link" href="../bibliotecario/gest_libri.php">Libri</a>
        <a class="nav-link" href="../bibliotecario/account.php">Account</a>
      <?php
        }
      ?>
      <button class="btn btn-outline-success" type="submit">
        <a href="../phps/logout.php">Logout</a>
      </button>
    </div>
  </div>
</nav>