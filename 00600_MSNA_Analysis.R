library(dplyr)

### Loading files

df_hh <- read.csv("output/REACH_CAR_MSNA_Final_dataset_0309_clean_sampled.csv", stringsAsFactors = F)
names(df_hh) <- tolower(names(df_hh))
df_hh$mssc_2_source_rev_1 <- gsub("[^ -~]", "", df_hh$mssc_2_source_rev_1)
df_hh$mssc_2_source_rev_2 <- gsub("[^ -~]", "", df_hh$mssc_2_source_rev_2)
df_hh$mssc_2_source_rev_3 <- gsub("[^ -~]", "", df_hh$mssc_2_source_rev_3)
df_hh$aap_1_source_confiance <- gsub("[^ -~]", "", df_hh$aap_1_source_confiance)

survey_form <- read.csv("input/questionnaire_kobo_hh_combine_v4_FINAL_PourAnalyse_choices.csv", stringsAsFactors = F)%>%select(-starts_with("X"))
choices_form <- read.csv("input/questionnaire_kobo_hh_combine_v4_FINAL_PourAnalyse_survey.csv", stringsAsFactors = F)%>%select(-starts_with("X"))

## Adding a few variable
df_hh <- df_hh %>%
  mutate(protect_9_auMoinsUnVul = if_else(sum_ig_7_gr_vulnerable.aucune == 0, "non", "oui"),
         moust_pp = nb_mousticaire/ig_6_hh_membres_tot,
         sup_couchage_pp = nb_couchage/ig_6_hh_membres_tot,
         draps_pp = nb_draps/ig_6_hh_membres_tot,
         score_bidons = case_when(
           volume_total_recipients_pp >= 0 & volume_total_recipients_pp < 2 ~ 5,
           volume_total_recipients_pp >= 2 & volume_total_recipients_pp < 3 ~ 4.5,
           volume_total_recipients_pp >= 3 & volume_total_recipients_pp < 4 ~ 4,
           volume_total_recipients_pp >= 4 & volume_total_recipients_pp < 6 ~ 3.5,
           volume_total_recipients_pp >= 6 & volume_total_recipients_pp < 8 ~ 3,
           volume_total_recipients_pp >= 8 & volume_total_recipients_pp < 10 ~ 2.5,
           volume_total_recipients_pp >= 10 & volume_total_recipients_pp < 12 ~ 2,
           volume_total_recipients_pp >= 12 & volume_total_recipients_pp < 14 ~ 1.5,
           volume_total_recipients_pp >= 14 & volume_total_recipients_pp < 16 ~ 1,
           volume_total_recipients_pp >= 16 & volume_total_recipients_pp < 18 ~ 0.5,
           volume_total_recipients_pp >= 18 ~ 0
         ),
         score_seau = case_when(
           nb_seaux >= 0 & nb_seaux < 1 ~ 5,
           nb_seaux >= 1 & nb_seaux < 2 ~ 3.5,
           nb_seaux >= 2 & nb_seaux < 3 ~ 2.5,
           nb_seaux >= 3 & nb_seaux < 3 ~ 1,
           nb_seaux >= 3 ~ 0
         ),
         score_moust = case_when(
           moust_pp >= 0 & moust_pp < 0.067 ~ 5,
           moust_pp >= 0.067 & moust_pp < 0.13 ~ 4.5,
           moust_pp >= 0.13 & moust_pp < 0.2 ~ 4,
           moust_pp >= 0.2 & moust_pp < 0.3 ~ 3.5,
           moust_pp >= 0.3 & moust_pp < 0.4 ~ 3,
           moust_pp >= 0.4 & moust_pp < 0.47 ~ 2.5,
           moust_pp >= 0.47 & moust_pp < 0.53 ~ 2,
           moust_pp >= 0.53 & moust_pp < 0.6 ~ 1.5,
           moust_pp >= 0.6 & moust_pp < 0.7 ~ 1,
           moust_pp >= 0.7 & moust_pp < 0.88 ~ 0.5,
           moust_pp >=0.88  ~ 0
         ),
         score_casserole = case_when(
           nb_casseroles >= 0 & nb_casseroles <1 ~ 5,
           nb_casseroles >= 1 & nb_casseroles <2 ~ 4,
           nb_casseroles >= 2 & nb_casseroles <3 ~ 3.5,
           nb_casseroles >= 3 & nb_casseroles <4 ~ 2,
           nb_casseroles >= 4 & nb_casseroles <5 ~ 2
         ),
         score_couchage = case_when(
           sup_couchage_pp >= 0 & sup_couchage_pp < 0.067 ~ 5,
           sup_couchage_pp >= 0.067 & sup_couchage_pp < 0.13 ~ 4.5,
           sup_couchage_pp >= 0.13 & sup_couchage_pp < 0.2 ~ 4,
           sup_couchage_pp >= 0.2 & sup_couchage_pp < 0.3 ~ 3.5,
           sup_couchage_pp >= 0.3 & sup_couchage_pp < 0.4 ~ 3,
           sup_couchage_pp >= 0.4 & sup_couchage_pp < 0.47 ~ 2.5,
           sup_couchage_pp >= 0.47 & sup_couchage_pp < 0.53 ~ 2,
           sup_couchage_pp >= 0.53 & sup_couchage_pp < 0.6 ~ 1.5,
           sup_couchage_pp >= 0.6 & sup_couchage_pp < 0.7 ~ 1,
           sup_couchage_pp >= 0.7 & sup_couchage_pp < 0.8 ~ 0.5,
           sup_couchage_pp >= 0.8 ~ 0
         ),
         score_draps = case_when(
           draps_pp >= 0 & draps_pp < 0.067 ~ 5,
           draps_pp >= 0.067 & draps_pp < 0.13 ~ 4.5,
           draps_pp >= 0.13 & draps_pp < 0.2 ~ 4,
           draps_pp >= 0.2 & draps_pp < 0.3 ~ 3.5,
           draps_pp >= 0.3 & draps_pp < 0.4 ~ 3,
           draps_pp >= 0.4 & draps_pp < 0.47 ~ 2.5,
           draps_pp >= 0.47 & draps_pp < 0.53 ~ 2,
           draps_pp >= 0.53 & draps_pp < 0.6 ~ 1.5,
           draps_pp >= 0.6 & draps_pp < 0.7 ~ 1,
           draps_pp >= 0.7 & draps_pp < 0.8 ~ 0.5,
           draps_pp >= 0.8 ~ 0
         )
  )%>%
  mutate(
    score_nfi_tot = (score_bidons+ score_seau+ score_moust+ score_casserole+ score_couchage+ score_draps)/6,
    sphere_nfi = if_else(is.na(volume_total_recipients+ nb_casseroles+ nb_couchage+ nb_draps+ nb_mousticaire), "NA",
                         if_else(volume_total_recipients >= 30 & nb_casseroles >= 2 & nb_couchage >=3 & nb_draps >=3 & nb_mousticaire >= 3, "oui", "non")
    )
  )%>%
  mutate(nb_bache = if_else(bache == "oui",1,0),
         nb_kitcuisine = if_else(kit_cuisine == "complet", 1, 0),
         nb_habits = if_else(habits_femmes_enfants == "tous", 1, 0),
         nb_doc_legal = if_else(doc_legale == "tous", 1 ,0),
         nb_doc_prop = if_else(doc_propriete == "complet", 1 , 0),
         nb_semance = if_else(semence == "suff", 1, 0),
         nb_outils_aratoires = if_else(outils_aratoires == "suff",1 ,0),
         nb_cendres = if_else(cendres == "oui", 1, 0))%>%
  mutate_at(vars(savon_toilette_azur, savon_lessive, pot, gobelet, serviette_hyg, bidons_cap, nb_seaux, nb_mousticaire,
                 nb_casseroles, nb_couchage, nb_draps), funs(auMoinsUn = case_when(. > 0 ~ 1, TRUE ~ 0)))%>%
  mutate(
    sum_other_items = rowSums(.[c("savon_toilette_azur_auMoinsUn", "savon_lessive_auMoinsUn", "pot_auMoinsUn", "gobelet_auMoinsUn", "serviette_hyg_auMoinsUn", "bidons_cap_auMoinsUn", "nb_seaux_auMoinsUn", "nb_mousticaire_auMoinsUn","nb_casseroles_auMoinsUn", "nb_couchage_auMoinsUn", "nb_draps_auMoinsUn")], na.rm = TRUE))

