exec sp_generate_inserts TBFATU024, 
                         @from = "from tbfatu024 where CODEMP = '02' AND sernf = '10'" --, @debug_mode =1

exec sp_generate_inserts TBFATU025, 
                         @from = "from tbfatu025 where CODEMP = '02' AND sernf = '10'"
                        ,@cols_to_exclude= "''NUMNFCOMPRAIND'',''SERNFCOMPRAIND'',''CODFORNCOMPRAIND'',''NUMITEMNFCOMPRAIND''"  

exec sp_generate_inserts TBFATU055, 
                         @from = "from tbfatu055 where CODEMP = '02' AND sernf = '10'" 

exec sp_generate_inserts TBFRCX006, 
                         @from = "from TBFRCX006 WHERE CODEMP = '02' AND NUMVENDA IN (SELECT NUMVENDA FROM TBFATU024 where CODEMP = '02' AND sernf = '10')" 

exec sp_generate_inserts TBFRCX007, 
                         @from = "from TBFRCX007 WHERE CODEMP = '02' AND NUMVENDA IN (SELECT NUMVENDA FROM TBFATU024 where CODEMP = '02' AND sernf = '10')" 

exec sp_generate_inserts TBFRCX008, 
                         @from = "from TBFRCX008 WHERE CODEMP = '02' AND NUMVENDA IN (SELECT NUMVENDA FROM TBFATU024 where CODEMP = '02' AND sernf = '10')" 

exec sp_generate_inserts TBFRCX009, 
                         @from = "from TBFRCX009 WHERE CODEMP = '02' AND NUMVENDA IN (SELECT NUMVENDA FROM TBFATU024 where CODEMP = '02' AND sernf = '10')" 


