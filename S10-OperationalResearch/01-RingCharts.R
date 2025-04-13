library("ggraph")
library("igraph")
library("tidyverse")

# plotting a simple ring graph, all default parameters, except the layout
g <- make_ring(10)
g$layout <- layout_in_circle
plot(g)
tkplot(g)
rglplot(g)

# plotting a random graph, set the parameters in the command arguments
g <- barabasi.game(100)
plot(g, layout=layout_with_fr, vertex.size=4,
     vertex.label.dist=0.5, vertex.color="red", edge.arrow.size=0.5)

# plot a random graph, different color for each component
g <- sample_gnp(100, 1/100)
comps <- components(g)$membership
colbar <- rainbow(max(comps)+1)
V(g)$color <- colbar[comps+1]
plot(g, layout=layout_with_fr, vertex.size=5, vertex.label=NA)

# plot communities in a graph
g <- make_full_graph(5) %du% make_full_graph(5) %du% make_full_graph(5)
g <- add_edges(g, c(1,6, 1,11, 6,11))
com <- cluster_spinglass(g, spins=5)
V(g)$color <- com$membership+1
g <- set_graph_attr(g, "layout", layout_with_kk(g))
plot(g, vertex.label.dist=1.5)

# draw a bunch of trees, fix layout
igraph_options(plot.layout=layout_as_tree)
plot(make_tree(20, 2))
plot(make_tree(50, 3), vertex.size=3, vertex.label=NA)
tkplot(make_tree(50, 2, mode="undirected"), vertex.size=10,
       vertex.color="green")


g <- make_ring(10)
plot(g, layout=layout_with_kk, vertex.color="green")

g <- make_lattice( c(5,5,5) )
coords <- layout_with_fr(g, dim=3)
rglplot(g, layout=coords)

g <- make_ring(10)
tkplot(g)

## Saving a tkplot() to a file programmatically
g <- make_star(10, center=10) 
E(g)$width <- sample(1:10, ecount(g), replace=TRUE)
lay <- layout_nicely(g)

id <- tkplot(g, layout=lay)
canvas <- tk_canvas(id)
tcltk::tkpostscript(canvas, file="/tmp/output.eps")
tk_close(id)

## Setting the coordinates and adding a title label
g <- make_ring(10)
id <- tkplot(make_ring(10), canvas.width=450, canvas.height=500)

canvas <- tk_canvas(id)
padding <- 20
coords <- norm_coords(layout_in_circle(g), 0+padding, 450-padding,
                      50+padding, 500-padding)
tk_set_coords(id, coords)

width <- as.numeric(tkcget(canvas, "-width"))
height <- as.numeric(tkcget(canvas, "-height"))
tkcreate(canvas, "text", width/2, 25, text="My title",
         justify="center", font=tcltk::tkfont.create(family="helvetica",
                                                     size=20,weight="bold"))


graph <- graph_from_data_frame(highschool)

# Not specifying the layout - defaults to "auto"
ggraph(graph) + 
  geom_edge_link(aes(colour = factor(year))) + 
  geom_node_point()

ggraph(graph, layout = 'kk') + 
  geom_edge_link(aes(colour = factor(year))) + 
  geom_node_point()

ggraph(graph, 'treemap', weight = 'size') + 
  geom_edge_link() + 
  geom_node_point(aes(colour = depth))


# Load Packages 
library(ggraph)
library(igraph) 
library(tidyverse)

# Load scripts and remove non-speaking lines
lines <- read_csv("./simpsons_script_lines.csv")

speaking_lines <- lines %>% 
  filter(!is.na(raw_character_text))

# Limit analysis to re-occuring characters in 20 or more episodes
top_char <- speaking_lines %>% 
  group_by(raw_character_text) %>% 
  mutate(appearances=n_distinct(episode_id)) %>% 
  filter(appearances >= 20) %>%
  ungroup()

# Count characters lines per episode 
lines_per_ep <- top_char %>% 
  group_by(raw_character_text, episode_id) %>% 
  summarise(lines=n()) %>% 
  ungroup()


# Convert to matrix
char_df <- lines_per_ep %>% 
  spread(episode_id, lines, fill=0)

char_mat <- as.matrix(select(char_df, -char_df$raw_character_text))
rownames(char_mat) <- char_df$raw_character_text

# Calculate cosine distance between characters
cosine_sim <- as.dist(char_mat %*% t(char_mat) / (sqrt(rowSums(char_mat^2) %*% t(rowSums(char_mat^2)))))

# Initial look at the network 
autograph(as.matrix(cosine_sim))
