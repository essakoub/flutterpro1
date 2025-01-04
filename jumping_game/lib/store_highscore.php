<?php

$host = "localhost";
$username = "root"; 
$password = "";     
$dbname = "high_score"; 


$conn = new mysqli($host, $username, $password, $dbname);


if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}


$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['playerName']) || !isset($data['score'])) {
    echo json_encode(["status" => "error", "message" => "Invalid input"]);
    exit;
}

$playerName = $conn->real_escape_string($data['playerName']);
$score = (int) $data['score'];


$sql = "INSERT INTO high_scores (playerName, score)
        VALUES ('$playerName', $score)
        ON DUPLICATE KEY UPDATE score = GREATEST(score, VALUES(score))";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "High score saved successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
}


$conn->close();
?>
