<?php
/**
 * Logs out the user from the session. Redirects to the index page.
 */
session_start();
session_destroy();
header("Location: ../index.php");
exit();
?>