-- 个人险种表
SELECT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
'' AS TTBDH,
       -- 团体保单号
       a.ContNo AS GRBDH,
       -- 个人保单号
       '个人' AS BDTGXZ,
       --	保单团个性质
       b.PolNo AS GDBXXZHM,
       -- 个单保险险种号码 
       b.MainPolNo AS ZXBXXZHM,
       -- 主险保险险种号码
       (CASE (SELECT SubRiskFlag FROM LMRiskApp WHERE RiskCode = b.RiskCode)
           WHEN 'M' THEN '主险'
           WHEN 'S' THEN '附加险'
           ELSE '不区分' END ) AS ZFXXZ,
       -- 主附险性质
       b.RiskCode AS CPBM,
       -- 产品编码
       a.ManageCom AS GLJGDM,
       -- 管理机构代码
       (SELECT t.Name FROM LDCom t WHERE t.ComCode = a.ManageCom) AS GLJGMC,
       -- 管理机构名称
       b.CValiDate AS BXZRSXRQ,
       -- 保险责任生效日期
       a.FirstPayDate AS SQJFRQ,
       -- 首期交费日期
       b.PayEndDate AS ZJRQ,
       -- 终交日期
          (CASE WHEN b.PayIntv = 0 THEN b.FirstPayDate
                WHEN b.PayIntv <> '0' AND b.PaytoDate = b.PayEndDate THEN DATE_SUB(b.PaytoDate, INTERVAL b.PayIntv MONTH)
                WHEN b.PayIntv <> '0' AND b.PaytoDate < b.PayEndDate THEN b.PaytoDate END) AS JZRQ,
       -- 交至日期
       DATE_SUB(b.EndDate,INTERVAL 1 DAY) AS BXZRZZRQ1,
       -- 保险责任终止日期
       (SELECT CodeName FROM LDCode WHERE CodeType = 'PayIntv' AND Code = b.PayIntv) AS JFJG,
       -- 交费间隔
       (case when b.payintv in ('0','-1','99') then '' else ( case when b.insuyearflag='Y' then '交费年数' when b.insuyearflag='M' then '交费月数' when b.insuyearflag='D' then '交费天数' when b.insuyearflag='A' then '交至年龄数' else '' end) end ) AS JFQJLX,
       -- 交费期间类型
       IF(b.PayIntv = '0',0,b.PayEndYear) AS JFNQ,
       -- 交费年期
       (case when b.insuyearflag='Y' then '保险年数' when b.insuyearflag='M' then '保险月数'  when b.insuyearflag='W' then '保险周数'  when b.insuyearflag='D' then '保险天数' when b.insuyearflag='A' then '保至年龄数'  when b.insuyearflag='O' then '终身' when b.insuyearflag='N' then '无关' else '' end) AS BXQJLX,
       -- 保险期间类型
       IF(b.InsuYear = '106' AND b.InsuYearFlag = 'A', '999', b.InsuYear) AS BXNQ,
       -- 保险年期
       b.Mult AS FS,
       -- 份数
       b.Prem AS DQBF,
       -- 当期保费
       (SELECT SUM(SumActuPayMoney) FROM LJAPayPerson WHERE ContNO = b.ContNo AND PolNo = b.PolNo) AS LJBF,
       -- 累计保费
       b.Amnt AS JBBE,
       -- 基本保额
       b.Amnt AS FXBE,
       -- 风险保额
       (CASE b.AppFlag
            WHEN '0' THEN '未生效'
            WHEN '1' THEN (IF(EXISTS(SELECT 1 FROM LCContState t WHERE t.StateType = 'Available' AND t.State = '0' AND t.EndDate IS NULL AND t.PolNo = b.PolNo),
                              '有效','中止'))
            WHEN '4' THEN '终止' ELSE '其他' END)  AS BDXZZT,
       -- 保单险种状态
       (IF(b.AppFlag = '1',(SELECT StartDate FROM LCContState WHERE StateType = 'Available' AND State = '1' AND EndDate IS NULL AND PolNo = b.PolNo),'')) AS BXZRZZRQ2,
       -- 保险责任中止日期
       (SELECT MAX(EdorValiDate) FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType = 'RE') AS BXZRXLHFRQ,
       -- 保险责任效力恢复日期
       (IF(b.AppFlag = '4',(SELECT StartDate FROM LCContState WHERE StateType = 'Terminate' AND State = '1' AND PolNo = b.PolNo),'')) AS XZZZRQ
       -- 险种终止日期