df_hh <- df_hh %>%
  mutate(
    sum_item_list = rowSums(.[c("nb_bache", "nb_kitcuisine", "nb_habits", "nb_doc_legal", "nb_doc_prop", "nb_semance", "nb_outils_aratoires", "nb_cendres", "sum_other_items")]),
    taille_abri_pp = nfi_5_taille_abri/nfi_4_personnes_abri,
    lavage_mains_MomentsCles_Savon = if_else(sum(select(., starts_with("wash_18_lavage_main_moment."), - "wash_18_lavage_main_moment.autre", "wash_18_lavage_main_moment.nsp"), na.rm = TRUE)>=3 & sum(wash_19_lavage_main_moyens.savon, wash_19_lavage_main_moyens.cendre)>0,"oui","non" ),
    coping_1_1_aliments_moins_preferes_jours = case_when(coping_1_aliments_moins_preferes == "non" ~ 0, TRUE ~ as.double(coping_1_1_aliments_moins_preferes_jours)),
    coping_6_1_emprunter_nourriture_argent_jours = case_when(coping_6_emprunt_nourriture_argent == "non" ~ 0, TRUE ~ as.double(coping_6_1_emprunter_nourriture_argent_jours)),
    coping_3_1_diminution_quantite_jours = case_when(coping_3_diminution_quantite == "non" ~ 0, TRUE ~ as.double(coping_3_1_diminution_quantite_jours)),
    coping_2_1_restriction_nourriture_adultes_jours = case_when(coping_2_restriction_adultes == "non" ~ 0, TRUE ~ as.double(coping_2_1_restriction_nourriture_adultes_jours)),
    coping_8_1_reduction_repas_jours = case_when(coping_8_reduction_repas == "non" ~ 0, TRUE ~ as.double(coping_8_1_reduction_repas_jours)),
    coping_4_1_reduction_eau_domestique_jours = case_when(coping_4_reduction_eau_domestique == "non" ~ 0, TRUE ~ as.double(coping_4_1_reduction_eau_domestique_jours)),
    coping_5_1_utilisation_eau_non_sure_jours = case_when(coping_5_utilisation_eau_non_sure == "non" ~ 0, TRUE ~ as.double(coping_5_1_utilisation_eau_non_sure_jours)),
    rcsi = coping_1_1_aliments_moins_preferes_jours + coping_6_1_emprunter_nourriture_argent_jours*2 + coping_3_1_diminution_quantite_jours+
      coping_2_1_restriction_nourriture_adultes_jours*3+coping_8_1_reduction_repas_jours,
  )%>%mutate(
    hhs_noFood_score = if_else(secal_3_hhs_nb %in% "", 0, if_else(secal_3_hhs_nb %in% c("rarement", "parfois"), 1, 2)),
    hhs_sleepHungry_score = if_else(secal_4_hhs_nb %in% "", 0, if_else(secal_4_hhs_nb %in% c("rarement", "parfois"), 1, 2)),
    hhs_dayNightHunger_score = if_else(secal_5_hhs_nb %in% "", 0, if_else(secal_5_hhs_nb %in% c("rarement", "parfois"), 1, 2)),
    hhs_score = hhs_noFood_score + hhs_dayNightHunger_score + hhs_sleepHungry_score
  )%>%
  mutate(
    secal_11_lcs_actifs_non_prod_score = if_else(secal_11_lcs_actifs_non_prod %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_actifs_prod_score = if_else(secal_11_lcs_actifs_prod %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_reduire_dep_score = if_else(secal_11_lcs_reduire_dep %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_dep_epargne_score = if_else(secal_11_lcs_dep_epargne %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_emprunter_score = if_else(secal_11_lcs_emprunter %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_retirer_ecole_score = if_else(secal_11_lcs_retirer_ecole %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_vendre_maison_score = if_else(secal_11_lcs_vendre_maison %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_activites_risquees_score = if_else(secal_11_lcs_activites_risquees %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_mendier_score = if_else(secal_11_lcs_mendier %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_vendre_animaux_score = if_else(secal_11_lcs_vendre_animaux %in% c("non_deja_fait", "oui"), 1,0),
    secal_11_lcs_consommer_semences_score = if_else(secal_11_lcs_consommer_semences %in% c("non_deja_fait", "oui"), 1,0),
    
    lcs_urgence = if_else((secal_11_lcs_vendre_maison_score + secal_11_lcs_mendier_score + secal_11_lcs_activites_risquees_score) >= 1, 1, 0),
    lcs_crise = if_else( (secal_11_lcs_actifs_prod_score + secal_11_lcs_reduire_dep_score + secal_11_lcs_retirer_ecole_score + secal_11_lcs_consommer_semences_score) >=1,1,0),
    lcs_stress = if_else((secal_11_lcs_actifs_non_prod_score + secal_11_lcs_dep_epargne_score + secal_11_lcs_emprunter_score + secal_11_lcs_vendre_animaux_score) >=1,1,0),
    lcs_minimal = if_else((lcs_urgence + lcs_crise + lcs_stress)==0, 1,0),
    lcs_total = if_else(lcs_urgence ==1, "urgence", if_else(lcs_crise == 1, "crise", if_else( lcs_stress ==1, "stress", "minimal")))
  )%>%
  mutate(fcs_score2 = secal_1_cereales*2 + secal_1_legumineuse*3 + secal_1_lait*4 + secal_1_viande*4 + secal_1_legumes*1 + secal_1_fruits*1 + secal_1_huile*0.5 + secal_1_sucre*0.5,
         fcs_score_poor = if_else(fcs_score2 <= 21, 1, 0),
         fcs_score_borderline = if_else( fcs_score2 > 21 & fcs_score2 <= 35, 1,0),
         fcs_score_acceptable = if_else(fcs_score2 > 35, 1, 0),
         rcsi_high = if_else(rcsi >18, 1,0),
         rcsi_med = if_else(rcsi <=18 & rcsi >3, 1,0),
         rcsi_low = if_else(rcsi <= 3, 1,0),
         hhs_light = if_else(hhs_score <=1, 1,0),
         hhs_moderate = if_else(hhs_score >1 & hhs_score <=3, 1, 0),
         hhs_severe = if_else(hhs_score >=4 & hhs_score <=6, 1, 0)
  )%>%
  mutate(source_eau_boisson = if_else((wash_1_source_boisson.autre + wash_1_source_boisson.nsp) > 0, NA_character_,
                                      if_else((wash_1_source_boisson.eau_de_pluie + wash_1_source_boisson.cours_d_eau) >0, "surface",
                                              if_else(wash_1_source_boisson.puit_non_prot == 1, "non_amelioree", "amelioree"))),
         source_eaU_autresusages = if_else((wash_2_source_autre_usage.autre + wash_2_source_autre_usage.nsp) > 1, NA_character_,
                                           if_else((wash_2_source_autre_usage.eau_de_pluie + wash_2_source_autre_usage.cours_d_eau) >1, "surface",
                                                   if_else(wash_2_source_autre_usage.puit_non_prot == 1, "non_amelioree", "amelioree"))),
         source_eau_combinee = if_else(source_eaU_autresusages == "surface", "surface",
                                       if_else(source_eaU_autresusages == "non_amelioree", "non_amelioree", source_eau_boisson)),
         #aumoins_unenfant_diarrhee = if_else((sum_sante_4_0_4_malades_diarrhee_filles + sum_sante_4_0_4_malades_diarrhee_garcons)>0, 1, 0),
         enfants_ecole_6mois = rowSums(select(., starts_with("sum_educ_3_presence_18_19.")))/rowSums(select(., starts_with("sum_educ_2_inscrit."))),
         aumoins_unadulte_secu = if_else(protect_2_femmes == "oui" | protect_2_hommes == "oui", 1,0),
         aumoins_unenfant_secu = if_else(protect_3_filles == "oui" | protect_3_garcons == "oui", 1 ,0),
         aumoinsun_enfant_detressepsychosociale = if_else(protect_11_1 > 0,1,0)
  )




write.csv(df_hh, "output/MSNA_HH_Analysed_data.csv")
