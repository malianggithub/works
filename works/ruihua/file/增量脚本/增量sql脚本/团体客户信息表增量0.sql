select DISTINCT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
a.customerno as 'KHBH',
-- 客户编号
a.Corporation as 'FDDBRFZR',
-- 法定代表人/负责人
a.name as 'TBDWMC',
-- 投保单位名称
(case when GrpNature in ('04') then '个人客户' when GrpNature in ('06','08') then '非企业组织客户'  else '企业客户' end) as 'KHLB',
-- 客户类别
(select b.codename from LCCustomerID c,ldcode b where c.policyno=a.grpcontno and c.customerno=a.customerno  and c.idtype=b.code and b.codetype='gidtype' and c.idflag='00' limit 1) as  'JGZJLX',
-- 机构证件类型
(select c.idno from LCCustomerID c where c.policyno=a.grpcontno and c.customerno=a.customerno   and c.idflag='00' limit 1) as 'JGZJHM',
-- 机构证件号码
'' ZJYXQQ,
-- 证件有效起期
(select case when c.IsLongValid  is not null then '9999-12-31' else c.enddate end from LCCustomerID c where c.policyno=a.grpcontno and c.customerno=a.customerno limit 1) as 'ZJYXQQ',
-- 证件有效止期
'' QYCLRQ,
-- 企业成立日期
'' QYGMLX,
-- 企业规模类型
(select  codename from ldcode where codetype='grpnature' and code=a.grpnature) as 'DWXZ',
-- 单位性质
(select  codename from ldcode where codetype='category' and code=a.BusiCategory) as 'XYFL',
-- 行业分类
'' ZCZB,
-- 注册资本
a.PostalAddress as 'ZCDZ',
-- 注册地址
a.Phone as 'QYDHHM',
-- 企业电话号码
(select b.linkman from lcgrplink b where b.customerno=a.customerno and grpcontno=a.grpcontno and linkmanflag='00' LIMIT 1) as 'LXRXM',
-- 联系人姓名
(select b.MobilePhone from lcgrplink b where b.customerno=a.customerno and grpcontno=a.grpcontno and linkmanflag='00' LIMIT 1) as 'LXRSJHM',
-- 联系人手机号码
(select b.Phone from lcgrplink b where b.customerno=a.customerno and grpcontno=a.grpcontno and linkmanflag='00' LIMIT 1) as 'LXRGHHM',
-- 联系人固话号码
'否' as 'CJSHTCBZ',#核心未记录统筹标志
-- 参加社会统筹标志
(select c.placename from LCGrpContactInfo b,LDAddress c where c.placetype='01' and  c.placecode=b.Province  and  b.grpcontno=a.grpcontno and b.CustomerNo=a.CustomerNo limit 1) as 'DZSZS',
-- 地址所在省
(select c.placename from LCGrpContactInfo b,LDAddress c where c.placetype='02' and  c.placecode=b.City  and  b.grpcontno=a.grpcontno and b.CustomerNo=a.CustomerNo limit 1) as 'DZSZDS',
-- 地址所在地市
(select c.placename from LCGrpContactInfo b,LDAddress c where c.placetype='03' and  c.placecode=b.County  and  b.grpcontno=a.grpcontno and b.CustomerNo=a.CustomerNo limit 1) as 'DZSZQX',
-- 地址所在区县
(select b.Address from LCGrpContactInfo b where  b.grpcontno=a.grpcontno and b.CustomerNo=a.CustomerNo limit 1) as 'JD'
-- 街道
from lcgrpappnt a
where 
 a.grpcontno =(select  max(grpcontno) from lcgrpappnt where customerno=a.customerno )
 and EXISTS(select  1 from lpgrpedoritem where grpcontno=a.grpcontno and edortype in ('AC') and edorstate='0' and modifydate=DATE_SUB('${data_date}',INTERVAL 1 day))
