## ----import-getwd, eval = FALSE------------------------------------------
#  getwd()

## ----import-objects------------------------------------------------------
objects() 

## ----import-save, echo=-3------------------------------------------------
cars.mod <- cars
outdir = "../output"
if(!file.exists(outdir)) dir.create(outdir)
save(cars.mod, file=file.path(outdir,"cars_mod.RData"))

## ----import-save-image---------------------------------------------------
save.image(file.path(outdir,"workspace.RData"))

## ----import-load---------------------------------------------------------
remove(cars.mod) 
load(file.path(outdir,"cars_mod.RData"))

