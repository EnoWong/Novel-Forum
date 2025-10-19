<!-- 获取帖子数据 -->

<?php
include 'conn.php';

// Optional: Filter by group_id
$group_id = isset($_GET['group_id']) ? (int)$_GET['group_id'] : 0;

$sql = "
    SELECT
        fc.id,
        fc.title,
        LEFT(fc.content, 100) as content_preview, -- 内容预览
        fc.create_time,
        u.user_name AS author_name,
        u.avatar AS author_avatar,
        (SELECT COUNT(*) FROM forum_critique WHERE parent_id = fc.id AND is_deleted = FALSE) as comment_count,
        (SELECT MAX(create_time) FROM forum_critique WHERE parent_id = fc.id AND is_deleted = FALSE) as last_reply_time
    FROM
        forum_critique fc
    JOIN
        user u ON fc.author_id = u.id
    WHERE
        fc.is_deleted = FALSE
        AND fc.parent_id IS NULL
";

if ($group_id > 0) {
    $sql .= " AND fc.group_id = ?";
}

$sql .= " ORDER BY fc.create_time DESC";

$stmt = $conn->prepare($sql);

if ($group_id > 0) {
    $stmt->bind_param("i", $group_id);
}

$stmt->execute();
$result = $stmt->get_result();

$posts = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $posts[] = $row;
    }
}

$stmt->close();
$conn->close();

header('Content-Type: application/json');
echo json_encode($posts);

?>