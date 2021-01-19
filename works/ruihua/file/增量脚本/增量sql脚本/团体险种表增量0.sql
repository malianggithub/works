SELECT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
 a.grpcontno AS TTBDH,
-- 团体保单号
b.prtno AS TTBDTBDHM,
-- 团体保单投保单号码
a.grppolno AS TTBDXZHM,
-- 团体保单险种号码
(select  t.grppolno from lcgrppol t,lmriskapp c where t.riskcode=c.riskcode and c.SUBRISKFLAG='M' and t.grpcontno=a.grpcontno   ORDER BY t.riskcode desc LIMIT 1) AS ZXBXXZHM,
-- 主险保险险种号码
(select case when SUBRISKFLAG='M' then '主险' when SUBRISKFLAG='S' then '附加险' else '不区分' end  from lmriskapp where riskcode=a.riskcode) AS ZFXXZ,
-- 主附险性质
a.riskcode AS CPBM,
-- 产品编码
(select  t.riskcode from lcgrppol t,lmriskapp c where t.riskcode=c.riskcode and c.SUBRISKFLAG='M' and t.grpcontno=a.grpcontno   ORDER BY t.riskcode desc LIMIT 1) AS ZXCPBM,
-- 主险产品编码
b.managecom AS GLJGDM,
-- 管理机构代码
(select name from ldcom where comcode=b.managecom) as GLJGMC,
-- 管理机构名称
 a.cvalidate AS BXZRSXRQ,
-- 保险责任生效日期
 a.firstpaydate AS SQJFRQ,
-- 首期交费日期
( case when b.payintv='0' then b.firstpaydate else DATE_SUB(b.payenddate,INTERVAL b.payintv month) end ) AS ZJRQ,
-- 终交日期
( case when b.payintv='0' then b.firstpaydate when b.paytodate=b.payenddate then DATE_SUB(b.payenddate,INTERVAL b.payintv month) else b.paytodate end  ) AS JZRQ,
-- 交至日期
DATE_SUB(b.enddate,INTERVAL 1 day) AS BXZRZZRQ1,
-- 保险责任终止日期
(case when b.payintv='0' then '趸交' when b.payintv='1' then '月交' when b.payintv='3' then '季交' when b.payintv='6' then '半年交'  when  b.payintv='12' then '年交' when b.payintv='-1' then '不定期交费' else '其他' end) AS JFJG,
-- 交费间隔
(case when b.payintv in ('0','-1','99') then '' else ( case when b.insuyearflag='Y' then '交费年数' when b.insuyearflag='M' then '交费月数' when b.insuyearflag='D' then '交费天数' when b.insuyearflag='A' then '交至年龄数' else '' end) end ) AS JFQJLX,
 -- 交费期间类型
 (case when b.payintv='0' then '0' when b.payintv in ('-1','99') then '-1' else b.insuyear end) AS JFNQ,
 -- 交费年期
(case when b.insuyearflag='Y' then '保险年数' when b.insuyearflag='M' then '保险月数'  when b.insuyearflag='W' then '保险周数'  when b.insuyearflag='D' then '保险天数' when b.insuyearflag='A' then '保至年龄数'  when b.insuyearflag='O' then '终身' when b.insuyearflag='O' then '无关' else '' end) AS BXQJLX,
-- 保险期间类型
(case when b.insuyearflag='0' then '999' when b.insuyearflag='N' then '0'  else b.insuyear end) AS BXNQ,
-- 保险年期
(case when   b.mult is null or b.Mult=0 then 1 else  b.mult end) AS FS,
-- 份数
(case when  b.payintv='0' then a.prem else (select sum(sumactupaymoney) paymoney from ljapayperson where grpcontno=a.grpcontno and grppolno=a.grppolno and enteraccdate is not null  GROUP BY grpcontno,paycount ORDER BY paycount desc  limit 1)   end) AS DQBF,
-- 当期保费
ifnull((select sum(sumactupaymoney) from ljapayperson where grpcontno=a.grpcontno and grppolno=a.grppolno  and enteraccdate is not null),0) + ifnull((select sum(getmoney) from ljagetendorse where grpcontno=a.grpcontno  and a.grppolno=grppolno and getmoney>0),0) AS LJBF,
-- 累计保费
a.amnt AS JBBE,
-- 基本保额
a.uwdate AS HBWCRQ,
-- 核保完成日期
(case when b.state='11' then '有效' when b.state in ('30','40') then '终止' when b.state='21' then '中止' when b.state='00' then '未生效' else '其他' end ) AS BDXZZT
-- 保单险种状态
FROM
	lcgrpcont b,
	lcgrppol a
WHERE
	a.grpcontno = b.grpcontno
and b.makedate<'2021-01-01'
and  a.state <> '02' and not EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and edortype='SA' and edorstate='0')
and  (EXISTS (select 1 from ljagetendorse where  grpcontno =a.grpcontno and a.grppolno=grppolno and feeoperationtype in ('CT','NI','NC') and makedate=DATE_SUB('${data_date}',INTERVAL 1 day) )
or 
( b.state='30' and b.enddate=DATE_SUB('${data_date}',INTERVAL 1 day))
or (a.state='11' and EXISTS(select 1 from ljapay where othernotype='02' and grpcontno=a.grpcontno and enteraccdate=DATE_SUB('${data_date}',INTERVAL 1 day)))
);