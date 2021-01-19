SELECT
DISTINCT  c.ClmNo AS PAH,
-- 赔案号
c.RgtNo AS LAH,
-- 立案号
(SELECT llregister.rgtobjno FROM llregister WHERE  llregister.rgtno= c.RgtNo and llregister.rgtobj = '1') AS BAH,
-- 报案号
(CASE c.grpcontno WHEN 00000000000000000000  THEN '' ELSE c.grpcontno END ) AS TTBDH,
-- 团体保单号
(CASE c.grpcontno WHEN 00000000000000000000  THEN '个人' ELSE '团体' END ) AS BDTGXZ,-- 20201202 (CASE c.grpcontno WHEN 00000000000000000000  THEN '个体' ELSE '团体' END )
-- 保单团个性质
c.Contno AS GRBDH,
-- 个人保单号
c.polno AS GDBXXZHM,
-- 个单保险险种号码
(SELECT llreport.RptDate FROM llreport WHERE llreport.RptNo in(
SELECT llregister.rgtobjno from llregister where llregister.rgtno = c.RgtNo)) AS BARQ,
-- 报案日期
(SELECT llregister.RgtDate FROM llregister WHERE  llregister.rgtno= c.ClmNo) AS LARQ,
-- 立案日期
/* 20201231 SELECT llregister.AccidentDate FROM llregister WHERE  llregister.rgtno= c.ClmNo) AS CXRQ, */
(select accdate from llaccident where accno in (select caserelano from llcaserela where caseno = c.ClmNo) limit 1 )  AS CXRQ,
-- 出险日期
 (SELECT llregister.AccidentReason FROM llregister WHERE  llregister.rgtno= c.ClmNo)  AS CXYYFL,

/*-- 20201202 (SELECT ldcode.codename FROM ldcode WHERE ldcode.codetype = 'lloccurreason' and ldcode.code in(
SELECT llregister.AccidentReason FROM llregister WHERE  llregister.rgtno= c.ClmNo)) AS CXYYFL,*/
-- 出险原因分类
c.GetDutyKind AS PFZRLX,
-- 20201207(GROUP_CONCAT(DISTINCT(select a.codename from ldcode a where a.codetype = 'llclaimtype' and trim(a.code)=trim(c.GetDutyKind)))) AS PFZRLX,
-- 赔付责任类型
c.riskcode AS CPBM,
-- 产品编码
(case c.currency when 01 then 'CNY' ELSE '' end) AS HBDM,
-- 货币代码
(SELECT llclaim.realpay FROM llclaim WHERE LLClaim.ClmNo = c.ClmNo) AS HSPFJE,
-- 核算赔付金额
(SELECT llclaim.endcasedate FROM llclaim WHERE LLClaim.ClmNo = c.ClmNo) AS JARQ,
-- 结案日期
(SELECT LLClaimUWMain.AuditConclusion FROM LLClaimUWMain WHERE LLClaimUWMain.ClmNo = c.ClmNo) AS LPJL,
/*-- 20201202 (SELECT ldcode.codename FROM ldcode WHERE codetype = 'llclaimconclusion' and code in
	(SELECT LLClaimUWMain.AuditConclusion FROM LLClaimUWMain WHERE LLClaimUWMain.ClmNo = c.ClmNo)) AS LPJL,*/
	-- 理赔结论
(select  llc.examcom from LLclaimuwmain llc where llc.clmno = c.clmno) AS HPJGDM,-- 20201207'000235' AS HPJGDM,
-- 核赔机构代码
(select  llc.examcom from LLclaimuwmain llc where llc.clmno = c.clmno) AS HPJGMC,-- 20201207'瑞华健康保险股份有限公司' AS HPJGMC,
-- 核赔机构名称
(SELECT llclaim.realpay FROM llclaim WHERE LLClaim.ClmNo = c.ClmNo) AS PFJE,
'${data_date}' DIS_DATA_DATE
FROM
LLClaimPolicy c
WHERE
(SELECT llregister.endcasedate FROM llregister WHERE  llregister.rgtno= c.ClmNo)>='2017-01-01'
and (SELECT llregister.endcasedate FROM llregister WHERE  llregister.rgtno= c.ClmNo)<='2020-12-31'
and c.clmno in(select clmno from llclaim where clmstate ='50')
GROUP BY c.clmno,c.Contno,c.polno,GetDutyKind
