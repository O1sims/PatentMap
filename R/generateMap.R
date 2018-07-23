


generateMap <- function(neigh, bord, gd3) {
        load("data/both15.rda")
        
        # Create basemap
        basemap <- ggplot() +
                geom_polygon(data = neigh,
                             aes(x = long, y = lat, group = group),
                             fill = "grey90", color = "grey90") +
                coord_equal(ylim = c(1350000, 5550000), 
                            xlim = c(2500000, 7500000)) +
                theme_map(base_family = font_rc) +
                theme(panel.border = element_rect(color = "black", size = 0.5, fill = NA),
                      legend.position = c(1, 1),
                      legend.justification = c(1, 1),
                      legend.background = element_rect(colour = NA, fill = NA),
                      legend.title = element_text(size = 15),
                      legend.text = element_text(size = 15)) +
                scale_x_continuous(expand = c(0,0)) +
                scale_y_continuous(expand = c(0,0)) +
                labs(x = NULL, y = NULL)
        
        # Whole data mean
        center <- both15 %>% 
                select(2:6) %>% 
                summarise_all(.funs = funs(sum)) %>% 
                transmute(e = Y_GE65 / TOTAL,
                          w = `Y15-64` / TOTAL,
                          y = Y_LT15 / TOTAL) %>% 
                gather() %>% 
                pull(value)
        
        # Calculate scaling factor for colors, i.e. the factor of proportionality
        # from big tern to zoomed tern
        mins <- apply(both15 %>% select(so, sw, sy), 2, min)
        zoomed_side <- (1 - (mins[2] + mins[3])) - mins[1]
        true_scale <- 1 / zoomed_side
        
        tric_diff <- tricolore::Tricolore(
                df = both15, p1 = 'Y_GE65', p2 = 'Y15-64', p3 = 'Y_LT15',
                center = center, spread = true_scale, show_data = FALSE,
                contrast = 0.5, lightness = 1, chroma = 1, hue = 2/12)
        
        
        # Add color-coded proportions to map
        both15$rgb_diff <- tric_diff$hexsrgb
        
        EUPatentMap <- basemap +
                geom_map(map = ggHole(gd3)[[1]], 
                         data = both15,
                         aes(map_id = id, fill = rgb_diff)) +
                geom_map(map = ggHole(gd3)[[2]], 
                         data = both15,
                         aes(map_id = id, fill = rgb_diff)) +
                scale_fill_identity()+
                geom_path(data = bord, 
                          aes(long, lat, group = group), 
                          color = "white", 
                          size = 0.5) +
                theme(legend.position = "none")
        
        getwd() %>%
        paste0("/images/patent-map.png") %>%
        ggsave(
                width = 14, 
                height = 11.76, 
                dpi = 600, 
                type = "cairo-png")
        
        return(EUPatentMap)
}
