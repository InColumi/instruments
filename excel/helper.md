
Позволяет получить сумму динамичным строк

`=sum(INDIRECT("A1:A"&ROW()-1))`

=SUM(INDIRECT("B24:" & CHAR(COLUMN()+63) & "24"))