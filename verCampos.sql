DECLARE @tabela varchar(60),
        @Pesqtabela varchar(60)

SET @tabela = 'TBCOMP%'

SELECT CAST(OBJECT_NAME(object_id) AS VARCHAR(30)) AS Tabela,
       CAST(name AS VARCHAR(50)) AS Campo,
       column_id,
       CAST(TYPE_NAME(system_type_id) AS VARCHAR(15)) AS Tipo,
       case system_type_id 
            when 106 then precision + (cast(scale as float)  /100)
            when 108 then precision + (cast(scale as float)  /100)
            --when  62 then precision + (cast(scale as float)  /100)
            else max_length 
        end as Tamanho,
        precision
   FROM sys.all_columns
where OBJECT_NAME(object_id) like @tabela
ORDER BY 1, 3


                system_type_id
--------------- --------------
smalldatetime               58
float                       62
datetime                    61
varchar                    167
char                       175
text                        35
varbinary                  165
numeric                    108
decimal                    106
smallint                    52
int                         56
