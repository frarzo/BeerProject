<?php

include '../connection.php';

$id = $_POST['id'];
$nome = $_POST['nome'];
$cognome = $_POST['cognome'];
$email = $_POST['email'];
$password = md5($_POST['psw']); //Almeno un pelo più sicuro, ma non proprio

$db_query = "INSERT INTO User(id,nome,cognome,email,psw,saldo) VALUES (\'$id\',\'$nome\',\'$cognome\',\'$email\',\'$password\',0)";

$res = $connect->query($db_query);
