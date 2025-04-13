library(igraph)

g1 <- graph(edges=c(1,2, 2,3, 3,1), directed=F)
g1
plot(g1)
class(g1)

g2 <- graph(edges=c(1,2, 2,3, 3,1), directed=F, n = 5)  # default is direted=T
g2
plot(g2)
class(g2)


g3 <- graph(edges=c(1,2, 2,3, 3,1), n = 5)  # default is direted=T
g3
plot(g3, 
     edge.arrow.size = 0.5, 
     vertex.color="lightblue", 
     vertex.size=20,
     vertex.frame.color="gray",
     vertex.label.color="black",
     vertex.label.cex=1,
     vertex.label.dist=3)
class(g3)


plot(graph_from_literal(a--b, b--c))
plot(graph_from_literal(a-+b, b+-c))
plot(graph_from_literal(a++b, b++c))
plot(graph_from_literal(a:b:c--c:d:e))
g1 <- graph_from_literal(a-b-c-d-e-f, a-g-h-b, h-e:f:i, j)
plot(g1)

# acessar vertices e arestas
E(g3)

V(g3)

# examinar matriz de redes diretamente
g3[]

# adcionar atributos à rede, vertices ou arestas
g5 <- graph(edges=c(1,2, 2,3, 2,3, 3,1), n = 5)  
plot(g5, 
     edge.arrow.size = 0.5, 
     vertex.color="lightblue", 
     vertex.size=20,
     vertex.frame.color="gray",
     vertex.label.color="black",
     vertex.label.cex=1,
     vertex.label.dist=0,
     edge.curved=0.5)

V(g5)$name
V(g5)$gender <- c("M", "F", "M", "F", "F")
E(g5)$type = "email" #atribuindo "email" a todas as arestas
E(g5)$weight = 10 # configura todas as arestas existentes para 10

edge_attr(g5)

vertex_attr(g5)

graph_attr(g5)

g5 = set_graph_attr(g5, "Nome", "Email de Serviço")
g5 = set_graph_attr(g5, "Teste", "Testando")
graph_attr_names(g5)
graph_attr(g5)
g5 = delete_graph_attr(g5, "Teste")
graph_attr(g5)

plot(g5,
     edge.arrow.size=0.5,
     vertex.label.color="black",
     vertex.label.dist=0,
     edge.curved=0.5,
     vertex.color=c("pink", "skyblue")[1+(V(g5)$gender=="M")])

g5s = simplify(g5,
                remove.multiple=T,
                remove.loops=T,
                edge.attr.comb = c(weight="sum", type="ignore"))

g5
g5s

# A descrição de um objeto igraph começa com até 4 letras:
# 1. D or U, para um grafo direcionado ou não-direcionado
# 2. N para um grafo nomeado (onde os nós têm um nomeatributo)
# 3. W para um grafo ponderado (onde as bordas têm um weight atributo)
# 4. B para um grafo bipartido (dois modos) (onde os nós tem um type atributo)
# 5. os dois numeros a seguir (5 4) se referem ao número de nós e arestas no grafo.

# A descriçãp também lista os atributos de nó e borda, por exemplo:
# 1. (g/c) - atributo de caractere no nível do grafo
# 2. (v/c) - atributo de caractere no nível do vértice
# 3. (e/n) - atributo numérico no nível da borda

g <- make_ring(10) + make_full_graph(5)
coords <- layout_(g, as_star())
plot(g, layout = coords)

# Grafo vazio
gv = make_empty_graph(40)
plot(gv,
     vertex.size=10,
     vertex.label=NA)

# Grafo Completo
gc = make_full_graph(40)
plot(gc,
     vertex.size=10,
     vertex.label=NA)

# Grafo estrela simples
es = make_star(40)
plot(es,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_as_star)

# Grafo árvore
ga = make_tree(40, children=3, mode="undirected")
plot(ga,
     vertex.size=10,
     vertex.label=NA)
