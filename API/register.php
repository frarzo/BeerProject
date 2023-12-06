<?php

require_once('utils.php');

$encryption = new Encryption();

if (isset($_POST["email"]) && $_POST["email"] != "" && isset($_POST["psw"]) && $_POST["psw"] != "") {
    $dbhost = 'localhost';
    $dbuser = 'app_api';
    $dbpasssword = 'abcd1234';
    $database = 'beer';
    $connection = mysqli_connect($dbhost, $dbuser, $dbpasssword, $database);

    if (mysqli_connect_errno()) {
        echo mysqli_connect_error();
        exit('Failed to connect to MySQL: ' . mysqli_connect_error());
    }

    $user_psw = $encryption->decrypt($_POST['psw']);
    $user_email = $encryption->decrypt($_POST['email']);
    $user_nome = $encryption->decrypt($_POST['nome']);
    $user_cognome = $encryption->decrypt($_POST['cognome']);

    $result_insert = mysqli_query($connection, "INSERT INTO Utente(nome,cognome,email,psw,saldo,data_reg) VALUES ('$user_nome','$user_cognome','$user_email','$user_psw',0,NOW())");

    if ($result_insert) {
        //Controllo che effettivamente siano inseriti e ritorno i dati
        $result = mysqli_query($connection, "SELECT * FROM Utente WHERE email='$user_email'");

        if (mysqli_num_rows($result) > 0) {

            $row = mysqli_fetch_array($result);
            $id = $row['id'];
            $nome = $row['nome'];
            $cognome = $row['cognome'];
            $email = $row['email'];
            $saldo = $row['saldo'];
            $data_reg = $row['data_reg'];

            response($id, $nome, $cognome, $email, $saldo, $data_reg);
        } else {
            response(null, null, null, null, null, null);
        }
        mysqli_close($connection);
    }
} else {
    response(null, null, null, null, null, null);
    mysqli_close($connection);
}

function response($id, $nome, $cognome, $email, $saldo, $data_reg) {

    global $encryption;
    $response['id'] = $encryption->encrypt($id);
    $response['nome'] = $encryption->encrypt($nome);
    $response['cognome'] = $encryption->encrypt($cognome);
    $response['email'] = $encryption->encrypt($email);
    $response['saldo'] = $encryption->encrypt($saldo);
    $response['data_reg'] = $encryption->encrypt($data_reg);

    echo json_encode($response);
}