FROM LCCont a,
     LCPol b
WHERE a.GrpContNo = '00000000000000000000'
  AND a.ContNO = b.ContNo
  AND a.AppFlag in ('1','4','0')
  AND b.UWFlag not in ('1','2')
  AND (1 = 2
           -- IO-职业类别变更 AE-投保人变更 CM-客户重要资料变更(客户层) IC-客户重要资料变更(保单层)
    OR EXISTS(SELECT 1 FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType IN ('IO','AE','CM','IC') AND EdorState = '0' AND DATEDIFF('${data_date}', EdorValiDate) = 1
                                         AND EXISTS(SELECT 1 FROM LJAGet WHERE OtherNo = EdorAcceptNo AND OtherNoType = '10'))
           -- PT-减保 XS-协议减保 PM-交费间隔变更 PC-交费方式及交费账号变更 NS-新增附加险 FM-交费期间变更
    OR EXISTS(SELECT 1 FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType IN ('PT','XS','PM','PC','NS','FM') AND EdorState = '0' AND DATEDIFF('${data_date}', EdorValiDate) = 1)
           -- 前一天保单状态有变更(生效、失效、终止)
    OR EXISTS(SELECT 1 FROM LCContState WHERE ContNo = a.ContNo AND StateType IN ('Available','Terminate') AND DATEDIFF('${data_date}', MakeDate) = 1)
           -- 保单在前一天有收费(首期、续期、续保、复效、新增附加险)
    OR EXISTS(SELECT 1 FROM LJAPayPerson WHERE ContNo = a.ContNo AND DATEDIFF('${data_date}', MakeDate) = 1 )
    )





union all

select  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
 a.grpcontno AS TTBDH,
-- 团体保单号
a.contno AS GRBDH,
-- 个人保单号
'团体' AS BDTGXZ,
-- 	保单团个性质
polno AS GDBXXZHM,
-- 个单保险险种号码 
ifnull((select  b.polno from lcpol b,lmriskapp c where b.riskcode=c.riskcode and c.SUBRISKFLAG='M' and b.grpcontno=a.grpcontno and a.contno=b.contno and  a.insuredno=b.insuredno  ORDER BY b.riskcode desc LIMIT 1),a.polno) AS ZXBXXZHM,
-- 主险保险险种号码
(select case when SUBRISKFLAG='M' then '主险' when SUBRISKFLAG='S' then '附加险' else '不区分' end  from lmriskapp where riskcode=a.riskcode) AS ZFXXZ,
-- 主附险性质
riskcode AS CPBM,
-- 产品编码
managecom AS GLJGDM,
-- 管理机构代码
(select name from ldcom where comcode=a.managecom ) AS GLJGMC,
-- 管理机构名称
cvalidate AS BXZRSXRQ,
-- 保险责任生效日期
ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno and polno=a.polno and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) )AS SQJFRQ,
-- 20201208 (case when a.polstate='02' or EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and edortype='SA' and edorstate='0') then '1900-01-01' ELSE firstpaydate end) AS SQJFRQ,
-- 首期交费日期
( case when payintv='0' then ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno and polno=a.polno and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) else DATE_SUB(payenddate,INTERVAL payintv month) end ) AS ZJRQ,
-- 终交日期
( case when payintv='0' then ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno and polno=a.polno and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) when paytodate=payenddate then DATE_SUB(payenddate,INTERVAL payintv month) else paytodate end  ) AS JZRQ,
-- 20201208 ( case when a.polstate='02' or EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and edortype='SA' and edorstate='0') then '1900-01-01' when payintv='0' then firstpaydate when paytodate=payenddate then DATE_SUB(payenddate,INTERVAL payintv month) else paytodate end  ) AS JZRQ,
-- 交至日期
DATE_SUB(enddate,INTERVAL 1 day) AS BXZRZZRQ1,
-- 保险责任终止日期
(case when a.payintv='0' then '趸交' when a.payintv='1' then '月交' when a.payintv='3' then '季交' when a.payintv='6' then '半年交'  when  a.payintv='12' then '年交' when a.payintv='-1' then '不定期交费' else '其他' end) AS JFJG,
-- 交费间隔
(case when a.payintv in ('0','-1','99') then '' else ( case when a.insuyearflag='Y' then '交费年数' when a.insuyearflag='M' then '交费月数' when a.insuyearflag='D' then '交费天数' when a.insuyearflag='A' then '交至年龄数' else '' end) end ) AS JFQJLX,
 -- 交费期间类型
