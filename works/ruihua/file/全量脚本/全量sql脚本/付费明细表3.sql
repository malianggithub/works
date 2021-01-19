


select '' AS TTBDH,
		-- 团体保单号
b.contno AS GRBDH,
	   -- 个人保单号
'个人' AS BDTGXZ,
	   -- 保单团个性质
c.polno AS GDBXXZHM,
	   -- 个单保险险种号码
c.riskcode AS CPBM,
	   -- 产品编码
a.actugetno AS SFHM,
	   -- 实付号码
(case b.edortype
	when 'CT' then '退保金'
	when 'WT' then '犹豫期退保'
	when 'LN' then '保单借款'
	else '保全退费'
end) AS FFLX,
	   -- 付费类型
(case a.PayMode
	when '4' then '银行转账'
	when '5' then '投保人自缴'
	when '9' then '网银代付'
	when 'f' then '渠道代付'
	when 'p' then 'TPA代收'
	when 'q' then '渠道代收'
	when 't' then 'TPA代付'
	when 'ty' then '腾讯医保支付'
	when 'wd' then '微信代扣'
  else ''
end) AS FFFS,
	   -- 付费方式
a.SumGetMoney AS SFJE,
	   -- 实付金额
a.EnterAccDate AS DZRQ,
	   -- 到账日期
a.confdate AS QRRQ,
	   -- 确认日期
d.headbankname AS YXMC,
	   -- 银行名称
a.BankAccNo AS YXZH,
	   -- 银行账号
a.Drawer AS YXZHMC,
	   -- 银行账户名称	
(select code FROM LDCODE where codetype='idtype' and code =a.DrawerType) AS ZJLX,
	   -- 证件类型
a.DrawerID AS ZJHM,
	   -- 证件号码
'' as LPPAH,
-- 理赔赔案号
'${data_date}' DIS_DATA_DATE
from ljaget a
join lpedoritem b
on a.otherno = b.edoracceptno
join lcpol c on
b.contno = c.contno
LEFT JOIN (
        SELECT
                headbankcode,
                headbankname
        FROM
                ldbank
        GROUP BY
                headbankcode
) d ON substring_index(a.BankCode, '&', 1) = d.headbankcode
where b.grpcontno = '00000000000000000000'
AND B.edortype IN ('CT','WT','XT','LN','IC','IO','PT')
  AND a.ConfDate < '2021-01-01'
GROUP BY B.edortype


