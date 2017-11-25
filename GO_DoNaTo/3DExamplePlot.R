library(plotly)

dens <- with(diamonds, tapply(price, INDEX = cut, density))
data <- data.frame(
  x = unlist(lapply(dens, "[[", "x")),
  y = unlist(lapply(dens, "[[", "y")),
  cut = rep(names(dens), each = length(dens[[1]]$x)))

p <- plot_ly(data, x = ~x, y = ~y, z = ~cut, type = 'scatter3d', mode = 'lines', color = ~cut)
chart_link = plotly_POST(p, filename="line3d/density")
