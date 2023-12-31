#' search and get genetic profiles (CNA,mRNA, Methylation, Mutation...)
#'
#' @details See \url{https://github.com/kmezhoud/bioCancer/wiki}
#'
#' @return A data frame with Genetic profile
#'
#' @usage grepRef(regex1, listRef1,regex2, listRef2, GeneList,Mut)
#' @param regex1 Case id (cancer_study_id_[mutations, cna, methylation, mrna ]).
#' @param listRef1 A list of cases for one study.
#' @param regex2 Genetic Profile id (cancer_study_id_[mutations, cna, methylation, mrna ]).
#' @param listRef2 A list of Genetic Profiles for one study.
#' @param GeneList A list of genes
#' @param Mut Condition to set if the genetic profile is mutation or not (0,1)
#'
#' @examples
#' GeneList <- c("ALK", "JAK3", "SHC3","TP53","MYC","PARP")
#' \dontrun{
#' cgds <- CGDS("http://www.cbioportal.org/")
#' listCase_gbm_tcga_pub <- getCaseLists.CGDS(cgds,"gbm_tcga_pub")[,1]
#' listGenProf_gbm_tcga_pub <- getGeneticProfiles.CGDS(cgds,"gbm_tcga_pub")[,1]
#'
#' ProfData_Mut <- grepRef("gbm_tcga_pub_all", listCase_gbm_tcga_pub,
#'  "gbm_tcga_pub_mutations", listGenProf_gbm_tcga_pub, GeneList, Mut=1)
#'}
#'@export
#'
#'
#'
grepRef<-function(regex1, listRef1,regex2, listRef2, GeneList,Mut){
  if(length(grep(regex1,listRef1)) != 0){
    if(length(grep(regex2,listRef2))!= 0){
      if(Mut== 0){
        #print(paste("Getting Profile Data of ",regex2,"...",sep=""))
        ProfData_X <- getProfileData.CGDS(cgds,GeneList, regex2,regex1)
        ########################
        #ProfData_X <- ProfData_X[,as.factor(GeneList)]
        #ProfData_X <- ProfData_X[GeneList,,drop=FALSE]


        #                     > GeneList[c(179,306,338,400)]
        #                     [1] "HBXIP"     "C16orf5"   "SELS"      "MAGI2-IT1"
        #                     > colnames(ProfData)[c(82,198,205,404)]
        #                     [1] "CDIP1"     "LAMTOR5"   "MAGI2.IT1" "VIMP"
        #                     >
        ####################
        if(length(ProfData_X)== 0){
          if(length(GeneList) <= 500){
            ## built empty data frame with gene Symbol in colnames
            ProfData_X <- as.data.frame(setNames(replicate(length(GeneList),numeric(1),
                                                           simplify = FALSE), GeneList[order(GeneList)]))
            return(ProfData_X)

          }else{
            ProfData_X <- as.data.frame(setNames(replicate(length(SubMegaGeneList),numeric(1),
                                                           simplify = FALSE), SubMegaGeneList[order(SubMegaGeneList)]))
            return(ProfData_X)
          }
        }else{
          return(ProfData_X)
        }

      }else if(Mut==1){
        #print(paste("Getting Mutation Data of ",checked_Studies[s],"...",sep=""))
        MutData <- getMutationData.CGDS(cgds,regex1, regex2, GeneList)
        #print(paste("MutData: ",dim(MutData)))
        if(length(MutData)==0 || nrow(MutData)==0){
          ## built emty data.frame as the same form of MutData
          gene_symbol <- as.vector(GeneList)
          mutation_type <- rep(character(1), length(GeneList))
          amino_acid_change <- rep(character(1), length(GeneList))
          MutData <- data.frame(gene_symbol, mutation_type, amino_acid_change)
          #          MutData <- data.frame("gene_symbol"=character(1),"mutation_type"=character(1), "amino_acid_change"= character(1))
          return(MutData)
        }else{
          ## From Mut Data frame select only Gene_symbol, Mutation_Type, AA-Changes
          #myGlobalEnv$ListMutData[[checked_Studies[s]]] <- MutData[,c(2,6,8)]# Gene Symbol, Mut type, AA change
          return(MutData)
        }
        #return(MutData)

      }
    }else{
      shiny::withProgress(message=
                            paste("There is no genetic Profiles: ",
                                  regex2 ), value = 1,
                          {p1 <- proc.time()
                          Sys.sleep(2) # wait 2 seconds
                          proc.time() - p1 })
      if(length(GeneList) <500){
        ProfData_X <- as.data.frame(setNames(replicate(
          length(GeneList),numeric(1), simplify = FALSE),
          GeneList[order(GeneList)]))
        return(ProfData_X)
      }else{
        ProfData_X <- as.data.frame(setNames(replicate(
          length(SubMegaGeneList),numeric(1), simplify = FALSE),
          SubMegaGeneList[order(SubMegaGeneList)]))
        return(ProfData_X)
      }
      return( ProfData_X)
    }
  }else{
    shiny::withProgress(message=
                          paste("There is no Cases: ",
                                regex1 ), value = 1,
                        {p1 <- proc.time()
                        Sys.sleep(2)
                        proc.time() - p1 })
    if(length(GeneList) <500){
      ProfData_X <-as.data.frame(setNames(replicate
                                          (length(GeneList),
                                            numeric(1),
                                            simplify = FALSE),
                                          GeneList[order(GeneList)]))
      return(ProfData_X)
    }else{
      ProfData_X <-as.data.frame(setNames(replicate
                                          (length(SubMegaGeneList),
                                            numeric(1), simplify = FALSE),
                                          SubMegaGeneList[order(SubMegaGeneList)]))
      return(ProfData_X)
    }
    return(ProfData_X)


  }
}



