SELECT 
DISTINCT 
(CASE b.grpcontno WHEN 00000000000000000000  THEN '' ELSE b.grpcontno END ) AS TTBDH,
		-- 团体保单号
b.contno AS GRBDH,
	   -- 个人保单号
( CASE b.grpcontno WHEN 00000000000000000000  THEN '个体' ELSE '团体' END ) AS BDTGXZ,
	   -- 保单团个性质
b.polno AS GDBXXZHM,
	   -- 个单保险险种号码
b.riskcode AS CPBM,
	   -- 产品编码
b.ActuGetNo AS SFHM,
	   -- 实付号码
'理赔赔付' AS FFLX,
	   -- 付费类型
(SELECT ldcode.codename from ldcode where ldcode.codetype = 'chargepaymode' and ldcode.code in(SELECT ljaget.paymode from ljaget  where ljaget.otherno = b.otherno and (ljaget.othernotype = '5' or ljaget.othernotype = '13' ))limit 1) AS FFFS,
	   -- 付费方式
sum(b.pay) AS SFJE,
	   -- 实付金额
(select ljaget.EnterAccDate from ljaget where ljaget.otherno = b.otherno and (ljaget.othernotype = '5' or ljaget.othernotype = '13' )LIMIT 1) AS DZRQ,
	   -- 到账日期
(select ljaget.ConfDate from ljaget where ljaget.otherno = b.otherno and  (ljaget.othernotype = '5' or ljaget.othernotype = '13' ) LIMIT 1) AS QRRQ,
	   -- 确认日期
(select ldbank.HeadBankName from ldbank where ldbank.HeadBankCode in (select SUBSTRING_INDEX(ljaget.bankcode, '&', 1) from ljaget where  ljaget.otherno = b.otherno and (ljaget.othernotype = '5' or ljaget.othernotype = '13' ))limit 1) AS YXMC,
	   -- 银行名称
(select ljaget.BankAccNo from ljaget where ljaget.otherno = b.otherno and (ljaget.othernotype = '5' or ljaget.othernotype = '13' ) limit 1) AS YXZH,
	   -- 银行账号
(select ljaget.AccName from ljaget where ljaget.otherno = b.otherno and (ljaget.othernotype = '5' or ljaget.othernotype = '13' ) LIMIT 1) AS YXZHMC,
	   -- 银行账户名称	
'' AS ZJLX,
	   -- 证件类型
'' AS ZJHM,
	   -- 证件号码
b.otherno as LPPAH,

-- 理赔赔案号
'${data_date}' DIS_DATA_DATE
from 
ljagetclaim b
where 
b.ConfDate <='2020-12-31' GROUP BY b.otherno,b.contno,b.polno


