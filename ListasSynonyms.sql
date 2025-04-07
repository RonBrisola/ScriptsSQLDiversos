select --name, base_object_name,
       '/*----- ' + name + ': ' + base_object_name + '---------------------------------------- */' + char(13) + char(13) +
       'IF EXISTS (select name from sys.synonyms where name = ''' + name + ''')' + char(13) +
       '   DROP SYNONYM ' + name + char(13) +
       'GO' + char(13) +
       'CREATE SYNONYM ' + name + char(13) +
       'FOR ' + base_object_name + char(13) +
       'GO'   + char(13)  AS COMANDO
from sys.synonyms 
order by name
