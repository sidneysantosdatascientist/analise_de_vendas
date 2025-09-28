COPY clientes
TO 'D:\clientes.csv'
DELIMITER ',' CSV HEADER;

COPY itens_venda
TO 'D:\itens_venda.csv'
DELIMITER ',' CSV HEADER;

COPY produtos
TO 'D:\produtos.csv'
DELIMITER ',' CSV HEADER;

COPY vendas
TO 'D:\vendas.csv'
DELIMITER ',' CSV HEADER;
