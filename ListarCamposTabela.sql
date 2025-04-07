select c.name, 
       t.type, 
       c.length, 
       c.status, 
        t.name, c.prec, c.scale 
from syscolumns c, systypes t where c.id = object_id ('dbo.TBCOMP002') and c.usertype = t.usertype order by 
colid ASC 
