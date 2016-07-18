SET SESSION FOREIGN_KEY_CHECKS=0;

/* Drop Tables */

DROP TABLE IF EXISTS md0003_menu_relation;
DROP TABLE IF EXISTS md9011_role_menu;
DROP TABLE IF EXISTS md0003_menu;
DROP TABLE IF EXISTS md0000_menu_category;
DROP TABLE IF EXISTS md0002_user_otp;
DROP TABLE IF EXISTS md9008_user_roles;
DROP TABLE IF EXISTS md0002_user;
DROP TABLE IF EXISTS md0006_role_child;
DROP TABLE IF EXISTS md0006_role;
DROP TABLE IF EXISTS md8014_notification;
DROP TABLE IF EXISTS md9008_user_type_permissions;




/* Create Tables */

-- To distinguish between Operation or Maintenance menus
CREATE TABLE md0000_menu_category
(
	gid bigint NOT NULL,
	cat_code varchar(50) NOT NULL,
	cat_name varchar(200),
	-- 1 : active; 0 : inactive
	status varchar(1) DEFAULT '1' NOT NULL COMMENT '1 : active; 0 : inactive',
	-- 0 is operator module, 1 is master module
	type varchar(2) DEFAULT '0' NOT NULL COMMENT '0 is operator module, 1 is master module',
	cat_index int DEFAULT 0 NOT NULL,
	PRIMARY KEY (gid)
) COMMENT = 'To distinguish between Operation or Maintenance menus';


-- User information in system
CREATE TABLE md0002_user
(
	gid bigint NOT NULL AUTO_INCREMENT,
	-- Fullname 
	fullname varchar(200) NOT NULL COMMENT 'Fullname ',
	user_code varchar(50) NOT NULL,
	user_pwd varchar(200),
	user_pwd_expired_dtz timestamp,
	-- 1 : HEX; 2 : Agent; 3 : Customer
	type varchar(2) NOT NULL COMMENT '1 : HEX; 2 : Agent; 3 : Customer',
	-- 1 : active; 0 : inactive
	status varchar(1) DEFAULT '1' NOT NULL COMMENT '1 : active; 0 : inactive',
	-- 1 : male; 2 : female; 3 : other
	user_gender varchar(2) COMMENT '1 : male; 2 : female; 3 : other',
	user_email varchar(200) NOT NULL,
	user_phone varchar(50),
	company_name varchar(200),
	address varchar(250),
	-- Default language
	def_lang_code varchar(10) COMMENT 'Default language',
	last_login_datetimez timestamp,
	timezone_gid bigint,
	summertime_flag varchar(10),
	-- 0: User has not changed password yet after receiving otp
	-- 1: User has changed password after receiving otp
	otp_flag varchar(1) COMMENT '0: User has not changed password yet after receiving otp
1: User has changed password after receiving otp',
	auth_token varchar(255),
	PRIMARY KEY (gid)
) COMMENT = 'User information in system';


-- Onetime password of user
CREATE TABLE md0002_user_otp
(
	gid bigint NOT NULL,
	otp varchar(50),
	-- expired date for ont time password - if have
	expired_dtz timestamp COMMENT 'expired date for ont time password - if have',
	user_gid bigint NOT NULL,
	PRIMARY KEY (gid)
) COMMENT = 'Onetime password of user';


-- List all menu in system
CREATE TABLE md0003_menu
(
	gid bigint NOT NULL,
	-- join with code of table md0000_message
	menu_name varchar(200) COMMENT 'join with code of table md0000_message',
	-- 1 : active; 0 :inactive
	status varchar(1) DEFAULT '1' COMMENT '1 : active; 0 :inactive',
	-- 0 is not menu link, 1 is menu link, 2 is menu radio
	type varchar(2) DEFAULT '0' COMMENT '0 is not menu link, 1 is menu link, 2 is menu radio',
	-- format value: RPXXXXHXXXX sample RP1001H0101, actual value is MD1001/RP1001H01BL.do
	action_url varchar(200) COMMENT 'format value: RPXXXXHXXXX sample RP1001H0101, actual value is MD1001/RP1001H01BL.do',
	cat_gid bigint,
	module_gid bigint NOT NULL,
	-- order module name on screen by menu_type and module_type
	menu_index int DEFAULT 0 NOT NULL COMMENT 'order module name on screen by menu_type and module_type',
	-- 1 is menu don't need param
	is_need_param varchar(1) COMMENT '1 is menu don''t need param',
	PRIMARY KEY (gid)
) COMMENT = 'List all menu in system';


