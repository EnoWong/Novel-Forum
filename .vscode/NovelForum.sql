
DROP TABLE IF EXISTS novel_critique;
CREATE TABLE novel_critique(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `novel_id` MEDIUMINT NOT NULL COMMENT '小说评论评价',
    `title` VARCHAR(255) COMMENT '帖子标题; 主题帖(parent_id is NULL)需要有标题',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `author_id` MEDIUMINT NOT NULL COMMENT '评论创建者',
    `parent_id` MEDIUMINT COMMENT '附属评论id;楼中楼，当不存在时确认为话题楼主，存在时则和相关评论行成回复关系',
    `create_time` DATETIME NOT NULL COMMENT '评论创建时间',
    `modify_time` DATETIME COMMENT '评论修改时间',
    `is_approved` BOOLEAN COMMENT '是否审批通过;可做保留字段采用，评论可以先不采取审核，若是有人发表不当言论再予以撤回操作，若是有大量的群友多次出现不当言论，则强制采用审核后才可显示的策略。是否审批通过，FALSE不通过并撤回，TRUE或NULL状态正常（非正常时期策略TRUE审批通过，NULL未审核不显示）',
    PRIMARY KEY (`id`)
) COMMENT 'novel_critique;小说下的评论';


DROP TABLE IF EXISTS [novel_group];
CREATE TABLE novel_group(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `name` VARCHAR(128) NOT NULL COMMENT '类型名称',
    PRIMARY KEY (`id`)
) COMMENT 'novel_group;小说分组';


DROP TABLE IF EXISTS read_novel_history;
CREATE TABLE read_novel_history(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `novel_id` MEDIUMINT NOT NULL COMMENT '小说id',
    `user_id` MEDIUMINT NOT NULL COMMENT '用户id',
    `read_time` DATETIME NOT NULL COMMENT '最新浏览时间;除了第一次浏览外其余浏览操作都只会更新该时间而不是添加新记录',
    PRIMARY KEY (`id`)
) COMMENT 'read_novel_history;小说文件浏览记录';


DROP TABLE IF EXISTS user_group;
CREATE TABLE user_group(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `user_id` MEDIUMINT NOT NULL COMMENT '用户id',
    `group_id` MEDIUMINT NOT NULL COMMENT '讨论组id',
    PRIMARY KEY (`id`)
) COMMENT 'user_group;用户和讨论组的映射';


DROP TABLE IF EXISTS role;
CREATE TABLE role(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `name` VARCHAR(128) NOT NULL COMMENT '角色名称',
    PRIMARY KEY (`id`)
) COMMENT 'role;角色表创建时默认添加admin,manager,member三个角色，权限可通过维护role_menu映射关系加以区分';


DROP TABLE IF EXISTS novel_info;
CREATE TABLE novel_info(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `name` VARCHAR(128) NOT NULL COMMENT '小说标题',
    `group_id` MEDIUMINT NOT NULL COMMENT '小说类型',
    `file_path` VARCHAR(128) NOT NULL COMMENT '小说服务器文件路径;该数据需要考虑是否加密',
    `is_draft` BOOLEAN COMMENT '是否草稿;草稿则在草稿箱中显示，下面的审批等字段在草稿阶段不具有意义',
    `is_approved` BOOLEAN COMMENT '是否审批通过;是否审批通过，FALSE不通过，TRUE通过，NULL未审批',
    `author_id` MEDIUMINT NOT NULL COMMENT '作者id',
    `is_competition` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '是否为征文;征文标记，从征文入口提交文章时置为TRUE，文章在征文结束阶段前不显示，不可让作者手动更改',
    `is_punishment` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '是否为罚文;罚文标记，方便后续统计罚文字数，从罚文入口提交罚文时置为TRUE，该字段不可在其他地方更改',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `modify_time` DATETIME COMMENT '修改时间;修改后需要清空审批字段的数据以重新审批',
    PRIMARY KEY (`id`)
) COMMENT 'novel_info;小说文件的管理';


