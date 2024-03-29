#' Attribute Color to Value
#' @usage attriColorValue(Value, df, colors=c(a,b,c),feet)
#' @param Value integer
#' @param df data frame with numeric values
#' @param colors a vector of 5 colors
#' @param feet the interval between two successive colors in the palette (0.1)
#'
#' @return Hex Color Code
#' @export
#'
#' @examples
#' cgds <- cBioPortal(
#' hostname = "www.cbioportal.org",
#' protocol = "https",
#' api = "/api/v2/api-docs"
#' )
#' \dontrun{
#' getDataByGenes( api =  cgds,
#' studyId = "gbm_tcga_pub",
#' genes = c("NF1", "TP53", "ABL1"),
#' by = "hugoGeneSymbol",
#' molecularProfileIds = "gbm_tcga_pub_mrna"
#' )
#'}
#'
attriColorValue <- function(Value, df, colors=c(a,b,c),feet){
  #df <- df *100
  df[is.na(df)] <- 0
  if(max(df,na.rm=TRUE)<1){
    ## for Methylation df
    Min <- 0
    Max <- 1
  }else{
    df <- round(df, digits = 0)
    Max <- max(df, na.rm=TRUE)
    Min <- min(df, na.rm=TRUE)
  }
  my.colors <- colorRampPalette(colors)
  #generates Max-Min colors from the color ramp
  color.df<-data.frame(COLOR_VALUE=seq(Min,Max,feet), color.name=my.colors(length(seq(Min,Max,feet))))
  colorRef <- color.df[which(color.df[,1]==Value),2]
  return(colorRef)
}


#' Attribute Color to Gene
#' @usage attriColorGene(df)
#' @param df data frame with mRNA or CNA or mutation frequency or methylation (numeric). Without sampleID column.
#'
#' @return A list colors for every gene
#'
#' @examples
#' cgds <- cBioPortal(
#' hostname = "www.cbioportal.org",
#' protocol = "https",
#' api = "/api/v2/api-docs"
#' )
#' \dontrun{
#' getDataByGenes( api =  cgds,
#' studyId = "gbm_tcga_pub",
#' genes = c("NF1", "TP53", "ABL1"),
#' by = "hugoGeneSymbol",
#' molecularProfileIds = "gbm_tcga_pub_mrna"
#' )
#'}
#' @export
attriColorGene <- function(df){

  if(all(apply(df,2, function(x)class(x)=='integer'))==TRUE
  ){
    ListFreqCNA <- apply(df,2,
                         function(x) as.data.frame(table(x[order(x)])))
    print("getting the most frequent CNA categorie...")
    dfMeansOrCNA <- as.data.frame(lapply(
      ListFreqCNA, function(x) x[,1][which(x[,2]== max(x[,2]))]))

    ## at this step the dfMeansOtCNA is not as numeric
    namedfMeansOrCNA <- names(dfMeansOrCNA)
    dfMeansOrCNA <- as.numeric(as.matrix(dfMeansOrCNA))
    names(dfMeansOrCNA) <- namedfMeansOrCNA

  }else if(all(apply(df,2, function(x)class(x)=='numeric'))==TRUE){
    ## Compute mean of FreqMutData and mRNA Expression
    dfMeansOrCNA <-apply(df,2,function(x) mean(x, na.rm=TRUE))
    dfMeansOrCNA <- round(dfMeansOrCNA, digits = 0)
  }

  ## Set colors if all value are 0 set only black
  if(all(dfMeansOrCNA=="0")||all(dfMeansOrCNA=="NaN")){
    colorls <- lapply(dfMeansOrCNA, function(x)
      attriColorValue(x, dfMeansOrCNA, colors=c("white"), feet=0.1))
    print("setting black color for empty data...")
  }else{
    colorls <- lapply(dfMeansOrCNA, function(x)
      attriColorValue(x, dfMeansOrCNA,
                      colors=c("blue3","white","red"),
                      feet=0.1))
  }
  return(colorls)
}

#' Restructure the list of color attributed to the genes in every dimenssion for every studies
#' @usage reStrColorGene(df)
#' @param df data frame with colors attributed to the genes
#'
#' @return  Hierarchical color attribute: gene > color
#' @export
#'
#' @examples
#' cgds <- cBioPortal(
#' hostname = "www.cbioportal.org",
#' protocol = "https",
#' api = "/api/v2/api-docs"
#' )
#' \dontrun{
#' getDataByGenes( api =  cgds,
#' studyId = "gbm_tcga_pub",
#' genes = c("NF1", "TP53", "ABL1"),
#' by = "hugoGeneSymbol",
#' molecularProfileIds = "gbm_tcga_pub_mrna"
#' )
#'}
reStrColorGene <- function(df){

  colorls <- attriColorGene(df)
  ## extract disease name
  disease_name <- unlist(lapply(strsplit(capture.output(substitute(df)), "\\$"),tail, 1))
  Children <- list(name=disease_name,unname(mapply(function(genes, color){
    list(list(name=genes, colour= color))},names(colorls), colorls)))
  names(Children)[2] <- "children"
  return(Children)

}

