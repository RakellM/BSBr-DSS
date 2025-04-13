########### FASE 2
describe erp.tbdependente;
describe erp.tbestoqueproduto;
describe erp.tbvendas;
describe erp.tbvendedor;

# Filtrar a tabela de vendedores pelo vendedor de nome: Vendedor 6
select 
	CdVdd as `Vendedor Código`,
	NmVdd as `Vendedor Nome`,
    case
		when SxVdd = 1 then 'Masculino'
        when SxVdd = 0 then 'Feminino'
        else NULL
	end as `Vendedor Sexo`,
    PercComissao as `Vendedor Percentual Comissão`
from erp.tbvendedor
where trim(NmVdd) like "% 6" ;

# Uma consulta que retorne o nome dos dependentes, mas quando for o 
#dependente de código 5, retorne o seu nome. (Usando IF ou CASE)
select
	CdDep as `Dependente Código`,
    case
		when CdDep = 5 then 'Raquel'
        else NmDep
	end as `Dependente Nome`,
    date(DtNasc) as `Data de Nascimento`,
    SxDep as `Dependente Sexo`,
    CdVdd as `Vendedor Código`,
    InepEscola
from erp.tbdependente;

# Retornar todas as vendas entre os dias 07/05/2019 a 03/03/2021 unidas 
#com as todas as vendas entre os dias 11/09/2011 a 03/09/2012
select * 
from erp.tbvendas
where date(DtVen) between '2019-05-07' and '2021-03-03'
union
select * 
from erp.tbvendas
where date(DtVen) between '2011-09-11' and '2012-09-03' ;

#or

select 	
	CdVen as `Código de Vendas`,
    date(DtVen) as `Data da Venda`,
    CdCli as `Cliente Código`,
    trim(NmCli) as `Cliente Nome`, 
    trim(Cidade) as `Cidade`,
    trim(Estado) as `Estado`,
    trim(Pais) as `País`, 
    CdPro as `Produto Código`,
    trim(NmPro) as `Produto Nome`,
    trim(TpPro) as `Produto Tipo`,
    Qtd as `Quantidade Vendida`,
    trim(Und) as `Unidade de Medida`,
    VrUnt as `Valor Unitário`,
    CdVdd as `Vendedor Código`,
    trim(NmCanalVendas) as `Canal de Vendas`,
    status,
    deletado 
from erp.tbvendas
where (date(DtVen) between '2019-05-07' and '2021-03-03') or (date(DtVen) between '2011-09-11' and '2012-09-03') ;


# Retornar o nome do produto (apenas os 5 primeiros caracteres) e a quantidade 
#de venda com 10 dígitos, completando com zeros a esquerda.
select 
	CdPro as `Produto Código`,
	trim(NmPro) as `Produto Nome`,
    left(trim(NmPro),5) as `Primeiras 5 letras do Produto Nome`,
    lpad(sum(Qtd),10,0) as `LPad Quantidade Vendida`,
	sum(Qtd) as `Quantidade Vendida`    
from erp.tbvendas
group by 1,2,3,4;

# Qual o produto que tem a maior quantidade de vendas no canal: Ecommerce?
select 
#	CdCanalVendas, 
    trim(NmCanalVendas) as `Canal de Vendas`,
    NmPro as `Produto Nome`,
    sum(Qtd) as `Quantidade Vendas`
from erp.tbvendas
where CdCanalVendas=2
group by 1,2#,3
order by sum(Qtd) desc 
limit 1;

# Existiram vendas para produtos em MVP - validação? Quais foram?
select 
	t1.CdVen as `Código de Vendas`,
    date(t1.DtVen) as `Data da Venda`,
    t1.CdCli as `Cliente Código`,
    trim(t1.NmCli) as `Cliente Nome`, 
    trim(t1.Cidade) as `Cidade`,
    trim(t1.Estado) as `Estado`,
    trim(t1.Pais) as `País`, 
    t1.CdPro as `Produto Código`,
    trim(t1.NmPro) as `Produto Nome`,
    trim(t1.TpPro) as `Produto Tipo`,
    t1.Qtd as `Quantidade Vendida`,
    trim(t1.Und) as `Unidade de Medida`,
    t1.VrUnt as `Valor Unitário`,
    t1.CdVdd as `Vendedor Código`,
    trim(t1.NmCanalVendas) as `Canal de Vendas`,
    trim(t1.status),
    t1.deletado
from erp.tbvendas t1
inner join (
	select distinct CdPro from erp.tbestoqueproduto where trim(Status) = 'MVP - validação'
    )t2
on t1.CdPro = t2.CdPro ;

# Quantas vendas encontram-se deletadas logicamente?
select
	case
		when deletado = 1 then 'Sim'
        when deletado = 0 then 'Não'
	end as `Deletado Logicamente`,
    count(distinct(CdVen)) as `Quantidade de Vendas`
from erp.tbVendas
group by 1 
order by `Deletado Logicamente` desc
limit 1;

# Quantas vendas encontram-se canceladas?
select
	trim(status) as `Status da Venda`,
    count(distinct(CdVen)) as `Quantidade de Vendas`
from erp.tbVendas
where status like "%Cancelado%"
group by 1 ;

# Na tabela de dependentes, temos o código da Escola que o dependente estuda, 
#precisamos além do códido da escola (INEP), saber o nome da escola de cada um 
#dos dependentes estudam. (planilha com nome da escola em anexo)

drop table if exists erp.censo2020_INEP ;
create table erp.censo2020_INEP (
    restricao_atendimento TEXT,
    Escola TEXT,
    CdINEP INT,
    UF TEXT,
    Municipio TEXT,
    Localizacao TEXT,
    CatAdm TEXT,
    Porte TEXT
) ;

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Censo2020_inep.csv'
	into table erp.censo2020_INEP
	fields terminated by ';' 
	enclosed by '"'
	lines terminated by '\n'
	ignore 1 rows;


select 
	t1.CdDep as `Dependente Código`,
	trim(t1.NmDep) as `Dependente Nome`,
	date(t1.DtNasc) as `Data de Nascimento`,
	trim(t1.SxDep) as `Dependente Sexo`,
	t1.CdVdd as `Vendedor Código`,
	t1.INEPEscola as `Escola Código INEP`,
	trim(t2.Escola) as `Escola Nome`
from erp.tbDependente t1
left join erp.censo2020_INEP t2
on t1.INEPEscola = t2.CdINEP;




