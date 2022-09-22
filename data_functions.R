# make the team data
# get teams

teams_df <- nottshcData::get_rio_team_spec(team_status = TRUE) |>
  nottshcData::tidy_rio_team_spec() |>
  dplyr::collect() |>
  dplyr::filter(stringr::str_detect(team_desc, "CAMHS - |LMHT|CMHT|EIP"))

#' Function to return data. This is an optional function which allows users
#' to load data into the application instead of defining it with sliders
#'
#' @param selected_team String. Team code (not name, which this function
#' outputs)
#'
#' @return dataframe. Containing, avg_week_ax, avg_week_ref, avg_week_treat,
#' ax_to_treat, ref_to_ax
#' @export
return_data <- function(selected_team){

  team_name_set <- nottshcData::get_rio_team_spec() %>%
    nottshcData::tidy_rio_team_spec() %>%
    dplyr::filter(team_code %in% selected_team) %>%
    dplyr::collect() %>%
    dplyr::pull(team_desc)

  contacts <- nottshcData::get_rio_contacts() %>%
    nottshcData::tidy_rio_contacts() %>%
    dplyr::filter(team_code %in% selected_team) %>%
    dplyr::filter(contacts_referral_datetime > "2021-04-01") %>%
    dplyr::filter(contact_status == "Seen") %>%
    dplyr::collect() %>%
    dplyr::filter(stringr::str_detect(appt_type_desc, "Face|Video|Clinic")) %>%
    dplyr::group_by(client_id, referral_id) %>%
    dplyr::count() %>%
    dplyr::ungroup() |>
    dplyr::mutate(client_id = as.character(client_id))

  referrals <- nottshcData::get_rio_referrals() %>%
    nottshcData::tidy_rio_referrals() %>%
    dplyr::filter(team_code %in% selected_team) %>%
    dplyr::filter(referrals_referral_datetime > "2021-04-01") %>%
    dplyr::select(client_id, referral_id, referrals_referral_datetime,
                  referrals_firstappt_datetime, referrals_discharge_datetime,
                  team_code, team_desc) %>%
    dplyr::collect() %>%
    dplyr::left_join(contacts)

  referrals <- referrals %>%
    dplyr::mutate(status =
                    dplyr::case_when(
                      n > 1 & !is.na(referrals_firstappt_datetime) ~ "Treatment",
                      is.na(referrals_firstappt_datetime) &
                        !is.na(referrals_discharge_datetime) ~ "Unassessed",
                      n = 1 & !is.na(referrals_firstappt_datetime) &
                        !is.na(referrals_discharge_datetime) ~ "Assessed & Discharged",
                      is.na(referrals_firstappt_datetime) &
                        is.na(referrals_discharge_datetime) ~ "Current Waiting List",
                      TRUE ~ "Status Pending")) |>
    dplyr::mutate(referral_date = as.Date(referrals_referral_datetime),
                  first_appt = as.Date(referrals_firstappt_datetime),
                  discharge_date = as.Date(referrals_discharge_datetime))

  counting <- referrals %>%
    dplyr::filter(status != "Current Waiting List") %>%
    dplyr::group_by(status) %>%
    dplyr::count() %>%
    dplyr::ungroup() %>%
    dplyr::mutate(percent = scales::percent(n/sum(n), accuracy = 0.1))

  avg_week_ref <- referrals %>%
    dplyr::mutate(week = lubridate::floor_date(referrals_referral_datetime,
                                               unit = "week")) %>%
    dplyr::group_by(week) %>%
    dplyr::count() %>%
    dplyr::ungroup() |>
    dplyr::pull(n)

  avg_week_ax <- referrals %>%
    dplyr::filter(!is.na(referrals_firstappt_datetime)) %>%
    dplyr::mutate(week = lubridate::floor_date(referrals_firstappt_datetime,
                                               unit = "week")) %>%
    dplyr::group_by(week) %>%
    dplyr::count() %>%
    dplyr::ungroup() |>
    dplyr::pull(n)

  avg_week_treat <- referrals %>%
    dplyr::filter(status == "Treatment") %>%
    dplyr::mutate(week = lubridate::floor_date(referrals_firstappt_datetime,
                                               unit = "week")) %>%
    dplyr::group_by(week) %>%
    dplyr::count() %>%
    dplyr::ungroup() |>
    dplyr::pull(n)

  current_waiting_list <- referrals %>%
    dplyr::filter(status == "Current Waiting List") %>%
    nrow()

  current_ax_outcome_unknown <- referrals %>%
    dplyr::filter(status == "Status Pending") %>%
    nrow()

  referrals_caseload <- nottshcData::get_rio_referrals() %>%
    nottshcData::tidy_rio_referrals() %>%
    dplyr::filter(team_code %in% selected_team) %>%
    dplyr::filter(is.na(referrals_discharge_datetime)) %>%
    dplyr::filter(!is.na(referrals_firstappt_datetime)) %>%
    dplyr::select(client_id, referral_id, referrals_referral_datetime,
                  referral_reason_desc, referrals_firstappt_datetime,
                  referrals_discharge_datetime, team_code, team_desc) %>%
    dplyr::collect()  %>%
    nrow()

  ref_to_ax <- counting %>%
    dplyr::mutate(status = dplyr::case_when(
      status == "Unassessed" ~ "Unassessed",
      TRUE ~ "Assessed")) %>%
    dplyr::group_by(status) %>%
    dplyr::summarise(n = sum(n)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(percent = n/sum(n)) %>%
    dplyr::filter(status == "Assessed") %>%
    dplyr::pull(percent)

  ax_to_treat <- counting %>%
    dplyr::filter(status == "Treatment" |
                    status == "Assessed & Discharged") %>%
    dplyr::mutate(percent = n/sum(n)) %>%
    dplyr::filter(status == "Treatment") %>%
    dplyr::pull(percent)

  # unite the data objects-
  # avg_week_ax, avg_week_ref, avg_week_treat, ax_to_treat, ref_to_ax

  data.frame(
    "avg_week_ax" = mean(avg_week_ax), # average weekly assessments
    "avg_week_ref" = mean(avg_week_ref), # average weekly referrals in
    "avg_week_treat" = mean(avg_week_treat), # average weekly treatments
    "ax_to_treat" = ax_to_treat, # proportion assessment to treatment
    "ref_to_ax" = ref_to_ax, # proportion referral to assessment
    "current_waiting_list" = current_waiting_list,
    "min_date_referrals" = min(referrals$referral_date),
    "max_date_referrals" = max(referrals$referral_date),
    "first_appt" = min(referrals$first_appt, na.rm = TRUE),
    "date_unit" = "week"
  )
}

#' Function to draw reactive interface to select teams
#'
#' @return Shiny input with team codes, named with team names
#' @export
team_ui_function <- function(){
  team_list <- teams_df |>
    dplyr::pull(team_code)

  names(team_list) <- teams_df |>
    dplyr::pull(team_desc)

  selectInput("select_team", "Team select",
              choices = team_list, selected = "AMH LMHT Broxtowe & Hucknall")
}