## this function restructure the Diseases
#' Restructure the list of color attributed to the genes in every disease
#' @usage reStrDisease(List)
#' @param List of data frame with color attributes
#'
#' @return  Hierarchy of dimensions in the same study: dimensions > gene > color
#'
#' @examples
#' cgds <- cBioPortal(
#' hostname = "www.cbioportal.org",
#' protocol = "https",
#' api = "/api/v2/api-docs"
#' )
#' \dontrun{
#' getDataByGenes( api =  cgds,
#' studyId = "gbm_tcga_pub",
#' genes = c("NF1", "TP53", "ABL1"),
#' by = "hugoGeneSymbol",
#' molecularProfileIds = "gbm_tcga_pub_mrna"
#' )
#'}
#' @export
reStrDisease <- function(List){
  print("restructuring Selected Diseases...")
  child<-lapply(List, function(x)reStrColorGene(x))
  for(i in 1: length(names(child))){
    child[[i]]$name <- names(child)[i]
  }
  child <-unname(child)
  return(child)
}



## This function restructure the Dimensions
#' Restructure the list of color attributed to the genes in every study for every dimensions
#' @usage reStrDimension(LIST)
#' @param LIST list of  hierarchical dimensions
#'
#' @return Hierarchical structure of: Study > dimensions > gene > color
#'
#' @examples
#' cgds <- cBioPortal(
#' hostname = "www.cbioportal.org",
#' protocol = "https",
#' api = "/api/v2/api-docs"
#' )
#' \dontrun{
#' getDataByGenes( api =  cgds,
#' studyId = "gbm_tcga_pub",
#' genes = c("NF1", "TP53", "ABL1"),
#' by = "hugoGeneSymbol",
#' molecularProfileIds = "gbm_tcga_pub_mrna"
#' )
#'}
#' @export
reStrDimension <- function(LIST){
  print("restructuring Dimensions...")
  Parent <- lapply(LIST, function(x)list(name="Dimension",children=reStrDisease(x)))
  for(i in 1: length(names(Parent))){
    Parent[[i]]$name <- names(Parent)[i]
  }
  Parent <- unname(Parent)
  return(Parent)
}


#' Unify row names in data frame with the same order of gene list.
#' @usage UnifyRowNames(x,geneList)
#' @param x data frame with gene symbol in the row name
#' @param geneList a gene list
#'
#' @return a data frame having the gene in row name ordered as in gene list.
#'
#' @examples
#' cgds <- cBioPortal(
#' hostname = "www.cbioportal.org",
#' protocol = "https",
#' api = "/api/v2/api-docs"
#' )
#' \dontrun{
#' getDataByGenes( api =  cgds,
#' studyId = "gbm_tcga_pub",
#' genes = c("NF1", "TP53", "ABL1"),
#' by = "hugoGeneSymbol",
#' molecularProfileIds = "gbm_tcga_pub_mrna"
#' )
#'}
#' @export
UnifyRowNames <- function(x, geneList){
  ## compute the ratio of mutation
  df_MutData <-as.data.frame(table(x$hugoGeneSymbol) /sum(table(x$hugoGeneSymbol))*100)
  ## compute le sum of mutation using table function.
  #df_MutData <-as.data.frame(table(x$hugoGeneSymbol))
  rownames(df_MutData) <- df_MutData$Var1
  ## ordering genes in MutData as in GeneList

  df_GeneList <- as.data.frame(t(geneList))
  #df_GeneList <- as.data.frame(GeneList)
  rownames(df_GeneList) <- df_GeneList[,1]
  df_merge <- merge(df_GeneList, df_MutData, by="row.names",all.x=TRUE)
  Freq_Mut <- df_merge[,c(-2,-3)]
  return(Freq_Mut)
}



