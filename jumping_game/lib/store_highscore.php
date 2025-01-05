<?php

$host = "localhost";
$username = "root";
$password = "";
$dbname = "high_score";

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

$sql = "SELECT score FROM high_scores WHERE id = 1";
$result = $conn->query($sql);

if ($result && $row = $result->fetch_assoc()) {
    echo json_encode(["status" => "success", "highScore" => $row['score']]);
} else {
    echo json_encode(["status" => "error", "message" => "High score not found"]);
}

$conn->close();
?>
