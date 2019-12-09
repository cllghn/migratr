
## **{migratr}**

A set of tools for unifying **{sf}** and **{igraph}** object for
geospatial network analysis.

## Example

The goal is to create representations of network both projected over a
map or as a sociogram. Because the network is the unit of analysis, the
functions are designed to work with both a edge and node list.

First, load the package and any other tools you may require (I suggest
using **{tidyverse}** tools for data manipulation):

``` r
library(migratr)
library(tidyverse)
```

Now load the sample node and edge lists:

``` r
edges <- migratr::edgelist
nodes <- migratr::nodelist
```

  - Edges list: A `data.frame` containing a symbolic edge list in the
    first two columns. Additional columns are considered as edge
    attributes.

<!-- end list -->

``` r
edges %>%
  glimpse()
#> Observations: 115
#> Variables: 3
#> $ from      <chr> "Aleppo and Idlib Province [NSYAI] (Halab and Idlib go…
#> $ to        <chr> "Aleppo City [NSYAICIT] (Mount Simeon / Jabal Sem’an D…
#> $ edge_type <chr> "Population", "Population", "Population", "Population"…
```

  - Nodes list: A `data.frame` and `sf` class object with node metadata.
    The first column will be assumed to contain the symbolic vertex
    names.

<!-- end list -->

``` r
nodes %>% 
  glimpse()
#> Observations: 14
#> Variables: 5
#> $ neighborhood_id  <chr> "Aleppo and Idlib Province [NSYAI] (Halab and I…
#> $ geometry         <MULTIPOLYGON [°]> MULTIPOLYGON (((37.77172 35..., MU…
#> $ lon              <dbl> 37.40469, 37.17000, 36.34893, 37.03019, 36.1000…
#> $ lat              <dbl> 36.12795, 36.23000, 33.55288, 33.46118, 32.6300…
#> $ total_population <dbl> 2681318, 2567509, 2350000, 308669, 68532, 15284…
```

Using the edge and node list produce a new object with relationships and
geographic data:

``` r
migratr_object <- migratr::get_proto_graph(edges = edges[edges["edge_type"] == "Adjacency/Population",],
                                         nodes = nodes)
migratr_object
#> PROTO_GRAPH 
#>  Nodes: 14
#>  Edges: 15
```

Plot `migratr_object`:

``` r
plot(migratr_object)
```

<img src="README_files/figure-gfm/unnamed-chunk-6-1.png" style="display: block; margin: auto;" />
