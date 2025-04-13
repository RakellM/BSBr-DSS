head(vertice)
head(ligacoes)


ligacoes2 <- ligacoes[ligacoes$Final == 1,c(1:3,5)]

graf = graph_from_data_frame(d=ligacoes2, vertices=vertice$Group, directed=T)

plot(graf,
     edge.arrow.size = 0.5,
     edge.curved=0.2,
     vertex.shape="circle",
     vertex.color="lightblue",
     vertex.size=10,
     #vertex.label=NA,
     vertex.frame.color="gray",
     vertex.label.color="black",
     vertex.label.cex=1,
     vertex.label.dist=0,
     layout=layout_nicely)

# Gerar cores baseado no tipo de mídia
colrs = c("darkblue", "darkgreen", "gold")

E(graf)$color= colrs[E(graf)$Type]

# Set o nó com base no tamanho da audiencia
V(graf)$size = V(graf)$tamanho.audiencia*0.7

V(graf)$label.color = "black"

V(graf)$label = NA

V(graf)$label = V(graf)$label

# Set a latgura da aresta baseado no peso
E(graf)$width = E(graf)$peso/6

# Alterar o tamanho da seta e a cor da aresta
E(graf)$arrow.size = 0.5
E(graf)$edge.color = "gray80"
E(graf)$width = 1 + E(graf)$peso/12
plot(graf, layout=layout_nicely)


legend(x=1.2, y=1,
       c("Walk", "Car", "Bus"),
       pch=21,
       col="#777777",
       pt.bg=colrs,
       pt.cex=2,
       cex=0.8,
       bty="n",
       ncol=1)


ligacoes2a <- ligacoes[ligacoes$Final == 1 & ligacoes$Type == 1,c(1:3,5)]

graf1 = graph_from_data_frame(d=ligacoes2a, vertices=vertice$Group, directed=T)
plot(graf1,
     edge.arrow.size = 0.5,
     edge.curved=0.2,
     vertex.shape="circle",
     vertex.color="lightblue",
     vertex.size=10,
     #vertex.label=NA,
     vertex.frame.color="gray",
     vertex.label.color="black",
     vertex.label.cex=1,
     vertex.label.dist=0,
     layout=layout_nicely)


ligacoes2b <- ligacoes[ligacoes$Final == 1 & ligacoes$Type == 2,c(1:3,5)]

graf2 = graph_from_data_frame(d=ligacoes2b, vertices=vertice$Group, directed=T)
plot(graf2,
     edge.arrow.size = 0.5,
     edge.curved=0.2,
     vertex.shape="circle",
     vertex.color="lightblue",
     vertex.size=10,
     #vertex.label=NA,
     vertex.frame.color="gray",
     vertex.label.color="black",
     vertex.label.cex=1,
     vertex.label.dist=0,
     layout=layout_nicely)

ligacoes2c <- ligacoes[ligacoes$Final == 1 & ligacoes$Type == 3,c(1:3,5)]

graf3 = graph_from_data_frame(d=ligacoes2c, vertices=vertice$Group, directed=T)
plot(graf3,
     edge.arrow.size = 0.5,
     edge.curved=0.2,
     vertex.shape="circle",
     vertex.color="lightblue",
     vertex.size=10,
     #vertex.label=NA,
     vertex.frame.color="gray",
     vertex.label.color="black",
     vertex.label.cex=1,
     vertex.label.dist=0,
     layout=layout_nicely)

##
tree <- make_tree(20, 3)
plot(tree, layout=layout_as_tree)
plot(tree, layout=layout_as_tree(tree, flip.y=FALSE))
plot(tree, layout=layout_as_tree(tree, circular=TRUE))

tree2 <- make_tree(10, 3) + make_tree(10, 2)
plot(tree2, layout=layout_as_tree)
plot(tree2, layout=layout_as_tree(tree2, root=c(1,11),
                                  rootlevel=c(2,1)))