(case when payintv='0' then '0' else insuyear end) AS JFNQ,
-- 交费年期
(case when a.insuyearflag='Y' then '保险年数' when a.insuyearflag='M' then '保险月数'  when a.insuyearflag='W' then '保险周数'  when a.insuyearflag='D' then '保险天数' when a.insuyearflag='A' then '保至年龄数'  when a.insuyearflag='O' then '终身' when a.insuyearflag='N' then '无关' else '' end) AS BXQJLX,
-- 保险期间类型
(case when a.insuyearflag='0' then '999' when a.insuyearflag='N' then '0'  else a.insuyear end) AS BXNQ,
-- 保险年期
(case when   a.mult is null or a.Mult=0 then 1 else  a.mult end) AS FS,
-- 份数
(case when  payintv='0' then prem else (select sum(sumactupaymoney) paymoney from ljapayperson where polno=a.polno and grpcontno=a.grpcontno and enteraccdate is not null  GROUP BY polno,paycount ORDER BY paycount desc  limit 1)   end) AS DQBF,
-- 当期保费
 ifnull((select sum(sumactupaymoney) from ljapayperson where polno=a.polno and enteraccdate is not null),0) + ifnull((select sum(getmoney) from lpedoritem where polno=a.polno and getmoney>0 and edorstate='0'),0) AS LJBF,
-- 累计保费
amnt AS JBBE,
-- 基本保额
riskamnt AS FXBE,
-- 风险保额
(CASE a.AppFlag
    WHEN '0' THEN '未生效'
    WHEN '1' THEN '有效'
    WHEN '4' THEN '终止' ELSE '其他' END)  AS BDXZZT,
-- 保单险种状态
'' BXZRZZRQ2,
-- 保险责任中止日期
'' BXZRXLHFRQ,
-- 保险责任效力恢复日期
enddate AS XZZZRQ
-- 险种终止日期
from lcpol a
 where a.grpcontno!= '00000000000000000000'
and a.polstate<>'02' and not EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and edortype='SA' and edorstate='0')
and (exists (select 1 from lccontstate where contno=a.contno and polno=a.polno  and statetype='Terminate'  and makedate=DATE_SUB('${data_date}',INTERVAL 1 day))
or (a.polstate='11' and EXISTS(select 1 from ljapay where othernotype='02' and grpcontno=a.grpcontno and enteraccdate=DATE_SUB('${data_date}',INTERVAL 1 day)))
or (EXISTS(select 1 from ljagetendorse where contno=a.contno and polno=a.polno and   feeoperationtype='NI' and grpcontno in (select  grpcontno from ldpbalanceon where balanceonstate='0') and  enteraccdate=DATE_SUB('${data_date}',INTERVAL 1 day) and   enteraccdate=DATE_SUB('${data_date}',INTERVAL 1 day)) )
)
union ALL
select  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
 a.grpcontno AS TTBDH,
