<?php  
$dbhost='localhost';
$dbuser='app_api';
$dbpasssword='abcd1234';
$database='beer';

$connect = new mysqli($dbhost,$dbuser,$dbpasssword,$database);

if (mysqli_connect_errno()) {
	exit('Failed to connect to MySQL: ' . mysqli_connect_error());
}
