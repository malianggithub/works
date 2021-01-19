

-- 团险
select  grpcontno AS TTBDH,
-- 团体保单号
contno AS GRBDH,
	   -- 个人保单号
'团体'  AS BDTGXZ,
	   -- 保单团个性质
'自然人' AS JTDBZ,
	   -- 家庭单标志
managecom AS GLJGDM,
	   -- 管理机构代码
managecom AS GLJGMC,
	   -- 管理机构名称
a.managecom AS JGXQDM, 
	   -- 监管辖区代码
managecom AS CBDQ,
	   -- 承保地区
(CASE WHEN a.salechnl='11' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '3' THEN '122'  WHEN '4' THEN '272' END)
     WHEN a.salechnl='33' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '2' THEN '230' END) 
     WHEN a.salechnl='09' THEN (CASE (SELECT agentkind FROM laagent  WHERE AGENTCODE = a.AGENTCODE) WHEN '1' THEN '111' when '2' then '210' ELSE NULL END) ELSE a.salechnl END) AS XSQD,
	   -- 销售渠道
(select agentcom from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGBM,
	   -- 代理机构编码
(select agentcomname from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGMC,
	   -- 代理机构名称
(select customerno from lcgrpappnt where grpcontno=a.grpcontno limit 1) AS TBRKHBH,
	   -- 投保人客户编号
(case when a.payintv='0' then '趸交' when a.payintv='1' then '月交' when a.payintv='3' then '季交' when a.payintv='6' then '半年交'  when  a.payintv='12' then '年交' when a.payintv='-1' then '不定期交费' else '其他' end) AS JFJG,
	   -- 交费间隔
(select paytype from   LCCustomerAccount where policyno=a.grpcontno LIMIT 1) AS JFFS,
	   -- 交费方式
signdate AS QDRQ,
	   -- 签单日期
'CNY' AS HBDM,
	   -- 货币代码
(case when  payintv='0' then prem else (select sum(sumactupaymoney) paymoney from ljapayperson where contno=a.contno and grpcontno=a.grpcontno and enteraccdate is not null  GROUP BY contno,paycount ORDER BY paycount desc  limit 1)   end) AS BF,
	   -- 保费
amnt AS BE,
	   -- 保额
ifnull((select sum(sumactupaymoney) from ljapayperson where contno=a.contno and enteraccdate is not null),0) + ifnull((select sum(getmoney) from lpedoritem where contno=a.contno and getmoney>0),0) AS LJBF,
	   -- 累计保费
 /*ifnull((case when payintv=0 then ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno  
 -- 20201229 gulaoshiand insuredno=a.insuredno 
 and feeoperationtype='NI' LIMIT 1) ) when paytodate=enddate then DATE_SUB(enddate,INTERVAL payintv month) else paytodate end ),'9999-12-31') AS JZRQ,*/
		-- 交至日期  20201225 当前数据有问题，将为空的数据直接置为9999-12-31
/*ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno  and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) AS SQJFRQ, 20201225 当前数据有问题，将为空的数据直接置为9999-12-31*/

/*(case when payintv=0 then ifnull(firstpaydate,(select edorvalidate from lpedoritem  where contno=a.contno and edortype='NI' limit 1) ) when paytodate=enddate then DATE_SUB(enddate,INTERVAL payintv month) else ifnull(paytodate,(select edorvalidate from lpedoritem  where contno=a.contno and edortype='NI' limit 1)) end ) AS JZRQ,*/
(case when payintv=0 then ifnull(firstpaydate,(select edorvalidate from lpedoritem  where contno=a.contno and edortype='NI' limit 1) ) when paytodate=enddate then DATE_SUB(enddate,INTERVAL payintv month) else ifnull(paytodate,(select edorvalidate from lpedoritem  where contno=a.contno and edortype='NI' limit 1)) end ) AS JZRQ,
-- 交至日期  2020-12-29 guaoshi 交至日期为空取别的字段

-- 2020-12-29 ifnull(ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno   and feeoperationtype='NI' LIMIT 1) ),'9999-12-31') AS SQJFRQ,
ifnull(firstpaydate,(select edorvalidate from lpedoritem  where contno=a.contno and edortype='NI' limit 1)) AS SQJFRQ,
-- 首期交费日期 2020-12-29 guaoshi 首期交费日期为空取别的字段
cvalidate AS BDSXRQ,
	   -- 保单生效日期
 (case when (select 1 from lcuwtrace where contno=a.contno LIMIT 1) is not null then '人工核保' else '自动核保' end) AS HBLX,
	   -- 核保类型
ifnull(PolApplyDate,ifnull((select PolApplyDate from  lobcont where contno=a.contno),(select modifydate from lpedoritem where contno=a.contno and edortype in ('NI','RR') LIMIT 1)))AS TBDSQRQ,
	   -- 投保单申请日期
 CASE appflag
            WHEN '0' THEN '未生效'
			WHEN '1' THEN '有效'
			WHEN '4' THEN '终止'
