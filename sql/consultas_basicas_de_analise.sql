-- Consultas Básicas de Análise


-- 1.1. Total de vendas e valor total por mês
SELECT 
    EXTRACT(YEAR FROM data_venda) AS ano,
    EXTRACT(MONTH FROM data_venda) AS mes,
    COUNT(*) AS total_vendas,
    SUM(total_venda) AS valor_total,
    ROUND(AVG(total_venda), 2) AS ticket_medio
FROM vendas
GROUP BY ano, mes
ORDER BY ano, mes;

-- 1.2. Vendas por categoria de produto
SELECT 
    p.categoria,
    COUNT(iv.item_id) AS total_itens,
    SUM(iv.quantidade) AS total_quantidade,
    SUM(iv.total_item) AS valor_total,
    ROUND(SUM(iv.total_item) / SUM(iv.quantidade), 2) AS preco_medio
FROM itens_venda iv
JOIN produtos p ON iv.produto_id = p.produto_id
GROUP BY p.categoria
ORDER BY valor_total DESC;

-- 1.3. Top 10 produtos mais vendidos
SELECT 
    p.produto_id,
    p.nome,
    p.categoria,
    SUM(iv.quantidade) AS total_vendido,
    SUM(iv.total_item) AS valor_total_vendido,
    ROUND(SUM(iv.total_item) / SUM(iv.quantidade), 2) AS preco_medio
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.nome, p.categoria
ORDER BY total_vendido DESC
LIMIT 10;

-- 1.4. Top 10 clientes que mais compram
SELECT 
    c.cliente_id,
    c.nome,
    c.cidade,
    c.estado,
    COUNT(v.venda_id) AS total_compras,
    SUM(v.total_venda) AS valor_total_gasto,
    ROUND(AVG(v.total_venda), 2) AS ticket_medio
FROM clientes c
JOIN vendas v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nome, c.cidade, c.estado
ORDER BY valor_total_gasto DESC
LIMIT 10;

-- Análises Geográficas


-- 2.1. Vendas por estado
SELECT 
    c.estado,
    COUNT(v.venda_id) AS total_vendas,
    SUM(v.total_venda) AS valor_total,
    ROUND(AVG(v.total_venda), 2) AS ticket_medio
FROM vendas v
JOIN clientes c ON v.cliente_id = c.cliente_id
GROUP BY c.estado
ORDER BY valor_total DESC;

-- 2.2. Vendas por cidade
SELECT 
    c.cidade,
    c.estado,
    COUNT(v.venda_id) AS total_vendas,
    SUM(v.total_venda) AS valor_total,
    ROUND(AVG(v.total_venda), 2) AS ticket_medio
FROM vendas v
JOIN clientes c ON v.cliente_id = c.cliente_id
GROUP BY c.cidade, c.estado
ORDER BY valor_total DESC
LIMIT 15;

-- 2.3. Distribuição de clientes por estado
SELECT 
    estado,
    COUNT(*) AS total_clientes,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes), 2) AS percentual
FROM clientes
GROUP BY estado
ORDER BY total_clientes DESC;


-- Análises Temporais e Sazonais


-- 3.1. Vendas por dia da semana
SELECT 
    EXTRACT(DOW FROM data_venda) AS dia_semana_num,
    CASE EXTRACT(DOW FROM data_venda)
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
    END AS dia_semana,
    COUNT(*) AS total_vendas,
    SUM(total_venda) AS valor_total
FROM vendas
GROUP BY dia_semana_num, dia_semana
ORDER BY dia_semana_num;

-- 3.2. Crescimento mensal (comparativo)
WITH vendas_mensais AS (
    SELECT 
        EXTRACT(YEAR FROM data_venda) AS ano,
        EXTRACT(MONTH FROM data_venda) AS mes,
        SUM(total_venda) AS valor_total
    FROM vendas
    GROUP BY ano, mes
)
SELECT 
    ano,
    mes,
    valor_total,
    LAG(valor_total) OVER (ORDER BY ano, mes) AS valor_mes_anterior,
    ROUND(
        (valor_total - LAG(valor_total) OVER (ORDER BY ano, mes)) / 
        LAG(valor_total) OVER (ORDER BY ano, mes) * 100, 2
    ) AS variacao_percentual
