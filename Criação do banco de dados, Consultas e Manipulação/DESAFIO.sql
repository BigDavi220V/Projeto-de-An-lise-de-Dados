-- EXERCÍCIOS ######################################################################

-- (Exercício 1) Selecione os nomes de cidade distintas que existem no estado de
-- Minas Gerais em ordem alfabética (dados da tabela sales.customers)
select distinct city, state
from sales.customers
where state = 'MS'
order by city;

-- (Exercício 2) Selecione o visit_id das 10 compras mais recentes efetuadas
-- (dados da tabela sales.funnel)

select visit_id, visit_page_date
from sales.funnel
order by visit_page_date desc
limit 10;
-- (Exercício 3) Selecione todos os dados dos 10 clientes com maior score nascidos
-- após 01/01/2000 (dados da tabela sales.customers)
select *
from sales.customers
where birth_date >'20000101'
order by score desc
limit 10;
