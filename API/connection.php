<?php  
$dbhost='localhost';
$dbuser='app_api';
$dbpasssword='abcd1234';
$database='beer';

$connection = mysqli_connect($dbhost,$dbuser,$dbpasssword,$database);

if (mysqli_connect_errno()) {
	echo mysqli_connect_error();
	exit('Failed to connect to MySQL: ' . mysqli_connect_error());
}
