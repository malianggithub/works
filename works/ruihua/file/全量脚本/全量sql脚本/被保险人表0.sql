-- 个险
-- 被保险人表
SELECT 
'${data_date}' DIS_DATA_DATE,
 '' AS TTBDH,
-- 团体保单号
       '个人' AS BDTGXZ,
	   -- 保单团个性质
       a.ContNo AS GRBDH,
	   -- 个人保单号
       b.InsuredNo AS BBRKHBH,
	   -- 被保人客户编号
       a.ManageCom AS GLJGDM,
	   -- 管理机构代码
       (SELECT t.Name FROM LDCom t WHERE t.ComCode = a.ManageCom) AS GLJGMC,
	   -- 管理机构名称
       (SELECT t.Code FROM LDCode t WHERE t.CodeType ='Relation' AND t.Code = b.RelationToMainInsured) AS YZBBRGX,
	   -- 与主被保人关系
       a.InsuredNo AS ZBBRKHH,
	   -- 主被保人客户号
       (SELECT t.Code FROM LDCode t WHERE t.CodeType ='Relation' AND t.Code = b.RelationToAppnt) AS YTBRGX,
	   -- 与投保人关系
       ifnull(b.occupationcode,'未记录') AS ZY, -- 20201224增加未记录选项
	   -- 职业
       (IF(b.RelationToMainInsured = '00','主被保险人','连带被保人')) AS BBXRLX,
	   -- 被保险人类型
       '1' AS BBXRZT
/*FROM LCCont a,
     LCInsured b
WHERE a.GrpContNo = '00000000000000000000'
  AND a.ContNO = b.ContNo
  AND a.AppFlag IN ('1', '4','0')
  AND b.MakeDate < '2021-01-01'*/-- 20201229 gulaoshi 满足【被保险人表】中的“个人保单号”在【个人保单表】中存在
  FROM LCCont a,
     LCInsured b
WHERE a.GrpContNo = '00000000000000000000'
  AND a.ContNO = b.ContNo
  AND a.AppFlag IN ('1', '4','0')
  and a.contno=(select contno from lccont cont where cont.contno=a.contno and cont.signdate<'2021-01-01')
 -- AND b.MakeDate < '2021-01-01' 
  /*20210108 取消 b.MakeDate < '2021-01-01'*/

