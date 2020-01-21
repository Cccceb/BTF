#插入司机数据 如果线路号和车队号不匹配，则返回影响行数为0。
#如果所属车辆与车队号不匹配，则返回0
DELIMITER $;
DROP PROCEDURE insert_siji $
CREATE  PROCEDURE 	insert_siji(IN xm VARCHAR(20),IN xb CHAR(2),IN c VARCHAR(20))
BEGIN 
	INSERT INTO siji (`sj_name`,`sex`,`che_id`,`cd_id`,`xl_id`)
	SELECT xm,xb,c,cd.cd_id,xl.xl_id
	FROM xianlu xl,che,chedui cd
	WHERE che.`che_id` = c AND che.`xl_id` = xl.xl_id AND xl.cd_id = cd.cd_id;
	
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
#委任车队队长 委任之后，可能改变司机所属车队
#已经是车队队长的不能委任
DROP PROCEDURE appoint_cddz$
CREATE  PROCEDURE 	appoint_cddz(IN id INTEGER,IN cd INTEGER)
BEGIN 
	UPDATE siji SET cd_id = (
	CASE 
	WHEN 
	(
		SELECT cd_id
		FROM (
			SELECT * FROM chedui WHERE cddz_id = id
		      ) mm 
	)IS NULL
	THEN cd
	ELSE cd_id
	END
	)WHERE sj_id = id;
	UPDATE chedui SET cddz_id = (
	CASE 
	WHEN 
	(
		SELECT cd_id
		FROM (
			SELECT * FROM chedui WHERE cddz_id = id
		      ) mm 
	)IS NULL
	THEN id 
	ELSE cddz_id
	END
	)WHERE cd_id = cd;

END $

#委任线路队长 将司机委任为所在线路的线路队长(因为线路队长还要开车所以加此限制)
#因为原来设定的是委任车队队长之后，会将线路置空，所以此处需要判定。
DROP PROCEDURE appoint_xldz$
CREATE  PROCEDURE 	appoint_xldz(IN id INTEGER)
BEGIN 
	UPDATE xianlu SET `xldz_id` = (
	CASE 
	WHEN (
		SELECT xl_id
		FROM siji
		WHERE sj_id =  id
	)IS NOT NULL
	THEN  id
	ELSE xldz_id
	END
	)WHERE xl_id = (
		SELECT xl_id
		FROM siji
		WHERE sj_id = id
	);
END $
#插入司机违章信息 保证违章时间不能超过当前时间
DROP PROCEDURE insert_weizhangjilu $
CREATE PROCEDURE insert_weizhangjilu(IN zd INTEGER ,IN t DATETIME,IN sj_id INTEGER,IN wz_id INTEGER)
BEGIN
	INSERT INTO weizhangjilu(`zd`,`TIME`,`sj_id`,`wz_id`)
	SELECT zd,t,sj_id,wz_id
	FROM DUAL
	WHERE t<=NOW();
END $
#查询某个车队下的司机信息，非车队队长，cddz_id为空，非线路队长,xldz_id 为空
DROP PROCEDURE query_siji_cd $
CREATE PROCEDURE query_siji_cd(IN cd_id INTEGER)
BEGIN
	SELECT t1.sj_id,t1.sj_name,t1.sex,t1.che_id,t1.cd_id,t1.cddz_id,t1.`xl_id`,xl.`xldz_id`
	FROM (
	SELECT sj.`sj_id`,sj.`sj_name`,sj.`sex`,sj.`che_id`,sj.`cd_id`,cddz_id,sj.`xl_id`
	FROM siji sj
	LEFT OUTER JOIN chedui cd
	ON cd.cddz_id = sj.`sj_id`
	WHERE sj.cd_id = cd_id
	) t1
	LEFT OUTER JOIN xianlu xl
	ON xl.`xldz_id` = t1.sj_id;
END $
#查询属于某条线路的司机信息
DROP PROCEDURE query_siji_xl $
CREATE PROCEDURE query_siji_xl(IN xl_id INTEGER)
BEGIN
	SELECT t1.sj_id,t1.sj_name,t1.sex,t1.che_id,t1.cd_id,t1.cddz_id,t1.`xl_id`,xl.`xldz_id`
	FROM (
	SELECT sj.`sj_id`,sj.`sj_name`,sj.`sex`,sj.`che_id`,sj.`cd_id`,cddz_id,sj.`xl_id`
	FROM siji sj
	LEFT OUTER JOIN chedui cd
	ON cd.cddz_id = sj.`sj_id`
	WHERE sj.xl_id = xl_id
	) t1
	LEFT OUTER JOIN xianlu xl
	ON xl.`xldz_id` = t1.sj_id;
	
END $
#查询全体司机信息
CREATE PROCEDURE siji_in_all()
BEGIN
	SELECT *
	FROM siji
	ORDER BY cd_id,xl_id,sj_id;
