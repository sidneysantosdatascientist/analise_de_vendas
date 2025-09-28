-- No seu PostgreSQL, execute estas queries para exportar os dados

-- Exportar clientes
COPY (SELECT * FROM clientes) TO '/tmp/clientes.csv' WITH CSV HEADER;

-- Exportar produtos  
COPY (SELECT * FROM produtos) TO '/tmp/produtos.csv' WITH CSV HEADER;

-- Exportar vendas
COPY (SELECT * FROM vendas) TO '/tmp/vendas.csv' WITH CSV HEADER;

-- Exportar itens_venda
COPY (SELECT * FROM itens_venda) TO '/tmp/itens_venda.csv' WITH CSV HEADER;