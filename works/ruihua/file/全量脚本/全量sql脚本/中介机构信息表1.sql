


(SELECT
	'${data_date}' DIS_DATA_DATE,
	'' LSH,
	'' BXJGDM,
	'' BXJGMC,
	a.agentcom ZJJGDM,
	a.managecom SSFZJGDM,
	a. NAME ZJJGMC,
	a.address ZJJGDZ,
	(CASE a.actype
WHEN '0' THEN
	'0-保险经纪'
WHEN '1' THEN
	'1-专业代理'
WHEN '2' THEN
	'2-兼业代理'
ELSE
	a.actype end) ZJJGLB,
	-- a.agentunioncode ZJJGTYBM,
	'未记录' ZJJGTYBM,
	'1-统一社会信用代码' ZJJGZJLX,
	a.appagentcom ZJJGZJHM,
	DATE_FORMAT(a.licensestartdate,'%Y-%m-%d') HDZJXKZRQ,
	DATE_FORMAT(a.licenseenddate,'%Y-%m-%d') ZJXKZDQR,
	DATE_FORMAT(a.begaindate,'%Y-%m-%d') QYRQ,
	DATE_FORMAT(a.endoutdate,'%Y-%m-%d') XYDQRHJYR,
	a.licenseno ZJYWXKZH,
	-- a.licensename ZJYWXKZMC,
	'未记录' ZJYWXKZMC,
	'' YWFW,
	e.openArea JYQY,
	linkman FZRXM,
	'' WFWGJL
FROM
	lagrpcom a
LEFT JOIN (
	SELECT
		agentCom,
		GROUP_CONCAT(
			CONCAT(ManageCom, '-', codeName) SEPARATOR '|'
		) openArea
	FROM
		lagrpcomtocom a
	LEFT JOIN ldcode b ON a.manageCom = b. CODE
	AND b.codetype = 'nativeplacecom'
	GROUP BY
		agentCom
) e ON a.agentcom = e.agentcom
ORDER BY
	a.agentcom ASC)