# Citations
```{bibliography}
```

## How to convert .Rmd to .ipynb
1. Require an R package, rmd2jupyter
```
devtools::install_github("mkearney/rmd2jupyter")
library(rmd2jupyter)
```
2. Prepare the .Rmd file
3. Convert the file
```
rmd2jupyter("sample_file.Rmd")
```
