delete from article_search 
where ticket_id in (select idt from delticket);

delete from article_flag
where article_id in (select id from article
                     where ticket_id in (select idt from delticket));

delete from article_plain
where article_id in (select id from article where ticket_id in (select idt from delticket));

delete from article_attachment
where article_id in (select id from article where ticket_id in (select idt from delticket));

delete from article
where ticket_id in (select idt from delticket);

delete from ticket_watcher
where  ticket_id in (select idt from delticket);

delete from ticket_lock_index
where  ticket_id in (select idt from delticket);

delete from time_accounting
where  ticket_id in (select idt from delticket);

delete from ticket_history
where ticket_id in (select idt from delticket);

delete from ticket
where id in (select idt from delticket);