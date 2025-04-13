########### FASE 1
describe erp.tbdependente;
describe erp.tbestoqueproduto;
describe erp.tbvendas;
describe erp.tbvendedor;


# Quantidade de dependentes
select ("Dependentes") as Total, 
	count(distinct(CdDep)) as Quantidade 
    from erp.tbdependente 
    group by 1;

# Quantidade de dependentes por sexo
select ("Dependentes") as Total, 
	trim(SxDep) as Sexo, 
    count(distinct(CdDep)) as Quantidade 
    from erp.tbdependente 
    group by 1,2;

# Quantidade de clientes da região sul
select ("Clientes") as Total,
	("Sul") as `Região`,
	count(distinct(CdCli)) as Quantidade
	from erp.tbvendas
    where trim(Estado) in ('Paraná', 'Santa Catarina', 'Rio Grande do Sul')
    group by 1;

# Uma descrição breve dos produtos da empresa (codigo, nome, tipo)
select distinct CdPro as `Código Produto`,
	trim(NmPro) as `Nome Produto`,
    trim(TpPro) as `Tipo Produto`
    from erp.tbvendas;

# Quais os 5 produtos mais vendidos de 2021?
select CdPro as `Código Produto`,
	trim(NmPro) as `Nome Produto`,
    trim(TpPro) as `Tipo Produto`,
    sum(Qtd) as Quantidade
    from erp.tbvendas
    where year(DtVen) = 2021
    group by 1,2,3
    order by Quantidade desc
    limit 5;

# Nome, Nome em Maiúsculo e Nome em Minúsculo, dos vendedores do sexo feminino
select trim(NmVdd) as `Nome Vendedor`,
	upper(trim(NmVdd)) as `Nome Vendedor (maiúsculo)`,
    lower(trim(NmVdd)) as `Nome Vendedor (minúsculo)`
	from erp.tbvendedor
    where SxVdd = 0 -- 1=Masc e 0=Fem
    ;

# Nome e idade de todos os dependentes, ordenados do mais velho para o mais novo
select trim(NmDep) as `Nome Dependente`,
	floor( datediff( date(localtimestamp()) , date(DtNasc) ) / 365 ) as Idade
    from erp.tbdependente 
    order by Idade desc;
    
# Somatório do Valor Total de Vendas (concluídas e não deletadas) por Estado
select trim(Estado) as Estado,
#	status,
#    deletado,
#    sum(Qtd) as Quantidade,
    sum(Qtd * VrUnt) as `Valor vendido`
    from erp.tbvendas
    where status like "%Concluído%" and deletado = 0  #variáveis binarias 0 é falso e 1 é verdadeiro
    group by 1#,2,3
    order by `Valor Vendido` desc;

# Somatório de Unidades Vendidas (concluídas e não deletadas) por Produto
select trim(NmPro) as Estado,
#	 status,
#    deletado,
    sum(Qtd) as Quantidade
#    sum(Qtd * VrUnt) as `Valor Vendido`
    from erp.tbvendas
    where status like "%Concluído%" and deletado = 0  #variáveis binarias 0 é falso e 1 é verdadeiro
    group by 1#,2,3
    order by Quantidade desc;

# Média do Valor Total de Vendas por Estado
select trim(Estado) as Estado,
#	 status,
#    deletado,
#    sum(Qtd) as Quantidade,
    round(sum(Qtd * VrUnt), 2) as `Valor Vendido`,
    count(*) as n,
    round(avg(Qtd * VrUnt), 2) as `Valor Médio`
    from erp.tbvendas
#    where status like "%Concluído%" and deletado = 0  #variáveis binarias 0 é falso e 1 é verdadeiro
    group by 1#,2,3
    order by `Valor Médio` desc;

# Nome dos clientes que compram o produto 1
select distinct 
	CdPro as `Código Produto`,
    trim(NmPro) as `Nome Produto`,
    trim(NmCli) as `Nome Cliente`
    from erp.tbvendas
    where CdPro = 1 ;

# Quantidade mínima e qual o respectivo produto
select 
	CdPro as `Código Produto`,
    trim(NmPro) as `Nome Produto`,
#    min(Qtd) over(partition by CdVen) as `Qtd partmin`,
#    sum(Qtd) over() as `Qtd part`,
    min(Qtd) as `Quantidade Mínima`
    from erp.tbvendas
    group by 1,2
    order by `Quantidade Mínima`
    limit 1;