FROM vendas_mensais
ORDER BY ano, mes;

-- 3.3. Vendas por trimestre
SELECT 
    EXTRACT(YEAR FROM data_venda) AS ano,
    EXTRACT(QUARTER FROM data_venda) AS trimestre,
    COUNT(*) AS total_vendas,
    SUM(total_venda) AS valor_total
FROM vendas
GROUP BY ano, trimestre
ORDER BY ano, trimestre;


-- Análises de Produtividade e Rentabilidade


-- 4.1. Margem de lucro por produto
SELECT 
    p.produto_id,
    p.nome,
    p.categoria,
    p.preco,
    p.custo,
    ROUND((p.preco - p.custo), 2) AS lucro_unitario,
    ROUND(((p.preco - p.custo) / p.preco * 100), 2) AS margem_percentual,
    SUM(iv.quantidade) AS total_vendido,
    ROUND(SUM(iv.quantidade) * (p.preco - p.custo), 2) AS lucro_total
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.nome, p.categoria, p.preco, p.custo
ORDER BY lucro_total DESC;

-- 4.2. Margem de lucro por categoria
SELECT 
    p.categoria,
    SUM(iv.quantidade) AS total_vendido,
    ROUND(SUM(iv.total_item), 2) AS receita_total,
    ROUND(SUM(iv.quantidade * p.custo), 2) AS custo_total,
    ROUND(SUM(iv.total_item) - SUM(iv.quantidade * p.custo), 2) AS lucro_total,
    ROUND(
        (SUM(iv.total_item) - SUM(iv.quantidade * p.custo)) / 
        SUM(iv.total_item) * 100, 2
    ) AS margem_percentual
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.categoria
ORDER BY lucro_total DESC;

-- 4.3. Produtos com melhor e pior margem
(SELECT 
    'Melhor Margem' AS tipo,
    p.nome,
    p.categoria,
    ROUND(((p.preco - p.custo) / p.preco * 100), 2) AS margem_percentual,
    SUM(iv.quantidade) AS total_vendido
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.nome, p.categoria, p.preco, p.custo
ORDER BY margem_percentual DESC
LIMIT 5)

UNION ALL

(SELECT 
    'Pior Margem' AS tipo,
    p.nome,
    p.categoria,
    ROUND(((p.preco - p.custo) / p.preco * 100), 2) AS margem_percentual,
    SUM(iv.quantidade) AS total_vendido
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.nome, p.categoria, p.preco, p.custo
ORDER BY margem_percentual ASC
LIMIT 5);


-- Análises de Comportamento do Cliente


