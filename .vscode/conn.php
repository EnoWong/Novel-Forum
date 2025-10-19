<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "novelforum";

// 创建连接
$conn = mysqli_connect($servername, $username, $password, $dbname);

// 检测连接
if (!$conn) {
    die("连接失败: " . mysqli_connect_error());
}
?>