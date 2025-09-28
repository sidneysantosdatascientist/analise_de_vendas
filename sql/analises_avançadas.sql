-- Análises Avançadas


-- Análise de Cohort de Retenção de Clientes 

WITH cohort_assignments AS (
    SELECT 
        cliente_id,
        DATE_TRUNC('month', MIN(data_venda)) AS cohort_month
    FROM vendas
    GROUP BY cliente_id
),
cohort_size AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT cliente_id) AS total_clientes
    FROM cohort_assignments
    GROUP BY cohort_month
),
user_activities AS (
    SELECT
        ca.cliente_id,
        ca.cohort_month,
        DATE_TRUNC('month', v.data_venda) AS activity_month,
        (EXTRACT(YEAR FROM DATE_TRUNC('month', v.data_venda)) - EXTRACT(YEAR FROM ca.cohort_month)) * 12 +
        (EXTRACT(MONTH FROM DATE_TRUNC('month', v.data_venda)) - EXTRACT(MONTH FROM ca.cohort_month)) AS month_number
    FROM cohort_assignments ca
    JOIN vendas v ON ca.cliente_id = v.cliente_id
    GROUP BY ca.cliente_id, ca.cohort_month, DATE_TRUNC('month', v.data_venda)
),
cohort_retention AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT cliente_id) AS clientes_ativos
    FROM user_activities
    GROUP BY cohort_month, month_number
)
SELECT 
    cr.cohort_month,
    TO_CHAR(cr.cohort_month, 'YYYY-MM') AS cohort,
    cr.month_number,
    cs.total_clientes AS cohort_size,
    cr.clientes_ativos,
    ROUND((cr.clientes_ativos * 100.0 / cs.total_clientes), 2) AS retention_rate
FROM cohort_retention cr
JOIN cohort_size cs ON cr.cohort_month = cs.cohort_month
WHERE cr.month_number >= 0
ORDER BY cr.cohort_month, cr.month_number;



-- Análise RFM (Recência, Frequência, Valor Monetário)


-- Análise RFM Avançada com percentis
WITH rfm_analysis AS (
    SELECT
        c.cliente_id,
        c.nome,
        c.cidade,
        c.estado,
        -- Recência (dias desde última compra)
        CURRENT_DATE - MAX(v.data_venda) AS recencia,
        -- Frequência (número de compras)
        COUNT(v.venda_id) AS frequencia,
        -- Valor Monetário (total gasto)
        SUM(v.total_venda) AS valor_monetario,
        -- Percentis para cada métrica RFM
        NTILE(5) OVER (ORDER BY CURRENT_DATE - MAX(v.data_venda) DESC) AS r_score,
        NTILE(5) OVER (ORDER BY COUNT(v.venda_id)) AS f_score,
        NTILE(5) OVER (ORDER BY SUM(v.total_venda)) AS m_score
    FROM clientes c
    JOIN vendas v ON c.cliente_id = v.cliente_id
    GROUP BY c.cliente_id, c.nome, c.cidade, c.estado
),
rfm_segments AS (
    SELECT
        *,
        -- Segmentação RFM baseada nos scores
        CASE 
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Clientes Champions'
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Clientes Leais'
            WHEN r_score >= 2 AND f_score >= 2 THEN 'Clientes Potenciais'
            WHEN r_score >= 2 AND m_score >= 2 THEN 'Clientes Promissores'
            WHEN r_score >= 1 AND f_score >= 1 THEN 'Clientes Novos'
            WHEN r_score = 1 THEN 'Clientes Inativos'
            ELSE 'Clientes Perdidos'
        END AS rfm_segment,
        -- Score RFM combinado
        (r_score * 100 + f_score * 10 + m_score) AS rfm_score
    FROM rfm_analysis
)
SELECT 
    rfm_segment,
    COUNT(*) AS total_clientes,
    ROUND(AVG(recencia), 2) AS avg_recencia,
    ROUND(AVG(frequencia), 2) AS avg_frequencia,
    ROUND(AVG(valor_monetario), 2) AS avg_valor,
    ROUND(SUM(valor_monetario), 2) AS total_valor