#' get list of data frame with profiles data (CNA,mRNA, Methylation, Mutation...)
#'
#' @usage getListProfData(panel, geneListLabel)
#'
#' @param panel Panel name (string) in which Studies are selected. There are two panels ("Circomics" or "Networking")
#' @param geneListLabel The label of GeneList. There are three cases:
#'        "Genes" user gene list,
#'        "Reactome_GeneList" GeneList plus genes from reactomeFI
#'       "file name" from Examples
#'
#' @return A LIST of profiles data (CNA, mRNA, Methylation, Mutation, miRNA, RPPA).
#'         Each dimension content a list of studies.
#'
#'
#'@examples
#'  \dontrun{
#'  cgds <- CGDS("http://www.cbioportal.org/")
#' geneList <- whichGeneList("73")
#' r_data <- new.env()
#' MutData <- getMutationData.CGDS(cgds,"gbm_tcga_pub_all",
#'  "gbm_tcga_pub_mutations", geneList )
#' FreqMut <- getFreqMutData(list(ls1=MutData, ls2=MutData), "73")
#' input <- NULL
#' input[['StudiesIDCircos']] <- c("luad_tcga_pub","blca_tcga_pub")
#'
#' ListProfData <- getListProfData(panel= "Circomics","73")
#' }
#' @export
getListProfData <- function(panel, geneListLabel){

  GeneList <- whichGeneList(geneListLabel)
  cgds <-  CGDS("http://www.cbioportal.org/")
  dat <- getProfileData.CGDS(cgds,GeneList, "gbm_tcga_pub_mrna","gbm_tcga_pub_all")

  if(all(dim(dat)==c(0,1))== TRUE){
    ## avoide error when GeneList is empty
    ## Error..No.cancer.study..cancer_study_id...or.genetic.profile..genetic_profile_id..or.case.list.or..case_list..case.set..case_set_id..provid
    #dat <- as.list(as.data.frame("Gene List is empty. copy and paste genes from text file (Gene/line)
    #                    or use gene list from examples."))
    r_info[['ListProfData']] <- NULL
    #r_data[['ListMetData']] <- NULL
    #r_data[['ListMutData']] <- NULL

  }else{

    if (panel=="Circomics"){
      checked_Studies <- input$StudiesIDCircos
      Lchecked_Studies <- length(checked_Studies)
    }else if (panel=="Networking"){
      checked_Studies <- input$StudiesIDReactome
      Lchecked_Studies <- length(checked_Studies)

    }
    ## get Cases for selected Studies
    CasesRefStudies <- unname(unlist(apply(
      as.data.frame(checked_Studies), 1,
      function(x) getCaseLists.CGDS(cgds,x)[1])))
    ## get Genetics Profiles for selected Studies
    GenProfsRefStudies <- unname(unlist(apply(
      as.data.frame(checked_Studies), 1,
      function(x) getGeneticProfiles.CGDS(cgds,x)[1])))


    LengthGenProfs <- 0
    LengthCases <- 0
    ListProfData <- NULL
    r_info$ListProfData <- NULL #reinit tree for circomics
    ListMetData <- NULL
    ListMutData <- NULL
    for (s in 1: Lchecked_Studies){
      #Si = myGlobalEnv$checked_StudyIndex[s]
      shiny::withProgress(message= paste(checked_Studies[s],":"), value = 1, {

        incProgress(0.1, detail=paste(round((s/Lchecked_Studies)*100, 0),"% of Profiles Data"))
        Sys.sleep(0.1)

        ### get Cases and Genetic Profiles  with cBioportal references
        GenProf_CNA<- paste(checked_Studies[s],"_gistic", sep="")
        Case_CNA   <- paste(checked_Studies[s],"_cna", sep="")

        GenProf_Exp<- paste(checked_Studies[s],"_rna_seq_v2_mrna", sep="")
        Case_Exp   <- paste(checked_Studies[s],"_rna_seq_v2_mrna", sep="")

        GenProf_Met_HM450<- paste(checked_Studies[s],"_methylation_hm450", sep="")
        Case_Met_HM450   <- paste(checked_Studies[s],"_methylation_hm450", sep="")

        GenProf_Met_HM27<- paste(checked_Studies[s],"_methylation_hm27", sep="")
        Case_Met_HM27   <- paste(checked_Studies[s],"_methylation_hm27", sep="")

        GenProf_RPPA<- paste(checked_Studies[s],"_RPPA_protein_level", sep="")
        Case_RPPA   <- paste(checked_Studies[s],"_rppa", sep="")

        GenProf_miRNA<- paste(checked_Studies[s],"_mirna", sep="")
        Case_miRNA   <- paste(checked_Studies[s],"_microrna", sep="")

        GenProf_Mut<- paste(checked_Studies[s],"_mutations", sep="")
        Case_Mut   <- paste(checked_Studies[s],"_sequenced", sep="")


        ## Subsettint of Gene List if bigger than 500
        if(length(GeneList)>500){
          MegaGeneList <- GeneList
          if(is.integer(length(MegaGeneList)/500)){
            G <- length(MegaGeneList)/500
          }else{
            G <- as.integer(length(MegaGeneList)/500) + 1
          }

          MegaProfData_CNA <- 0
          MegaProfData_Exp <- 0
          MegaProfData_Met_HM450 <- 0
          MegaProfData_Met_HM27 <- 0
          MegaProfData_RPPA <- 0
          MegaProfData_miRNA <- 0
          MegaMutData <- 0
          SubMegaGeneList <- 0
          LastSubMegaGeneList <- 0
          for(g in 1: G){

            if (length(MegaGeneList) - LastSubMegaGeneList > 500){
              SubMegaGeneList <- MegaGeneList[((g-1)*(500)+1):((g)*500)]
              LastSubMegaGeneList <- LastSubMegaGeneList + length(SubMegaGeneList)
            } else{

              SubMegaGeneList <- MegaGeneList[LastSubMegaGeneList:length(MegaGeneList)]

            }
            ProfData_CNA<-grepRef(Case_CNA, CasesRefStudies, GenProf_CNA, GenProfsRefStudies, SubMegaGeneList, Mut=0)
            ProfData_Exp<-grepRef(Case_Exp, CasesRefStudies, GenProf_Exp, GenProfsRefStudies, SubMegaGeneList, Mut=0)
            ProfData_Met_HM450<-grepRef(Case_Met_HM450, CasesRefStudies, GenProf_Met_HM450, GenProfsRefStudies, SubMegaGeneList, Mut=0)
            ProfData_Met_HM27<-grepRef(Case_Met_HM27, CasesRefStudies, GenProf_Met_HM27, GenProfsRefStudies, SubMegaGeneList, Mut=0)
            ProfData_RPPA<-grepRef(Case_RPPA, CasesRefStudies, GenProf_RPPA, GenProfsRefStudies, SubMegaGeneList, Mut=0)
            ProfData_miRNA<-grepRef(Case_miRNA, CasesRefStudies, GenProf_miRNA, GenProfsRefStudies, SubMegaGeneList, Mut=0)
            MutData <- grepRef(Case_Mut,CasesRefStudies ,GenProf_Mut, GenProfsRefStudies,SubMegaGeneList, Mut=1)


            MegaProfData_CNA <- cbind(MegaProfData_CNA, ProfData_CNA)

            MegaProfData_Exp <- cbind(MegaProfData_Exp, ProfData_Exp)

            MegaProfData_Met_HM450 <- cbind(MegaProfData_Met_HM450, ProfData_Met_HM450)

            MegaProfData_Met_HM27 <- cbind(MegaProfData_Met_HM27, ProfData_Met_HM27)

            MegaProfData_RPPA <- cbind(MegaProfData_RPPA, ProfData_RPPA)

            MegaProfData_miRNA <- cbind(MegaProfData_miRNA, ProfData_miRNA)
            MegaMutData <- rbind(MegaMutData, MutData)

          }
          ProfData_CNA <- MegaProfData_CNA[,-1]
          ProfData_Exp <- MegaProfData_Exp[,-1]
          ProfData_Met_HM450 <- MegaProfData_Met_HM450[,-1]
          ProfData_Met_HM27 <- MegaProfData_Met_HM27[,-1]
          ProfData_RPPA <- MegaProfData_RPPA[,-1]
          ProfData_miRNA <- MegaProfData_miRNA[,-1]
          MutData <- MegaMutData[-1,]


        } else if (length(GeneList) > 0){


          ProfData_CNA<- grepRef(Case_CNA, CasesRefStudies, GenProf_CNA, GenProfsRefStudies, GeneList, Mut=0)
          ProfData_Exp<- grepRef(Case_Exp, CasesRefStudies, GenProf_Exp, GenProfsRefStudies, GeneList, Mut=0)
          ProfData_Met_HM450 <- grepRef(Case_Met_HM450, CasesRefStudies, GenProf_Met_HM450, GenProfsRefStudies, GeneList, Mut=0)
          ProfData_Met_HM27 <- grepRef(Case_Met_HM27, CasesRefStudies, GenProf_Met_HM27, GenProfsRefStudies, GeneList,Mut=0)
          ProfData_RPPA<- grepRef(Case_RPPA, CasesRefStudies, GenProf_RPPA, GenProfsRefStudies, GeneList,Mut=0)
          ProfData_miRNA<- grepRef(Case_miRNA, CasesRefStudies, GenProf_miRNA, GenProfsRefStudies, GeneList,Mut=0)
          MutData <- grepRef(Case_Mut,CasesRefStudies ,GenProf_Mut, GenProfsRefStudies,GeneList, Mut=1)

        }

        ListProfData$CNA[[checked_Studies[s]]] <- ProfData_CNA
        ListProfData$Expression[[checked_Studies[s]]] <- ProfData_Exp
        ListProfData$Met_HM450[[checked_Studies[s]]] <- ProfData_Met_HM450
        ListProfData$Met_HM27[[checked_Studies[s]]] <- ProfData_Met_HM27
        ListMetData$HM450[[checked_Studies[s]]] <- ProfData_Met_HM450
        ListMetData$HM27[[checked_Studies[s]]] <- ProfData_Met_HM27
        ListProfData$RPPA[[checked_Studies[s]]] <- ProfData_RPPA
        ListProfData$miRNA[[checked_Studies[s]]] <- ProfData_miRNA
        ListMutData[[checked_Studies[s]]] <- MutData

        #print(" End Getting Profiles Data... ")
        #close(progressBar_ProfilesData)
      })
    }
    r_info[['ListProfData']] <- ListProfData
    r_info[['ListMetData']] <- ListMetData
    r_info[['ListMutData']] <- ListMutData


    #r_info[['TreeMetData']] <- reStrDimension(r_info$ListMetData)


    ## cooffeWheel Mutation is initiated without userData
    #r_data[['Freq_DfMutData']] <- getFreqMutData(list = r_data$ListMutData,input$GeneListID)

    #   ListProfData_bkp <<- ListProfData
    #   ListMetData_bkp <<- ListMetData
    #   ListMutData_bkp <<- ListMutData
    #   ListCNAData_bkp <<- ListProfData$CNA

    #     print("Start Ordering ...")
    ## range matrices by the same order
    #     myGlobalEnv$ListProfData$CNA <- myGlobalEnv$ListProfData$CNA[order(names(myGlobalEnv$ListProfData$CNA))]
    #     myGlobalEnv$ListProfData$Expression <- myGlobalEnv$ListProfData$Expression[order(names(myGlobalEnv$ListProfData$Expression))]
    #     myGlobalEnv$ListMetData$HM450 <- myGlobalEnv$ListMetData$HM450[order(names(myGlobalEnv$ListMetData$HM450))]
    #     myGlobalEnv$ListMetData$HM27 <- myGlobalEnv$ListMetData$HM27[order(names(myGlobalEnv$ListMetData$HM27))]
    #     myGlobalEnv$ListProfData$RPPA <- myGlobalEnv$ListProfData$RPPA[order(names(myGlobalEnv$ListProfData$RPPA))]
    #     myGlobalEnv$ListMutData <- myGlobalEnv$ListMutData[order(names(myGlobalEnv$ListMutData))]

    #    print("End Ordering ...")
  }
}
