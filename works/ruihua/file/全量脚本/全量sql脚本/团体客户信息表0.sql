select DISTINCT customerno AS KHBH,
-- 客户编号
Corporation AS FDDBRFZR,
-- 法定代表人/负责人
name AS TBDWMC,
-- 投保单位名称
(case when GrpNature in ('04') then '个人客户' when GrpNature in ('06','08') then '非企业组织客户'  else '企业客户' end) AS KHLB,
-- 客户类别
(select b.code from LCCustomerID a,ldcode b where a.policyno=a.grpcontno and a.customerno=a.customerno  and a.idtype=b.code and b.codetype='gidtype' and a.idflag='00' limit 1) AS JGZJLX,
-- 机构证件类型
(select c.idno from LCCustomerID c where c.policyno=a.grpcontno and c.customerno=a.customerno   and c.idflag='00' limit 1) AS JGZJHM,
-- 机构证件号码
'' ZJYXQQ,
-- 证件有效起期
(select case when c.IsLongValid  is not null then '9999-12-31' else c.enddate end from LCCustomerID c where c.policyno=a.grpcontno and c.customerno=a.customerno limit 1) AS ZJYXZQ,
-- 证件有效止期
'' QYCLRQ,
-- 企业成立日期
'' QYGMLX,
-- 企业规模类型
(select code from ldcode where codetype='grpnature' and code=a.grpnature) AS DWXZ,
-- 单位性质
(select  code from ldcode where codetype='category' and code=a.BusiCategory) AS XYFL,
-- 行业分类
'' ZCZB,
-- 注册资本
PostalAddress AS ZCDZ,
-- 注册地址
Phone AS QYDHHM,
-- 企业电话号码
(select b.linkman from lcgrplink b where b.customerno=a.customerno and grpcontno=a.grpcontno and linkmanflag='00' LIMIT 1) AS LXRXM,
-- 联系人姓名
(select b.MobilePhone from lcgrplink b where b.customerno=a.customerno and grpcontno=a.grpcontno and linkmanflag='00' LIMIT 1) AS LXRSJHM,
-- 联系人手机号码
(select b.Phone from lcgrplink b where b.customerno=a.customerno and grpcontno=a.grpcontno and linkmanflag='00' LIMIT 1) AS LXRGHHM,
-- 联系人固话号码
'否' AS CJSHTCBZ,#核心未记录统筹标志
(select c.placecode from LCGrpContactInfo b,LDAddress c where c.placetype='01' and  c.placecode=b.Province  and  b.grpcontno=a.grpcontno and b.CustomerNo=a.CustomerNo limit 1) AS DZSZS,
-- 地址所在省
(select c.placecode from LCGrpContactInfo b,LDAddress c where c.placetype='02' and  c.placecode=b.City  and  b.grpcontno=a.grpcontno and b.CustomerNo=a.CustomerNo limit 1) AS DZSZDS,
-- 地址所在地市
(select c.placecode from LCGrpContactInfo b,LDAddress c where c.placetype='03' and  c.placecode=b.County  and  b.grpcontno=a.grpcontno and b.CustomerNo=a.CustomerNo limit 1) AS DZSZQX,
-- 地址所在区县
(select b.Address from LCGrpContactInfo b where  b.grpcontno=a.grpcontno and b.CustomerNo=a.CustomerNo limit 1) AS JD,
-- 街道
'${data_date}' DIS_DATA_DATE
from lcgrpappnt a
where a.makedate<'2021-01-01'
and a.grpcontno =(select  max(grpcontno) from lcgrpappnt where customerno=a.customerno )  -- 20201224日添加
