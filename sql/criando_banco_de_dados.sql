-- Tabela de Clientes
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    cidade VARCHAR(50),
    estado VARCHAR(2),
    data_cadastro DATE
);

COMMENT ON TABLE clientes IS 'Tabela que armazena informações dos clientes';
COMMENT ON COLUMN clientes.cliente_id IS 'Identificador único do cliente';
COMMENT ON COLUMN clientes.nome IS 'Nome completo do cliente';
COMMENT ON COLUMN clientes.email IS 'Endereço de e-mail do cliente';
COMMENT ON COLUMN clientes.cidade IS 'Cidade de residência do cliente';
COMMENT ON COLUMN clientes.estado IS 'Estado de residência do cliente (sigla)';
COMMENT ON COLUMN clientes.data_cadastro IS 'Data de cadastro do cliente no sistema';

-- Tabela de Produtos
CREATE TABLE produtos (
    produto_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    preco DECIMAL(10,2) CHECK (preco > 0),
    custo DECIMAL(10,2) CHECK (custo >= 0)
);

COMMENT ON TABLE produtos IS 'Tabela que armazena informações dos produtos';
COMMENT ON COLUMN produtos.produto_id IS 'Identificador único do produto';
COMMENT ON COLUMN produtos.nome IS 'Nome do produto';
COMMENT ON COLUMN produtos.categoria IS 'Categoria do produto';
COMMENT ON COLUMN produtos.preco IS 'Preço de venda do produto';
COMMENT ON COLUMN produtos.custo IS 'Custo de aquisição do produto';

-- Tabela de Vendas
CREATE TABLE vendas (
    venda_id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    data_venda DATE NOT NULL,
    total_venda DECIMAL(10,2) CHECK (total_venda >= 0),
    CONSTRAINT fk_cliente
        FOREIGN KEY(cliente_id) 
        REFERENCES clientes(cliente_id)
        ON DELETE CASCADE
);

COMMENT ON TABLE vendas IS 'Tabela que armazena o cabeçalho das vendas';
COMMENT ON COLUMN vendas.venda_id IS 'Identificador único da venda';
COMMENT ON COLUMN vendas.cliente_id IS 'Chave estrangeira para o cliente';
COMMENT ON COLUMN vendas.data_venda IS 'Data em que a venda foi realizada';
COMMENT ON COLUMN vendas.total_venda IS 'Valor total da venda';

-- Tabela de Itens da Venda
CREATE TABLE itens_venda (
    item_id SERIAL PRIMARY KEY,
    venda_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    quantidade INTEGER CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) CHECK (preco_unitario >= 0),
    total_item DECIMAL(10,2) CHECK (total_item >= 0),
    CONSTRAINT fk_venda
        FOREIGN KEY(venda_id) 
        REFERENCES vendas(venda_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_produto
        FOREIGN KEY(produto_id) 
        REFERENCES produtos(produto_id)
        ON DELETE CASCADE
);

COMMENT ON TABLE itens_venda IS 'Tabela que armazena os itens de cada venda';
COMMENT ON COLUMN itens_venda.item_id IS 'Identificador único do item de venda';
COMMENT ON COLUMN itens_venda.venda_id IS 'Chave estrangeira para a venda';
COMMENT ON COLUMN itens_venda.produto_id IS 'Chave estrangeira para o produto';
COMMENT ON COLUMN itens_venda.quantidade IS 'Quantidade vendida do produto';
COMMENT ON COLUMN itens_venda.preco_unitario IS 'Preço unitário do produto na venda';
COMMENT ON COLUMN itens_venda.total_item IS 'Total do item (quantidade × preço unitário)';


-- Índices para a tabela de clientes
CREATE INDEX idx_clientes_email ON clientes(email);
CREATE INDEX idx_clientes_cidade ON clientes(cidade);
CREATE INDEX idx_clientes_estado ON clientes(estado);

-- Índices para a tabela de produtos
CREATE INDEX idx_produtos_categoria ON produtos(categoria);
CREATE INDEX idx_produtos_preco ON produtos(preco);

-- Índices para a tabela de vendas
CREATE INDEX idx_vendas_data ON vendas(data_venda);
CREATE INDEX idx_vendas_cliente ON vendas(cliente_id);
CREATE INDEX idx_vendas_total ON vendas(total_venda);

-- Índices para a tabela de itens_venda
CREATE INDEX idx_itens_venda ON itens_venda(venda_id);
CREATE INDEX idx_itens_produto ON itens_venda(produto_id);


-- View para visualizar vendas com detalhes do cliente
CREATE VIEW vw_vendas_detalhadas AS
SELECT 
    v.venda_id,
    v.data_venda,
    v.total_venda,
    c.cliente_id,
    c.nome as cliente_nome,
    c.cidade as cliente_cidade,
    c.estado as cliente_estado
FROM vendas v
JOIN clientes c ON v.cliente_id = c.cliente_id;

-- View para visualizar itens de venda com detalhes do produto
CREATE VIEW vw_itens_detalhados AS
SELECT 
    iv.item_id,
    iv.venda_id,
    iv.quantidade,
    iv.preco_unitario,
    iv.total_item,
    p.produto_id,
    p.nome as produto_nome,
    p.categoria as produto_categoria
FROM itens_venda iv
JOIN produtos p ON iv.produto_id = p.produto_id;

-- View para análise de vendas por categoria
CREATE VIEW vw_vendas_por_categoria AS
SELECT 
    p.categoria,
    COUNT(iv.item_id) as total_itens,
    SUM(iv.quantidade) as total_quantidade,
    SUM(iv.total_item) as total_vendas
FROM itens_venda iv
JOIN produtos p ON iv.produto_id = p.produto_id
GROUP BY p.categoria
ORDER BY total_vendas DESC;



-- Verificar todas as tabelas criadas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Verificar a estrutura de uma tabela específica
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'clientes' 
ORDER BY ordinal_position;

-- Verificar as views criadas
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Verificar índices
SELECT tablename, indexname, indexdef 
FROM pg_indexes 
WHERE schemaname = 'public' 
ORDER BY tablename, indexname;