# Uma descrição detalhada dos produtos da empresa (codigo, nome, tipo, Qtd em Estoque)
select
	t2.CdPro as `Código Produto`,
    trim(t1.NmPro) as `Nome Produto`,
    t1.TpPro as `Tipo Produto`,
    t1.Und as `Unidade de Medida`, 
    t2.QtdPro_sum as `Estoque Quantidade`
    from (
		select distinct CdPro, NmPro, TpPro, Und 
        from erp.tbvendas 
        ) t1
    right join (
		select CdPro, sum(QtdPro) as QtdPro_sum 
        from erp.tbestoqueproduto 
        group by 1
        ) t2
    on t1.CdPro = t2.CdPro 
    order by `Estoque Quantidade`;

# Nome dos Vendedores que realizaram determinadas Vendas (Codigo da Venda, Data da Venda, Produto e nome do vendedor)
select
	t1.CdVen as `Código de Vendas`,
    date(t1.DtVen) as `Data da Venda`,
    t1.NmPro as `Produto Nome`,
    trim(t2.NmVdd) as `Vendendor Nome`
from (
	select
		CdVen, 
		DtVen,
		trim(NmPro) as NmPro,
		CdVdd,
		sum(Qtd) as Qtd
	from erp.tbvendas
	group by 1,2,3,4 ) t1
left join erp.tbvendedor t2
on t1.CdVdd = t2.CdVdd 
order by `Data da Venda`;

# Relação com o nome dos vendedores e seus respectivos filhos (dependentes - nome e data de nascimento) -- montar uma view com estes dados
create view erp.vwDependentes as
select
	t1.NmVdd as `Vendedor Nome`,
    t2.NmDep as `Dependente Nome`,
    date(t2.DtNasc) as `Data de Nascimento`
from erp.tbvendedor t1
left join erp.tbdependente t2
on t1.CdVdd = t2.CdVdd
order by t1.CdVdd;

select * from erp.vwDependentes ;

# drop view if exists erp.vwDependentes ;

# Criar uma view com informações de vendas, produto, estoque, cliente, vendedores (apenas concluídas e não deletadas)
create view erp.vwVendas as
select 
	a.CdVen as `Código da Venda`,
	date(a.DtVen) as `Data da Venda`,
    a.CdCli as `Código do Cliente`,
    trim(a.NmCli) as `Nome do Cliente`,
    a.CdVdd as `Código do Vendedor`,
    trim(b.NmVdd) as `Vendedor Nome`,
	case
		when b.SxVdd = 1 then "Masculino"
        when b.SxVdd = 0 then "Feminino"
        else NULL
	end as `Vendedor Sexo`,
	b.PercComissao as `Percentual Comissão do Vendedor`,
    trim(a.Cidade) as `Cidade`,
    trim(a.Estado) as `Estado`,
    trim(a.Pais) as `País`,
	a.CdPro as `Código do Produto`,
    trim(a.NmPro) as `Nome do Produto`,
    trim(a.TpPro) as `Tipo do Produto`,
    trim(a.Und) as `Unidade de Medida`,
    a.VrUnt as `Valor Unitário`,
    a.Qtd as `Quantidade Vendida`, 
    (a.Qtd * a.VrUnt) as `Valor vendido`,
    a.QtdPro_sum as `Quantidade em Estoque`
from (
	select
		t1.*,
		t2.QtdPro_sum
		from (
			select *
			from erp.tbvendas
			where status like "%Concluído%" and deletado = 0  #variáveis binarias 0 é falso e 1 é verdadeiro
			) t1
		left join (
			select CdPro, sum(QtdPro) as QtdPro_sum 
			from erp.tbestoqueproduto 
			group by 1
			) t2
		on t1.CdPro = t2.CdPro 
    
	) a
left join erp.tbvendedor b
on a.CdVdd = b.CdVdd ;

select * from erp.vwVendas ;

#	drop view if exists erp.vwVendas ;

# View de quantidade de vendas por canal
create view erp.vwVendasPorCanal as
select 
	CdCanalVendas as `Códido Canal`,
	trim(NmCanalVendas) as `Canal de Vendas`,
    count(distinct(CdVen)) as `Quantidade Vendas`
from erp.tbvendas
group by 1,2;

select * from erp.vwVendasPorCanal ;

#	drop view if exists erp.vwVendasPorCanal ;