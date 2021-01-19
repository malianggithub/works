


-- 团险
select '${data_date}' DIS_DATA_DATE,
a.agentcode AS XSRYDM,
-- 销售人员代码
a.agentname AS XSRYXM,
-- 销售人员姓名
'' AS YYXSRYDM,
-- 20201208(case when b.salechnl='66' then (select BankSalerCode from lcbankcominfo where  policyno=b.grpcontno LIMIT 1) else '' end) AS YYXSRYDM,
-- 银邮销售人员代码 （lcbankcominfo 不存在 暂取空）
'' AS YYXSRYXM,
-- 20201208(case when b.salechnl='66' then (select BankSalerName from lcbankcominfo where policyno=b.grpcontno LIMIT 1) else '' end) AS YYXSRYXM,
-- 银邮销售人员姓名
a.policyno AS TTBDH,
-- 团体保单号
'团体' AS BDTGXZ,
-- 保单团个性质
b.contno AS GRBDH,
-- 个人保单号
b.managecom AS GLJGDM,
-- 管理机构代码
(select name from ldcom where comcode=b.managecom) AS GLJGMC
from lcagenttocont a,lccont b
where a.policyno=b.grpcontno
and b.grpcontno!='00000000000000000000'
and a.makedate< '2021-01-01'
and b.signdate<'2021-01-01'
/* 将b.makedate修改成signdate */
and b.signdate  is not null
and left(a.agentcode,2) not in ('WX','SH')
union -- 建工险无名单客户
select  '${data_date}' DIS_DATA_DATE,
 a.agentcode AS XSRYDM,
-- 销售人员代码
a.agentname AS XSRYXM,
-- 销售人员姓名
'' AS YYXSRYDM,
-- 20201208(case when b.salechnl='66' then (select BankSalerCode from lcbankcominfo where  policyno=b.grpcontno LIMIT 1) else '' end) AS YYXSRYDM,
-- 银邮销售人员代码 （lcbankcominfo 不存在 暂取空）
'' AS YYXSRYXM,
-- 20201208(case when b.salechnl='66' then (select BankSalerName from lcbankcominfo where policyno=b.grpcontno LIMIT 1) else '' end) AS YYXSRYXM,
-- 银邮销售人员姓名
a.policyno AS TTBDH,
-- 团体保单号
'团体' AS BDTGXZ,
-- 保单团个性质
b.contno AS GRBDH,
-- 个人保单号
b.managecom AS GLJGDM,
-- 管理机构代码
(select name from ldcom where comcode=b.managecom) AS GLJGMC
from lcagenttocont a,lccont b
where a.policyno=b.grpcontno
and b.grpcontno!='00000000000000000000'
and a.makedate< '2021-01-01'
and b.signdate<'2021-01-01'
/* 将b.makedate修改成signdate */
and b.signdate  is not null
and left(a.agentcode,2) not in ('WX','SH')
and b.contno=(select contno from lccont cont where cont.contno=b.contno and cont.signdate is null and exists (select 1 from lpedoritem lp where lp.edortype='RR' and lp.contno=cont.contno))


