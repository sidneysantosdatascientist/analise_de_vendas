-- Verificando todas as tabelas criadas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Verificando a estrutura de uma tabela específica
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'clientes' 
ORDER BY ordinal_position;

-- Verificando as views criadas
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public' 
ORDER BY table_name;