end AS BDZT,
		-- 保单状态
'000000' AS BDXS,
	   -- 保单形式
-- DATE_SUB(enddate,INTERVAL 1 day) AS BDMQRQ,
(SELECT MAX(grppol.enddate) - INTERVAL '1' DAY  FROM lcgrppol grppol inner join lmriskapp lk on lk.riskcode =grppol.riskcode and subriskflag='M' WHERE grppol.grpcontno = a.grpcontno) AS BDMQRQ,
	   -- 保单满期日期 2020-12-29 gulaoshi1 (取的是主险的enddate) 满足保单满期日期不得小于保单生效日期
 (case when  state in ('20','40','30') then DATE_SUB(enddate,INTERVAL 1 day)  else '' end ) AS BDZZRQ1,
	   -- 保单终止日期
'' AS BDZZRQ2,
	   -- 保单中止日期
'' AS BDXLHFRQ,
	   -- 保单效力恢复日期
(case when state='30' then '满期终止'  when state='40' then '退保' when state='20' then '团体减人' when state='02' then '拒保终止' when state='01' then '当日撤单' else '' end) AS BDZZYY,
		 -- 保单终止原因
 (case when InterBusinessType is not null then '是' else '否' end) AS HLWBXYWBZ,
	   -- 互联网保险业务标志
'' AS SMRZTGBZ,
	   -- 实名认证通过标志
'' AS SMRZFS,
	   -- 实名认证方式
'否' AS FZCTBBZ,
	   -- 非正常退保标志
'否' AS FZCGFBZ,
	   -- 非正常给付标志
'否' AS JBYWBZ,
	   -- 经办业务标志
'' AS JBGLF,
	   -- 经办管理费
'否' AS YBGRZHGMBZ,
'${data_date}' DIS_DATA_DATE
from lccont a
left join (select m.agentcom,m.AngencyType,m.name,f.policyno from lacom m,lcagentcominfo f where m.agentcom=f.agentcom )com  on com.policyno=a.grpcontno
where a.grpcontno!= '00000000000000000000'
and a.state <>'02' and not EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and edortype='SA' and edorstate='0')
/*  (a.CValiDate > '2016-12-31' AND a.CValiDate < '2021-01-01')
      OR (a.CValiDate < '2017-01-01' AND a.APPFLAG='1')
	  */-- 20201229 gulaoshi 生效日期改成签单日期
  AND ((a.signdate > '2016-12-31' AND a.signdate < '2021-01-01')
      OR (a.signdate < '2017-01-01' AND a.APPFLAG='1')
      OR (EXISTS(SELECT 1 FROM LLCase a,LLRegister b,LLClaimDetail c
                 WHERE a.CaseNo = b.RgtNo AND a.CaseNo = c.ClmNo AND c.ContNo = a.ContNo
                   AND b.RgtDate > '2016-12-31'
                   AND a.EndCaseDate < '2021-01-01')))
-- AND a.MakeDate < '2021-01-01'
/*20210105 取消AND a.MakeDate <'2021-01-01'*/
and a.signdate is not null
union 
select  grpcontno AS TTBDH,
-- 团体保单号
contno AS GRBDH,
	   -- 个人保单号
'团体'  AS BDTGXZ,
	   -- 保单团个性质
'自然人' AS JTDBZ,
	   -- 家庭单标志
managecom AS GLJGDM,
	   -- 管理机构代码
managecom AS GLJGMC,
	   -- 管理机构名称
a.managecom AS JGXQDM, 
	   -- 监管辖区代码
managecom AS CBDQ,
	   -- 承保地区
(CASE WHEN a.salechnl='11' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '3' THEN '122'  WHEN '4' THEN '272' END)
     WHEN a.salechnl='33' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '2' THEN '230' END) 
     WHEN a.salechnl='09' THEN (CASE (SELECT agentkind FROM laagent  WHERE AGENTCODE = a.AGENTCODE) WHEN '1' THEN '111' when '2' then '210' ELSE NULL END) ELSE a.salechnl END) AS XSQD,
	   -- 销售渠道
