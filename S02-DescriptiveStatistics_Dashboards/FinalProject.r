# MBA Data Science & Statistics
# Disciplina: Estatística Descritiva e Contrucao de Dashboards
# Projeto FInal
# Membros: Marcus Dias / Raquel Marques / Ricardo Nascimento

# curso escolhido para analise: 6306 = Engenharia

# Listar items na area de trabalho
ls()
# Remover items da area de trabalho
rm(list=ls())

# Pacotes
load.pks <- c(
  "readr",
  "ggplot2",
  "plotly",
  "e1071",
  "dplyr",
  "Hmisc",
  "DescTools",
  "esquisse",
  "gridExtra",
  "kableExtra"
)
#Instalar
# lapply(load.pks, install.packages, character.only = TRUE)
lapply(load.pks, require, character.only = TRUE)
#remotes::install_github("juba/rmdformats")
#remotes::install_github("glin/reactable")
# DataSet directory
path <- c("C:\\0. R\\Personal\\MBA\\DS\\Materia2\\MBA_ProjetoFinal_original")

# Direcionando a pasta no diretório para o ambiente R
setwd(path)

getwd()

# Carregando DataSet
# Option 1: R base [Mais flexível e menor performance de velocidade]
dataset = read.table(
  "MICRODADOS_ENADE_2017.txt",
  header = TRUE,
  sep = ";",
  dec = ",",
  colClasses = c(NT_OBJ_FG = "numeric")
)

# Option 2: ReadR [menos flexivel e maior performance]
#system.time(
# enade2017 = read_csv2("MICRODADOS_ENADE_2017.txt")
#  )

# Dimensao do BD [rows, columns]
dim(dataset)

# Selecao de variaveis
# Variáveis obrigatorias
## NT_OBJ_FG, CO_GRUPO, CO_REGIAO_CURSO, QE_I02, CO_TURNO_GRADUACAO
# Variaveis adicionais
## CO_MODALIDADE, NU_IDADE, TP_SEXO, ANO_IN_GRAD, QE_I01

ds.filtered= dataset %>% dplyr::select(
  CO_GRUPO,
  CO_REGIAO_CURSO,
  QE_I02,
  CO_TURNO_GRADUACAO,
  CO_MODALIDADE,
  NU_IDADE,
  TP_SEXO,
  ANO_IN_GRAD,
  QE_I01,
  NT_OBJ_FG
)

# Nome das variaveis
names(ds.filtered)

# Filtro curso de Engenharia 6306
ds.engenharia = ds.filtered %>% filter(CO_GRUPO == 6306)

# Certificando que o dataset possui somente o curso escolhido
table(ds.filtered$CO_GRUPO)
table(ds.engenharia$CO_GRUPO)

# Tranformacao das variaveis
#Curso
ds.engenharia = ds.engenharia %>% mutate(
  curso = case_when(
    CO_GRUPO == 6306 ~ "Engenharia",
    TRUE ~ "Outro"
  )
)

#Regiao
ds.engenharia = ds.engenharia %>% mutate(
  regiao = case_when(
    CO_REGIAO_CURSO == 1 ~ "Norte",
    CO_REGIAO_CURSO == 2 ~ "Nordeste",
    CO_REGIAO_CURSO == 3 ~ "Sudeste",
    CO_REGIAO_CURSO == 4 ~ "Sul",
    CO_REGIAO_CURSO == 5 ~ "Centro-Oeste"
  )
)

#Raca
ds.engenharia = ds.engenharia %>% mutate(
  raca = case_when(
    QE_I02 == "A" ~ "Branca",
    QE_I02 == "B" ~ "Preta",
    QE_I02 == "C" ~ "Amarela",
    QE_I02 == "D" ~ "Parda",
    QE_I02 == "E" ~ "Indígena",
    QE_I02 == "F" ~ "Não quero declarar"
  )
)

#Turno
ds.engenharia = ds.engenharia %>% mutate(
  turno = case_when(
    CO_TURNO_GRADUACAO == 1 ~ "Matutino",
    CO_TURNO_GRADUACAO == 2 ~ "Vespertino",
    CO_TURNO_GRADUACAO == 3 ~ "Integral",
    CO_TURNO_GRADUACAO == 4 ~ "Noturno"
  )
)