DROP TABLE IF EXISTS forum_critique;
CREATE TABLE forum_critique(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `group_id` MEDIUMINT NOT NULL COMMENT '所属讨论组id',
    `title` VARCHAR(255) COMMENT '帖子标题; 主题帖(parent_id is NULL)需要有标题',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `author_id` MEDIUMINT NOT NULL COMMENT '评论创建者',
    `parent_id` MEDIUMINT COMMENT '附属评论id;当不存在时确认为话题楼主，存在时则和相关评论行成回复关系',
    `create_time` DATETIME NOT NULL COMMENT '评论创建时间',
    `modify_time` DATETIME COMMENT '评论修改时间',
    `is_approved` BOOLEAN COMMENT '是否审批通过;可做保留字段采用，评论可以先不采取审核，若是有人发表不当言论再予以撤回操作，若是有大量的群友多次出现不当言论，则强制采用审核后才可显示的策略。是否审批通过，FALSE不通过并撤回，TRUE或NULL状态正常（非正常时期策略TRUE审批通过，NULL未审核不显示）',
    PRIMARY KEY (`id`)
) COMMENT 'forum_critique;论坛中的评论和帖子';


DROP TABLE IF EXISTS punishment_info;
CREATE TABLE punishment_info(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `user_id` MEDIUMINT NOT NULL COMMENT '用户id',
    `word_number` MEDIUMINT NOT NULL COMMENT '罚文字数',
    `word_number_remain` MEDIUMINT NOT NULL COMMENT '上一次罚文的多余字数;上一次罚文有结余则填入，若上一次罚文还未完成则置0（不需要写负数，方便最终盘点）',
    `start_time` DATETIME NOT NULL COMMENT '计时开始时间',
    `day_count` MEDIUMINT NOT NULL DEFAULT 15 COMMENT '限时日数',
    `status` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '罚文状态;只有确认罚文合格，由管理员更改状态为true才可视作罚文结束',
    PRIMARY KEY (`id`)
) COMMENT 'punishment_info;罚文单';


DROP TABLE IF EXISTS menu;
CREATE TABLE menu(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `name` VARCHAR(128) NOT NULL COMMENT '菜单栏名称',
    `parent_id` MEDIUMINT NOT NULL COMMENT '菜单栏等级;0为一级菜单，非0则为具体菜单的子菜单或对应的按钮',
    `menu_type` TINYINT NOT NULL DEFAULT 0 COMMENT '类型;0菜单，1按钮(做菜单路由时筛选出为0的数据即可)',
    PRIMARY KEY (`id`)
) COMMENT 'menu';


DROP TABLE IF EXISTS role_menu;
CREATE TABLE role_menu(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `role_id` MEDIUMINT NOT NULL COMMENT '角色id',
    `menu_id` MEDIUMINT NOT NULL COMMENT '菜单或按钮id',
    PRIMARY KEY (`id`)
) COMMENT 'role_menu;菜单和角色的映射关系（多对多）';


DROP TABLE IF EXISTS novel_follow;
CREATE TABLE novel_follow(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `user_id` MEDIUMINT NOT NULL COMMENT '用户id',
    `novel_id` MEDIUMINT NOT NULL COMMENT '讨论组id',
    `collection_id` MEDIUMINT COMMENT '用户收藏组的id;没有就是属于默认收藏夹',
    PRIMARY KEY (`id`)
) COMMENT 'novel_follow;小说收藏数据的归档';


DROP TABLE IF EXISTS user_follow;
CREATE TABLE user_follow(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `user_id` MEDIUMINT NOT NULL COMMENT '用户id',
    `follow_id` MEDIUMINT NOT NULL COMMENT '被关注人的id',
    PRIMARY KEY (`id`)
) COMMENT 'user_follow;关注者和被关注作者的映射';


DROP TABLE IF EXISTS competition_novel;
CREATE TABLE competition_novel(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `novel_id` MEDIUMINT NOT NULL COMMENT '小说id',
    `competition_id` MEDIUMINT NOT NULL COMMENT '征文比赛id',
    PRIMARY KEY (`id`)
) COMMENT 'competition_novel';


DROP TABLE IF EXISTS novel_tag;
CREATE TABLE novel_tag(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `novel_id` MEDIUMINT NOT NULL COMMENT '小说id',
    `tag_id` MEDIUMINT NOT NULL COMMENT 'tagid',
    PRIMARY KEY (`id`)
) COMMENT 'novel_tag;小说和对应标签的对应关系';


DROP TABLE IF EXISTS read_forum_history;
CREATE TABLE read_forum_history(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `forum_id` MEDIUMINT NOT NULL COMMENT '楼主的评论id',
    `user_id` MEDIUMINT NOT NULL COMMENT '用户id',
    `read_time` DATETIME COMMENT '最新浏览时间;除了第一次浏览外其余浏览操作都只会更新该时间而不是添加新记录',
    PRIMARY KEY (`id`)
) COMMENT 'read_forum_history;小说文件浏览记录';


