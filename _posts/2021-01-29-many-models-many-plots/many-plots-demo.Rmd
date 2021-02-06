---
title: "Demo"
output: pdf_document
lof: true
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, message = FALSE)
```

\newpage

```{r}
library(tidyverse)
library(survival)
library(survminer)

by_celltype <- veteran %>% 
  nest_by(celltype) %>% 
  mutate(model = list(survfit(Surv(time, status) ~ trt, data = data)),
         name = str_glue("Survival curve by treatmeant for celltype: {celltype}"),
         plot = list(ggsurvplot(model, data)))

all_plots <- as.list(by_celltype$plot)
names(all_plots) <- by_celltype$name
```

```{r fig.cap = names(all_plots), results='asis', fig.height=5}

for(plot in names(all_plots)){
  print(all_plots[[plot]])
  cat('\n\n')
}

```

\newpage