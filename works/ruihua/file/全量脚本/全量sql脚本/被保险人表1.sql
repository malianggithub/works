

-- 团险
select  '${data_date}' DIS_DATA_DATE,
a.grpcontno AS TTBDH,
-- 团体保单号
'团体' AS BDTGXZ,
-- 保单团个性质
a.contno AS GRBDH,
-- 个人保单号
a.insuredno AS BBRKHBH,
-- 被保人客户编号
cont.managecom AS GLJGDM,
-- 管理机构代码
cont.managecom AS GLJGMC,
-- 管理机构名称
(SELECT t.Code FROM LDCode t WHERE t.CodeType ='Relation' AND t.Code = a.RelationToMainInsured) AS YZBBRGX,
-- 与主被保人关系
ifnull(a.maincustomerno,a.insuredno) AS ZBBRKHH,
-- 主被保人客户号
#团险投保人为公司
'09' AS YTBRGX,
-- 与投保人关系
ifnull(a.occupationcode,'未记录') AS ZY, -- 20201224增加未记录选项
-- 职业
(case when a.relationtomaininsured='00' then '主被保险人' else '连带被保人' end ) AS BBXRLX,
-- 被保险人类型
 (select appflag from lcpol where contno=a.contno and insuredno=a.insuredno limit 1 ) AS BBXRZT
-- 被保险人状态

/*from lcinsured a
where a.grpcontno != '00000000000000000000'
and a.makedate<'2021-01-01'
*/-- 20201229 gulaoshi 满足【被保险人表】中的“团体保单号”在【团体保单表】中存在
from lcinsured a,lcgrpcont cont
where a.grpcontno != '00000000000000000000'
and a.grpcontno = cont.grpcontno
-- and a.makedate<'2021-01-01'
/*取消a.makedate<'2021-01-01'*/
 and a.contno=(select contno from lccont cont where cont.contno=a.contno and cont.signdate<'2021-01-01' 
   union (select contno from lccont cont where cont.contno=a.contno and cont.signdate<'2021-01-01' and 
   exists (select 1 from lpedoritem lp where  lp.edortype='RR' and lp.contno=a.contno and  lp.edorvalidate<'2021-01-01')))
 /*增加signdate<'2021-01-01' ，lp.edorvalidate<'2021-01-01'*/