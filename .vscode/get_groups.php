<!-- 获取讨论群组数据 -->

<?php
include 'conn.php';

$sql = "SELECT g.id, g.name, g.group_lv, g.group_type, COUNT(ug.user_id) as member_count FROM `group` g LEFT JOIN user_group ug ON g.id = ug.group_id WHERE g.is_deleted = FALSE GROUP BY g.id";
$result = $conn->query($sql);

$groups = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $groups[] = $row;
    }
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($groups);

?>