#Modalidade
ds.engenharia = ds.engenharia %>% mutate(
  modalidade = case_when(
    CO_MODALIDADE == 0 ~ "EaD",
    CO_MODALIDADE == 1 ~ "Presencial"
  )
)

#Sexo
ds.engenharia = ds.engenharia %>% mutate(
  sexo = case_when(
    TP_SEXO == "M" ~ "Masculino",
    TP_SEXO == "F" ~ "Feminino"
  )
)

#Estado Civil
ds.engenharia = ds.engenharia %>% mutate(
  estado_civil = case_when(
    QE_I01 == "A" ~ "Solteiro(a)",
    QE_I01 == "B" ~ "Casado(a)",
    QE_I01 == "C" ~ "Separado(a)",
    QE_I01 == "D" ~ "Viúvo(a)",
    QE_I01 == "E" ~ "Outro"
  )
)

# Nota Bruta na parte Objetiva da formacao
ds.engenharia$nota <- ds.engenharia$NT_OBJ_FG


# Nome das variaveis
names(ds.engenharia)

#Verificando a classe das variaveis
class(ds.engenharia$estado_civil)
class(ds.engenharia$regiao)
class(ds.engenharia$sexo)
class(ds.engenharia$NU_IDADE)
class(ds.engenharia$ANO_IN_GRAD)
class(ds.engenharia$nota)

# ANALISE DESCRITIVA

#describe(ds.engenharia$raca)
#unique(ds.engenharia$raca) %>% kbl %>% kable_material_dark(full_width = F)

#Resumindo os dados
s <- summary(ds.engenharia)
d <- describe(ds.engenharia)

#Analise de cada variavel separada
#variaveis obrigatorias
d$regiao #0 missing
d$raca #551 missing
d$turno #1 missing
#variaveis alternativas
d$modalidade #0 missing
d$sexo #0 missing
d$estado_civil #551 missing
d$nota #1060 missing

unique(d$raca) %>% kbl %>% kable_material_dark(full_width = F)
unique(d$turno) %>% kbl %>% kable_material_dark(full_width = F)
unique(d$nota) %>% kbl %>% kable_material_dark(full_width = F)

#Nota-se que a var NOTA eh a que contem mais missings, entao vale a pena
#remover os faltantes dessa var e ver se depois da remocao se ainda restam
#missings nas demais var explicativas.

#Checar missing na var raca
ds.eng.raca_na <- ds.engenharia %>% filter(!is.na(raca))
d1 <- describe(ds.eng.raca_na)
#variaveis obrigatorias
d1$regiao #0 missing
d1$raca #488 missing
d1$turno #1 missing
#variaveis alternativas
d1$modalidade #0 missing
d1$sexo #0 missing
d1$estado_civil #488 missing
d1$nota #0 missing

unique(d1$raca) %>% kbl %>% kable_material_dark(full_width = F)
unique(d1$estado_civil) %>% kbl %>% kable_material_dark(full_width = F)


summary_na = ds.engenharia %>%
  select(everything()) %>%
  summarise_all(list(~ sum(is.na(.))))
unique(d$raca) %>% kbl %>% kable_material_dark(full_width = F)
unique(d$turno) %>% kbl %>% kable_material_dark(full_width = F) 
summary_na[,12:18] %>% kbl %>% kable_material_dark(full_width = F)
view(summary_na)
#Nota-se que msm depois de remover somente as obs faltantes da var NOTA,
#ainda restaram 488 obs faltantes nas var RACA, 488 na var ESTADO CIVIL
#e 1 na var TURNO.
ds.eng.na.raca <- ds.engenharia %>% filter(!is.na(raca))
d2 <- describe(ds.eng.na.raca)
d2$raca #0 missing
d2$turno #0 missing
d2$estado_civil #1 missing

#Como ESTADO CIVIL eh uma var alternativa no banco de dados sugerido, faz-se
#uma analise das obs faltantes da var RACA.

#analise das obs faltantes da var RACA:
#nota-se que todas as obs da var ESTADO CIVIL tb sao faltantes
#nota-se tb que a unica obs faltante da var TURNO esta presente nesse banco
#Conclusao: ao remover as 488 obs faltantes da var RACA, automaticamente remove
#as faltantes das variaveis ESTADO CIVIL e TURNO.

#Tudo isso para ter certeza que ao remover todas as obs faltantes do banco
#nao afetaria em a analise com e sem as var alternativas que decidiu-se
#incluir no estudo.