-- 5.1. Frequência de compra por cliente
SELECT 
    c.cliente_id,
    c.nome,
    COUNT(v.venda_id) AS total_compras,
    MIN(v.data_venda) AS primeira_compra,
    MAX(v.data_venda) AS ultima_compra,
    ROUND(
        (EXTRACT(EPOCH FROM (MAX(v.data_venda) - MIN(v.data_venda))) / 
        NULLIF(COUNT(v.venda_id) - 1, 0) / 86400
    , 2) AS dias_entre_compras
FROM clientes c
JOIN vendas v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nome
HAVING COUNT(v.venda_id) > 1
ORDER BY total_compras DESC;

-- 5.2. Valor do cliente (LTV - Lifetime Value)
SELECT 
    c.cliente_id,
    c.nome,
    c.cidade,
    c.estado,
    COUNT(v.venda_id) AS total_compras,
    SUM(v.total_venda) AS valor_total,
    ROUND(SUM(v.total_venda) / COUNT(v.venda_id), 2) AS valor_medio_por_compra,
    ROUND(
        SUM(v.total_venda) / 
        (EXTRACT(EPOCH FROM (MAX(v.data_venda) - MIN(v.data_venda))) / 86400 * 30
    , 2) AS valor_mensal_medio
FROM clientes c
JOIN vendas v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nome, c.cidade, c.estado
ORDER BY valor_total DESC;

-- 5.3. Clientes inativos (não compram há mais de 60 dias)
SELECT 
    c.cliente_id,
    c.nome,
    c.email,
    c.cidade,
    c.estado,
    MAX(v.data_venda) AS ultima_compra,
    CURRENT_DATE - MAX(v.data_venda) AS dias_desde_ultima_compra
FROM clientes c
LEFT JOIN vendas v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nome, c.email, c.cidade, c.estado
HAVING MAX(v.data_venda) IS NULL OR CURRENT_DATE - MAX(v.data_venda) > 60
ORDER BY dias_desde_ultima_compra DESC NULLS FIRST;


-- Views para Dashboards no Power BI


-- 6.1. View para dashboard principal
CREATE OR REPLACE VIEW dashboard_vendas AS
SELECT 
    v.venda_id,
    v.data_venda,
    EXTRACT(YEAR FROM v.data_venda) AS ano,
    EXTRACT(MONTH FROM v.data_venda) AS mes,
    EXTRACT(QUARTER FROM v.data_venda) AS trimestre,
    EXTRACT(DOW FROM v.data_venda) AS dia_semana_num,
    TO_CHAR(v.data_venda, 'Day') AS dia_semana,
    v.total_venda,
    c.cliente_id,
    c.nome AS cliente_nome,
    c.cidade AS cliente_cidade,
    c.estado AS cliente_estado,
    c.data_cadastro,
    iv.item_id,
    iv.quantidade,
    iv.preco_unitario,
    iv.total_item,
    p.produto_id,
    p.nome AS produto_nome,
    p.categoria AS produto_categoria,
    p.preco AS produto_preco,
    p.custo AS produto_custo,
    ROUND((p.preco - p.custo), 2) AS lucro_unitario,
    ROUND(((p.preco - p.custo) / p.preco * 100), 2) AS margem_percentual
FROM vendas v
JOIN clientes c ON v.cliente_id = c.cliente_id
JOIN itens_venda iv ON v.venda_id = iv.venda_id
JOIN produtos p ON iv.produto_id = p.produto_id;

-- 6.2. View para análise de performance de produtos
CREATE OR REPLACE VIEW performance_produtos AS
SELECT 
    p.produto_id,
    p.nome,
    p.categoria,
    p.preco,
    p.custo,
    ROUND((p.preco - p.custo), 2) AS lucro_unitario,
    ROUND(((p.preco - p.custo) / p.preco * 100), 2) AS margem_percentual,
    COALESCE(SUM(iv.quantidade), 0) AS total_vendido,
    COALESCE(ROUND(SUM(iv.total_item), 2), 0) AS receita_total,
    COALESCE(ROUND(SUM(iv.quantidade * p.custo), 2), 0) AS custo_total,
    COALESCE(ROUND(SUM(iv.total_item) - SUM(iv.quantidade * p.custo), 2), 0) AS lucro_total
FROM produtos p
LEFT JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.nome, p.categoria, p.preco, p.custo;

-- 6.3. View para análise de clientes
CREATE OR REPLACE VIEW analise_clientes AS
SELECT 
    c.cliente_id,
    c.nome,
    c.email,
    c.cidade,
    c.estado,
    c.data_cadastro,
    COUNT(v.venda_id) AS total_compras,
    COALESCE(SUM(v.total_venda), 0) AS valor_total_gasto,
    COALESCE(ROUND(AVG(v.total_venda), 2), 0) AS ticket_medio,
    MIN(v.data_venda) AS primeira_compra,
    MAX(v.data_venda) AS ultima_compra,
    CASE 
        WHEN MAX(v.data_venda) IS NULL THEN 'Nunca comprou'
        WHEN CURRENT_DATE - MAX(v.data_venda) > 90 THEN 'Inativo'
        WHEN CURRENT_DATE - MAX(v.data_venda) > 30 THEN 'Pouco ativo'
        ELSE 'Ativo'
    END AS status_cliente
FROM clientes c
LEFT JOIN vendas v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nome, c.email, c.cidade, c.estado, c.data_cadastro;


