#sj_xl_cd的基础：将车表，线路表，车队表组合
CREATE OR REPLACE VIEW che_xl_cd
AS 
	SELECT che.`che_id`,xl.xl_id,cd.cd_id,xl.xldz_id,cd.cddz_id
	FROM che,xianlu xl,chedui cd
	WHERE che.`xl_id` = xl.xl_id  
	AND xl.cd_id = cd.cd_id
$
#用于联合查询
CREATE OR REPLACE VIEW cddz_cd
AS 
	SELECT sj.sj_id,sj.sex,sj.sj_name,sj.`che_id`,NULL xl_id,NULL xldz_id,cd.cddz_id,cd.cd_id
	FROM siji sj
	LEFT OUTER JOIN chedui cd
	ON cd.cddz_id = sj_id
	WHERE sj.che_id IS NULL
$
#所有司机的详细信息并包括车队队长编号，线路队长编号
CREATE OR REPLACE VIEW sj_xl_cd
AS 
	SELECT sj.sj_id,sj.sex,sj.sj_name,t1.`che_id`,t1.xl_id,cd_id,t1.xldz_id,cddz_id
	FROM siji sj,che_xl_cd t1
	WHERE sj.che_id = t1.che_id
	UNION
	SELECT sj_id,sex,sj_name,che_id,xl_id,cd_id,xldz_id,cddz_id
	FROM cddz_cd
	ORDER BY sj_id
$
#包含所有前任车队队长的视图
CREATE OR REPLACE VIEW precddz
AS 
	SELECT *
	FROM sj_xl_cd
	WHERE cd_id IS NULL
$

#所有司机的详细信息并包括车队队长姓名和线路队长姓名
CREATE OR REPLACE VIEW sj_xldz_cddz(sj_id,sj_name,che_id,xl_id,cd_id,cddz,xldz)
AS 
	SELECT ssj.sj_id,ssj.sj_name,ssj.che_id,ssj.xl_id,ssj.cd_id,sj1.sj_name,sj2.sj_name
	FROM sj_xl_cd ssj
	LEFT OUTER JOIN siji sj1
	ON sj1.sj_id = ssj.cddz_id
	LEFT OUTER JOIN siji sj2
	ON sj2.sj_id = ssj.xldz_id
$
#查询某条违章记录对应的车队线路
CREATE OR REPLACE VIEW wzjl_xl_cd
AS 
	SELECT wz_name,sj_id,che.che_id,xl.xl_id,xl.cd_id,wzjl.TIME,wzjl.zd
	FROM weizhangjilu wzjl,che,xianlu xl,weizhangxinxi wzxx
	WHERE wzjl.wz_id = wzxx.wz_id
	AND wzjl.che_id = che.`che_id`
	AND che.`xl_id` = xl.xl_id
	
$
