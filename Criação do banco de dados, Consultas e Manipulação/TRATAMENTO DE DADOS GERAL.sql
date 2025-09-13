-- TIPOS ###########################################################################
-- CASE WHEN
-- COALESCE()


-- EXEMPLOS ########################################################################

-- (Exemplo 1) Agrupamento de dados com CASE WHEN
-- Calcule o nº de clientes que ganham abaixo de 5k, entre 5k e 10k, entre 10k e 
-- 15k e acima de 15k
select * from sales.customers limit 10;

with faixa_de_renda as ( 
select 
	income,
		case
			when income < 5000 then 'Renda de R$0 - R$5000'
			when income >= 5000 and income < 10000 then 'Renda de R$5000 - R$10000'
			when income >= 10000 and income < 15000 then 'Renda de R$10000 - R$15000'
			else 'Renda superior à R$15000'
			end as faixa_renda -- nome da coluna
from sales.customers
)
select faixa_renda, 
count(*)
from faixa_de_renda
group by faixa_renda;

-- (Exemplo 2) Tratamento de dados nulos com COALESCE
-- Crie uma coluna chamada populacao_ajustada na tabela temp_tables.regions e
-- preencha com os dados da coluna population, mas caso esse campo estiver nulo, 
-- preencha com a população média (geral) das cidades do Brasil
select * from temp_tables.regions limit 10;

-- Opção 1
select *,
		case 
			when population is not null then population
			else (select avg(population) from temp_tables.regions)
			end as populacao_ajustada
from temp_tables.regions
where population is null;

-- Opção 2
select *,
		coalesce(population,(select avg(population) from temp_tables.regions)) as populacao_ajustada
from temp_tables.regions; -- quando não é visto valor nullo na coluna population

select *,
		coalesce(population,(select avg(population) from temp_tables.regions)) as populacao_ajustada
from temp_tables.regions 
where population is null; -- quando é visto a coluna population nullo.

-- RESUMO ##########################################################################
-- (1) CASE WHEN é o comando utilizado para criar respostas específicas para 
-- diferentes condições e é muito utilizado para fazer agrupamento de dados
-- (2) COALESCE é o comando utilizado para preencher campos nulos com o primeiro
-- valor não nulo de uma sequência de valores.