DROP TABLE IF EXISTS user_collection;
CREATE TABLE user_collection(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `name` VARCHAR(128) NOT NULL COMMENT '收藏夹名称',
    `user_id` MEDIUMINT NOT NULL COMMENT '用户id',
    `is_secret` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '是否私密文件夹;私密文件夹除本人外无法查看',
    PRIMARY KEY (`id`)
) COMMENT 'user_collection;用户收藏分组';


DROP TABLE IF EXISTS competition_info;
CREATE TABLE competition_info(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `name` VARCHAR(128) NOT NULL COMMENT '活动名称',
    `content` VARCHAR(128) NOT NULL COMMENT '活动公告;直接存储相关富文本内容',
    `flow_id` MEDIUMINT NOT NULL COMMENT '活动阶段id;活动阶段',
    `create_id` MEDIUMINT NOT NULL COMMENT '发起人',
    `create_time` DATETIME NOT NULL COMMENT '发起时间',
    PRIMARY KEY (`id`)
) COMMENT 'competition_info;征文比赛内容';


DROP TABLE IF EXISTS tag;
CREATE TABLE tag(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `name` VARCHAR(128) NOT NULL COMMENT 'tag名称',
    `create_id` MEDIUMINT NOT NULL COMMENT '首次创建人的id;只在第一次修改，后续不动',
    PRIMARY KEY (`id`)
) COMMENT 'tag';


DROP TABLE IF EXISTS competition_flow;
CREATE TABLE competition_flow(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `name` VARCHAR(128) NOT NULL COMMENT '阶段名称',
    `content` VARCHAR(128) COMMENT '阶段说明;直接存储相关富文本内容',
    `is_used` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '是否使用;每次维护完流程除去使用的流程均需重新设置成FALSE',
    `previous_id` MEDIUMINT NOT NULL COMMENT '上一阶段id;上一活动阶段',
    `is_final_step` MEDIUMINT COMMENT '是否是结束阶段;不做显示',
    PRIMARY KEY (`id`)
) COMMENT 'competition_flow;征文比赛流程（说明比赛期间流程不可更改，该维护操作仅交由管理员，is_final_step只用于判断是否是结束流程，不用于显示和更改，是最开始数据库就写入的数据，其余流程均可增删改）';


DROP TABLE IF EXISTS user;
CREATE TABLE user(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `account_name` MEDIUMINT NOT NULL COMMENT '账号(QQ号);预想用QQ号来作为账号，这样可以不用限制用户名唯一',
    `user_name` VARCHAR(128) NOT NULL DEFAULT '默认用户' COMMENT '用户昵称',
    `password` VARCHAR(128) NOT NULL COMMENT '密码;需通过加密手段加密，存储的数据为加密后数据',
    `role_id` MEDIUMINT NOT NULL COMMENT '角色id;关联角色表（单个用户只担任一种角色）',
    `gender` TINYINT COMMENT '性别(选填);1male,2female,不填不公示',
    `age` TINYINT COMMENT '年龄(选填);隐私数据，可不填',
    `avatar` MEDIUMTEXT COMMENT '头像;头像数据(base64)',
    `is_forbidden` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '是否封禁',
    `phone` VARCHAR(128) COMMENT '手机号(选填);若考虑国际化则需要存储国家码，比如+8612345678912',
    `address` VARCHAR(128) COMMENT '地址(选填)',
    `remark` VARCHAR(128) COMMENT '签名',
    PRIMARY KEY (`id`)
) COMMENT 'user';


DROP TABLE IF EXISTS group;
CREATE TABLE group(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `name` VARCHAR(128) NOT NULL COMMENT '讨论组名称',
    `group_lv` MEDIUMINT COMMENT '讨论组等级',
    `group_type` MEDIUMINT COMMENT '讨论组类型;暂定，后续要用枚举固定维护',
    PRIMARY KEY (`id`)
) COMMENT 'group;讨论组';


DROP TABLE IF EXISTS punishment_record;
CREATE TABLE punishment_record(
    `id` MEDIUMINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '假删除标记',
    `punishment_id` MEDIUMINT NOT NULL COMMENT '罚文单id',
    `novel_id` MEDIUMINT NOT NULL COMMENT '小说id',
    `word_number` MEDIUMINT NOT NULL COMMENT '罚文字数;若罚文作者更新文章，该字数需要同步更新，除非当前罚文所在的罚单已确认结束',
    PRIMARY KEY (`id`)
) COMMENT 'punishment_record;罚文记录';

