<?php
$out;
if ($_GET["id"] && $_GET["id"]) {
    $dbhost = 'localhost';
    $dbuser = 'app_api';
    $dbpasssword = 'abcd1234';
    $database = 'beer';
    $connection = mysqli_connect($dbhost, $dbuser, $dbpasssword, $database);
    //$mysqli = new mysqli($dbhost, $dbuser, $dbpasssword, $database);

    if (mysqli_connect_errno()) {
        echo mysqli_connect_error();
        exit('Failed to connect to MySQL: ' . mysqli_connect_error());
    }
    $user_id = $_GET['id'];
    //echo $user_id . '</br>';
    if ($result = mysqli_query($connection, "SELECT * FROM Consumazione WHERE user_id='$user_id'")) {
        if (mysqli_num_rows($result)) {
            $i = 0;
            while ($row = mysqli_fetch_array($result)) {
                $response['id'] = $row['id'];
                $response['user_id'] = $user_id;
                $response['beer_id'] = $row['beer_id'];
                $response['quantita'] = $row['quantita'];
                $response['importo'] = $row['importo'];
                $response['data_consumazione'] = $row['data_consumazione'];
                $out[$i] = $response;
                $i++;
            }
            echo json_encode($out);
        }
    }
} else {
    echo ["ERRORE"];
}