-- Define menu/permission relationship, for example, if user ha
CREATE TABLE md0003_menu_relation
(
	gid bigint NOT NULL,
	type varchar(2) NOT NULL,
	menu_gid bigint NOT NULL,
	menu_child_gid bigint NOT NULL,
	PRIMARY KEY (gid)
) COMMENT = 'Define menu/permission relationship, for example, if user ha';


-- Role informationo
CREATE TABLE md0006_role
(
	gid bigint NOT NULL,
	role_code varchar(50) NOT NULL,
	role_name varchar(100),
	-- 0 : inactive; 1 : active
	status varchar(1) DEFAULT '1' NOT NULL COMMENT '0 : inactive; 1 : active',
	role_index smallint DEFAULT 0 NOT NULL,
	PRIMARY KEY (gid),
	UNIQUE (role_code)
) COMMENT = 'Role informationo';


-- List child role of one role
CREATE TABLE md0006_role_child
(
	gid bigint NOT NULL,
	role_gid bigint NOT NULL,
	role_child_gid bigint NOT NULL,
	role_child_index int DEFAULT 0 NOT NULL,
	PRIMARY KEY (gid)
) COMMENT = 'List child role of one role';


-- Contain all notification in system
CREATE TABLE md8014_notification
(
	gid bigint NOT NULL,
	sentence varchar(2000),
	sent_datetimez timestamp,
	notification_source varchar(50),
	-- 0 : inactive; 1 : active
	status varchar(1) DEFAULT '1' NOT NULL COMMENT '0 : inactive; 1 : active',
	PRIMARY KEY (gid)
) COMMENT = 'Contain all notification in system';


-- Store user-role relationship
CREATE TABLE md9008_user_roles
(
	gid bigint NOT NULL,
	user_gid bigint NOT NULL,
	role_gid bigint NOT NULL,
	user_roles_index int DEFAULT 0 NOT NULL,
	PRIMARY KEY (gid)
) COMMENT = 'Store user-role relationship';


CREATE TABLE md9008_user_type_permissions
(
	gid bigint NOT NULL,
	-- Link to "type" field in table md0002_user
	user_type varchar(2) NOT NULL COMMENT 'Link to "type" field in table md0002_user',
	-- Wildcard for action URL
	menu_code varchar(200) COMMENT 'Wildcard for action URL',
	PRIMARY KEY (gid)
);


CREATE TABLE md9011_role_menu
(
	gid bigint NOT NULL,
	role_gid bigint NOT NULL,
	menu_gid bigint NOT NULL,
	role_menu_index int DEFAULT 0 NOT NULL,
	PRIMARY KEY (gid)
);



/* Create Foreign Keys */

ALTER TABLE md0003_menu
	ADD FOREIGN KEY (cat_gid)
	REFERENCES md0000_menu_category (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE md0002_user_otp
	ADD FOREIGN KEY (user_gid)
	REFERENCES md0002_user (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE md9008_user_roles
	ADD FOREIGN KEY (user_gid)
	REFERENCES md0002_user (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE md0003_menu_relation
	ADD FOREIGN KEY (menu_child_gid)
	REFERENCES md0003_menu (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE md0003_menu_relation
	ADD FOREIGN KEY (menu_gid)
	REFERENCES md0003_menu (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE md9011_role_menu
	ADD FOREIGN KEY (menu_gid)
	REFERENCES md0003_menu (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE md0006_role_child
	ADD FOREIGN KEY (role_gid)
	REFERENCES md0006_role (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE md0006_role_child
	ADD FOREIGN KEY (role_child_gid)
	REFERENCES md0006_role (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE md9008_user_roles
	ADD FOREIGN KEY (role_gid)
	REFERENCES md0006_role (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE md9011_role_menu
	ADD FOREIGN KEY (role_gid)
	REFERENCES md0006_role (gid)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;



