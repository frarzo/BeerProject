<?php

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

    $user_psw = $_POST['psw'];
    $user_email = $_POST['email'];


    $result = mysqli_query($connection, "SELECT * FROM Utente WHERE email='$user_email' AND psw='$user_psw'");
    if (mysqli_num_rows($result) > 0) {


        $row = mysqli_fetch_array($result);
        $id = $row['id'];
        $nome = $row['nome'];
        $cognome = $row['cognome'];
        $email = $row['email'];
        $saldo = $row['saldo'];
        $data_reg = $row['data_reg'];
        response($id, $nome, $cognome, $email, $saldo, $data_reg);
        mysqli_close($connection);
    } else {
        response(NULL, NULL, NULL, NULL, NULL, NULL);

    }
} else {

    response(NULL, NULL, NULL, NULL, NULL, NULL);
}
function response($id, $nome, $cognome, $email, $saldo, $data_reg) {

    $response['id'] = $id;
    $response['nome'] = $nome;
    $response['cognome'] = $cognome;
    $response['email'] = $email;
    $response['saldo'] = $saldo;
    $response['data_reg'] = $data_reg;
    echo json_encode($response);
}
