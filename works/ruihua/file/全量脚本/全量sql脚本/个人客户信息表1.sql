

select DISTINCT '${data_date}' DIS_DATA_DATE,
insuredno AS KHBH,
--	客户编号
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
ifnull((select  occupationcode  from ldoccupation where occupationcode=a.occupationcode),'未记录') AS ZY, -- 20201224职业增加未记录判断
	   -- 职业
ifnull((select code from ldcode where codetype='nativeplace' and  code=a.nativeplace),'未记录') AS GJ, -- 20201224国籍增加未记录判断
	   -- 国籍
#团险被保人客户系统不录
'未说明的婚姻状况' AS HYZK,
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
ifnull((select b.province from LCCustomerContactInfo b where  b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1),'000000') AS DZSZS, -- 20201224地址所在省增加未记录判断
	   -- 地址所在省
ifnull((select b.city from LCCustomerContactInfo b where  b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1),'000000')AS DZSZDS, -- 20201224地址所在地市增加未记录判断
	   -- 地址所在地市
ifnull((select b.county from LCCustomerContactInfo b where   b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1),'000000') AS DZSZQX, -- 20201224地址所在区县增加未记录判断
	   -- 地址所在区县
ifnull((select PostalAddress from   LCCustomerContactInfo where policyno=a.grpcontno and CustomerNo=a.insuredno limit 1),'000000') AS JD
	   -- 街道  -- 20201224街道增加未记录判断
from lcinsured a where a.grpcontno != '00000000000000000000'
-- and a.makedate<'2021-01-01'
and a.contno=(select  max(b.contno) from lcinsured b where  b.insuredno=a.insuredno and grpcontno!='00000000000000000000' and makedate<'2021-01-01')

/* 20210101  增加排除不在集中采集范围内的数据  */
-- and  not EXISTS(select 1 from lcinsured where insuredno=a.insuredno and grpcontno='00000000000000000000')
-- and  a.contno=(select  max(b.contno) from lcinsured b where  b.insuredno=a.insuredno and grpcontno!='00000000000000000000')  
-- 20201224增加
-- and  not EXISTS(select 1 from lcinsured where insuredno=a.insuredno and grpcontno='00000000000000000000')
/* 20210108  增加判断  */
and  not EXISTS(select 1 from lcinsured lc where lc.insuredno=a.insuredno and lc.grpcontno='00000000000000000000' 
 and lc.contno in (select  cont.contno from   lccont cont where cont.contno=lc.contno and cont.signdate<'2021-01-01')

)






