-- 个险
-- 保费明细表
SELECT '' AS TTBDH,
		-- 团体保单号
       a.ContNo AS GRBDH,
	   -- 个人保单号
       '个人' AS BDTGXZ,
	   -- 保单团个性质
       (CASE b.OtherNoType WHEN '6' THEN '首期' WHEN '7' THEN '首期' WHEN '2' THEN '正常续期'
           WHEN '10' THEN (IF(EXISTS(SELECT 1 FROM LPEdorItem WHERE EdorAcceptNo = b.IncomeNo AND EdorType = 'RE'),'复效续期','其他'))
           ELSE '其他' END ) AS BFYWLX,
		   -- 保费业务类型
       c.PayNo AS JFXH,
	   -- 交费序号
       c.PolNo AS GDBXXZHM,
	   -- 个单保险险种号码
       c.RiskCode AS CPBM,
	   -- 产品编码
       a.ManageCom AS GLJGDM,
	   -- 管理机构代码
       (SELECT t.Name FROM LDCom t WHERE t.ComCode = a.ManageCom) AS GLJGMC,
	   -- 管理机构名称
       b.SumActuPayMoney AS SJJE,
	   -- 实交金额
       b.EnterAccDate AS DZRQ,
	   -- 到账日期
       b.ConfDate AS QRRQ,
	   -- 确认日期
       (SELECT t.HeadBankName FROM (SELECT DISTINCT HeadBankCode,HeadBankName FROM LDBank) t WHERE t.HeadBankCode = SUBSTRING_INDEX(b.BankCode, '&', 1)) AS KHYXMC,
	   -- 开户银行名称
       b.BankAccNo AS YXZH,
	   -- 银行账号
       b.AccName AS YXZHMC,
	   -- 银行账户名称
'${data_date}' DIS_DATA_DATE
FROM LCCont a,
     LJAPay b,
     LJAPayPerson c
WHERE a.GrpContNo = '00000000000000000000'
  AND a.AppFlag IN ('1', '4', '0')
  AND c.ContNO = a.ContNo
  AND c.PayNo = b.PayNo
  AND b.ConfDate < '2021-01-01'
 -- and a.makedate < '2021-01-01'
/* 20210101 排除不在集中范围内的个单数据
   20210105 最新逻辑，已将保单表数据做了调整，故而将makedate条件取消
*/ 
GROUP BY c.PolNo,c.PayNo

