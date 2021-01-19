

-- 团险
select DISTINCT a.insuredno AS KHBH,
-- 客户编号
'个人客户' AS KHLB,
-- 客户类别
'被保人' AS KHSX,
-- 客户属性
a.grpcontno AS TTBDH,
-- 团体保单号
a.contno  AS GRBDH,
-- 个人保单号
'团体' AS BDTGXZ,
-- 保单团个性质
(case when c.APPFLAG='0' then '未生效' when c.APPFLAG='1' then '有效' when c.APPFLAG='4' then '终止' else '其他' end) AS BDZT,
-- 保单状态
'${data_date}' DIS_DATA_DATE
from lcinsured a,lccont c where a.grpcontno=c.grpcontno and a.contno=c.contno 
and a.grpcontno!='00000000000000000000'
and  c.signdate is not null
and c.signdate<'2021-01-01'
 /*20210105 将makedate修改为signdate*/
UNION ALL
select DISTINCT a.customerno AS KHBH,
-- 客户编号
(case when a.GrpNature in ('04') then '个人客户' when a.GrpNature in ('06','08') then '非企业组织客户'  else '企业客户' end) AS KHLB,
-- 客户类别
'投保人' AS KHSX,
-- 客户属性
a.grpcontno AS TTBDH,
-- 团体保单号
'000000' AS GRBDH,
-- 个人保单号
'团体' AS BDTGXZ,
-- 保单团个性质
(case when b.APPFLAG='0' then '未生效' when b.APPFLAG='1' then '有效' when b.APPFLAG='4' then '终止' else '其他' end) AS BDZT,
-- 保单状态
'${data_date}' DIS_DATA_DATE
from lcgrpappnt a,lcgrpcont b
where a.grpcontno=b.grpcontno
and b.signdate<'2021-01-01'
 /*20210105 将makedate修改为signdate*/
and b.signdate is not null

