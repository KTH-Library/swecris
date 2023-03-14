# Theme -------------------------------------------------------------------
theme_typographic <- function (base_family = NULL) {
  if (is.null(base_family)) {
    if (options()[["dlookr_offline"]]) {
      base_family <- "Liberation Sans Narrow"
    }
    else {
      base_family <- "Roboto Condensed"
    }
  }
  if (!base_family %in% sysfonts::font_families()) {
    if (options()[["dlookr_offline"]]) {
      base_family <- "Liberation Sans Narrow"
    }
    else {
      base_family <- "Roboto Condensed"
    }
  }
  hrbrthemes::theme_ipsum_rc(base_family = base_family)
}


# Modified Pareto (1/2) ---------------------------------------------------
bazzi.na.Total <- function (x, only_na = FALSE, relative = FALSE, main = NULL,
         col = "black", grade = list(Good = 0.05, OK = 0.1, NotBad = 0.2,
                                     Bad = 0.5, Remove = 1),
         plot = TRUE, typographic = TRUE,
         base_family = NULL)
{
  if (sum(is.na(x)) == 0) {
    stop("Data have no missing value.")
  }
  info_na <- purrr::map_int(x, function(x) sum(is.na(x))) %>%
    tibble::enframe() %>% dplyr::rename(variable = name,
                                        frequencies = value) %>%
    arrange(desc(frequencies), variable) %>%
    mutate(ratio = frequencies/nrow(x)) %>%
    mutate(grade = cut(ratio, breaks = c(-1, unlist(grade)), labels = names(grade))) %>%
    mutate(cumulative = cumsum(frequencies)/sum(frequencies) * 100) %>%
    arrange(desc(frequencies)) %>% mutate(variable = factor(variable, levels = variable))
  if (only_na) {
    info_na <- info_na %>% filter(frequencies > 0)
    xlab <- "Variable Names with Missing Value"
  }
  else {
    xlab <- "All Variable Names"
  }
  if (relative) {
    info_na$frequencies <- info_na$frequencies/nrow(x)
    ylab <- "Relative Frequency of Missing Values"
  }
  else {
    ylab <- "Frequency of Missing Values"
  }
  if (is.null(main))
    main = "Pareto chart with missing values"
  scaleRight <- max(info_na$cumulative)/info_na$frequencies[1]
  if (!plot) {
    return(info_na)
  }
  labels_grade <- paste0(names(grade), paste0("\n(<=", unlist(grade) * 100, "%)"))
  n_pal <- length(labels_grade)
  if (n_pal <= 3) {
    pals <- c("#FFEDA0", "#FEB24C", "#F03B20")
  }
  else if (n_pal == 4) {
    pals <- c("#FFFFB2", "#FECC5C", "#FD8D3C", "#E31A1C")
  }
  else if (n_pal == 5) {
    # pals <- c("#FFFFB2", "#FECC5C", "#FD8D3C", "#F03B20", "#BD0026")
    pals <- colorspace::qualitative_hcl(5, palette = "Dark 3")
  }
  else if (n_pal == 6) {
    pals <- c("#FFFFB2", "#FED976", "#FEB24C", "#FD8D3C",
              "#F03B20", "#BD0026")
  }
  else if (n_pal == 7) {
    pals <- c("#FFFFB2", "#FED976", "#FEB24C", "#FD8D3C",
              "#FC4E2A", "#E31A1C", "#B10026")
  }
  else if (n_pal == 8) {
    pals <- c("#FFFFCC", "#FFEDA0", "#FED976", "#FEB24C",
              "#FD8D3C", "#FC4E2A", "#E31A1C", "#B10026")
  }
  else if (n_pal >= 9) {
    pals <- c("#FFFFCC", "#FFEDA0", "#FED976", "#FEB24C",
              "#FD8D3C", "#FC4E2A", "#E31A1C", "#BD0026", "#800026")
  }
  p <- ggplot(info_na, aes(x = variable)) +
    geom_bar(aes(y = frequencies, fill = grade), color = "darkgray", stat = "identity") +
    geom_text(aes(y = frequencies, label = paste(round(ratio * 100, 1), "%")),
              position = position_dodge(width = 0.9),
              vjust = -0.25, size = 1.9) +
    geom_path(aes(y = cumulative/scaleRight, group = 1), colour = col, linewidth = 0.4) +
    geom_point(aes(y = cumulative/scaleRight, group = 1),shape = 21,
               colour = "black",fill = "white", size = 1.5) +
    scale_y_continuous(sec.axis = sec_axis(~. * scaleRight, name = "Cumulative (%)")) +
    labs(title = main,x = xlab, y = ylab) + theme_grey(base_family = base_family) +
    theme(axis.text.x = element_text(angle = 45, vjust = 1,
                                     hjust = 1), legend.position = "top") +
    scale_fill_manual(values = pals, drop = FALSE, name = "Missing Grade", labels = labels_grade)
  if (typographic) {
    p <- p + theme_typographic(base_family) +
      theme(legend.position = "top", axis.title.x = element_text(size = 12), axis.title.y = element_text(size = 12),
            axis.title.y.right = element_text(size = 12), axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
  }
  suppressWarnings(p)
}

# Modified Pareto (2/2) ----------------------------------------------------
bazzi.na.Partial <- function (x, only_na = FALSE, relative = FALSE, main = NULL,
                            col = "black", grade = list(Good = 0.05, OK = 0.1, NotBad = 0.2,
                                                        Bad = 0.5, Remove = 1),
                            plot = TRUE, typographic = TRUE,
                            base_family = NULL)
{
  if (sum(is.na(x)) == 0) {
    stop("Data have no missing value.")
  }
  info_na <- purrr::map_int(x, function(x) sum(is.na(x))) %>%
    tibble::enframe() %>% dplyr::rename(variable = name,
                                        frequencies = value) %>%
    arrange(desc(frequencies), variable) %>%
    mutate(ratio = frequencies/nrow(x)) %>%
    mutate(grade = cut(ratio, breaks = c(-1, unlist(grade)), labels = names(grade))) %>%
    mutate(cumulative = cumsum(frequencies)/sum(frequencies) * 100) %>%
    arrange(desc(frequencies)) %>% mutate(variable = factor(variable, levels = variable))
  if (only_na) {
    info_na <- info_na %>% filter(frequencies > 0)
    xlab <- "Variable Names with Missing Value"
  }
  else {
    xlab <- "All Variable Names"
  }
  if (relative) {
    info_na$frequencies <- info_na$frequencies/nrow(x)
    ylab <- "Relative Frequency of Missing Values"
  }
  else {
    ylab <- "Frequency of Missing Values"
  }
  if (is.null(main))
    main = "Pareto chart with missing values"
  scaleRight <- max(info_na$cumulative)/info_na$frequencies[1]
  if (!plot) {
    return(info_na)
  }
  labels_grade <- paste0(names(grade), paste0("\n(<=", unlist(grade) * 100, "%)"))
  n_pal <- length(labels_grade)
  if (n_pal <= 3) {
    pals <- c("#FFEDA0", "#FEB24C", "#F03B20")
  }
  else if (n_pal == 4) {
    pals <- c("#FFFFB2", "#FECC5C", "#FD8D3C", "#E31A1C")
  }
  else if (n_pal == 5) {
    # pals <- c("#FFFFB2", "#FECC5C", "#FD8D3C", "#F03B20", "#BD0026")
    pals <- colorspace::qualitative_hcl(5, palette = "Dark 3")
  }
  else if (n_pal == 6) {
    pals <- c("#FFFFB2", "#FED976", "#FEB24C", "#FD8D3C",
              "#F03B20", "#BD0026")
  }
  else if (n_pal == 7) {
    pals <- c("#FFFFB2", "#FED976", "#FEB24C", "#FD8D3C",
              "#FC4E2A", "#E31A1C", "#B10026")
  }
  else if (n_pal == 8) {
    pals <- c("#FFFFCC", "#FFEDA0", "#FED976", "#FEB24C",
              "#FD8D3C", "#FC4E2A", "#E31A1C", "#B10026")
  }
  else if (n_pal >= 9) {
    pals <- c("#FFFFCC", "#FFEDA0", "#FED976", "#FEB24C",
              "#FD8D3C", "#FC4E2A", "#E31A1C", "#BD0026", "#800026")
  }
  p <- ggplot(info_na, aes(x = variable)) +
    geom_bar(aes(y = frequencies, fill = grade), color = "darkgray", stat = "identity") +
    geom_text(aes(y = frequencies, label = paste(round(ratio * 100, 1), "%")),
              position = position_dodge(width = 0.9),
              vjust = -0.25, size = 1.4) +
    # geom_path(aes(y = cumulative/scaleRight, group = 1), colour = col, linewidth = 0.4) +
    # geom_point(aes(y = cumulative/scaleRight, group = 1),shape = 21,colour = "black",fill = "white", size = 1.5) +
    # scale_y_continuous(sec.axis = sec_axis(~. * scaleRight, name = "Cumulative (%)")) +
    labs(title = main,x = xlab, y = ylab) + theme_grey(base_family = base_family) +
    theme(axis.text.x = element_text(angle = 45, vjust = 1,
                                     hjust = 1), legend.position = "top") +
    scale_fill_manual(values = pals, drop = FALSE, name = "Missing Grade", labels = labels_grade)
  if (typographic) {
    p <- p + theme_typographic(base_family) +
      theme(legend.position = "top", axis.title.x = element_text(size = 12), axis.title.y = element_text(size = 12),
            axis.title.y.right = element_text(size = 12), axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
  }
  suppressWarnings(p)
}
