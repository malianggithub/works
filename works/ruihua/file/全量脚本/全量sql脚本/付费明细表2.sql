


select  a.grpcontno AS TTBDH,
		-- 团体保单号
b.contno AS GRBDH,
	   -- 个人保单号
'团体' AS BDTGXZ,
	   -- 保单团个性质
b.polno AS GDBXXZHM,
	   -- 个单保险险种号码
b.riskcode AS CPBM,
	   -- 产品编码
c.actugetno AS SFHM,
	   -- 实付号码
(case when b.feeoperationtype='CT' then '退保金' ELSE '保全退费' end) AS FFLX,
	   -- 付费类型
 (select (select codename from ldcode where codetype='paymode' and code=LCCustomerAccount.paytype)  from LCCustomerAccount where policyno=a.grpcontno limit 1) AS FFFS,
	   -- 付费方式
sum(b.getmoney) AS SFJE,
	   -- 实付金额
c.enteraccdate AS DZRQ,
	   -- 到账日期
c.confdate AS QRRQ,
	   -- 确认日期
 (SELECT t.HeadBankName FROM (SELECT DISTINCT HeadBankCode,HeadBankName FROM LDBank) t WHERE t.HeadBankCode = SUBSTRING_INDEX((select bankcode from lccustomeraccount where policyno=a.grpcontno LIMIT 1), '&', 1)) AS YXMC,
	   -- 银行名称
     (select bankaccno from lccustomeraccount where policyno=a.grpcontno) AS YXZH,
	   -- 银行账号
      (select accname from lccustomeraccount where policyno=a.grpcontno) AS YXZHMC,
	   -- 银行账户名称	
#单位证件类型
	''  AS ZJLX,

	   -- 证件类型
#单位证件号码
(select c.idno from LCCustomerID c where c.policyno=a.grpcontno   and c.idflag='00' limit 1) AS ZJHM,
	   -- 证件号码
'' as LPPAH,
-- 理赔赔案号
'${data_date}' DIS_DATA_DATE
from lcgrpcont a,ljagetendorse b,ljaget c where a.grpcontno=b.grpcontno
and a.grpcontno=c.grpcontno and b.getnoticeno=c.actugetno
and c.enteraccdate is not null 
and c.modifydate<'2021-01-01'
GROUP BY b.otherno,b.polno

union all
select  a.grpcontno AS TTBDH,
		-- 团体保单号
'000000' AS GRBDH,
	   -- 个人保单号
'团体' AS BDTGXZ,
	   -- 保单团个性质
'000000' AS GDBXXZHM,
	   -- 个单保险险种号码
-- 溢交退费数据没关联到产品
'' AS CPBM,
	   -- 产品编码
b.actugetno AS SFHM,
	   -- 实付号码
'溢交退费' AS FFLX,
	   -- 付费类型
 (select (select codename from ldcode where codetype='paymode' and code=LCCustomerAccount.paytype)  from LCCustomerAccount where policyno=a.grpcontno limit 1) AS FFFS,
	   -- 付费方式
b.sumgetmoney AS SFJE,
	   -- 实付金额
b.enteraccdate AS DZRQ,
	   -- 到账日期
b.confdate AS QRRQ,
	   -- 确认日期
 (SELECT t.HeadBankName FROM (SELECT DISTINCT HeadBankCode,HeadBankName FROM LDBank) t WHERE t.HeadBankCode = SUBSTRING_INDEX((select bankcode from lccustomeraccount where policyno=a.grpcontno LIMIT 1), '&', 1)) AS YXMC,
	   -- 银行名称
     (select bankaccno from lccustomeraccount where policyno=a.grpcontno) AS YXZH,
	   -- 银行账号
      (select accname from lccustomeraccount where policyno=a.grpcontno) AS YXZHMC,
	   -- 银行账户名称	
-- 单位证件类型   --20201207  团险的单位证件类型取空
-- (select d.codename from LCCustomerID c,ldcode d where  c.idtype=d.code and d.codetype='gidtype' and c.policyno=a.grpcontno   and c.idflag='00' limit 1) AS ZJLX,
   '' AS ZJLX,
	   -- 证件类型
-- #单位证件号码 --20201207  团险的单位证件号码取空
-- (select c.idno from LCCustomerID c where c.policyno=a.grpcontno   and c.idflag='00' limit 1) AS ZJHM,
   '' AS ZJHM,
	   -- 证件号码
'' as LPPAH,
-- 理赔赔案号
'${data_date}' DIS_DATA_DATE
from lcgrpcont a,ljaget b where a.grpcontno=b.grpcontno  and a.signdate is not null and b.othernotype='06' and b.enteraccdate is not null
and b.modifydate<'2021-01-01'
GROUP BY 
b.actugetno



