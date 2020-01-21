#插入司机数据
DROP PROCEDURE insert_siji $
CREATE  PROCEDURE 	insert_siji(IN xm VARCHAR(20),IN xb CHAR(2),IN c VARCHAR(20))
BEGIN 
	INSERT INTO siji (`sj_name`,`sex`,`che_id`)
	VALUES (xm,xb,c);
END $
#插入车表数据	
DROP PROCEDURE insert_che $
CREATE PROCEDURE insert_che(IN che_id VARCHAR(20),IN zw INT,IN xl_id INT )
BEGIN
	INSERT INTO che (che_id,zw,xl_id) VALUES 
	(che_id,zw,xl_id);
END $
#插入线路表 线路不重名，则返回0  线路名不是主键   不同车队的线路名能否重复？
DROP PROCEDURE insert_xianlu $
CREATE PROCEDURE insert_xianlu(IN xl_name VARCHAR(20),IN cd_id INTEGER)
BEGIN
	INSERT INTO xianlu (`xl_name`,`cd_id`)
	SELECT xl_name,cd_id
	FROM DUAL
	WHERE NOT EXISTS(
	SELECT *
	FROM xianlu xl
	WHERE xl_name = xl.xl_name
	);
END $
# 委任车队队长 
# 委任之后，可能改变司机所属车队
# 第一个update保证一个人只能在一个车队
DROP PROCEDURE appoint_cddz$
CREATE  PROCEDURE 	appoint_cddz(IN id INTEGER,IN cd INTEGER)
BEGIN 
	UPDATE chedui SET cddz_id = 
	(
	CASE 
	WHEN (
		SELECT sj_id
		FROM sj_xl_cd sj
		WHERE sj_id = id
		AND cddz_id = sj_id
	     )
	IS NOT NULL
	THEN NULL
	ELSE cddz_id
	END
	)WHERE cd_id =  (
		SELECT cd_id
		FROM sj_xl_cd sj
		WHERE sj_id = id
	);
	
	UPDATE chedui SET cddz_id = id
	WHERE cd_id = cd;
	UPDATE siji SET che_id = NULL
	WHERE sj_id = id;
END $

#委任线路队长 将司机委任为所在线路的线路队长(因为线路队长还要开车所以加此限制)
DROP PROCEDURE appoint_xldz $
CREATE  PROCEDURE 	appoint_xldz(IN id INTEGER)
BEGIN 
	UPDATE xianlu SET `xldz_id` = (
	CASE 
	WHEN (
	SELECT xl_id 
	FROM (
		SELECT xl_id
		FROM sj_xl_cd
		WHERE sj_id =  id
	)t1		
	)IS NOT NULL
	THEN  id
	ELSE xldz_id
	END
	)WHERE xl_id = (
	SELECT xl_id
	FROM(
		SELECT xl_id
		FROM sj_xl_cd
		WHERE sj_id = id
	)t2
	);
END $
#插入司机违章信息 保证违章时间不能超过当前时间
#限制司机和车是同一个线路下的。
DROP PROCEDURE insert_weizhangjilu $
CREATE PROCEDURE insert_weizhangjilu(IN zd INTEGER ,IN t DATETIME,IN sj_id INTEGER,IN wz_id INTEGER,IN che VARCHAR(20))
BEGIN
	INSERT INTO weizhangjilu(`zd`,`TIME`,`sj_id`,`wz_id`,`che_id`)
	SELECT zd,t,sj_id,wz_id,che
	FROM DUAL
	WHERE EXISTS (
	SELECT *
	FROM che_xl_cd c
	WHERE c.che_id  = che
	AND c.xl_id = (
		SELECT xl_id 
		FROM sj_xl_cd sj
		WHERE sj.sj_id = sj_id
		)
	)
	AND NOT EXISTS(
	SELECT *
	FROM sj_xl_cd sj
	WHERE sj.sj_id=sj_id
	AND sj.sj_id = sj.cddz_id
	)
	AND  t<=NOW();
END $
#4参数插入司机违章信息，车辆为当前所驾驶的车辆 4参数录入
DROP PROCEDURE insert_weizhangjilu4 $
CREATE PROCEDURE insert_weizhangjilu4(IN zd INTEGER,IN t DATETIME,IN sj_id INTEGER,IN wz_id INTEGER)
BEGIN
	INSERT INTO weizhangjilu(`zd`,`TIME`,`sj_id`,`wz_id`,`che_id`) 
	
	SELECT zd,t,sj_id,wz_id,che_id
	FROM siji sj
	WHERE sj.sj_id = sj_id
	AND NOT EXISTS(
	SELECT *
	FROM sj_xl_cd sj
	WHERE sj.sj_id=sj_id
	AND sj.sj_id = sj.cddz_id
	)
	;
END $
#查询某个车队下的司机信息，非车队队长，cddz_id为空，非线路队长,xldz_id 为空
DROP PROCEDURE query_siji_cd $
CREATE PROCEDURE query_siji_cd(IN cd_id INTEGER)
BEGIN
	SELECT *
	FROM sj_xl_cd sj
	WHERE sj.cd_id = cd_id
	ORDER BY che_id;
END $
#查询属于某条线路的司机信息
DROP PROCEDURE query_siji_xl $
CREATE PROCEDURE query_siji_xl(IN xl_id INTEGER)
BEGIN
	SELECT *
	FROM sj_xl_cd sj
	WHERE sj.xl_id = xl_id;
	
END $
#查询全体司机信息
CREATE PROCEDURE siji_in_all()
BEGIN
	SELECT *
	FROM sj_xl_cd
	ORDER BY cd_id,xl_id,sj_id;
