--  个险
-- 个人客户信息
SELECT '${data_date}' DIS_DATA_DATE,
a.AppntNo AS KHBH,
--	客户编号
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
       ifnull(a.OccupationCode,'未记录') AS ZY,
	   -- 20201224 增加未记录选项
	   -- 职业
       ifnull((SELECT Code FROM LDCode WHERE CodeType = 'NativePlace' AND Code = a.NativePlace),'未记录') AS GJ, 
	   -- 20201224 增加未记录选项
	   -- 国籍
       ifnull((SELECT Code FROM LDCode WHERE CodeType = 'Marriage' AND Code = a.Marriage),'未说明的婚姻状况') AS HYZK, 
	   -- 20201224 增加未说明的婚姻状况选项
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
        IFNULL(b.PostalAddress,'000000') AS JD
FROM LCAppnt a,LCAddress b
WHERE a.AppntNo = b.CustomerNo AND a.GrpContNo = '00000000000000000000'
  AND a.AddressNo = b.AddressNo
 -- AND a.MakeDate < '2021-01-01'
 -- AND b.MakeDate < '2021-01-01'
  AND a.contno =(SELECT
		max(b.contno)
	FROM
		lcappnt b,lccont c
	WHERE
		b.appntno = a.AppntNo
	--	and b.appntno = c.AppntNo 
		and c.contno = b.contno
		and  c.signdate < '2021-01-01'
	-- AND a.makedate < '2021-01-01'
)
-- 20201224 增加
/* AND NOT EXISTS (
	SELECT
		1
	FROM
		lcinsured
	WHERE
		insuredno = a.appntno
) */ -- 20210108 修改
AND NOT EXISTS (
	SELECT
		1
	FROM
		lcinsured lc
	WHERE
		lc.insuredno = a.appntno
		and lc.contno in 
		(select  cont.contno from   lccont cont where cont.contno=lc.contno and cont.signdate<'2021-01-01')
)
-- 20201224 增加
UNION
SELECT '${data_date}' DIS_DATA_DATE,
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
       IFNULL(a.OccupationCode,'未记录') AS ZY,
	    -- 20201224 增加未记录选项
	   -- 职业
       IFNULL((SELECT CodeName FROM LDCode WHERE CodeType = 'NativePlace' AND Code = a.NativePlace),'未记录') AS GJ,
	    -- 20201224 增加未记录选项
	   -- 国籍
       IFNULL((SELECT CodeName FROM LDCode WHERE CodeType = 'Marriage' AND Code = a.Marriage),'未说明的婚姻状况') AS HYZK,
	    -- 20201224 增加未说明的婚姻状况选项
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
       IFNULL(b.PostalAddress,'000000') AS JD
FROM LCInsured a,LCAddress b
WHERE a.InsuredNo = b.CustomerNo AND a.GrpContNo = '00000000000000000000'
  AND a.AddressNo = b.AddressNo
  -- AND a.MakeDate < '2021-01-01'
  -- AND b.MakeDate < '2021-01-01'
  AND a.contno = (  
	SELECT
		max(c.contno)
	FROM
		lcinsured c,lccont b
	WHERE
		c.insuredno = a.InsuredNo
		and b.contno = c.contno
	--	and c.insuredno = b.insuredno
		and  b.signdate < '2021-01-01'
	-- AND a.makedate < '2021-01-01'
)

