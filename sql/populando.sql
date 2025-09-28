-- Script para popular o banco de dados de vendas
-- Execute após criar a estrutura das tabelas

-- 1. Inserir dados na tabela de clientes
INSERT INTO clientes (nome, email, cidade, estado, data_cadastro) VALUES
('João Silva', 'joao.silva@email.com', 'São Paulo', 'SP', '2023-01-15'),
('Maria Santos', 'maria.santos@email.com', 'Rio de Janeiro', 'RJ', '2023-02-20'),
('Pedro Oliveira', 'pedro.oliveira@email.com', 'Belo Horizonte', 'MG', '2023-03-10'),
('Ana Costa', 'ana.costa@email.com', 'Porto Alegre', 'RS', '2023-04-05'),
('Carlos Pereira', 'carlos.pereira@email.com', 'Salvador', 'BA', '2023-05-12'),
('Juliana Almeida', 'juliana.almeida@email.com', 'Brasília', 'DF', '2023-06-18'),
('Fernando Lima', 'fernando.lima@email.com', 'Fortaleza', 'CE', '2023-07-22'),
('Patrícia Rocha', 'patricia.rocha@email.com', 'Recife', 'PE', '2023-08-30'),
('Ricardo Martins', 'ricardo.martins@email.com', 'Manaus', 'AM', '2023-09-05'),
('Amanda Dias', 'amanda.dias@email.com', 'Curitiba', 'PR', '2023-10-15'),
('Bruno Nunes', 'bruno.nunes@email.com', 'Belém', 'PA', '2023-11-20'),
('Camila Ferreira', 'camila.ferreira@email.com', 'Goiânia', 'GO', '2023-12-25'),
('Daniel Souza', 'daniel.souza@email.com', 'São Luís', 'MA', '2024-01-08'),
('Eduarda Carvalho', 'eduarda.carvalho@email.com', 'Natal', 'RN', '2024-02-14'),
('Fábio Barbosa', 'fabio.barbosa@email.com', 'Campo Grande', 'MS', '2024-03-21'),
('Gabriela Ribeiro', 'gabriela.ribeiro@email.com', 'Florianópolis', 'SC', '2024-04-03'),
('Hugo Cardoso', 'hugo.cardoso@email.com', 'Vitória', 'ES', '2024-05-17'),
('Isabela Melo', 'isabela.melo@email.com', 'Maceió', 'AL', '2024-06-11'),
('Lucas Santana', 'lucas.santana@email.com', 'João Pessoa', 'PB', '2024-07-19'),
('Mariana Pinto', 'mariana.pinto@email.com', 'Teresina', 'PI', '2024-08-22');

-- 2. Inserir dados na tabela de produtos
INSERT INTO produtos (nome, categoria, preco, custo) VALUES
('Notebook Dell Inspiron', 'Eletrônicos', 3500.00, 2500.00),
('Smartphone Samsung Galaxy', 'Eletrônicos', 1500.00, 1000.00),
('iPhone 13', 'Eletrônicos', 4500.00, 3200.00),
('Tablet Amazon Fire', 'Eletrônicos', 800.00, 500.00),
('Smartwatch Apple Watch', 'Eletrônicos', 2200.00, 1500.00),
('Camiseta Nike Dry-Fit', 'Roupas', 99.90, 40.00),
('Calça Jeans Levi''s', 'Roupas', 199.90, 80.00),
('Tênis Adidas Ultraboost', 'Esportes', 299.90, 150.00),
('Bola de Futebol Nike', 'Esportes', 129.90, 60.00),
('Raquete de Tênis Wilson', 'Esportes', 399.90, 200.00),
('Sofá 3 Lugares', 'Casa', 1200.00, 700.00),
('Mesa de Jantar', 'Casa', 800.00, 450.00),
('Cadeira Escritório', 'Casa', 350.00, 200.00),
('Panela de Pressão', 'Casa', 120.00, 60.00),
('Livro "O Poder do Hábito"', 'Livros', 49.90, 25.00),
('Livro "1984"', 'Livros', 39.90, 20.00),
('Livro "A Arte da Guerra"', 'Livros', 29.90, 15.00),
('Fone de Ouvido Sony', 'Eletrônicos', 250.00, 150.00),
('Mouse Gamer', 'Eletrônicos', 180.00, 100.00),
('Teclado Mecânico', 'Eletrônicos', 300.00, 180.00);