END $
#查询某名司机在某个时间段内的违章详细信息
DROP PROCEDURE siji_wz_time $
CREATE PROCEDURE siji_wz_time(IN id INTEGER,IN statime DATETIME,IN endtime DATETIME)
BEGIN 
	SELECT sj.sj_name,`time`,zd,wz_name,wzjl.cd_id,wzjl.che_id,wzjl.xl_id
	FROM sj_xl_cd sj,wzjl_xl_cd wzjl
	WHERE sj.sj_id = wzjl.sj_id
	AND sj.sj_id = id
	AND statime <= wzjl.time <= endtime;
END $
#查询某名司机的全部违章信息
DROP PROCEDURE siji_wz_all $
CREATE PROCEDURE siji_wz_all(IN sj_id INTEGER )
BEGIN 
	SELECT `time`,wz_name,sj_name,wzjl.che_id,sj.xl_id,sj.cd_id
	FROM weizhangjilu wzjl,sj_xl_cd sj,weizhangxinxi wzxx
	WHERE sj.`sj_id` = wzjl.`sj_id` 
	AND wzjl.`wz_id` = wzxx.wz_id 
	AND wzjl.sj_id = sj_id
	ORDER BY wzjl.time;
END $
#查询某个车队在某段时间内的违章统计信息
DROP PROCEDURE chedui_wz_time $
CREATE PROCEDURE chedui_wz_time(IN cd_id INTEGER,IN statime DATETIME,IN endtime DATETIME)
BEGIN
	SELECT wz_name,COUNT(*) num
	FROM wzjl_xl_cd wzjl
	WHERE wzjl.cd_id = cd_id
	AND statime <= wzjl.time <= endtime
	GROUP BY wz_name,wz_id;
	
END $
#根据司机编号查询司机基本信息
DROP PROCEDURE query_siji $
CREATE PROCEDURE query_siji(IN sj_id INTEGER)
BEGIN
	SELECT sj.sj_id,sj_name,sex,che_id,sj.`cd_id`,xl_name,sj.xldz_id,sj.xl_id,sj.cddz_id
	FROM sj_xl_cd sj
	WHERE sj.sj_id = sj_id;
END $
#根据输入的司机编号得到他所在车队下的线路名，和队长名
DROP PROCEDURE xldz_cd_xl $
CREATE PROCEDURE xldz_cd_xl(IN sj_id INTEGER)
BEGIN
	SELECT t1.cd_id,t1.xl_id,t1.xldz_id,t1.xl_name,sj2.sj_name
	FROM 
	(
		SELECT sj1.cd_id,xl.xl_id,xl.xldz_id,xl.xl_name
		FROM sj_xl_cd sj1,xianlu xl
		WHERE sj1.cd_id = xl.cd_id
		AND sj1.sj_id = sj_id
	)t1
	LEFT OUTER JOIN sj_xl_cd sj2 
	ON t1.xldz_id = sj2.sj_id;
END $
#录入司机封面的显示 输入司机编号，输出基本信息，包括司机编号，司机姓名，司机性别，驾驶车辆，线路队长姓名，车队队长姓名
##已经废弃
DROP PROCEDURE apperence_siji $
CREATE PROCEDURE apperence_siji()
BEGIN 
	SELECT nm.`sj_id`,nm.`sj_name`,nm.`che_id`,nm.`cd_id`,nm.`xl_id`,sj1.`sj_name` 'xldz',sj2.`sj_name` 'cddz'
	FROM siji sj1
	RIGHT OUTER JOIN 
	(
		SELECT xldz_id
		FROM xianlu xl,last_sj_cd ssj
		WHERE xl.xl_id = ssj.xl_id
	)nm
	ON sj1.`sj_id` = nm.xldz_id
	LEFT OUTER JOIN siji sj2 ON  sj2.`sj_id` = nm.cddz_id ;
END $
#查询某个车队下的线路信息
CREATE PROCEDURE query_xl_cd(IN cd_id INTEGER)
BEGIN
	SELECT xl.xl_id,xl_name,sj_name 
	FROM xianlu xl
	LEFT OUTER JOIN sj_xl_cd sj 
	ON xl.xldz_id = sj.sj_id WHERE xl.cd_id = cd_id;
END $
#查询全部线路信息
DROP PROCEDURE query_Xianlu $
CREATE PROCEDURE query_Xianlu()
BEGIN
	SELECT xl.xl_id,xl_name,sj_name
	FROM xianlu xl 
	LEFT OUTER JOIN sj_xl_cd sj 
	ON xl.xldz_id = sj.sj_id;
END $
#查询全部车队信息
CREATE PROCEDURE query_Chedui()
BEGIN
	SELECT cd.cd_id,sj_name,sj.sj_id 
	FROM chedui cd LEFT OUTER JOIN siji sj 
	ON sj.`sj_id` = cd.cddz_id ORDER BY cd.cd_id;
END $
#查询某个线路下车辆信息，司机信息
DROP PROCEDURE query_che_xl $
CREATE PROCEDURE query_che_xl(IN xl_id INTEGER)
BEGIN 
	SELECT * FROM che WHERE che.xl_id = xl_id;
END $
#更新司机的车辆
DROP PROCEDURE update_che $
CREATE PROCEDURE update_che(IN sj_id INTEGER,IN che_id VARCHAR(20))
BEGIN 
	UPDATE siji sj SET sj.che_id =
	(
	CASE 
	WHEN (
		SELECT sj.sj_id
		FROM sj_xl_cd sj
		WHERE sj.cddz_id != sj.sj_id 
		AND sj.sj_id = sj_id
	)IS NULL
	THEN  NULL
	ELSE che_id
	END
	)WHERE sj.sj_id = sj_id;
END $




