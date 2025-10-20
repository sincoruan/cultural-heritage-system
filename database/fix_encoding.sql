-- 修复数据库中文编码问题
SET NAMES utf8mb4;

-- 更新前几条记录的编码
UPDATE heritage_info SET 
    heritage_name = '故宫博物院',
    category = '古建筑',
    era = '明清',
    location = '北京市东城区',
    description = '故宫博物院位于北京市中心，是中国明清两代的皇家宫殿，旧称紫禁城。故宫是世界上现存规模最大、保存最为完整的木质结构古建筑之一，被誉为世界五大宫之首。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 1;

UPDATE heritage_info SET 
    heritage_name = '长城',
    category = '古建筑',
    era = '春秋战国至明清',
    location = '北京、河北、山西等',
    description = '长城是中国古代的军事防御工程，是一道高大、坚固的长墙，用来抵御外敌的入侵。长城不是一道单纯孤立的城墙，而是以城墙为主体，同大量的城、障、亭、标相结合的防御体系。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 2;

UPDATE heritage_info SET 
    heritage_name = '兵马俑',
    category = '古遗址',
    era = '秦代',
    location = '陕西省西安市',
    description = '秦始皇帝陵兵马俑，位于陕西省西安市临潼区秦始皇帝陵以东1.5公里处的兵马俑坑，是秦代陶俑的一个类别，制作兵马（战车、战马、士兵）形状的陶俑。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 3;

UPDATE heritage_info SET 
    heritage_name = '天坛',
    category = '古建筑',
    era = '明清',
    location = '北京市东城区',
    description = '天坛是明清两代皇帝祭天、祈谷的场所，世界文化遗产。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 4;

UPDATE heritage_info SET 
    heritage_name = '颐和园',
    category = '古建筑',
    era = '清代',
    location = '北京市海淀区',
    description = '颐和园是中国清朝时期的皇家园林，世界文化遗产。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 5;
