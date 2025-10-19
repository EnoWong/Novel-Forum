<?php

/**
 * Logs in a user.
 *
 * @param mysqli $conn The database connection.
 * @param int $account_name The user's account name (QQ number).
 * @param string $password The user's password.
 * @return array|null User data on success, null on failure.
 */
function loginUser($conn, $account_name, $password) {
    $stmt = $conn->prepare("SELECT id, user_name, password, role_id, is_forbidden FROM user WHERE account_name = ? AND is_deleted = FALSE");
    $stmt->bind_param("i", $account_name);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows == 1) {
        $user = $result->fetch_assoc();
        if (password_verify($password, $user['password'])) {
            // 密碼正確
            if ($user['is_forbidden']) {
                // 使用者被禁止
                return null;
            }
            unset($user['password']); // 安全刪除密碼
            return $user;
        }
    $_SESSION['user'] = $user;
    }
    // 無效憑證或未找到用戶
    return null;
}

?>