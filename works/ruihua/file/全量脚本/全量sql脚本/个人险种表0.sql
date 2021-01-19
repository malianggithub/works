-- 个险
-- 个人险种表
SELECT '${data_date}' DIS_DATA_DATE,
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
				WHEN (b.PayIntv = 12 AND b.RiskCode='HT1008') then b.FirstPayDate /*20201230 gulaoshi*/
				WHEN (b.PayIntv = 12 AND EXISTS(select 1 from LMRiskApp where RiskCode = b.RiskCode and RiskPeriod in ('M','S'))) then b.FirstPayDate -- 20201230 gulaoshi
                WHEN b.PayIntv <> '0' AND b.PaytoDate = b.PayEndDate THEN DATE_SUB(b.PaytoDate, INTERVAL b.PayIntv MONTH)
                WHEN b.PayIntv <> '0' AND b.PaytoDate < b.PayEndDate THEN b.PaytoDate END) AS JZRQ,
-- 交至日期
       DATE_SUB(b.EndDate,INTERVAL 1 DAY) AS BXZRZZRQ1,
-- 保险责任终止日期
       (case when a.payintv='0' then '趸交' when a.payintv='1' then '月交' when a.payintv='3' then '季交' when a.payintv='6' then '半年交'  when  a.payintv='12' then '年交' when a.payintv='-1' then '不定期交费' else '其他' end)  AS JFJG, -- 交费间隔
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
       ifnull((SELECT SUM(SumActuPayMoney) FROM LJAPayPerson WHERE ContNO = b.ContNo AND PolNo = b.PolNo),0) AS LJBF,
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

FROM LCCont a,
     LCPol b
WHERE a.GrpContNo = '00000000000000000000'
  AND a.ContNO = b.ContNo
  AND a.AppFlag in ('1','4','0')
 -- AND a.MakeDate < '2021-01-01'
  AND  a.signdate < '2021-01-01' /*20210105 将makedate修改为signdate*/
  AND b.UWFlag not in ('1','2')

and a.signdate is not null