-- 团体保单号
a.contno AS GRBDH,
-- 个人保单号
'团体' AS BDTGXZ,
-- 	保单团个性质
a.polno AS GDBXXZHM,
-- 个单保险险种号码 
ifnull((select  b.polno from lcpol b,lmriskapp c where b.riskcode=c.riskcode and c.SUBRISKFLAG='M' and b.grpcontno=a.grpcontno and a.contno=b.contno and  a.insuredno=b.insuredno  ORDER BY b.riskcode desc LIMIT 1),a.polno) AS ZXBXXZHM,
-- 主险保险险种号码
(select case when SUBRISKFLAG='M' then '主险' when SUBRISKFLAG='S' then '附加险' else '不区分' end  from lmriskapp where riskcode=a.riskcode) AS ZFXXZ,
-- 主附险性质
a.riskcode AS CPBM,
-- 产品编码
a.managecom AS GLJGDM,
-- 管理机构代码
(select name from ldcom where comcode=a.managecom ) AS GLJGMC,
-- 管理机构名称
a.cvalidate AS BXZRSXRQ,
-- 保险责任生效日期
ifnull(a.firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno and polno=a.polno and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) )AS SQJFRQ,
-- 20201208 (case when a.polstate='02' or EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and edortype='SA' and edorstate='0') then '1900-01-01' ELSE firstpaydate end) AS SQJFRQ,
-- 首期交费日期
( case when a.payintv='0' then ifnull(a.firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno and polno=a.polno and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) else DATE_SUB(a.payenddate,INTERVAL a.payintv month) end ) AS ZJRQ,
-- 终交日期
( case when a.payintv='0' then ifnull(a.firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno and polno=a.polno and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) when a.paytodate=a.payenddate then DATE_SUB(a.payenddate,INTERVAL a.payintv month) else a.paytodate end  ) AS JZRQ,
-- 20201208 ( case when a.polstate='02' or EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and edortype='SA' and edorstate='0') then '1900-01-01' when payintv='0' then firstpaydate when paytodate=payenddate then DATE_SUB(payenddate,INTERVAL payintv month) else paytodate end  ) AS JZRQ,
-- 交至日期
DATE_SUB(p.enddate,INTERVAL 1 day) AS BXZRZZRQ1,
-- 保险责任终止日期
(case when a.payintv='0' then '趸交' when a.payintv='1' then '月交' when a.payintv='3' then '季交' when a.payintv='6' then '半年交'  when  a.payintv='12' then '年交' when a.payintv='-1' then '不定期交费' else '其他' end) AS JFJG,
-- 交费间隔
(case when a.payintv in ('0','-1','99') then '' else ( case when a.insuyearflag='Y' then '交费年数' when a.insuyearflag='M' then '交费月数' when a.insuyearflag='D' then '交费天数' when a.insuyearflag='A' then '交至年龄数' else '' end) end ) AS JFQJLX,
 -- 交费期间类型
(case when a.payintv='0' then '0' else a.insuyear end) AS JFNQ,
-- 交费年期
(case when a.insuyearflag='Y' then '保险年数' when a.insuyearflag='M' then '保险月数'  when a.insuyearflag='W' then '保险周数'  when a.insuyearflag='D' then '保险天数' when a.insuyearflag='A' then '保至年龄数'  when a.insuyearflag='O' then '终身' when a.insuyearflag='N' then '无关' else '' end) AS BXQJLX,
-- 保险期间类型
(case when a.insuyearflag='0' then '999' when a.insuyearflag='N' then '0'  else a.insuyear end) AS BXNQ,
-- 保险年期
(case when   a.mult is null or a.Mult=0 then 1 else  a.mult end) AS FS,
-- 份数
(case when  a.payintv='0' then a.prem else (select sum(sumactupaymoney) paymoney from ljapayperson where polno=a.polno and grpcontno=a.grpcontno and enteraccdate is not null  GROUP BY polno,paycount ORDER BY paycount desc  limit 1)   end) AS DQBF,
-- 当期保费
 ifnull((select sum(sumactupaymoney) from ljapayperson where polno=a.polno and enteraccdate is not null),0) + ifnull((select sum(getmoney) from lpedoritem where polno=a.polno and getmoney>0 and edorstate='0'),0) AS LJBF,
-- 累计保费
a.amnt AS JBBE,
-- 基本保额
a.riskamnt AS FXBE,
-- 风险保额
(CASE p.appflag
            WHEN '0' THEN '未生效'
			WHEN '1' THEN '有效'
			WHEN '4' THEN '终止'
end )  AS BDXZZT,
-- 保单险种状态
'' BXZRZZRQ2,
-- 保险责任中止日期
'' BXZRXLHFRQ,
-- 保险责任效力恢复日期
p.enddate AS XZZZRQ
-- 险种终止日期
from lcpol a,lppol p
where a.grpcontno!= '00000000000000000000'
and a.polno=p.polno
and (EXISTS  (
select 1 from lpedoritem where edorstate='0' and p.edorno=edorno and contno=p.contno and polno=p.polno and grpcontno=p.grpcontno
and edortype in ('ZT','CT','NI','RR')
and modifydate=DATE_SUB('${data_date}',INTERVAL 1 day)
 )) 
and p.polstate!='02'
