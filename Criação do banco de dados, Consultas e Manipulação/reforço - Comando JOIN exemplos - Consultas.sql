-- EXERCÍCIOS ########################################################################

-- (Exemplo 1) Identifique qual é o status profissional mais frequente nos clientes 
-- que compraram automóveis no site
select first_name, professional_status
from sales.customers
limit 10;
select *from sales.funnel limit 10; -- paid_date = pagamento

select professional_status,
count(paid_date) as pagamento
from sales.funnel as fun
left join sales.customers as cus
on fun.customer_id = cus.customer_id
group by professional_status
order by pagamento desc;

-- (Exemplo 2) Identifique qual é o gênero mais frequente nos clientes que compraram
-- automóveis no site. Obs: Utilizar a tabela temp_tables.ibge_genders
select * from temp_tables.ibge_genders limit 10;
select * from sales.customers limit 10;

select ibge.gender as genero,
count(fun.paid_date) as pagamento
from sales.funnel as fun
left join sales.customers as cus
on fun.customer_id = cus.customer_id
left join temp_tables.ibge_genders as ibge
on lower(cus.first_name) = ibge.first_name -- já que o sql faz o camocase
group by ibge.gender;					   -- o lower é usado para tranformar as letras maicusclas
										    -- em minusculas para realizar a consulta com precisão.


-- (Exemplo 3) Identifique de quais regiões são os clientes que mais visitam o site
-- Obs: Utilizar a tabela temp_tables.regions
select * from sales.customers limit 10;
select * from temp_tables.regions limit 10;
select * from sales.funnel limit 5;

select regiao.region,
count(fun.visit_page_date) as visita
from sales.funnel as fun
left join sales.customers as cus
	on fun.customer_id = cus.customer_id
left join temp_tables.regions as regiao
	on lower(cus.city) = lower(regiao.city)
	and lower(cus.state) = lower(regiao.state)
group by regiao.region
order by visita desc;

