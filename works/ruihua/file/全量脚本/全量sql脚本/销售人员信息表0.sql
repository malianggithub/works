SELECT
	'' LSH,
	'' BXJGDM,
	'' BXJGMC,
	a.agentcode XSRYDM,
	a.managecom SSFZJGDM,
	a.name XSRYXM,
    a.degree XL,
	a.idnotype ZJLX,
	a.idno ZJHM,
	a.mobile LXDH,
	a.agentKind SSQDXX,
	ifnull(b.qualifno,'未记录')  ZYZSH, -- 执业证书号,
--  DATE_FORMAT(b.GrantDate,'%Y-%m-%d') ZYZFFRQ,
  ifnull(DATE_FORMAT(b.ValidStart,'%Y-%m-%d'),'2999-12-31') ZYZFFRQ,
--  DATE_FORMAT(b.InvalidDate,'%Y-%m-%d') ZYZZXDQRQ,
  ifnull(DATE_FORMAT(b.ValidEnd,'%Y-%m-%d'),'2999-12-31') ZYZZXDQRQ,
  ifnull(DATE_FORMAT(a.EmployDate,'%Y-%m-%d'),'2999-12-31') QYRQ,
 -- (case when a.OutWorkDate is null then '9999-12-31' else DATE_FORMAT(a.OutWorkDate,'%Y-%m-%d') end) JYRQ,
   ifnull((case when c.DepartState in ('03','04','05','09')  then to_char(c.applydate,'yyyy-mm-dd') else '9999-12-31' end),'9999-12-31') JYRQ,
  (select lp.branchmanager from labranchgroup lp where lp.agentgroup=a.agentgroup) SJXSRYDM,
  '' WGWJJL,
  '' GWRZXX,
  (select ldb.BankName from ldbank ldb where ldb.bankcode = ldb.headbankcode and ldb.bankcode=a.bankcode) KHYXMC,
  a.bankaccno YXZH,
  a.name YXZHMC,
  DATE_FORMAT(a.makedate,'%Y-%m-%d') XSRYXXCJSJ,
  DATE_FORMAT(a.modifydate,'%Y-%m-%d') XSRYXXGXSJ,
  DATE_FORMAT(b.modifydate,'%Y-%m-%d') ZYZGZXXGXSJ,
'${data_date}' DIS_DATA_DATE
from laagent a LEFT JOIN LADimission c ON a.agentcode = c.agentcode and (
		c.DepartTimes = (
		SELECT
			e.DepartTimes 
		FROM
			LADimission e 
		WHERE
			e.AGENTCODE = a.AGENTCODE 
		AND e.DepartTimes = ( SELECT MAX( d.DepartTimes ) FROM LADimission d WHERE d.AGENTCODE = a.AGENTCODE )) 
		OR c.DepartTimes IS NULL 
 ) left join LAQualification b on a.agentcode=b.agentcode and b.idx='2' where a.agentState in ('01','03','04') order by a.agentcode asc