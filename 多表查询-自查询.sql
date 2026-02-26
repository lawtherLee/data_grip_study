select * from areas where pid = 140000;

# 根据身份证前6位查家乡
select
    province.id 省编码,
    province.title 省,
    city.id 市编码,
    city.title 市,
    county.id 区县编码,
    county.title 区县
from areas county
         join areas city on county.pid = city.id
         join areas province on city.pid = province.id
where county.id = '110104';
