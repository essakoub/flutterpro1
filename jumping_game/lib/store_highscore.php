<?php

$host = "localhost";
$username = "root";
$password = "";
$dbname = "high_score";

$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

$sql = "SELECT MAX(score) AS highScore FROM display_score";
$result = $conn->query($sql);

if ($result && $row = $result->fetch_assoc()) {
    echo json_encode(["status" => "success", "highScore" => $row['highScore']]);
} else {
    echo json_encode(["status" => "error", "message" => "High score not found"]);
}

$conn->close();
?>
