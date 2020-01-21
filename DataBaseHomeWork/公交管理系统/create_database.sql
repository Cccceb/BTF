DROP DATABASE test3;
CREATE DATABASE TEST3 CHARACTER SET utf8 COLLATE utf8_general_ci;
USE TEST3;
#Mysql中没有 check 所以添加外键约束
CREATE TABLE nannv
(
	sex CHAR(2) PRIMARY KEY
);
INSERT INTO nannv VALUES("男"),("女");
CREATE TABLE che
(
	che_id               VARCHAR(20) NOT NULL,
	zw                   INTEGER NULL,
	xl_id                INTEGER NULL
);



ALTER TABLE che
ADD PRIMARY KEY (che_id);



CREATE TABLE chedui
(
	cd_id                INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
	cddz_id              INTEGER NULL
);





CREATE TABLE siji
(
	sj_id                INTEGER PRIMARY KEY AUTO_INCREMENT,
	sj_name              VARCHAR(20) NOT NULL,
	sex                  CHAR(2)  NOT NULL ,
	che_id               VARCHAR(20) NULL
);

CREATE TABLE weizhangjilu
(
	zd                   INTEGER NULL,
	TIME                 DATETIME  NULL,
	sj_id                INTEGER NULL,
	wz_id                INTEGER NULL,
	che_id               VARCHAR(20) NOT NULL,
	PRIMARY KEY (sj_id,TIME,wz_id)
);




CREATE TABLE weizhangxinxi
(
	wz_id                INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
	wz_name              VARCHAR(20) NULL
);




CREATE TABLE xianlu
(
	xl_id                INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
	xl_name              VARCHAR(20) UNIQUE NULL,
	cd_id                INTEGER NULL,
	xldz_id              INTEGER NULL
);



ALTER TABLE che
ADD FOREIGN KEY R_13 (xl_id) REFERENCES xianlu (xl_id) ON DELETE CASCADE;



ALTER TABLE chedui
ADD FOREIGN KEY R_52 (cddz_id) REFERENCES siji (sj_id)ON DELETE CASCADE;



ALTER TABLE siji
ADD FOREIGN KEY R_16 (che_id) REFERENCES che (che_id)ON DELETE CASCADE;

ALTER TABLE siji
ADD FOREIGN KEY fk_sex(sex) REFERENCES	nannv(sex)ON DELETE CASCADE;





ALTER TABLE weizhangjilu
ADD FOREIGN KEY R_35 (sj_id) REFERENCES siji (sj_id)ON DELETE CASCADE;



ALTER TABLE weizhangjilu
ADD FOREIGN KEY R_50 (wz_id) REFERENCES weizhangxinxi (wz_id)ON DELETE CASCADE;


ALTER TABLE weizhangjilu
ADD FOREIGN KEY R_57 (che_id) REFERENCES che (che_id)ON DELETE CASCADE;


ALTER TABLE xianlu
ADD FOREIGN KEY R_11 (cd_id) REFERENCES chedui (cd_id)ON DELETE CASCADE;



ALTER TABLE xianlu
ADD FOREIGN KEY R_51 (xldz_id) REFERENCES siji (sj_id)ON DELETE CASCADE;


