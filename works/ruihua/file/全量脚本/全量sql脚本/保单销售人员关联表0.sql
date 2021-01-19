-- 个险
-- 保单销售人员关联表
SELECT  '${data_date}' DIS_DATA_DATE,
b.AgentCode AS XSRYDM,
-- 销售人员代码
       b.Name AS XSRYXM,
-- 销售人员姓名
       IF(a.ContSource = 'Y' OR a.ContSource = 'YF', a.AgentBankCode ,'') AS YYXSRYDM,
-- 银邮销售人员代码
       IF(a.ContSource = 'Y' OR a.ContSource = 'YF', a.BankAgent,'') AS YYXSRYXM,
-- 银邮销售人员姓名
       '000000' AS TTBDH,
-- 团体保单号
       '个人' AS BDTGXZ,
-- 保单团个性质
       a.ContNo AS GRBDH,
-- 个人保单号
       a.ManageCom AS GLJGDM,
-- 管理机构代码
       (SELECT t.Name FROM LDCom t WHERE t.ComCode = a.ManageCom) AS GLJGMC
/*FROM LCCont a,LAAgent b
WHERE a.GrpContNo = '00000000000000000000'
  AND b.AgentCode = a.AgentCode
  AND b.MakeDate < '2021-01-01'
  AND a.MakeDate < '2021-01-01'
 and a.signdate is not null
 */-- 20201229 gulaoshi 去除虚拟销售人员
FROM LCCont a,(select * from laagent where  left(agentcode, 2)not in ('WX','SH')) b
WHERE a.GrpContNo = '00000000000000000000'
  AND b.AgentCode = a.AgentCode
  AND b.MakeDate < '2021-01-01'
  AND a.signdate< '2021-01-01'
/* 将b.makedate修改成signdate */
  and a.signdate is not null

