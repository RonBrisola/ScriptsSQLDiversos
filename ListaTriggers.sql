SELECT      t.[name], o.name  
FROM        sys.objects     AS t
INNER JOIN  sys.syscomments AS c ON t.object_id = c.id
INNER JOIN  sys.objects     As o ON o.object_id = t.parent_object_id
WHERE   t.[type] = 'TR'
ORDER BY o.name



SELECT      '/*----- ' + o.name + ': ' + t.[name] + '---------------------------------------- */' + char(13) + char(13) +
            'IF EXISTS(SELECT name FROM sysobjects WHERE name = ''' + t.[name] + ''') ' + char(13) +
            '   DROP TRIGGER ' + t.[name] + char(13) +
            'GO' + char(13) + char(13) +
            c.[text] +
            char(13) + 'GO' + char(13)
FROM        sys.objects     AS t
INNER JOIN  sys.syscomments AS c ON t.object_id = c.id
INNER JOIN  sys.objects     As o ON o.object_id = t.parent_object_id
WHERE   t.[type] = 'TR'
ORDER BY o.name



name                                                                                                                             name
-------------------------------------------------------------------------------------------------------------------------------- --------------------------------------------------------------------------------------------------------------------------------
trg_CanctoTituloDevComprasRV                                                                                                     TBCOMP022
ins_upTBCOMP057                                                                                                                  TBCOMP057
delTBCOMP057                                                                                                                     TBCOMP057
ins_upTBCOMP058                                                                                                                  TBCOMP058
delTBCOMP058                                                                                                                     TBCOMP058
trg_InsereRV                                                                                                                     TBCTRC001
trgINS_TBCTRC002_NumDocBoleto                                                                                                    TBCTRC002
trg_InsereParcelaRV                                                                                                              TBCTRC002
trg_CanctoTituloRV                                                                                                               TBFATU024
trg_TBFATU071_Historico_Orcamento                                                                                                TBFATU071
trg_TBFATU072_Historico_Orcamento                                                                                                TBFATU072
ins_upTBFATU115_v1                                                                                                               TBFATU115
ins_upTBFATU115                                                                                                                  TBFATU115
delTBFATU115                                                                                                                     TBFATU115


