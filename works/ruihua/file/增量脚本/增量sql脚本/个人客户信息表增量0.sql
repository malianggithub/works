-- 个人客户信息
SELECT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
a.AppntNo AS KHBH,
-- 客户编号
       a.AppntName AS XM,
	   -- 姓名
       (case (SELECT CodeName FROM LDCode WHERE CodeType = 'Sex' AND Code = a.AppntSex) 
				when '男' then '男性'
				when '女' then '女性'
				else '未说明的性别' end ) as XB,
	   -- 性别
       a.AppntBirthday AS CSRQ,
	   -- 出生日期
       (SELECT Code FROM LDCode WHERE CodeType = 'IdType' AND Code = a.IdType) AS ZJLX,
	   -- 证件类型
       a.IDNo AS ZJHM,
	   -- 证件号码
       '' AS ZJYXQQ,
	   -- 证件有效起期
       IF(a.ISLongValid = '1','9999-12-31',a.IDExpDate) AS ZJYXZQ,
	   -- 证件有效止期
       a.OccupationCode AS ZY,
	   -- 职业
       (SELECT Code FROM LDCode WHERE CodeType = 'NativePlace' AND Code = a.NativePlace) AS GJ,
	   -- 国籍
       (SELECT Code FROM LDCode WHERE CodeType = 'Marriage' AND Code = a.Marriage) AS HYZK,
	   -- 婚姻状况 ',
       b.Phone AS YDDH,
	   -- 移动电话
       b.Mobile AS GDDH,
	   -- 固定电话
       b.Email AS DZYX,
	   -- 电子邮箱
       '' AS XL,
	   -- 学历
       a.Pretax AS GRNSR,
	   -- 个人年收入
       IFNULL(b.Province,'000000') AS DZSZS,
	   -- 地址所在省
       IFNULL(b.City,'000000') AS DZSZDS,
	   -- 地址所在地市
       IFNULL(b.County,'000000') AS DZSZQX,
	   -- 地址所在区县
       b.PostalAddress AS JD
	   -- 街道
FROM LCAppnt a,LCAddress b
WHERE a.AppntNo = b.CustomerNo AND a.GrpContNo = '00000000000000000000'
  AND a.AddressNo = b.AddressNo
  AND (1=2
      OR DATEDIFF('${data_date}', a.MakeDate) = 1
      OR DATEDIFF('${data_date}', b.MakeDate) = 1
      OR EXISTS(SELECT 1 FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType IN ('AC','AM','CM') AND EdorState = '0' AND DATEDIFF('${data_date}', EdorValiDate) = 1)
      )
UNION
SELECT DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
a.InsuredNo AS KHBH,
-- 客户编号
       a.Name AS XM,
	   -- 姓名
       (case (SELECT CodeName FROM LDCode WHERE CodeType = 'Sex' AND Code = a.Sex) 
				when '男' then '男性'
				when '女' then '女性'
				else '未说明的性别' end ) as XB,
	   -- 性别
       a.Birthday AS CSRQ,
	   -- 出生日期
       (SELECT CodeName FROM LDCode WHERE CodeType = 'IdType' AND Code = a.IdType) AS ZJLX,
	   -- 证件类型
       a.IDNo AS ZJHM,
	   -- 证件号码
       '' AS ZJYXQQ,
	   -- 证件有效起期
       IF(a.ISLongValid = '1','9999-12-31',a.IDExpDate) AS ZJYXZQ,
	   -- 证件有效止期
       a.OccupationCode AS ZY,
	   -- 职业
       (SELECT CodeName FROM LDCode WHERE CodeType = 'NativePlace' AND Code = a.NativePlace) AS GJ,
	   -- 国籍
       IFNULL((SELECT CodeName FROM LDCode WHERE CodeType = 'Marriage' AND Code = a.Marriage),'未说明的婚姻状况') AS HYZK,
	   -- 婚姻状况
       b.Phone AS YDDH,
	   -- 移动电话
       b.Mobile AS GDDH,
	   -- 固定电话
       b.Email AS DZYX,
	   -- 电子邮箱
       '' AS XL,
	   -- 学历
       a.Pretax AS GRNSR,
	   -- 个人年收入
       IFNULL(b.Province,'000000') AS DZSZS,
	   -- 地址所在省
       IFNULL(b.City,'000000') AS DZSZDS,
	   -- 地址所在地市
       IFNULL(b.County,'000000') AS DZSZQX,
	   -- 地址所在区县
       b.PostalAddress AS JD
	   -- 街道
FROM LCInsured a,LCAddress b
WHERE a.InsuredNo = b.CustomerNo AND a.GrpContNo = '00000000000000000000'
  AND a.AddressNo = b.AddressNo
  AND (1=2
    OR DATEDIFF('${data_date}', a.MakeDate) = 1
    OR DATEDIFF('${data_date}', b.MakeDate) = 1
    OR EXISTS(SELECT 1 FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType IN ('AM','CM') AND EdorState = '0' AND DATEDIFF('${data_date}', EdorValiDate) = 1)
    )


union all

select  DISTINCT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
 insuredno AS KHBH,
-- 	客户编号
name AS XM,
	   -- 姓名
(case when sex='1' then '女性' when sex='0' then '男性' else '未说明的性别' end ) AS XB,
	   -- 性别
birthday AS CSRQ,
	   -- 出生日期
(select code from ldcode where codetype='idtype' and code=a.idtype) AS ZJLX,
	   -- 证件类型
idno AS ZJHM,
	   -- 证件号码
'' AS ZJYXQQ,
	   -- 证件有效起期
(case when a.IsLongValid  is not null then '9999-12-31' else a.IDExpDate end) AS ZJYXZQ,
	   -- 证件有效止期
(select  occupationcode  from ldoccupation where occupationcode=a.occupationcode) AS ZY,
	   -- 职业
(select code from ldcode where codetype='nativeplace' and  code=a.nativeplace) AS GJ,
	   -- 国籍
#团险被保人客户系统不录
'' AS HYZK,
	   -- 婚姻状况
(select b.Mobile1 from  LCCustomerContactInfo b where b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS YDDH,
	   -- 移动电话
(select b.Phone from  LCCustomerContactInfo b where b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS GDDH,
	   -- 固定电话
(select b.EMail1 from LCCustomerContactInfo b where b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS DZYX,
	   -- 电子邮箱
#团险客户系统不录学历
'' AS XL,
	   -- 学历
ifnull(Salary*12,'') AS GRNSR,
	   -- 个人年收入
(select b.province from LCCustomerContactInfo b where  b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS DZSZS,
	   -- 地址所在省
(select b.city from LCCustomerContactInfo b where  b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS DZSZDS,
	   -- 地址所在地市
(select b.county from LCCustomerContactInfo b where   b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS DZSZQX,
	   -- 地址所在区县
(select PostalAddress from   LCCustomerContactInfo where policyno=a.grpcontno and CustomerNo=a.insuredno limit 1) AS JD
	   -- 街道
from lcinsured a where a.grpcontno != '00000000000000000000'
and a.makedate<'2021-01-01'
and a.contno=(select  max(b.contno) from lcinsured b where  b.insuredno=a.insuredno and grpcontno!='00000000000000000000')
and  not EXISTS(select 1 from lcinsured where insuredno=a.insuredno and grpcontno='00000000000000000000')
and EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and insuredno=a.insuredno and contno=a.contno and  edortype in ('NI','RR','BB','IC') and edorstate='0' and modifydate=DATE_SUB('${data_date}',INTERVAL 1 day))

