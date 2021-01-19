


select a.grpcontno AS TTBDH,
	-- 团体保单号
	c.contno AS GRBDH,
	-- 个人保单号
	'团体' AS BDTGXZ,
	-- 保单团个性质
	(case when b.othernotype='01' then '首期' else '正常续期' end) AS BFYWLX,
	-- 保费业务类型
	c.payno AS JFXH,
	   -- 交费序号
	c.polno AS GDBXXZHM,
	   -- 个单保险险种号码
	c.riskcode AS CPBM,
	   -- 产品编码
	a.managecom AS GLJGDM,
	   -- 管理机构代码
	(select name from ldcom where comcode=a.managecom ) AS GLJGMC,
	   -- 管理机构名称
	sum(c.sumactupaymoney) AS SJJE,
	   -- 实交金额
	c.enteraccdate AS DZRQ,
	   -- 到账日期
	c.confdate AS QRRQ,
	   -- 确认日期
	 (SELECT t.HeadBankName FROM (SELECT DISTINCT HeadBankCode,HeadBankName FROM LDBank) t WHERE t.HeadBankCode = SUBSTRING_INDEX((select bankcode from lccustomeraccount where policyno=a.grpcontno LIMIT 1), '&', 1)) AS KHYXMC,
	   -- 开户银行名称
     (select bankaccno from lccustomeraccount where policyno=a.grpcontno) AS YXZH,
	   -- 银行账号
      (select accname from lccustomeraccount where policyno=a.grpcontno) AS YXZHMC,
	   -- 银行账户名称	
'${data_date}' DIS_DATA_DATE
FROM LCgrpCont a,
     LJAPay b,
     LJAPayPerson c
WHERE 
   a.AppFlag IN ('1', '4', '0')
  AND b.grpContNO = a.grpContNO
	and c.grpcontno=a.grpContNO
  AND c.PayNo = b.PayNo
	and b.enteraccdate is not NULL
	and b.sumactupaymoney is not null
	and b.othernotype in ('01','02')
	and b.confdate<'2021-01-01'
GROUP BY c.grpcontno,c.polno,c.paycount
HAVING sum(c.sumactupaymoney)>0

UNION ALL
#保全收费归类为其他
select  a.grpcontno AS TTBDH,
		-- 团体保单号
c.contno AS GRBDH,
	   -- 个人保单号
'团体' AS BDTGXZ,
	   -- 保单团个性质
'其他'AS BFYWLX,
		   -- 保费业务类型
b.payno AS JFXH,
	   -- 交费序号
c.polno AS GDBXXZHM,
	   -- 个单保险险种号码
c.riskcode AS CPBM,
	   -- 产品编码
a.managecom AS GLJGDM,
	   -- 管理机构代码
	(select name from ldcom where comcode=a.managecom ) AS GLJGMC,
	   -- 管理机构名称
sum(c.getmoney) AS SJJE,
	   -- 实交金额
c.enteraccdate AS DZRQ,
	   -- 到账日期
b.confdate AS QRRQ,
	   -- 确认日期
 (SELECT t.HeadBankName FROM (SELECT DISTINCT HeadBankCode,HeadBankName FROM LDBank) t WHERE t.HeadBankCode = SUBSTRING_INDEX((select bankcode from lccustomeraccount where policyno=a.grpcontno LIMIT 1), '&', 1)) AS KHYXMC,
	   -- 开户银行名称
     (select bankaccno from lccustomeraccount where policyno=a.grpcontno) AS YXZH,
	   -- 银行账号
      (select accname from lccustomeraccount where policyno=a.grpcontno) AS YXZHMC,
	   -- 银行账户名称
'${data_date}' DIS_DATA_DATE		
FROM lcgrpcont a,
ljapay b,
ljagetendorse c
WHERE
	  b.grpcontno = c.grpcontno 
	and a.grpcontno=b.grpcontno
	and b.otherno=c.otherno
	and b.payno=c.getnoticeno
	and b.sumduepaymoney>0
	and  c.enteraccdate is not null 
	and b.confdate<'2021-01-01'
GROUP BY
	c.grpcontno,
  c.otherno,
	c.polno 