#' get mutation frequency
#'
#' @usage getFreqMutData(list, geneListLabel)
#'
#' @param list a list of data frame with mutation data. Each data frame is for one study
#' @param geneListLabel file name of geneList examples: "73"
#'
#' @return a data frame with mutation frequency. gene is in rows and study is in column
#' @export
#'
#' @examples
#' cgds <- cBioPortal(
#' hostname = "www.cbioportal.org",
#' protocol = "https",
#' api = "/api/v2/api-docs"
#' )
#' \dontrun{
#' getDataByGenes( api =  cgds,
#' studyId = "gbm_tcga_pub",
#' genes = c("NF1", "TP53", "ABL1"),
#' by = "hugoGeneSymbol",
#' molecularProfileIds = "gbm_tcga_pub_mrna"
#' )
#'}
getFreqMutData <- function(list, geneListLabel){

  GeneList <- whichGeneList(geneListLabel)

  if(is.null(list)){stop("Select a less one Study.")}

  Freq_ListMutData <- lapply(list,
                             function(x) UnifyRowNames(x, GeneList))

  ## convert the list of correlation matrices to Array
  Freq_ArrayMutData <- array(unlist( Freq_ListMutData),
                             dim = c(nrow(Freq_ListMutData[[1]]),
                                     ncol( Freq_ListMutData[[1]]),
                                     length(Freq_ListMutData)))

  if (inherits(try(dimnames(Freq_ArrayMutData) <-
                   list(Freq_ListMutData[[1]][,1],
                        colnames(Freq_ListMutData[[1]]),
                        names(Freq_ListMutData)),
                   silent=TRUE),"try-error")){
    p("There is a Study without Mutation Data.
      Use Mutation Panel to verify mutations data for selected studies.",
      align="center", style = "color:blue")
  }else{
    dimnames(Freq_ArrayMutData) <-
      list(Freq_ListMutData[[1]][,1],
           colnames(Freq_ListMutData[[1]]),
           names(Freq_ListMutData))
  }
  #   ?getListProfData(Genes= empty)
  if(dim(Freq_ArrayMutData)[3]==1){
    Freq_DfMutData <- as.numeric(Freq_ArrayMutData[,2,])
    names(Freq_DfMutData) <- names(Freq_ArrayMutData[,2,])
    ## ordering gene list as in GeneList from MSigDB:
    ## grouping genes with the same biological process or gene Sets
    Freq_DfMutData <- Freq_DfMutData[GeneList]
    Freq_DfMutData <- data.frame(round(Freq_DfMutData,digits=2))
    names(Freq_DfMutData) <- names(Freq_ListMutData)
  }else{
    Freq_DfMutData <- apply(Freq_ArrayMutData[,2,],2,as.numeric)
    rownames(Freq_DfMutData) <- rownames(Freq_ArrayMutData[,2,])
    ## ordering gene list as in GeneList from MSigDB:
    ## grouping genes with the same biological process or gene Sets
    Freq_DfMutData <- Freq_DfMutData[GeneList,,drop=FALSE]
    Freq_DfMutData <- data.frame(round(Freq_DfMutData,digits=2))
  }

  #Freq_DfMutData <<- Freq_DfMutData
  return(Freq_DfMutData)
}

