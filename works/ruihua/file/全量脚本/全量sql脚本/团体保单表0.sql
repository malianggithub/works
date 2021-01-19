-- 只有团险
select a.grpcontno AS TTBDH,
-- 团体保单号
a.prtno AS TTBDTBDHM,
-- 团体保单投保单号码
(case when a.CardFlag is not null and a.cardflag='1' then '是' else '否' end) AS KDBZ,
-- 卡单标志,
(case when EXISTS (select  1 from lcinsured where  insuredtype='1' and grpcontno=a.grpcontno LIMIT 1) then '是' else '否' end ) AS 	WMDBZ,
-- 无名单标志,
'法人' as JTDBZ,
-- 家庭单标志
managecom AS GLJGDM,
-- 管理机构代码,
a.managecom  AS GLJGMC,
-- 管理机构名称
managecom AS JGXQDM,
-- 监管辖区代码,
managecom AS CBDQ,
-- 承保地区,
(CASE WHEN a.salechnl='11' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '3' THEN '122'  WHEN '4' THEN '272' END)
     WHEN a.salechnl='33' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '2' THEN '230' END) 
     WHEN a.salechnl='09' THEN (CASE (SELECT agentkind FROM laagent  WHERE AGENTCODE = a.AGENTCODE) WHEN '1' THEN '111' when '2' then '210' ELSE NULL END) ELSE a.salechnl END) AS XSQD,
-- salechnl AS XSQD,
-- 销售渠道
(select agentcom from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGBM,
-- 代理机构编码,
(select agentcomname from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGMC,
-- 代理机构名称,
(select customerno from lcgrpappnt where grpcontno=a.grpcontno limit 1) AS TBRKHBH,
-- 投保人客户编号
(select paytype from   LCCustomerAccount where policyno=a.grpcontno LIMIT 1) AS JFFS,
-- 交费方式
signdate AS QDRQ,
-- 签单日期,
a.peoples AS TBZRS,
-- 投保总人数
'CNY' AS HBDM,
-- 货币代码
(case when  payintv='0' then prem else (select sum(sumactupaymoney) paymoney from ljapayperson where grpcontno=a.grpcontno and enteraccdate is not null  GROUP BY grpcontno,paycount ORDER BY paycount desc  limit 1)   end) AS BF,
-- 保费
amnt AS BE,
-- 保额
ifnull((select sum(sumactupaymoney) from ljapayperson where grpcontno=a.grpcontno  and enteraccdate is not null),0) + ifnull((select sum(getmoney) from lpedoritem where grpcontno=a.grpcontno and getmoney>0),0) AS LJBF,
-- 累计保费
firstpaydate AS SQJFRQ,
-- 首期交费日期
cvalidate AS BDSXRQ,
-- 保单生效日期
 case when (select 1 from lcguwtrace where grpcontno=a.grpcontno LIMIT 1) is not null then '人工核保' else '自动核保' end AS HBLX,
-- 	核保类型
a.polapplydate AS TBDSQRQ,
-- 投保单申请日期
(case when a.CustomGetPolDate is not null then '是' else '否' end ) AS BDHZQSBZ,
-- 保单回执签收标志
a.CustomGetPolDate AS BDHZKHQSRQ,
-- 保单回执客户签收日期
a.appflag AS BDZT,
-- 保单状态
'纸质保单' as BDXS,
-- 保单形式
DATE_SUB(enddate,INTERVAL 1 day) AS BDMQRQ,
-- 保单满期日期
 (case when  state in ('40','30') then DATE_SUB(enddate,INTERVAL 1 day)  else '' end ) AS BDZZRQ1,
-- 保单终止日期
'' as BDZZRQ2,
-- 保单中止日期
'' as BDXLHFRQ,
-- 保单效力恢复日期
(case when state='30' then '满期终止'  when state='40' then '退保'  when state='02' then '拒保终止' when state='01' then '当日撤单' else '' end) AS BDZZYY,
-- 保单终止原因
(case when EXISTS(select  1 from lccont where  grpcontno=a.grpcontno and InterBusinessType is not null LIMIT 1) then '是' else '否' end ) as HLWBXYWBZ,
-- 互联网保险业务标志
'否' as FZCTBBZ,
-- 非正常退保标志
'否' as FZCGFBZ,
-- 非正常给付标志
'否' as JBYWBZ,
-- 经办业务标志
'' as JBGLF,
-- 经办管理费
'否' as YBGRZHGMBZ,
/*from lcgrpcont a
left join (select m.agentcom,m.AngencyType,m.name,f.policyno from lacom m,lcagentcominfo f where m.agentcom=f.agentcom )com  on com.policyno=a.grpcontno
 where a.state<>'02' 
 and not EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and edortype='SA' and edorstate='0')
and 
 ((a.CValiDate > '2016-12-31' AND a.CValiDate < '2021-01-01')
      OR (a.CValiDate < '2017-01-01' AND a.APPFLAG='1')
      OR (EXISTS(SELECT 1 FROM LLCase a,LLRegister b,LLClaimDetail c
                 WHERE a.CaseNo = b.RgtNo AND a.CaseNo = c.ClmNo AND c.grpcontno = a.grpcontno
                   AND b.RgtDate > '2016-12-31'
                   AND a.EndCaseDate < '2021-01-01')))
AND a.MakeDate < '2021-01-01'
and a.signdate is not null
*/-- 20201229 gulaoshi 生效日期改成签单日期
'${data_date}' DIS_DATA_DATE
from lcgrpcont a
left join (select m.agentcom,m.AngencyType,m.name,f.policyno from lacom m,lcagentcominfo f where m.agentcom=f.agentcom )com  on com.policyno=a.grpcontno
 where a.state<>'02' 
 and not EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and edortype='SA' and edorstate='0')
and 
 ((a.signdate > '2016-12-31' AND a.signdate < '2021-01-01')
      OR (a.signdate < '2017-01-01' AND a.APPFLAG='1')
      OR (EXISTS(SELECT 1 FROM LLCase a,LLRegister b,LLClaimDetail c
                 WHERE a.CaseNo = b.RgtNo AND a.CaseNo = c.ClmNo AND c.grpcontno = a.grpcontno
                   AND b.RgtDate > '2016-12-31'
                   AND a.EndCaseDate < '2021-01-01')))
-- AND a.MakeDate < '2021-01-01'
/*20210105 取消makedate限制*/
