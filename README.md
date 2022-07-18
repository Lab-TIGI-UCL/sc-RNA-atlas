# sc-RNA-atlas
A repository for single cell atlas in TIGI-UCL lab

## How to use the atlas
metadata.rds: metadata for the single cell atlas with informations such as study, cancer type, treatment and original annotations. You can extract data according to the metadata for any specific cancer type or cell type.

raw data of this atlas are stored in the UCL cluster, if you are a collaborator of our lab, please email to Kevin or Danwen to ask for the path of the folder.

scRNA_atlas_part1.h5seurat includes YOST,Azizi,Qian,Vishwakarma,Pelka,Kim,Maynard,Li,Zilionis,Cheng,Bi,Wu studies, while scRNA_atlas_part2.h5seurat includes Krishna,Braun,Chan,ZhangYY,Leader studies.

## scripts
integration.R: integrate cells without batch correction or CCA (CCA is recommended, also would use Harmony)


