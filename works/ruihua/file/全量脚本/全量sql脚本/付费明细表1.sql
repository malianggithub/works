

-- 付费明细表
SELECT '' AS TTBDH,
		-- 团体保单号
       a.ContNo AS GRBDH,
	   -- 个人保单号
       '个人' AS BDTGXZ,
	   -- 保单团个性质
       d.PolNo AS GDBXXZHM,
	   -- 个单保险险种号码
       d.RiskCode AS CPBM,
	   -- 产品编码
       b.ActuGetNo AS SFHM,
	   -- 实付号码
       '其他' AS FFLX,
	   -- 付费类型
       (SELECT CodeName FROM LDCode WHERE CodeType = 'PayMode' AND Code = b.PayMode) AS FFFS,
	   -- 付费方式
       b.SumGetMoney AS SFJE,
	   -- 实付金额
       b.EnterAccDate AS DZRQ,
	   -- 到账日期
       b.ConfDate AS QRRQ,
	   -- 确认日期
       (SELECT t.HeadBankName FROM (SELECT DISTINCT HeadBankCode,HeadBankName FROM LDBank) t WHERE t.HeadBankCode = SUBSTRING_INDEX(b.BankCode, '&', 1)) AS YXMC,
	   -- 银行名称
       b.BankAccNo AS YXZH,
	   -- 银行账号
       b.AccName AS YXZHMC,
	   -- 银行账户名称	
       (SELECT Code FROM LDCode WHERE CodeType = 'IDType' AND Code = a.AppntIDType) AS ZJLX,
	   -- 证件类型
       a.AppntIDNo AS ZJHM,
	   -- 证件号码
       '' AS LPPAH,
	   -- 理赔赔案号
'${data_date}' DIS_DATA_DATE
FROM LCCont a,
     LJAGet b,
     LJTempFee c,
     LCPol d
WHERE a.GrpContNo = '00000000000000000000'
  AND c.OtherNo = a.ContNo
  AND b.OtherNo = c.TempFeeNo AND b.OtherNoType = '4'
  AND d.ContNo = a.ContNo AND d.AppFlag IN ('1', '4', '0')
  AND b.ConfDate < '2021-01-01'


