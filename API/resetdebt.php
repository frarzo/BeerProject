<?php

require_once('utils.php');

$encryption = new Encryption();

if ($_GET["id"] && $_GET["id"]) {
    $dbhost = 'localhost';
    $dbuser = 'app_api';
    $dbpasssword = 'abcd1234';
    $database = 'beer';
    $connection = mysqli_connect($dbhost, $dbuser, $dbpasssword, $database);

    if (mysqli_connect_errno()) {
        echo mysqli_connect_error();
        exit('Failed to connect to MySQL: ' . mysqli_connect_error());
    }
    $user_id = $encryption->decrypt($_GET['id']);

    if ($result = mysqli_query($connection, "UPDATE Utente SET saldo=0 where id='$user_id'")) {
        $out['status'] = $encryption->encrypt('0');
    } else {
        $out['status'] = $encryption->encrypt('1');
    }
    echo json_encode($out);
}
