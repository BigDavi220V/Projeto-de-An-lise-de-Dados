-- (Query 1) Receita, leads, conversão e ticket médio mês a mês
-- Colunas: mês, leads (#), vendas (#), receita (k, R$), conversão (%), ticket médio (k, R$)
select * from sales.funnel limit 50;
-- leads = visitas. OU seja visitas na loja.

-- Mês e Leads:
	WITH leads as(
		SELECT
		date_trunc('month', visit_page_date)::date as visit_page_month,
		count(*) as visit_page_count
		from sales.funnel
		group by visit_page_month
		order by visit_page_month),

	payments as (
		SELECT
		date_trunc('month',paid_date)::date as paid_month,
		COUNT(fun.paid_date) as paid_count,-- numero de vendas
		SUM(pro.price * (1 + fun.discount)) as receita
		FROM sales.products as pro
			LEFT JOIN sales.funnel as fun
				ON pro.product_id = fun.product_id
		WHERE fun.paid_date is not null
		GROUP BY paid_month
		ORDER BY paid_month )

SELECT
leads.visit_page_month as "Mês",
leads.visit_page_count as "Leads",
payments.paid_count as "Vendas",
(payments.receita / 1000) as "Receita (K, R$)",
((payments.paid_count::float / leads.visit_page_count::float)*100) as "Conversão %",
((payments.receita / payments.paid_count)/1000) as "Ticket Médio (K, R$)"
FROM leads
 LEFT JOIN payments
 	ON leads.visit_page_month = payments.paid_month;


-- (Query 2) Estados que mais venderam
-- Colunas: país, estado, vendas (#)
SELECT
	'Brazil' as pais,
	re.state as estado,
	COUNT(fun.paid_date) as vendas
	from sales.funnel as fun
		LEFT JOIN sales.customers as cus
			ON fun.customer_id = cus.customer_id
				LEFT JOIN temp_tables.regions as re
					ON cus.state = re.state
WHERE fun.paid_date between '2021-08-01' and '2021-08-31'
GROUP BY re.state, pais
ORDER BY vendas DESC
LIMIT 5;

-- (Query 3) Marcas que mais venderam no mês
-- Colunas: marca, vendas (#)
SELECT * FROM sales.funnel LIMIT 10;

SELECT 
pro.brand as marcas,
COUNT(fun.paid_date) as vendas
FROM sales.funnel as fun
	LEFT JOIN sales.products as pro
		ON pro.product_id = fun.product_id
WHERE fun.paid_date between '2021-08-010' and '2021-08-31'
GROUP BY marcas
ORDER BY vendas DESC
LIMIT 5;

-- (Query 4) Lojas que mais venderam
-- Colunas: loja, vendas (#)
SELECT store_name as loja,
COUNT(fun.paid_date) as vendas
FROM sales.stores as sto
	LEFT JOIN sales.funnel as fun
		ON sto.store_id = fun.store_id
WHERE fun.paid_date between '2021-08-010' and '2021-08-31'
GROUP BY loja
ORDER BY vendas DESC
LIMIT 5;

-- (Query 5) Dias da semana com maior número de visitas ao site
-- Colunas: dia_semana, dia da semana, visitas (#)
SELECT
EXTRACT ('dow' FROM visit_page_date) as dia_semana,
CASE
		WHEN EXTRACT ('dow' FROM visit_page_date) = 0 THEN 'Domingo'
		WHEN EXTRACT ('dow' FROM visit_page_date) = 1 THEN 'Segunda'
		WHEN EXTRACT ('dow' FROM visit_page_date) = 2 THEN 'Terça'
		WHEN EXTRACT ('dow' FROM visit_page_date) = 3 THEN 'Quarta'
		WHEN EXTRACT ('dow' FROM visit_page_date) = 4 THEN 'Quinta'
		WHEN EXTRACT ('dow' FROM visit_page_date) = 5 THEN 'Sexta'
		WHEN EXTRACT ('dow' FROM visit_page_date) = 6 THEN 'Sábado'
		Else null
		End dia_da_semana,
		COUNT(*) as visitas
FROM sales.funnel
WHERE visit_page_date between '2021-08-010' and '2021-08-31'
GROUP BY dia_semana
ORDER BY dia_semana;