plot(ga,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_on_grid)
plot(ga,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_on_sphere)
plot(ga,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_randomly)
plot(ga,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_with_gem)
plot(ga,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_with_graphopt)
plot(ga,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_with_fr)
plot(ga,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_with_dh)
plot(ga,
     vertex.size=10,
     vertex.label=NA,
     layout=component_wise)

# Grafo em Anel
ganel = make_ring(40)
plot(ganel,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_in_circle)

# Modelo de Grafo aleatório Erdos-Renyi
#('n' é o número de nós, 'm' é o número de arestas)
er = sample_gnm(n=100, m=40)
plot(er,
     vertex.size=6,
     vertex.label=NA,
     layout=layout_in_circle)

# Modelo de mundo pequeno Watts-Strogatz
# Cria uma treliça (com dimensões e sizenós através da dimensão) e religa as arestas
#aleatóriamente com probabilidade p. A vizinhança na wual as arestas estão conectadas é nei.
#Você pode permitir loops e multiple arestas.
ws = sample_smallworld(dim=2, size=10, nei=1, p=0.1)
plot(ws,
     vertex.size=6,
     vertex.label=NA,
     layout=layout_in_circle)

# Modelo de anexo preferencial Barabasi-Albert para grafos sem escala
# (n é o número de nós, power é o poder do anexo (1 é linear)
# m é o número de arestas adicionadas em casa etapa do tempo)
ba = sample_pa(n=100, power=1, m=1, directed=F)
plot(ba,
     vertex.size=6,
     vertex.label=NA,
     layout=layout_nicely)

# igraph também pode fornecer alguns grafos historicos notáveis. Por exemplo:
z = graph("Zachary") # the Zachary Carate Club
plot(z,
     vertex.size=6,
     vertex.label=NA,
     layout=layout_nicely)

data(package = .packages(all.available = TRUE)) #traz todos os pacotes de dados dos pacotes que vc tem instalado no R

# A reconfiguração de um grafo
# each_edge() é um método de religação que altera os pontos finais da aresta uniformemente
# aleatoriamente com uma probabilidade prob
rg = rewire(ganel, each_edge(prob=0.1))
plot(rg,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_nicely)

# rewire para conectar vértices a outros vértices a uma certa distância.
rn = connect.neighborhood(ganel, 5)
plot(rn,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_nicely)

# Combine grafos (união separada, assumindo conjunto de vérices separados): %du%
plot(ganel,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_nicely)

plot(ga,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_nicely)

plot(ganel %du% ga,
     vertex.size=10,
     vertex.label=NA,
     layout=layout_nicely)

# Carregarndo conjunto de dados
nos = Dados1_MIDIA_NOS
ligacoes = Dados1_MIDIA_ARESTAS

head(nos)
head(ligacoes)

nrow(nos)
length(unique(nos$id))
nrow(ligacoes)
nrow(unique(ligacoes[,c("origem", "destino")]))

ligacoes = aggregate(ligacoes[,3], ligacoes[,-3], sum)

ligacoes = ligacoes[order(ligacoes$origem, ligacoes$destino),]

colnames(ligacoes)[4] = "peso"

rownames(ligacoes) = NULL

nos2 = Dados2_MIDIA_USUARIO_NOS
ligacoes2 = Dados2_MIDIA_USUARIO_ARESTAS


head(nos2)
head(ligacoes2)

# Podemos ver que ligacoes2 é uma matriz de adjacencia para uma rede de dois modos:

ligacoes2 = as.matrix(ligacoes2)

dim(ligacoes2)
dim(nos2)

graf = graph_from_data_frame(d=ligacoes, vertices=nos, directed=T)
class(graf)
graf
E(graf) # arestas
V(graf) # vértices
E(graf)$tipo
V(graf)$midia

plot(graf,
     edge.arrow.size = 0.5,
     vertex.color="lightblue",
     vertex.size=10,
     vertex.label=NA,
     vertex.frame.color="gray",
     vertex.label.color="black",
     vertex.label.cex=1,
     vertex.label.dist=0,
     layout=layout_nicely)

