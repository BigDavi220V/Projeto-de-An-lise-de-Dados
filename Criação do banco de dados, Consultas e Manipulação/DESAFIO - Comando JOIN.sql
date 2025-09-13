-- EXERCÍCIOS ########################################################################

-- (Exercício 1) Identifique quais as marcas de veículo mais visitada na tabela sales.funnel
select * from sales.funnel limit 5;
select * from sales.products limit 5;

select prod.brand as marca,
count(fun.visit_page_date) as qtd_visitas
from sales.products as prod
left join sales.funnel as fun
		on prod.product_id = fun.product_id
group by prod.brand
order by qtd_visitas desc;

-- (Exercício 2) Identifique quais as lojas de veículo mais visitadas na tabela sales.funnel
select * from sales.funnel limit 5;
select * from sales.stores;

select st.store_name as nome,
count(fun.visit_page_date) as qtd_visitas
from sales.stores as st
left join sales.funnel as fun
	on st.store_id = fun.store_id
group by nome
order by qtd_visitas desc;

-- (Exercício 3) Identifique quantos clientes moram em cada tamanho de cidade (o porte da cidade
-- consta na coluna "size" da tabela temp_tables.regions)
select * from temp_tables.regions order by size;
select * from sales.customers limit 10;

select reg.size as tamanho_cidade,
count(cus.customer_id) as qtd_clientes
from sales. customers as cus
 left join temp_tables.regions as reg
 	on lower(cus.city) = lower(reg.city)
	 	and lower(cus.state) = lower(reg.state)
group by tamanho_cidade
order by qtd_clientes desc;