-- 3. Inserir dados na tabela de vendas
INSERT INTO vendas (cliente_id, data_venda, total_venda) VALUES
(1, '2024-01-05', 3500.00),
(2, '2024-01-07', 1599.80),
(3, '2024-01-10', 299.90),
(4, '2024-01-12', 4500.00),
(5, '2024-01-15', 800.00),
(6, '2024-01-18', 2200.00),
(7, '2024-01-20', 199.90),
(8, '2024-01-22', 129.90),
(9, '2024-01-25', 399.90),
(10, '2024-01-28', 1200.00),
(11, '2024-02-01', 800.00),
(12, '2024-02-03', 350.00),
(13, '2024-02-05', 120.00),
(14, '2024-02-08', 49.90),
(15, '2024-02-10', 39.90),
(16, '2024-02-12', 29.90),
(17, '2024-02-15', 250.00),
(18, '2024-02-18', 180.00),
(19, '2024-02-20', 300.00),
(1, '2024-02-22', 1500.00),
(2, '2024-02-25', 99.90),
(3, '2024-02-28', 199.90),
(4, '2024-03-01', 299.90),
(5, '2024-03-03', 129.90),
(6, '2024-03-05', 399.90),
(7, '2024-03-08', 1200.00),
(8, '2024-03-10', 800.00),
(9, '2024-03-12', 350.00),
(10, '2024-03-15', 120.00),
(11, '2024-03-18', 49.90),
(12, '2024-03-20', 39.90),
(13, '2024-03-22', 29.90),
(14, '2024-03-25', 250.00),
(15, '2024-03-28', 180.00),
(16, '2024-04-01', 300.00),
(17, '2024-04-03', 3500.00),
(18, '2024-04-05', 1500.00),
(19, '2024-04-08', 99.90),
(1, '2024-04-10', 199.90),
(2, '2024-04-12', 299.90);

-- 4. Inserir dados na tabela de itens_venda
INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario, total_item) VALUES
-- Venda 1
(1, 1, 1, 3500.00, 3500.00),

-- Venda 2
(2, 2, 1, 1500.00, 1500.00),
(2, 6, 1, 99.80, 99.80),

-- Venda 3
(3, 8, 1, 299.90, 299.90),

-- Venda 4
(4, 3, 1, 4500.00, 4500.00),

-- Venda 5
(5, 4, 1, 800.00, 800.00),

-- Venda 6
(6, 5, 1, 2200.00, 2200.00),

-- Venda 7
(7, 7, 1, 199.90, 199.90),

-- Venda 8
(8, 9, 1, 129.90, 129.90),

-- Venda 9
(9, 10, 1, 399.90, 399.90),

-- Venda 10
(10, 11, 1, 1200.00, 1200.00),

-- Venda 11
(11, 12, 1, 800.00, 800.00),

-- Venda 12
(12, 13, 1, 350.00, 350.00),

-- Venda 13
(13, 14, 1, 120.00, 120.00),

-- Venda 14
(14, 15, 1, 49.90, 49.90),

-- Venda 15
(15, 16, 1, 39.90, 39.90),

-- Venda 16
(16, 17, 1, 29.90, 29.90),

-- Venda 17
(17, 18, 1, 250.00, 250.00),

-- Venda 18
(18, 19, 1, 180.00, 180.00),

-- Venda 19
(19, 20, 1, 300.00, 300.00),

