-- EXEMPLOS ########################################################################

-- (Exemplo 1) Análise de recorrência dos leads
-- Calcule o volume de visitas por dia ao site separado por 1ª visita e demais visitas
with primeira_visita as (
		select customer_id,
			min(visit_page_date) as visita_1
		from sales.funnel
		group by customer_id
)
	select fun.visit_page_date,
	(fun.visit_page_date <> primeira_visita.visita_1) as lead_recorrente,
	count(*)
	from sales.funnel as fun
		left join primeira_visita
			on fun.customer_id = primeira_visita.customer_id
	group by fun.visit_page_date, lead_recorrente
	order by fun.visit_page_date desc, lead_recorrente;

-- (Exemplo 2) Análise do preço versus o preço médio
-- Calcule, para cada visita ao site, quanto o preço do um veículo visitado pelo cliente
-- estava acima ou abaixo do preço médio dos veículos daquela marca 
-- (levar em consideração o desconto dado no veículo)

WITH preco_medio AS (
    SELECT brand,
           AVG(price) AS preco_medio_da_marca
    FROM sales.products
    GROUP BY brand
)
SELECT 
    fun.visit_id,
    fun.visit_page_date,
    pro.brand,
    (pro.price * (1 + fun.discount)) AS preco_final,
    preco_medio.preco_medio_da_marca,
    ((pro.price * (1 + fun.discount)) - preco_medio.preco_medio_da_marca) AS preco_vs_media
FROM sales.funnel AS fun
LEFT JOIN sales.products AS pro
    ON fun.product_id = pro.product_id
LEFT JOIN preco_medio
    ON pro.brand = preco_medio.brand;