#c1 <- ds.engenharia[,c(11:18)]
#c2 <- ds.engenharia[,c(11:15,18)]
#Remover obs faltantes 
ds.eng.final = ds.engenharia[,c(11:18)] %>% na.omit()

summary_final.nas=ds.eng.final %>%
  select(everything()) %>%  
  summarise_all(list(~sum(is.na(.))))
summary_final.nas %>% kbl %>% kable_material_dark(full_width = F)

d3 <- describe(ds.eng.final)

#Quatidade De Linhas Do Banco Original
dim(ds.engenharia)[1]
#Quatidade De Linhas Do Banco sem os NAS
dim(ds.eng.final)[1]

#observaçoes removidas
dim(ds.engenharia)[1] - dim(ds.eng.final)[1]
( dim(ds.engenharia)[1] - dim(ds.eng.final)[1] ) / dim(ds.engenharia)[1] 
# ~13% do banco de Eng foi removido por conter obs faltantes


#Estudar o comportamento das variaveis turno e raca
#Estatisticas descritivas da variável NOTA

#pelo R, temos que se
#k>0, leptocurtica
#k=0, Mesocurtica
#k<0, Platicurtica

#Consideramos então platicúrtica.

ds.eng.final %>%
  select(nota) %>%
  summarise(
    quantidade = n(),
    media = mean(nota),
    mediana = median(nota),
    moda = Mode(nota),
    cv = sd(nota) / media * 100,
    assimetria = skewness(nota),
    curtose = kurtosis(nota)
  ) %>%
  arrange(desc(mediana)) %>% 
  kbl %>% kable_material_dark(full_width = F)

#Estatísticas resumo 
summary(ds.eng.final$nota)



#Como Media < Mediana = Moda e o coef de assimetria é negativo, tenho que a 
#distribuicao eh assimetrica a direita.
#Como o coef de curtose eh negativo, thenho que a distribuicao é platicurtica (achatada).

# Graficos
#GRAFICO HISTOGRAMA DA NOTA DOS ALUNOS COM A FREQUENCIA RELATIVA DAS NOTAS
g_hist = ggplot(ds.eng.final, aes(x = nota)) +
  geom_histogram(color = "black",
                 fill = "lightblue",
                 bins = 10,
                 aes(y = (..count..) / sum(..count..))) +
  ggtitle("Histograma da nota dos alunos de Engenharia") +
  xlab("nota") +
  ylab("Frequência relativa")
g_hist
ggplotly(g_hist)

g_densidade = ggplot(ds.eng.final, aes(x = nota)) +
  geom_density(col = 2, size = 1, aes(y = 30 * (..count..) / sum(..count..))) +
  ggtitle("Curva de densidade da nota dos alunos de Engenharia") +
  xlab("nota") +
  ylab("Frequência relativa")
g_densidade
ggplotly(g_densidade)

g_hist_densidade = ggplot(ds.eng.final, aes(x = nota)) +
  geom_histogram(color = "black",
                 fill = "lightblue",
                 bins = 10,
                 aes(y = (..count..) / sum(..count..))) +
  geom_density(col = 2, size = 1, aes(y = 30 * (..count..) /  sum(..count..))) +
  ggtitle("Histograma e curva de densidade da nota dos alunos de Engenharia") +
  xlab("Nota") +
  ylab("Frequência relativa")
g_hist_densidade
ggplotly(g_hist_densidade)

grid.arrange(g_hist,
             g_densidade,
             g_hist_densidade,
             nrow = 3,
             ncol = 1)


#Comparar as médias por raca e turno
ds.eng.final_mod1 = ds.eng.final %>%
  select(raca, nota, turno) %>%
  group_by(turno, raca) %>%
  summarise(
    quantidade = n(),
    media = mean(nota, na.rm = T),
    mediana = median(nota, na.rm = T),
    cv = sd(nota, na.rm = T) / media * 100,
    amplitude_interquartil = IQR(nota)
  ) %>%
  arrange(desc(mediana))  

ds.eng.final_mod1 %>% 
  kbl %>% kable_material_dark(full_width = F) 

# cada turno separado

ds.eng.final_mod1[ds.eng.final_mod1$turno == "Vespertino",] %>% 
  kbl %>% kable_material_dark(full_width = F)

ds.eng.final_mod1[ds.eng.final_mod1$turno == "Matutino",] %>% 
  kbl %>% kable_material_dark(full_width = F)

