-- 批量修复文化遗产数据的中文编码问题 - 第一批
SET NAMES utf8mb4;

-- 更新前20条记录
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

UPDATE heritage_info SET 
    heritage_name = '布达拉宫',
    category = '古建筑',
    era = '唐代',
    location = '西藏自治区拉萨市',
    description = '布达拉宫是西藏的象征，也是世界上海拔最高、最雄伟的宫殿。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 6;

UPDATE heritage_info SET 
    heritage_name = '莫高窟',
    category = '古遗址',
    era = '十六国至元代',
    location = '甘肃省敦煌市',
    description = '莫高窟，俗称千佛洞，坐落在河西走廊西端的敦煌。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 7;

UPDATE heritage_info SET 
    heritage_name = '泰山',
    category = '文化景观',
    era = '古代',
    location = '山东省泰安市',
    description = '泰山是中国五岳之首，世界自然与文化双重遗产。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 8;

UPDATE heritage_info SET 
    heritage_name = '黄山',
    category = '文化景观',
    era = '古代',
    location = '安徽省黄山市',
    description = '黄山以奇松、怪石、云海、温泉著称，世界自然与文化双重遗产。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 9;

UPDATE heritage_info SET 
    heritage_name = '九寨沟',
    category = '自然遗产',
    era = '古代',
    location = '四川省阿坝州',
    description = '九寨沟以翠湖、叠瀑、彩林、雪峰、藏情、蓝冰六绝著称。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 10;

UPDATE heritage_info SET 
    heritage_name = '黄龙',
    category = '自然遗产',
    era = '古代',
    location = '四川省阿坝州',
    description = '黄龙以彩池、雪山、峡谷、森林四绝著称。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 11;

UPDATE heritage_info SET 
    heritage_name = '武陵源',
    category = '自然遗产',
    era = '古代',
    location = '湖南省张家界市',
    description = '武陵源以奇峰、怪石、幽谷、秀水、溶洞五绝著称。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 12;

UPDATE heritage_info SET 
    heritage_name = '三江并流',
    category = '自然遗产',
    era = '古代',
    location = '云南省',
    description = '三江并流是指金沙江、澜沧江和怒江三条大江在云南省境内并流而过的自然奇观。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 13;

UPDATE heritage_info SET 
    heritage_name = '南方喀斯特',
    category = '自然遗产',
    era = '古代',
    location = '广西、贵州、云南',
    description = '南方喀斯特是典型的喀斯特地貌，以峰林、峰丛、溶洞、地下河为特征。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 14;

UPDATE heritage_info SET 
    heritage_name = '中国丹霞',
    category = '自然遗产',
    era = '古代',
    location = '湖南、广东、福建、江西、浙江、贵州',
    description = '中国丹霞是典型的丹霞地貌，以红色砂岩、砾岩为特征。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 15;

UPDATE heritage_info SET 
    heritage_name = '澄江化石地',
    category = '自然遗产',
    era = '古代',
    location = '云南省澄江县',
    description = '澄江化石地是寒武纪生命大爆发的重要化石产地。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 16;

UPDATE heritage_info SET 
    heritage_name = '新疆天山',
    category = '自然遗产',
    era = '古代',
    location = '新疆维吾尔自治区',
    description = '新疆天山是典型的温带干旱区山地生态系统。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 17;

UPDATE heritage_info SET 
    heritage_name = '红河哈尼梯田',
    category = '文化景观',
    era = '古代',
    location = '云南省红河州',
    description = '红河哈尼梯田是哈尼族人民创造的农业文明奇迹。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 18;

UPDATE heritage_info SET 
    heritage_name = '土司遗址',
    category = '古遗址',
    era = '古代',
    location = '湖南、湖北、贵州',
    description = '土司遗址是中国古代土司制度的实物见证。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 19;

UPDATE heritage_info SET 
    heritage_name = '左江花山岩画',
    category = '古遗址',
    era = '古代',
    location = '广西壮族自治区',
    description = '左江花山岩画是壮族先民留下的珍贵文化遗产。',
    protection_level = '世界文化遗产'
WHERE heritage_id = 20;