-- Venda 20
(20, 2, 1, 1500.00, 1500.00),

-- Venda 21
(21, 6, 1, 99.90, 99.90),

-- Venda 22
(22, 7, 1, 199.90, 199.90),

-- Venda 23
(23, 8, 1, 299.90, 299.90),

-- Venda 24
(24, 9, 1, 129.90, 129.90),

-- Venda 25
(25, 10, 1, 399.90, 399.90),

-- Venda 26
(26, 11, 1, 1200.00, 1200.00),

-- Venda 27
(27, 12, 1, 800.00, 800.00),

-- Venda 28
(28, 13, 1, 350.00, 350.00),

-- Venda 29
(29, 14, 1, 120.00, 120.00),

-- Venda 30
(30, 15, 1, 49.90, 49.90),

-- Venda 31
(31, 16, 1, 39.90, 39.90),

-- Venda 32
(32, 17, 1, 29.90, 29.90),

-- Venda 33
(33, 18, 1, 250.00, 250.00),

-- Venda 34
(34, 19, 1, 180.00, 180.00),

-- Venda 35
(35, 20, 1, 300.00, 300.00),

-- Venda 36
(36, 1, 1, 3500.00, 3500.00),

-- Venda 37
(37, 2, 1, 1500.00, 1500.00),

-- Venda 38
(38, 6, 1, 99.90, 99.90),

-- Venda 39
(39, 7, 1, 199.90, 199.90),

-- Venda 40
(40, 8, 1, 299.90, 299.90);

-- 5. Consultas para verificar os dados inseridos

-- Contagem de registros em cada tabela
SELECT 'Clientes' as Tabela, COUNT(*) as Total FROM clientes
UNION ALL
SELECT 'Produtos', COUNT(*) FROM produtos
UNION ALL
SELECT 'Vendas', COUNT(*) FROM vendas
UNION ALL
SELECT 'Itens Venda', COUNT(*) FROM itens_venda;

-- Visualizar algumas vendas com detalhes
SELECT 
    v.venda_id,
    v.data_venda,
    c.nome as cliente,
    c.cidade,
    c.estado,
    p.nome as produto,
    iv.quantidade,
    iv.preco_unitario,
    iv.total_item,
    v.total_venda
FROM vendas v
JOIN clientes c ON v.cliente_id = c.cliente_id
JOIN itens_venda iv ON v.venda_id = iv.venda_id
JOIN produtos p ON iv.produto_id = p.produto_id
ORDER BY v.venda_id
LIMIT 10;

-- Vendas por categoria
SELECT 
    p.categoria,
    COUNT(iv.item_id) as total_itens,
    SUM(iv.quantidade) as total_quantidade,
    SUM(iv.total_item) as total_vendas
FROM itens_venda iv
JOIN produtos p ON iv.produto_id = p.produto_id
GROUP BY p.categoria
ORDER BY total_vendas DESC;

-- Vendas por mês
SELECT 
    EXTRACT(YEAR FROM data_venda) as ano,
    EXTRACT(MONTH FROM data_venda) as mes,
    COUNT(*) as total_vendas,
    SUM(total_venda) as valor_total
FROM vendas
GROUP BY ano, mes
ORDER BY ano, mes;

-- Clientes que mais compraram
SELECT 
    c.cliente_id,
    c.nome,
    c.cidade,
    c.estado,
    COUNT(v.venda_id) as total_compras,
    SUM(v.total_venda) as valor_total_gasto
FROM clientes c
JOIN vendas v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nome, c.cidade, c.estado
ORDER BY valor_total_gasto DESC
LIMIT 5;

-- Produtos mais vendidos
SELECT 
    p.produto_id,
    p.nome,
    p.categoria,
    SUM(iv.quantidade) as total_vendido,
    SUM(iv.total_item) as valor_total_vendido
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.nome, p.categoria
ORDER BY total_vendido DESC
LIMIT 5;