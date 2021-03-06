## The goal is to achieve good overlap between samples with the least ammount of correction, hence why no batch correction is tried first, 
##followed by CCA (good for strong effects).

library(Seurat)
library(SeuratDisk)
library(ggplot2)
library(dplyr)

#Load the seurat object
combined<-LoadH5Seurat("combined.h5seurat")

## No Batch Correction
cat ("Normalizing\n")
combined_int<- NormalizeData(combined,normalization.method = "LogNormalize", scale.factor = 10000)
combined_int <- FindVariableFeatures(combined_int, selection.method = "vst", nfeatures = 2000)
all.genes <- rownames(combined_int)
combined_int <- ScaleData(combined_int,features = all.genes)
cat ("RunPCA \n")
combined_int <- RunPCA(combined_int,features = VariableFeatures(object = combined_int))
print(combined_int[["pca"]], dims = 1:5, nfeatures = 5)
plot1<-DimPlot(combined_int, reduction = "pca", group.by="study")
ggsave("original_PCA.png", plot=plot1, height=10, width=10, dpi=600)
cat ("RunUMAP \n")
combined_int <- RunUMAP(combined_int, reduction = "pca", dims = 1:30)
plot1<-DimPlot(combined_int, reduction = "umap", group.by = "study")
ggsave("original_umap.png", plot=plot1, height=10, width=10, dpi=600)


#CCA
cat ("SCTransform\n")
combined_integrate <- SplitObject(combined, split.by = "study")
combined_integrate<- lapply(X = combined_integrate, FUN = SCTransform,vst.flavor = "v2")
features <- SelectIntegrationFeatures(object.list = combined_integrate, nfeatures = 3000)
combined_integrate <- PrepSCTIntegration(object.list = combined_integrate, anchor.features = features)
immune.anchors <- FindIntegrationAnchors(object.list = combined_integrate, normalization.method = "SCT", anchor.features = features)
combined_integrate <- IntegrateData(anchorset = immune.anchors, normalization.method = "SCT")

cat ("RunPCA \n")
DefaultAssay(combined_integrate) <- "integrated"
combined_integrate<-RunPCA(combined_integrate, verbose = FALSE)
combined_integrate<- RunUMAP(combined_integrate, reduction = "pca", dims = 1:30)
combined_integrate <- FindNeighbors(combined_integrate, reduction = "pca", dims = 1:30)
combined_integrate <- FindClusters(combined_integrate, resolution = 0.4)
plot1<-DimPlot(combined_integrate, reduction = "pca", group.by="study")
ggsave("plots/PCA_after_integration_0.4.png", plot=plot1, height=10, width=10, dpi=600)
plot1<-DimPlot(combined_integrate, reduction = "umap", group.by = "study")
ggsave("plots/umap_after_integration.png", plot=plot1, height=10, width=10, dpi=600)
plot1<-DimPlot(combined_integrate, reduction = "umap", label = TRUE,label.size = 6)
ggsave("plots/cluster_0.4.png", plot=plot1, height=10, width=10, dpi=600)

saveRDS(combined_integrate, "combined_integrated.rds")