graf = simplify(graf,
                remove.multiple=FALSE,
                remove.loops=TRUE) 

plot(graf,
     edge.arrow.size = 0.5,
     vertex.color="lightblue",
     vertex.size=10,
     vertex.label=NA,
     vertex.frame.color="gray",
     vertex.label.color="black",
     vertex.label.cex=1,
     vertex.label.dist=0,
     layout=layout_nicely)

as_edgelist(graf, names=T)
as_adjacency_matrix(graf, attr="peso")
as_data_frame(graf, what="edges")
as_data_frame(graf, what="vertices")

graf2 = graph_from_incidence_matrix(ligacoes2)

table(V(graf2)$type)

graf2.bp = bipartite.projection(graf2)

as_incidence_matrix(graf2) %*% t(as_incidence_matrix(graf2))

t(as_incidence_matrix(graf2)) %*% as_incidence_matrix(graf2)

plot(graf2.bp$proj1,
     vertex.label.color="black",
     vertex.label.dist=1,
     vertex.size=7,
     vertex.label=nos2$midia[!is.na(nos2$tipo.midia)],
     layout=layout_nicely)

plot(graf2.bp$proj2,
     vertex.shape="sphere",
     vertex.label.color="black",
     vertex.label.dist=1,
     vertex.size=7,
     vertex.label=nos2$midia[is.na(nos2$tipo.midia)],
     layout=layout_nicely)

names(igraph:::.igraph.shapes)
?igraph.plotting

plot(graf,
     edge.arrow.size=0.1,
     edge.curved=0.1,
     vertex.size=7,
     vertex.shape="circle",
     vertex.color="orange",
     vertex.frame.color="#555555",
     vertex.label.color="black",
     vertex.label.dist=0,
     vertex.label=V(graf)$midia,
     vertex.label.cex=0.7,
     layout=layout_nicely)

# Gerar cores baseado no tipo de mídia
colrs = c("gray50", "tomato", "gold")

V(graf)$color= colrs[V(graf)$tipo.midia]

# Set o nó com base no tamanho da audiencia
V(graf)$size = V(graf)$tamanho.audiencia*0.7

V(graf)$label.color = "black"

V(graf)$label = NA

# Set a latgura da aresta baseado no peso
E(graf)$width = E(graf)$peso/6

# Alterar o tamanho da seta e a cor da aresta
E(graf)$arrow.size = 0.5
E(graf)$edge.color = "gray80"
E(graf)$width = 1 + E(graf)$peso/12
plot(graf, layout=layout_nicely)

# Substituir os atributos explicitamente no grafo
plot(graf,
     edge.color="orange",
     vertex.color="gray50",
     layout=layout_nicely)

# Legenda
plot(graf,
     layout=layout_nicely)
legend(x=1.2, y=1,
       c("Jornal", "Televisão", "Notícias On Line"),
       pch=21,
       col="#777777",
       pt.bg=colrs,
       pt.cex=2,
       cex=0.8,
       bty="n",
       ncol=1)

#Em redes semanticas, podemos plotar apenas os rótulos dos nós
plot(graf,
     edge.arrow.size=0.5,
     edge.color="gray70",
     edge.curved=0.1,
     vertex.size=7,
     vertex.shape="none",
     vertex.color="orange",
     vertex.frame.color="#555555",
     vertex.label.color="gray40",
     vertex.label.dist=0,
     vertex.label=V(graf)$midia,
     vertex.label.cex=0.7,
     layout=layout_nicely)

# Coloris as arestas dos grafos com base na cor do nó de origem
edge.start = ends(graf, es=E(graf), names=F)[,1]
edge.col = V(graf)$color[edge.start]
plot(graf,
     edge.color=edge.col,
     edge.curved=0.2,
     layout=layout_nicely)

