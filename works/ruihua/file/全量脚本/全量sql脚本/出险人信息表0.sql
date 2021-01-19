SELECT
(select llregister.rgtobjno from llregister where  llregister.rgtno= a.caseNo and llregister.rgtobj = '1') AS BAH,
-- 报案号
b.RgtNo AS LAH,
-- 立案号
a.caseno AS PAH,
-- 赔案号
a.CustomerNo AS CXRKHBH,
-- 出险人客户编号
a.CustomerName AS CXRXM,
-- 出险人姓名
(case a.CustomerSex
	when '0' then '男性'
	when '1' then '女性'
	when '2' then '未知的性别'
end)
	CXRXB,-- 20201202 (SELECT ldcode.codename from ldcode where codetype = 'sex' and code =a.CustomerSex) AS CXRXB, 
-- 出险人性别
(SELECT ldperson.birthday from ldperson where ldperson.customerno = a.customerno) AS CXRCSRQ,
-- 出险人出生日期
(SELECT ldcode.code from ldcode where codetype = 'idtype' and code in (SELECT ldperson.idtype from ldperson where ldperson.customerno = a.customerno)) AS CXRZJLX,
-- 出险人证件类型
(SELECT ldperson.idno from ldperson where ldperson.customerno = a.customerno) AS CXRZJHM,
-- 出险人证件号码
(case a.DieFlag when 1 THEN '是' ELSE '否' END) AS SWBZ,
-- 死亡标志
a.DeathDate AS SWRQ,
-- 死亡日期
b.AccidentReason AS SWYY, -- 20201202(SELECT ldcode.codename from ldcode where codetype = 'lloccurreason' and code =b.AccidentReason) AS SWYY
'${data_date}' DIS_DATA_DATE
FROM
llcase a,llregister b
WHERE
a.caseNo = b.RgtNo
and b.endcasedate >='2017-01-01'
and b.endcasedate <='2020-12-31'
and b.clmstate in('40','50')  /* 20201231  只展示审批中、办结的案件 */