FROM rfm_segments
GROUP BY rfm_segment
ORDER BY total_valor DESC;



-- Análise de Série Temporal com Previsão Simples



-- Análise de Série Temporal com Tendência e Média Móvel
WITH vendas_diarias AS (
    SELECT
        data_venda,
        SUM(total_venda) AS total_vendas,
        COUNT(*) AS num_vendas
    FROM vendas
    GROUP BY data_venda
),
series_temporais AS (
    SELECT
        data_venda,
        total_vendas,
        num_vendas,
        -- Média móvel de 7 dias
        ROUND(AVG(total_vendas) OVER (
            ORDER BY data_venda 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2) AS media_movel_7d,
        -- Média móvel de 30 dias
        ROUND(AVG(total_vendas) OVER (
            ORDER BY data_venda 
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ), 2) AS media_movel_30d,
        -- Crescimento em relação ao dia anterior
        ROUND(
            (total_vendas - LAG(total_vendas, 1) OVER (ORDER BY data_venda)) / 
            LAG(total_vendas, 1) OVER (ORDER BY data_venda) * 100, 2
        ) AS crescimento_diario
    FROM vendas_diarias
)
SELECT 
    data_venda,
    total_vendas,
    num_vendas,
    media_movel_7d,
    media_movel_30d,
    crescimento_diario,
    -- Previsão simples baseada na média móvel
    ROUND(media_movel_7d * 1.1, 2) AS previsao_otimista,
    ROUND(media_movel_7d * 0.9, 2) AS previsao_conservadora
FROM series_temporais
ORDER BY data_venda;



-- Análise de Market Basket (Associação de Produtos)


-- Análise de Market Basket (Quais produtos são comprados juntos)
WITH vendas_produtos AS (
    SELECT
        v.venda_id,
        STRING_AGG(p.nome, ', ' ORDER BY p.nome) AS produtos,
        STRING_AGG(p.categoria, ', ' ORDER BY p.categoria) AS categorias
    FROM vendas v
    JOIN itens_venda iv ON v.venda_id = iv.venda_id
    JOIN produtos p ON iv.produto_id = p.produto_id
    GROUP BY v.venda_id
    HAVING COUNT(iv.item_id) > 1
),
combinacoes_produtos AS (
    SELECT
        vp1.produtos AS combo_produtos,
        vp1.categorias AS combo_categorias,
        COUNT(*) AS frequencia,
        ROUND(AVG(v.total_venda), 2) AS valor_medio_venda
    FROM vendas_produtos vp1
    JOIN vendas v ON vp1.venda_id = v.venda_id
    GROUP BY vp1.produtos, vp1.categorias
    HAVING COUNT(*) > 1
)
SELECT 
    combo_produtos,
    combo_categorias,
    frequencia,
    valor_medio_venda,
    ROUND(frequencia * 100.0 / (SELECT COUNT(*) FROM vendas_produtos), 2) AS percentual_combinacoes
FROM combinacoes_produtos
ORDER BY frequencia DESC, valor_medio_venda DESC
LIMIT 20;




-- Análise de Funnel de Vendas



-- Análise de Funnel de Conversão de Clientes
WITH funil_vendas AS (
    SELECT
        c.cliente_id,
        c.data_cadastro,
        MIN(v.data_venda) AS primeira_compra,
        COUNT(DISTINCT v.venda_id) AS total_compras,
        SUM(v.total_venda) AS valor_total,
        CASE 
            WHEN COUNT(DISTINCT v.venda_id) >= 5 THEN 'Cliente Fiel'
            WHEN COUNT(DISTINCT v.venda_id) >= 2 THEN 'Cliente Recorrente'
            WHEN COUNT(DISTINCT v.venda_id) = 1 THEN 'Cliente Única Compra'
            ELSE 'Lead Não Convertido'
        END AS estagio_funil
    FROM clientes c
    LEFT JOIN vendas v ON c.cliente_id = v.cliente_id
    GROUP BY c.cliente_id, c.data_cadastro
),
metricas_funil AS (
    SELECT
        estagio_funil,
        COUNT(*) AS total_clientes,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentual_total,
        ROUND(AVG(total_compras), 2) AS avg_compras,
        ROUND(AVG(valor_total), 2) AS avg_valor,
        ROUND(SUM(valor_total), 2) AS valor_total_estagio
    FROM funil_vendas
    GROUP BY estagio_funil
),
taxas_conversao AS (
    SELECT
        'Cadastro para Primeira Compra' AS conversao,
        COUNT(CASE WHEN primeira_compra IS NOT NULL THEN 1 END) AS convertidos,
        COUNT(*) AS total,
        ROUND(COUNT(CASE WHEN primeira_compra IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS taxa_conversao
    FROM funil_vendas
    
    UNION ALL
    
    SELECT
        'Primeira para Segunda Compra' AS conversao,
        COUNT(CASE WHEN total_compras >= 2 THEN 1 END) AS convertidos,
        COUNT(CASE WHEN total_compras >= 1 THEN 1 END) AS total,
        ROUND(COUNT(CASE WHEN total_compras >= 2 THEN 1 END) * 100.0 / COUNT(CASE WHEN total_compras >= 1 THEN 1 END), 2) AS taxa_conversao
    FROM funil_vendas
)
SELECT * FROM metricas_funil
UNION ALL
SELECT 
    conversao AS estagio_funil,
    convertidos AS total_clientes,
    taxa_conversao AS percentual_total,
    NULL AS avg_compras,
    NULL AS avg_valor,
    NULL AS valor_total_estagio
FROM taxas_conversao;



--Análise de Churn (Rotatividade de Clientes)



-- Análise de Churn com Previsão
WITH ultimas_compras AS (
    SELECT
        cliente_id,
        MAX(data_venda) AS ultima_compra,
        COUNT(*) AS total_compras,
        SUM(total_venda) AS valor_total
    FROM vendas
    GROUP BY cliente_id
),
churn_probability AS (
    SELECT
        uc.cliente_id,
        c.nome,
        c.cidade,
        c.estado,
        uc.ultima_compra,
        uc.total_compras,
        uc.valor_total,
        CURRENT_DATE - uc.ultima_compra AS dias_sem_comprar,
        -- Probabilidade de churn baseada em regras de negócio
        CASE 
            WHEN CURRENT_DATE - uc.ultima_compra > 180 THEN 0.95
            WHEN CURRENT_DATE - uc.ultima_compra > 90 THEN 0.75
            WHEN CURRENT_DATE - uc.ultima_compra > 60 THEN 0.50
            WHEN CURRENT_DATE - uc.ultima_compra > 30 THEN 0.25
            ELSE 0.10
        END AS probabilidade_churn,
        -- Valor esperado de perda
        uc.valor_total * 
        CASE 
            WHEN CURRENT_DATE - uc.ultima_compra > 180 THEN 0.95
            WHEN CURRENT_DATE - uc.ultima_compra > 90 THEN 0.75
            WHEN CURRENT_DATE - uc.ultima_compra > 60 THEN 0.50
            WHEN CURRENT_DATE - uc.ultima_compra > 30 THEN 0.25
            ELSE 0.10
        END AS valor_esperado_perda
    FROM ultimas_compras uc
    JOIN clientes c ON uc.cliente_id = c.cliente_id
)
SELECT 
    cliente_id,
    nome,
    cidade,
    estado,
    ultima_compra,
    total_compras,
    valor_total,
    dias_sem_comprar,
    probabilidade_churn,
    valor_esperado_perda,
    CASE 
        WHEN probabilidade_churn >= 0.7 THEN 'Alto Risco'
        WHEN probabilidade_churn >= 0.4 THEN 'Médio Risco'
        ELSE 'Baixo Risco'
    END AS nivel_risco
FROM churn_probability
ORDER BY valor_esperado_perda DESC, probabilidade_churn DESC;



-- Análise de Elasticidade-Preço e Sensibilidade



-- Análise de Elasticidade-Preço dos Produtos 

WITH variacao_precos AS (
    SELECT
        p.produto_id,
        p.nome,
        p.categoria,
        p.preco AS preco_atual,
        MIN(v.data_venda) AS data_primeira_venda
    FROM produtos p
    JOIN itens_venda iv ON p.produto_id = iv.produto_id
    JOIN vendas v ON iv.venda_id = v.venda_id
    GROUP BY p.produto_id, p.nome, p.categoria, p.preco
),
preco_historico AS (
    SELECT
        vp.produto_id,
        vp.preco_atual,
        LAG(vp.preco_atual) OVER (PARTITION BY vp.produto_id ORDER BY vp.data_primeira_venda) AS preco_anterior,
        vp.data_primeira_venda
    FROM variacao_precos vp
),
vendas_por_periodo AS (
    SELECT
        ph.produto_id,
        ph.preco_atual,
        ph.preco_anterior,
        ph.data_primeira_venda,
        -- Vendas antes da alteração de preço (últimos 30 dias antes da mudança)
        SUM(CASE WHEN v.data_venda BETWEEN ph.data_primeira_venda - INTERVAL '30 days' AND ph.data_primeira_venda - INTERVAL '1 day' THEN iv.quantidade ELSE 0 END) AS quantidade_antes,
        -- Vendas depois da alteração de preço (primeiros 30 dias depois da mudança)
        SUM(CASE WHEN v.data_venda BETWEEN ph.data_primeira_venda AND ph.data_primeira_venda + INTERVAL '30 days' THEN iv.quantidade ELSE 0 END) AS quantidade_depois
    FROM preco_historico ph
    JOIN itens_venda iv ON ph.produto_id = iv.produto_id
    JOIN vendas v ON iv.venda_id = v.venda_id
    WHERE ph.preco_anterior IS NOT NULL
    GROUP BY ph.produto_id, ph.preco_atual, ph.preco_anterior, ph.data_primeira_venda
),
calculo_elasticidade AS (
    SELECT
        produto_id,
        preco_anterior,
        preco_atual,
        ROUND(((preco_atual - preco_anterior) / preco_anterior * 100), 2) AS variacao_preco_percentual,
        quantidade_antes,
        quantidade_depois,
        ROUND(((quantidade_depois - quantidade_antes) / NULLIF(quantidade_antes, 0) * 100), 2) AS variacao_quantidade_percentual,
        -- Cálculo da elasticidade-preço
        ROUND(
            ((quantidade_depois - quantidade_antes) / NULLIF(quantidade_antes, 0)) / 
            NULLIF((preco_atual - preco_anterior) / preco_anterior, 0), 4
        ) AS elasticidade_preco
    FROM vendas_por_periodo
    WHERE quantidade_antes > 0 AND quantidade_depois > 0
)
SELECT
    c.*,
    CASE 
        WHEN elasticidade_preco < -1 THEN 'Elástico'
        WHEN elasticidade_preco BETWEEN -1 AND 0 THEN 'Inelástico'
        ELSE 'Neutro'
    END AS tipo_elasticidade
FROM calculo_elasticidade c
ORDER BY ABS(elasticidade_preco) DESC;




-- Análise de Valor do Tempo de Vida do Cliente (LTV)



-- Cálculo do LTV com tratamento completo de erros
WITH dados_cliente AS (
    SELECT
        c.cliente_id,
        c.nome,
        c.data_cadastro,
        COUNT(v.venda_id) AS total_compras,
        COALESCE(SUM(v.total_venda), 0) AS valor_total_gasto,
        MIN(v.data_venda) AS primeira_compra,
        MAX(v.data_venda) AS ultima_compra,
        -- Calcular dias ativo de forma segura
        CASE 
            WHEN MIN(v.data_venda) IS NOT NULL AND MAX(v.data_venda) IS NOT NULL THEN
                (MAX(v.data_venda) - MIN(v.data_venda))::integer
            ELSE 1 -- Evitar divisão por zero
        END AS dias_ativo
    FROM clientes c
    LEFT JOIN vendas v ON c.cliente_id = v.cliente_id
    GROUP BY c.cliente_id, c.nome, c.data_cadastro
),
metricas_ltv AS (
    SELECT
        cliente_id,
        nome,
        data_cadastro,
        primeira_compra,
        ultima_compra,
        total_compras,
        valor_total_gasto,
        -- Garantir pelo menos 1 dia para evitar divisão por zero
        GREATEST(dias_ativo, 1) AS dias_ativo,
        -- Taxa média de compra (compras por dia)
        total_compras::decimal / GREATEST(dias_ativo, 1) AS taxa_compra_diaria,
        -- Valor médio por compra
        CASE 
            WHEN total_compras > 0 THEN valor_total_gasto / total_compras
            ELSE 0
        END AS valor_medio_compra,
        -- LTV histórico
        valor_total_gasto AS ltv_historico,
        -- Projeção de LTV para 1 ano
        valor_total_gasto / GREATEST(dias_ativo, 1) * 365 AS ltv_projetado_1ano,
        -- Projeção de LTV para 3 anos
        valor_total_gasto / GREATEST(dias_ativo, 1) * 365 * 3 AS ltv_projetado_3anos
    FROM dados_cliente
)
SELECT
    cliente_id,
    nome,
    data_cadastro,
    primeira_compra,
    ultima_compra,
    total_compras,
    ROUND(valor_total_gasto, 2) AS valor_total_gasto,
    dias_ativo,
    ROUND(taxa_compra_diaria, 4) AS taxa_compra_diaria,
    ROUND(valor_medio_compra, 2) AS valor_medio_compra,
    ROUND(ltv_historico, 2) AS ltv_historico,
    ROUND(ltv_projetado_1ano, 2) AS ltv_projetado_1ano,
    ROUND(ltv_projetado_3anos, 2) AS ltv_projetado_3anos,
    CASE 
        WHEN ltv_projetado_3anos > 5000 THEN 'Cliente Alto Valor'
        WHEN ltv_projetado_3anos > 2000 THEN 'Cliente Médio Valor'
        WHEN ltv_projetado_3anos > 500 THEN 'Cliente Baixo Valor'
        ELSE 'Cliente Inativo'
    END AS segmento_ltv
FROM metricas_ltv
ORDER BY ltv_projetado_3anos DESC NULLS LAST;



-- Análise de SaZonalidade e Tendências



-- Análise Avançada de Sazonalidade e Tendências
WITH vendas_mensais AS (
    SELECT
        EXTRACT(YEAR FROM data_venda) AS ano,
        EXTRACT(MONTH FROM data_venda) AS mes,
        TO_CHAR(data_venda, 'Month') AS nome_mes,
        COUNT(*) AS total_vendas,
        SUM(total_venda) AS valor_total,
        AVG(total_venda) AS ticket_medio
    FROM vendas
    GROUP BY ano, mes, nome_mes
),
metricas_sazonais AS (
    SELECT
        ano,
        mes,
        nome_mes,
        total_vendas,
        valor_total,
        ticket_medio,
        -- Média móvel anual
        ROUND(AVG(valor_total) OVER (
            PARTITION BY mes 
            ORDER BY ano 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2) AS media_anual_mes,
        -- Crescimento anual
        ROUND(
            (valor_total - LAG(valor_total, 12) OVER (ORDER BY ano, mes)) / 
            LAG(valor_total, 12) OVER (ORDER BY ano, mes) * 100, 2
        ) AS crescimento_anual,
        -- Sazonalidade (comparação com média do mês)
        ROUND(
            (valor_total - AVG(valor_total) OVER (PARTITION BY mes)) / 
            AVG(valor_total) OVER (PARTITION BY mes) * 100, 2
        ) AS variacao_sazonal
    FROM vendas_mensais
)
SELECT
    ano,
    mes,
    TRIM(nome_mes) AS mes_nome,
    total_vendas,
    valor_total,
    ticket_medio,
    media_anual_mes,
    crescimento_anual,
    variacao_sazonal,
    CASE 
        WHEN variacao_sazonal > 20 THEN 'Alta Sazonalidade Positiva'
        WHEN variacao_sazonal > 10 THEN 'Média Sazonalidade Positiva'
        WHEN variacao_sazonal > -10 THEN 'Neutro'
        WHEN variacao_sazonal > -20 THEN 'Média Sazonalidade Negativa'
        ELSE 'Alta Sazonalidade Negativa'
    END AS classificacao_sazonal
FROM metricas_sazonais
ORDER BY ano, mes;



-- Dashboard de Performance Comercial


-- Visão 360° do Performance Comercial
WITH metrics AS (
    SELECT
        -- Métricas de Vendas
        COUNT(DISTINCT v.venda_id) AS total_vendas,
        SUM(v.total_venda) AS receita_total,
        AVG(v.total_venda) AS ticket_medio,
        
        -- Métricas de Clientes
        COUNT(DISTINCT c.cliente_id) AS total_clientes,
        COUNT(DISTINCT CASE WHEN v.venda_id IS NOT NULL THEN c.cliente_id END) AS clientes_ativos,
        
        -- Métricas de Produtos
        COUNT(DISTINCT p.produto_id) AS total_produtos,
        SUM(iv.quantidade) AS total_itens_vendidos,
        
        -- Métricas de Tempo
        MIN(v.data_venda) AS primeira_venda,
        MAX(v.data_venda) AS ultima_venda,
        MAX(v.data_venda) - MIN(v.data_venda) AS periodo_analise,
        
        -- Métricas de Valor
        SUM(iv.total_item) - SUM(iv.quantidade * p.custo) AS lucro_total,
        ROUND((SUM(iv.total_item) - SUM(iv.quantidade * p.custo)) / SUM(iv.total_item) * 100, 2) AS margem_percentual
    FROM clientes c
    LEFT JOIN vendas v ON c.cliente_id = v.cliente_id
    LEFT JOIN itens_venda iv ON v.venda_id = iv.venda_id
    LEFT JOIN produtos p ON iv.produto_id = p.produto_id
),
daily_metrics AS (
    SELECT
        data_venda,
        SUM(total_venda) AS receita_dia,
        COUNT(*) AS vendas_dia
    FROM vendas
    GROUP BY data_venda
),
variacao_diaria AS (
    SELECT
        ROUND(STDDEV(receita_dia) / AVG(receita_dia) * 100, 2) AS cv_receita,
        ROUND(STDDEV(vendas_dia) / AVG(vendas_dia) * 100, 2) AS cv_vendas
    FROM daily_metrics
)
SELECT
    m.total_vendas,
    m.receita_total,
    m.ticket_medio,
    m.total_clientes,
    ROUND(m.total_vendas * 100.0 / m.total_clientes, 2) AS frequencia_compra,
    m.clientes_ativos,
    ROUND(m.clientes_ativos * 100.0 / m.total_clientes, 2) AS taxa_ativacao,
    m.total_produtos,
    m.total_itens_vendidos,
    ROUND(m.total_itens_vendidos * 1.0 / m.total_vendas, 2) AS itens_por_venda,
    m.primeira_venda,
    m.ultima_venda,
    m.periodo_analise,
    m.lucro_total,
    m.margem_percentual,
    vd.cv_receita AS variabilidade_receita,
    vd.cv_vendas AS variabilidade_vendas,
    CASE 
        WHEN vd.cv_receita < 30 THEN 'Baixa Variabilidade'
        WHEN vd.cv_receita < 60 THEN 'Média Variabilidade'
        ELSE 'Alta Variabilidade'
    END AS classificacao_variabilidade
FROM metrics m, variacao_diaria vd;





