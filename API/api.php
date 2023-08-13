<?php
//header("Content-Type:application/json");
if (true) {
    //isset($_POST["email"]) && $_POST["email"] != "" && isset($_POST["psw"]) && $_POST["psw"] != ""
    include("connection.php");
    $email = $_POST["email"];
    $psw = $_POST["psw"];
    echo $email." ".$psw;
    $result = mysqli_query($connection, "SELECT * FROM Utente WHERE email='$email' AND psw='$psw'");

    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_array($result);
        $id = $row['email'];
        $nome = $row['nome'];
        $cognome = $row['cognome'];
        $email = $row['email'];
        $saldo = $row['saldo'];
        $data_reg = $row['data_reg'];
        response($id, $nome, $cognome, $email, $saldo, $data_reg);
        mysqli_close($connection);
    } else {
        response(NULL, NULL, NULL, NULL, NULL, NULL, 200, 'No record found');
    }
} else {
    response(NULL, NULL, NULL, NULL, NULL, NULL, 400, 'Invalid request');
    echo"\nparametri settati male";
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
