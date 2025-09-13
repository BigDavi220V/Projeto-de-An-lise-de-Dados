-- EXERCÍCIOS ########################################################################

-- (Exercício 1) Crie uma coluna calculada com o número de visitas realizadas por cada
-- cliente da tabela sales.customers
with qtd_visita(

select customer_id, 
count(*) as total_de_visitas
from sales.funnel
group by customer_id

)

select cus.*,
qtd_visita.total_de_visitas
from sales.customers as cus
left join qtd_visita as ndv
on cus.customer_id = ndv.customer_id;

/*with numero_de_visitas as (

	select customer_id, count(*) as n_visitas
	from sales.funnel
	group by customer_id

)

select
	cus.*,
	n_visitas

from sales.customers as cus
left join numero_de_visitas as ndv
	on cus.customer_id = ndv.customer_id*/