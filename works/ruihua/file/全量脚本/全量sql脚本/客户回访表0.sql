-- 个险
-- 客户回访表
SELECT a.ContNo AS GRBDH,
		-- 个人保单号
       c.VisitNo AS HFSXH,
	   -- 回访顺序号
	(CASE WHEN a.salechnl='11' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '3' THEN '122'  WHEN '4' THEN '272' END)
     WHEN a.salechnl='33' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '2' THEN '230' END) 
     WHEN a.salechnl='09' THEN (CASE (SELECT agentkind FROM laagent  WHERE AGENTCODE = a.AGENTCODE) WHEN '1' THEN '111' when '2' then '210' ELSE NULL END) ELSE a.salechnl END) AS XSQD,
 --      (SELECT Code FROM LDCode WHERE CodeType = 'SaleChnl' AND Code = a.SaleChnl) AS XSQD,
	   -- 销售渠道
       a.ManageCom AS GLJGDM,
	   -- 管理机构代码
       (SELECT t.Name FROM LDCom t WHERE t.ComCode = a.ManageCom) AS GLJGMC,
	   -- 管理机构名称
       a.AppntNo AS TBRKHBH,
	   -- 投保人客户编号
	   (IF(c.VisitType = '电话回访','电话回访','电子回访')) as HFLX,
       -- 2020-12-08:(case c.VisitType when '在线回访' then '?' end)  AS HFLX,
	   -- 回访类型
       (IF(c.VisitType = '电话回访',(SELECT d.Phone FROM LCAppnt c,LCAddress d WHERE c.ContNo = a.ContNo AND c.AppntNo = d.CustomerNo AND c.AddressNo = d.AddressNo),'')) AS HFDH,
	   -- 回访电话
       a.PolApplyDate AS TBDSQRQ,
	   -- 投保单申请日期
       a.SignDate AS QDRQ,
	   -- 签单日期
       a.CValiDate AS BDSXRQ,
	   -- 保单生效日期
       a.CustomGetPolDate AS BDHZKHQSRQ,
	   -- 保单回执客户签收日期
       c.VisitTime AS HFRQ,
	   -- 回访日期
       IF(b.RiskCode IN ('CT1001','CT1002','CT1003','CT1004','CT1005','CT1006','CT1009','CT1010','ST1001'),
           0,IFNULL((SELECT HesitateEnd FROM LMEdorWT WHERE HesitateFlag = 'Y' AND RiskCode = b.RiskCode),0)) AS YYQTS,
		   -- 犹豫期天数
       IF(b.RiskCode IN ('CT1001','CT1002','CT1003','CT1004','CT1005','CT1006','CT1009','CT1010','ST1001'),
          '9999-12-31',DATE_ADD(a.CustomGetPolDate, INTERVAL IFNULL((SELECT HesitateEnd FROM LMEdorWT WHERE HesitateFlag = 'Y' AND RiskCode = b.RiskCode),0) DAY))  AS YYQJZRQ,
		  -- 犹豫期截止日期
       IF(b.RiskCode IN ('CT1001','CT1002','CT1003','CT1004','CT1005','CT1006','CT1009','CT1010','ST1001'),
          '是',IF(DATEDIFF(c.VisitTime,a.CustomGetPolDate) > IFNULL((SELECT HesitateEnd FROM LMEdorWT WHERE HesitateFlag = 'Y' AND RiskCode = b.RiskCode),0),'否','是')) AS YYQNHFBZ,
		  -- 犹豫期内回访标志
       IF(c.VisitResult = '健康完成件','是','否') AS HFCGBZ,
	   -- 回访成功标志
'${data_date}' DIS_DATA_DATE
FROM LCCont a left join (select agentcom,AngencyType,name from lacom) com on com.agentcom=a.agentcom,LCPol b,VisitResultToCenter c

WHERE a.GrpContNo = '00000000000000000000'
  AND a.ContNo = b.ContNo AND b.PolNo = b.MainPolNo AND b.InsuredNo = a.InsuredNo
  AND a.ContNo = c.ContNo
  AND c.MakeDate < '2021-01-01'
  and a.AppntNo in (select  AppntNo  from LCAppnt where AppntNo=a.AppntNo and  makedate<'2021-01-01') 
  /* 20210101 排除不在集中采集范围内的被保人信息   */
  and a.signdate is not null
 and a.signdate < '2021-01-01'
Group by c.Contno,c.VisitNo











