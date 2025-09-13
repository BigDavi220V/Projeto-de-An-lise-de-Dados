-- CONTEÚDO ########################################################################
-- Inserção de colunas
-- Alteração de colunas
-- Deleção de colunas


-- EXEMPLOS ########################################################################

-- (Exemplo 1) Inserção de Colunas
-- Insira uma coluna na tabela sales.customers com a idade do cliente
ALTER TABLE sales.customers
ADD customer_age int;

SELECT * FROM sales.customers
LIMIT 10;

UPDATE sales.customers
SET customer_age = datadiff('y', birth_date, current_date)
WHERE customer_age is null;

-- (Exemplo 2) Alteração do tipo da coluna
-- Altere o tipo da coluna customer_age de inteiro para varchar
ALTER TABLE sales.customers
ALTER COLUMN customer_age type varchar;

-- (Exemplo 3) Alteração do nome da coluna
-- Renomeie o nome da coluna "customer_age" para "age"
ALTER TABLE sales.customers
RENAME COLUMN customer_age to age;

SELECT * FROM sales.customers
LIMIT 10;

-- (Exemplo 4) Deleção de coluna
-- Delete a coluna "age"
ALTER TABLE sales.customers
DROP COLUMN age;

SELECT * FROM sales.customers
LIMIT 10;

-- RESUMO ##########################################################################
-- (1) Para fazer qualquer modificação nas colunas de uma tabela utiliza-se o comando 
-- ALTER TABLE seguido do nome da tabela
-- (2) Para adicionar colunas utiliza-se o comando ADD seguido do nome da coluna e da
-- unidade da nova coluna
-- (3) Para mudar o tipo de unidade de uma coluna utiliza-se o comando ALTER COLUMN 
-- (4) Para renomear uma coluna utiliza-se o comando RENAME COLUMN
-- (5) Para deletar uma coluna utiliza-se o comando DROP COLUMN