#' Check wich Cases and genetic profiles are available for selected study
#' @usage checkDimensions(StudyID)
#' @param StudyID Study reference using cBioPortal index
#'
#' @return A data frame with two column (Cases, Genetic profiles). Every row has a dimension (CNA, mRNA...).
#' The data frame is filled with yes/no response.
#'
#'
#' @examples
#' cgds <- cBioPortal(
#' hostname = "www.cbioportal.org",
#' protocol = "https",
#' api = "/api/v2/api-docs"
#' )
#' \dontrun{
#' getDataByGenes( api =  cgds,
#' studyId = "gbm_tcga_pub",
#' genes = c("NF1", "TP53", "ABL1"),
#' by = "hugoGeneSymbol",
#' molecularProfileIds = "gbm_tcga_pub_mrna"
#' )
#'}
#' @export
#'
checkDimensions <- function(StudyID){


    checked_Studies <- StudyID #input$StudiesIDCircos

    # get Cases for selected Studies
    #CasesRefStudies <- unname(unlist(apply(as.data.frame(StudyID),
    #                                       1,function(x) cBioPortalData::sampleLists(cgds,x)[,"sampleListId"])))

    CasesRefStudies <- apply(as.data.frame(StudyID),1,
                             function(x) cBioPortalData::sampleLists(cgds,x) |>
                               pull("sampleListId")) |>
                              as.character()

    ## ger Genetics Profiles for selected Studies
    #GenProfsRefStudies <- unname(unlist(apply(as.data.frame(StudyID),
    #                                      1,function(x) cBioPortalData::molecularProfiles(cgds,x)[,"molecularProfileId"])))
    GenProfsRefStudies <- apply(as.data.frame(StudyID),1,
                               function(x) cBioPortalData::molecularProfiles(cgds,x) |>
                                 pull("molecularProfileId")) |>
                                as.character()


  df <- data.frame(row.names = c("Case_CNA", "GenProf_GISTIC", "Case_mRNA", "GenProf_mRNA", "Case_Met_HM450", "GenProf_Met_HM450",
                                 "Case_Met_HM27", "GenProf_Met_HM27", "Case_RPPA", "GeneProf_RPPA", "Case_miRNA", "GenProf_miRNA",
                                 "Case_Mut","GeneProf_Mut"
  ) )

  for(i in checked_Studies){
    ### get Cases and Genetic Profiles  with cBioPortal references
    GenProf_CNA<- paste(i,"_gistic", sep="")
    Case_CNA   <- paste(i,"_cna", sep="")

    GenProf_Exp<- paste(i,"_rna_seq_v2_mrna", sep="")
    Case_Exp   <- paste(i,"_rna_seq_v2_mrna", sep="")

    GenProf_Met_HM450<- paste(i,"_methylation_hm450", sep="")
    Case_Met_HM450   <- paste(i,"_methylation_hm450", sep="")

    GenProf_Met_HM27<- paste(i,"_methylation_hm27", sep="")
    Case_Met_HM27   <- paste(i,"_methylation_hm27", sep="")

    GenProf_RPPA<- paste(i,"_RPPA_protein_level", sep="")
    Case_RPPA   <- paste(i,"_rppa", sep="")

    GenProf_miRNA<- paste(i,"_mirna", sep="")
    Case_miRNA   <- paste(i,"_microrna", sep="")

    GenProf_Mut<- paste(i,"_mutations", sep="")
    Case_Mut   <- paste(i,"_sequenced", sep="")


    if(length(grep(Case_CNA, CasesRefStudies)!=0)){
      df[1,i] <- "Yes"
    }else{
      df[1,i] <- "No"
    }

    if(length(grep(GenProf_CNA, GenProfsRefStudies)!=0)){
      df[2,i] <- "Yes"
    }else{
      df[2,i] <- "No"
    }

    if(length(grep(Case_Exp, CasesRefStudies)!=0)){
      df[3,i] <- "Yes"
    }else{
      df[3,i] <- "No"
    }

    if(length(grep(GenProf_Exp, GenProfsRefStudies)!=0)){
      df[4,i] <- "Yes"
    }else{
      df[4,i] <- "No"
    }

    if(length(grep(Case_Met_HM450, CasesRefStudies)!=0)){
      df[5,i] <- "Yes"
    }else{
      df[5,i] <- "No"
    }

    if(length(grep(GenProf_Met_HM450, GenProfsRefStudies)!=0)){
      df[6,i] <- "Yes"
    }else{
      df[6,i] <- "No"
    }

    if(length(grep(Case_Met_HM27, CasesRefStudies)!=0)){
      df[7,i] <- "Yes"
    }else{
      df[7,i] <- "No"
    }

    if(length(grep(GenProf_Met_HM27, GenProfsRefStudies)!=0)){
      df[8,i] <- "Yes"
    }else{
      df[8,i] <- "No"
    }

    if(length(grep(Case_RPPA, CasesRefStudies)!=0)){
      df[9,i] <- "Yes"
    }else{
      df[9,i] <- "No"
    }

    if(length(grep(GenProf_RPPA, GenProfsRefStudies)!=0)){
      df[10,i] <- "Yes"
    }else{
      df[10,i] <- "No"
    }

    if(length(grep(Case_miRNA, CasesRefStudies)!=0)){
      df[11,i] <- "Yes"
    }else{
      df[11,i] <- "No"
    }

    if(length(grep(GenProf_miRNA, GenProfsRefStudies)!=0)){
      df[12,i] <- "Yes"
    }else{
      df[12,i] <- "No"
    }

    if(length(grep(Case_Mut, CasesRefStudies)!=0)){
      df[13,i] <- "Yes"
    }else{
      df[13,i] <- "No"
    }

    if(length(grep(GenProf_Mut, GenProfsRefStudies)!=0)){
      df[14,i] <- "Yes"
    }else{
      df[14,i] <- "No"
    }
  }
  names(df)<- checked_Studies
  return(df)
}



#' get samples size of sequensed genes
#' @usage getSequensed_SampleSize(StudiesID)
#' @param StudiesID Studies ID as a vector
#'
#'
#' @return dataframe with sample size for each selected study.
#'
#' @examples
#' \dontrun{
#'  sampleSize <- getSequensed_SampleSize(input$StudiesIDCircos)
#' }
#'
#' @export
getSequensed_SampleSize <- function(StudiesID){

  # get Cases for selected Studies
  dat <- apply(as.data.frame(paste0(StudiesID, "_sequenced")), 1,  #input$StudiesIDCircos
               function(x) nrow(as.data.frame(cBioPortalData::samplesInSampleLists(cgds, x)))) |>
    as.data.frame()

  rownames(dat) <-  StudiesID
  colnames(dat) <- "Samples"
  ## remove rownames to column
  #dat <- dat %>% tibble::rownames_to_column("Studies")

  return(dat)
}


