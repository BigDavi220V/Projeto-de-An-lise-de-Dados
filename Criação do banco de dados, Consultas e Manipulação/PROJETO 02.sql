-- (Query 1) Gênero dos leads
-- Colunas: gênero, leads(#)
SELECT 
CASE
	WHEN ibge.gender = 'male' THEN 'Homens'
	WHEN ibge.gender = 'famale' THEN 'Mulheres'
	END as "genero",
COUNT(ibge.gender) as leads
FROM sales.customers as cus
	LEFT JOIN temp_tables.ibge_genders as ibge
		ON lower(cus.first_name) = lower(ibge.first_name)
GROUP BY ibge.gender;


-- (Query 2) Status profissional dos leads
-- Colunas: status profissional, leads (%)

select * from sales.customers limit 10; --colana: professional_status
select* from sales.funnel limit 10; -- coluna: visit_page_date

SELECT
	CASE
		WHEN professional_status = 'freelancer' THEN 'Freelancer'
		WHEN professional_status = 'retired' THEN 'Aposentado(a)'
		WHEN professional_status = 'clt' THEN 'Clt'
		WHEN professional_status = 'self_employed' THEN 'Autônomo(a)'
		WHEN professional_status = 'other' THEN 'Outros'
		WHEN professional_status = 'businessman' THEN 'Empresário(a)'
		WHEN professional_status = 'civil_servant' THEN 'Funcionário(a) público'
		WHEN professional_status = 'student' THEN 'Estudante'
		End as "Status Profissional",
		ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM sales.customers),9)*100 as "leads %"
FROM sales.customers
GROUP BY professional_status
ORDER BY "leads %"; 



-- (Query 3) Faixa etária dos leads
-- Colunas: faixa etária, leads (%)
SELECT
	CASE
		WHEN datadiff('years', birth_date, current_date) < 20 THEN '0 - 20'
		WHEN datadiff('years', birth_date, current_date) < 40 THEN '20 - 40'
		WHEN datadiff('years', birth_date, current_date) < 60 THEN '40 - 60'
		WHEN datadiff('years', birth_date, current_date) < 80 THEN '60 - 80'
		Else '80+'
		End as "Faixa Etária",
	(COUNT(*)::float / (SELECT COUNT(*) FROM sales.customers))*100 as "leads (%)"
FROM sales.customers
GROUP BY "Faixa Etária"
ORDER BY "Faixa Etária" DESC;


-- (Query 4) Faixa salarial dos leads
-- Colunas: faixa salarial, leads (%), ordem
SELECT DISTINCT (income) FROM sales.customers order by income; -- maior 70.000 e menor 2.230
SELECT
	CASE
		WHEN income < 5000 THEN '0 - 5000'
		WHEN income < 10000 THEN '5000 - 10000'
		WHEN income < 15000 THEN '10000 - 15000'
		WHEN income < 20000 THEN '15000 - 20000'
		ELSE '20000+'
		END as "Faixa de Salarial",
	(COUNT(*)::float / (SELECT COUNT(*) FROM sales.customers))*100 as "leads (%)",
		CASE
			WHEN income < 5000 THEN '1'
			WHEN income < 10000 THEN '2'
			WHEN income < 15000 THEN '3'
			WHEN income < 20000 THEN '4'
			ELSE '5'
			END as "Ordem"
FROM sales.customers
GROUP BY "Faixa de Salarial", "Ordem"
ORDER BY "Ordem" DESC;

-- (Query 5) Classificação dos veículos visitados
-- Colunas: classificação do veículo, veículos visitados (#)
-- Regra de negócio: Veículos novos tem até 2 anos e seminovos acima de 2 anos

WITH classificacao_veiculos as (
SELECT
funnel.visit_page_date,
products.model_year,
extract('year' FROM visit_page_date) - products.model_year::int as "Idade do Veículo",
CASE
	WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 2 THEN 'Novo'
	else 'Seminovo'
	END as "Classificação do Veículo"
FROM sales.funnel
	LEFT JOIN sales.products
		ON funnel.product_id = products.product_id
)
SELECT
"Classificação do Veículo",
COUNT(*) as "Veículos Visitados"
FROM classificacao_veiculos
GROUP BY "Classificação do Veículo";

-- (Query 6) Idade dos veículos visitados
-- Colunas: Idade do veículo, veículos visitados (%), ordem

WITH faixa_de_idade_dos_veiculos as (
SELECT
funnel.visit_page_date,
products.model_year,
extract('year' FROM visit_page_date) - products.model_year::int as "Idade Veículo",
CASE
	WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 2 THEN 'Até 2 anos'
	WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 4 THEN 'De 2 à 4 anos'
	WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 6 THEN 'De 4 à 6 anos'
	WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 8 THEN 'De 6 à 8 anos'
	WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 10 THEN 'De 8 à 10 anos'
	else 'Acima de 10 anos'
	END as "Idade do Veículo",
		CASE
			WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 2 THEN '1'
			WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 4 THEN '2'
			WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 6 THEN '3'
			WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 8 THEN '4'
			WHEN (extract('year' FROM visit_page_date) - products.model_year::int) <= 10 THEN '5'
			else '6'
			END as "ORDEM"
FROM sales.funnel
	LEFT JOIN sales.products
		ON funnel.product_id = products.product_id
)
SELECT
"Idade do Veículo",
(COUNT(*)::float/(SELECT COUNT(*) FROM sales.funnel))*100 as "Veículos Visitados (%)",
"ORDEM"
FROM faixa_de_idade_dos_veiculos
GROUP BY "Idade do Veículo", "ORDEM"
ORDER BY "ORDEM";


-- (Query 7) Veículos mais visitados por marca
-- Colunas: brand, model, visitas (#)
SELECT
pro.brand,
pro.model,
COUNT(fun.visit_page_date) as "Visitas (#))"
FROM sales.funnel as fun
	LEFT JOIN sales.products as pro
		ON fun.product_id = pro.product_id
GROUP BY pro.brand, pro.model
ORDER BY pro.brand, pro.model, "Visitas (#))";








