<?php
session_start();
include 'conn.php';

// 检查用户是否登录
if (!isset($_SESSION['user']) || !isset($_SESSION['user']['id'])) {
    http_response_code(401); // Unauthorized
    echo json_encode(['status' => 'error', 'message' => '用户未登录或会话无效']);
    exit;
}
$author_id = $_SESSION['user']['id'];

// 数据请求
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['status' => 'error', 'message' => '仅支持POST请求']);
    exit;
}

// 获取和清理数据
$data = json_decode(file_get_contents('php://input'), true);

$title = isset($data['title']) ? trim($data['title']) : '';
$content = isset($data['content']) ? $data['content'] : '';
$group_id = isset($data['group_id']) ? (int)$data['group_id'] : 0;
$isDraft = isset($data['isDraft']) ? (bool)$data['isDraft'] : false;
$is_competition = isset($data['is_competition']) ? (bool)$data['is_competition'] : false;
$is_punishment = isset($data['is_punishment']) ? (bool)$data['is_punishment'] : false;

if (empty($title) || empty($content)) {
    http_response_code(400); // Bad Request
    echo json_encode(['status' => 'error', 'message' => '标题和内容不能为空']);
    exit;
}

//文件创建并储存
$uploadDir = '../uploads/novels';
if (!is_dir($uploadDir)){
    mkdir($uploadDir, 0777, true);
}

$filename = uniqid() . '.txt';
$filepath = $uploadDir . '/' . $filename;

if (file_put_contents($filepath, $content) === false) {
    http_response_code(500); // Internal Server Error
    echo json_encode(['status' => 'error', 'message' => '无法保存小说内容']);
    exit;
}

// 将小说信息存入数据库
$stmt = $conn->prepare("INSERT INTO novels (title, author_id, content_path, group_id, is_draft, is_competition, is_punishment) VALUES (?, ?, ?, ?, ?, ?, ?)");
if ($stmt === false) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => '数据库准备语句失败: ' . $conn->error]);
    exit;
}

$stmt->bind_param("sisiiii", $title, $author_id, $filepath, $group_id, $isDraft, $is_competition, $is_punishment);

if ($stmt->execute()) {
    $novel_id = $stmt->insert_id;
    echo json_encode(['status' => 'success', 'message' => '小说上传成功', 'novel_id' => $novel_id]);
} else {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => '数据库插入失败: ' . $stmt->error]);
    // 如果数据库插入失败，删除已创建的文件
    unlink($filepath);
}

$stmt->close();
$conn->close();
?>