ds.eng.final_mod1[ds.eng.final_mod1$turno == "Integral",] %>% 
  kbl %>% kable_material_dark(full_width = F)

ds.eng.final_mod1[ds.eng.final_mod1$turno == "Noturno",] %>% 
  kbl %>% kable_material_dark(full_width = F)


#Tabulação cruzada
table(ds.eng.final$turno,
      ds.eng.final$raca)

#Tabulaçãoo cruzada proporção
prop.table(table(
  ds.eng.final$turno,
  ds.eng.final$raca
))

#Tabulação Raça
table(ds.eng.final$turno)

#Tabulaçãoo Raça - proporção
prop.table(table(
  ds.eng.final$turno
))


#assimetria e curtose - Turno
ds.eng.final_mod2 = ds.eng.final %>% 
  select(turno,nota,raca) %>% 
  group_by(turno) %>% 
  #filter(raca=="Branca") %>% 
  summarise(  quantidade=n(),
              media = mean(nota),
              mediana = median(nota),
              cv=sd(nota)/media*100,
              amplitude_interquartil=IQR(nota),
              assimetria=skewness(nota),
              curtose=kurtosis(nota)
  ) %>% 
  
  arrange(desc(cv))

ds.eng.final_mod2  %>% kbl %>% kable_material_dark(full_width = F)

#assimetria e curtose - Raca
ds.eng.final_mod3 = ds.eng.final %>% 
  select(turno,nota,raca) %>% 
  group_by(raca) %>% 
  #filter(raca=="Branca") %>% 
  summarise(  quantidade=n(),
              media = mean(nota),
              mediana = median(nota),
              cv=sd(nota)/media*100,
              amplitude_interquartil=IQR(nota),
              assimetria=skewness(nota),
              curtose=kurtosis(nota)
  ) %>% 
  
  arrange(desc(cv))

ds.eng.final_mod3  %>% kbl %>% kable_material_dark(full_width = F)



### Item F
#GRAFICOS
#Histograma
grafico_hist.raca= ggplot(ds.eng.final, aes(x = nota, fill = raca)) +
  geom_histogram(binwidth = 10) +
  ggtitle("Gráfico de Histograma da Nota por Raça") +
  ylab("Frequência") +
  xlab("Notas")
ggplotly(grafico_hist.raca)

grafico_hist.turno= ggplot(ds.eng.final, aes(x = nota, fill = turno)) +
  geom_histogram(binwidth = 10) +
  ggtitle("Gráfico de Histograma da Nota por Turno") +
  ylab("Frequência") +
  xlab("Notas")
ggplotly(grafico_hist.turno)

grafico_hist.raca.turno= ggplot(ds.eng.final, aes(x = nota, fill = turno)) +
  geom_histogram(binwidth = 10) +
  ggtitle("Gráfico de Histograma da Nota por Raça e Turno") +
  ylab("Frequência") +
  xlab("Notas") +
  facet_grid(~ raca)
ggplotly(grafico_hist.raca.turno)




#Box-Plot
grafico_bp.raca= ggplot(ds.eng.final, aes(x = raca, y = nota, fill = raca)) +
  geom_boxplot() +
  ggtitle("Gráfico de Box-plot da Nota por Raça") +
  xlab("Raça") +
  ylab("Notas")
ggplotly(grafico_bp.raca)

grafico_bp.turno= ggplot(ds.eng.final, aes(x = turno, y = nota, fill = turno)) +
  geom_boxplot() +
  ggtitle("Gráfico de Box-plot da Nota por Turno") +
  xlab("Turno") +
  ylab("Notas")
ggplotly(grafico_bp.turno)

grafico_bp.raca.turno= ggplot(ds.eng.final, aes(x = turno, y = nota, fill = turno)) +
  geom_boxplot() +
  ggtitle("Gráfico de Box-plot da Nota por Raça e Turno") +
  xlab("Turno") +
  ylab("Notas") +
  facet_grid(~ raca) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  guides(fill=guide_legend(title="Raça"))
ggplotly(grafico_bp.raca.turno)

####
ds.eng.final_mod1[ds.eng.final_mod1$raca == "Branca",] %>% 
  kbl %>% kable_material_dark(full_width = F)

ds.eng.final_mod1[ds.eng.final_mod1$raca == "Parda",] %>% 
  kbl %>% kable_material_dark(full_width = F)

