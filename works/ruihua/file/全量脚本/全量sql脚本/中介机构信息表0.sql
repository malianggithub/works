(SELECT
	'${data_date}' DIS_DATA_DATE,
	'' LSH,
	'' BXJGDM,
	'' BXJGMC,
	a.agentcom ZJJGDM,
	a.managecom SSFZJGDM,
	a.name ZJJGMC,
	a.address ZJJGDZ,
	(CASE a.actype
WHEN '66' THEN
	'410-银行类金融代理机构'
ELSE
	a.actype end) ZJJGLB,
	'' ZJJGTYBM,
	'1-统一社会信用代码' ZJJGZJLX,
	'' ZJJGZJHM,
	DATE_FORMAT(a.LicenseStartDate ,'%Y-%m-%d') HDZJXKZRQ,
	DATE_FORMAT(a.LicenseEndDate,'%Y-%m-%d') ZJXKZDQR,
	DATE_FORMAT(a.FoundDate,'%Y-%m-%d') QYRQ,
	DATE_FORMAT(a.EndDate,'%Y-%m-%d') XYDQRHJYR,
	a.licenseno ZJYWXKZH,
	'' ZJYWXKZMC,
	'' YWFW,
	(select concat(b.code, '-', b.codename) from ldcode b where b.codetype = 'nativeplacebak' and b.code = a.AreaType) JYQY,
	'' FZRXM,
	'' WFWGJL
FROM
	lacom a
ORDER BY
	a.agentcom ASC)