(select agentcom from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGBM,
	   -- 代理机构编码
(select agentcomname from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGMC,
	   -- 代理机构名称
(select customerno from lcgrpappnt where grpcontno=a.grpcontno limit 1) AS TBRKHBH,
	   -- 投保人客户编号
(case when a.payintv='0' then '趸交' when a.payintv='1' then '月交' when a.payintv='3' then '季交' when a.payintv='6' then '半年交'  when  a.payintv='12' then '年交' when a.payintv='-1' then '不定期交费' else '其他' end) AS JFJG,
	   -- 交费间隔
(select paytype from   LCCustomerAccount where policyno=a.grpcontno LIMIT 1) AS JFFS,
	   -- 交费方式
(select lp.edorvalidate from lpedoritem lp where  lp.edortype='RR' and lp.contno=a.contno limit 1) AS QDRQ,
	   -- 签单日期
'CNY' AS HBDM,
	   -- 货币代码
(case when  payintv='0' then prem else (select sum(sumactupaymoney) paymoney from ljapayperson where contno=a.contno and grpcontno=a.grpcontno and enteraccdate is not null  GROUP BY contno,paycount ORDER BY paycount desc  limit 1)   end) AS BF,
	   -- 保费
amnt AS BE,
	   -- 保额
ifnull((select sum(sumactupaymoney) from ljapayperson where contno=a.contno and enteraccdate is not null),0) + ifnull((select sum(getmoney) from lpedoritem where contno=a.contno and getmoney>0),0) AS LJBF,
	   -- 累计保费
(select lp.edorvalidate from lpedoritem lp where  lp.edortype='RR' and lp.contno=a.contno limit 1) AS JZRQ,
		-- 交至日期 （与签单日期保持一致） 
/*ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno  and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) AS SQJFRQ, 20201225 当前数据有问题，将为空的数据直接置为9999-12-31*/
-- ifnull(ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno   and feeoperationtype='NI' LIMIT 1) ),'9999-12-31') AS SQJFRQ,
-- ifnull(firstpaydate,(select edorvalidate from lpedoritem  where contno=a.contno and edortype='NI' limit 1)) AS SQJFRQ,
(select lp.edorvalidate from lpedoritem lp where  lp.edortype='RR' and lp.contno=a.contno limit 1) AS SQJFRQ,
	   -- 首期交费日期 2020-12-29 gulaoshi （与签单日期保持一致）
cvalidate AS BDSXRQ,
	   -- 保单生效日期
 (case when (select 1 from lcuwtrace where contno=a.contno LIMIT 1) is not null then '人工核保' else '自动核保' end) AS HBLX,
	   -- 核保类型
ifnull(PolApplyDate,ifnull((select PolApplyDate from  lobcont where contno=a.contno),(select modifydate from lpedoritem where contno=a.contno and edortype in ('NI','RR') LIMIT 1)))AS TBDSQRQ,
	   -- 投保单申请日期
 CASE appflag
            WHEN '0' THEN '未生效'
			WHEN '1' THEN '有效'
			WHEN '4' THEN '终止'
end AS BDZT,
		-- 保单状态
'000000' AS BDXS,
	   -- 保单形式
-- DATE_SUB(enddate,INTERVAL 1 day) AS BDMQRQ,
(SELECT MAX(grppol.enddate) - INTERVAL '1' DAY  FROM lcgrppol grppol inner join lmriskapp lk on lk.riskcode =grppol.riskcode and subriskflag='M' WHERE grppol.grpcontno = a.grpcontno) AS BDMQRQ,
	   -- 保单满期日期 2020-12-29 gulaoshi
 (case when  state in ('20','40','30') then DATE_SUB(enddate,INTERVAL 1 day)  else '' end ) AS BDZZRQ1,
	   -- 保单终止日期
'' AS BDZZRQ2,
	   -- 保单中止日期
'' AS BDXLHFRQ,
	   -- 保单效力恢复日期
(case when state='30' then '满期终止'  when state='40' then '退保' when state='20' then '团体减人' when state='02' then '拒保终止' when state='01' then '当日撤单' else '' end) AS BDZZYY,
		 -- 保单终止原因
 (case when InterBusinessType is not null then '是' else '否' end) AS HLWBXYWBZ,
	   -- 互联网保险业务标志
'' AS SMRZTGBZ,
	   -- 实名认证通过标志
'' AS SMRZFS,
	   -- 实名认证方式
'否' AS FZCTBBZ,
	   -- 非正常退保标志
'否' AS FZCGFBZ,
	   -- 非正常给付标志
'否' AS JBYWBZ,
	   -- 经办业务标志
'' AS JBGLF,
	   -- 经办管理费
'否' AS YBGRZHGMBZ,
'${data_date}' DIS_DATA_DATE
from lccont a
left join (select m.agentcom,m.AngencyType,m.name,f.policyno from lacom m,lcagentcominfo f where m.agentcom=f.agentcom )com  on com.policyno=a.grpcontno
where a.grpcontno!= '00000000000000000000'
and a.signdate is null 
and exists (select 1 from lpedoritem lp where  lp.edortype='RR' and lp.contno=a.contno  and lp.edorvalidate<'2021-01-01');
-- 建工险实名化的保单 /*排除掉生效日期不是2021-01-01的数据/