END $
#查询某名司机在某个时间段内的违章详细信息
DROP PROCEDURE siji_wz_time $
CREATE PROCEDURE siji_wz_time(IN id INTEGER,IN statime DATETIME,IN endtime DATETIME)
BEGIN 
	SELECT sj_name,`time`,zd,wz_name,che_id,xl_id,cd_id
	FROM siji,(
	SELECT zd,`time`,sj_id,wz_name
	FROM weizhangjilu wzjl, weizhangxinxi wzxx
	WHERE wzjl.wz_id = wzxx.wz_id AND sj_id = id AND wzjl.time BETWEEN statime AND endtime
	)mm
	WHERE siji.sj_id = mm.sj_id
	ORDER BY `time`;
	
	
END $
#查询某名司机的全部违章信息
DROP PROCEDURE siji_wz_all $
CREATE PROCEDURE siji_wz_all(IN sj_id INTEGER )
BEGIN 
	SELECT `time`,wz_name,sj_name,che_id,xl_id,cd_id
	FROM weizhangjilu wzjl,siji sj,weizhangxinxi wzxx
	WHERE sj.`sj_id` = wzjl.`sj_id` AND wzjl.`wz_id` = wzxx.wz_id 
	AND sj.sj_id = sj_id
	ORDER BY wzjl.time;
END $
#查询某个车队在某段时间内的违章统计信息
DROP PROCEDURE chedui_wz_time $
CREATE PROCEDURE chedui_wz_time(IN cd_id INTEGER,IN statime DATETIME,IN endtime DATETIME)
BEGIN
	SELECT wz_name,num
	FROM (
	SELECT wz_id,COUNT(*) num
	FROM weizhangjilu wzjl,siji sj
	WHERE wzjl.sj_id = sj.sj_id
	AND sj.cd_id  = cd_id
	AND wzjl.time BETWEEN statime AND endtime
	GROUP BY wz_id
	) mm,weizhangxinxi wzxx
	WHERE mm.wz_id = wzxx.wz_id;
	
END $
#根据司机编号查询司机基本信息
DROP PROCEDURE query_siji $
CREATE PROCEDURE query_siji(IN sj_id INTEGER)
BEGIN
	SELECT sj_id,sj_name,sex,che_id,sj.`cd_id`,xl_name,xldz_id
	FROM (siji sj
	LEFT OUTER JOIN chedui cd
	ON cd.`cd_id` = sj.`cd_id`)
	LEFT JOIN xianlu xl
	ON sj.`xl_id` = xl.`xl_id`
	WHERE sj.sj_id = sj_id;
END $
#根据输入的司机编号得到他所在车队下的线路名，和队长名
DROP PROCEDURE xldz_cd_xl $
CREATE PROCEDURE xldz_cd_xl(IN sj_id INTEGER)
BEGIN
	SELECT xl.xl_id,xl_name,sj_name
	FROM xianlu xl
	LEFT JOIN siji sj
	ON xl.xldz_id = sj.sj_id 
	WHERE  xl.cd_id = (
	SELECT cd_id
	FROM siji sj
	WHERE sj.sj_id = sj_id
	);
	
END $
#录入司机封面的显示 输入司机编号，输出基本信息，包括司机编号，司机姓名，司机性别，驾驶车辆，线路队长姓名，车队队长姓名
DROP PROCEDURE apperence_siji $
CREATE PROCEDURE apperence_siji()
BEGIN 
	SELECT nm.`sj_id`,nm.`sj_name`,nm.`che_id`,nm.`cd_id`,nm.`xl_id`,sj1.`sj_name` 'xldz',sj2.`sj_name` 'cddz'
	FROM siji sj1
	RIGHT OUTER JOIN 
		(
			SELECT ssj.`sj_id`,ssj.`sj_name`,ssj.`che_id`,ssj.`cd_id`,ssj.`xl_id`,xl.`xldz_id`,cd.`cddz_id`
			FROM (
				SELECT sj.`sj_id`,sj.`sj_name`,sj.`che_id`,sj.`cd_id`,sj.`xl_id`
				FROM siji sj
				WHERE sj.`sj_id` = (SELECT MAX(sj_id) FROM siji)
				)ssj,chedui cd,xianlu xl
			WHERE ssj.xl_id = xl.`xl_id` AND ssj.cd_id = cd.`cd_id`
		)nm
	ON sj1.`sj_id` = nm.xldz_id
	LEFT OUTER JOIN siji sj2 ON  sj2.`sj_id` = nm.cddz_id ;
END $
#查询某个车队下的线路信息
CREATE PROCEDURE query_xl_cd(IN cd_id INTEGER)
BEGIN
	SELECT xl.xl_id,xl_name,sj_name 
	FROM xianlu xl
	LEFT OUTER JOIN siji sj 
	ON xl.xldz_id = sj.sj_id WHERE xl.cd_id = cd_id;
END $
#查询全部线路信息
DROP PROCEDURE query_Xianlu $
CREATE PROCEDURE query_Xianlu()
BEGIN
	SELECT xl.xl_id,xl_name,sj_name
	FROM xianlu xl 
	LEFT OUTER JOIN siji sj 
	ON xl.xldz_id = sj.sj_id;
END $
#查询全部车队信息
CREATE PROCEDURE query_Chedui()
BEGIN
	SELECT cd.cd_id,sj_name,sj.sj_id 
	FROM chedui cd LEFT OUTER JOIN siji sj 
	ON sj.`sj_id` = cd.cddz_id ORDER BY cd.cd_id;
END $