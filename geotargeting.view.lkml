view: geotargeting {
  derived_table: {
    sql:
        SELECT
          CAST('NA' as TEXT) as Canonical_Name,
          CAST('NA' as TEXT) as Country_Code,
          CAST('NA' as TEXT) as Criteria_ID,
          CAST('NA' as TEXT) as Name,
          CAST('NA' as TEXT) as Parent_ID,
          CAST('NA' as TEXT) as Status,
          CAST('NA' as TEXT) as Target_Type
      ;;
  }

  dimension: canonical_name {
    type: string
    sql: ${TABLE}.Canonical_Name ;;
  }

  dimension: country_code {
    map_layer_name: countries
    type: string
    sql: ${TABLE}.Country_Code ;;
  }

  dimension: criteria_id {
    type: number
    sql: ${TABLE}.Criteria_ID ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.Name ;;
  }

  dimension: parent_id {
    type: number
    sql: ${TABLE}.Parent_ID ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.Status ;;
  }

  dimension: target_type {
    type: string
    sql: ${TABLE}.Target_Type ;;
  }

  dimension: is_us_state {
    type: yesno
    sql: ${country_code} = 'US' AND ${target_type} = 'State' ;;
  }

  dimension: state {
    map_layer_name: us_states
    type: string
    sql: IF(${is_us_state}, ${name}, NULL) ;;
  }

  dimension: is_us_postal_code {
    type: yesno
    sql: ${country_code} = 'US' AND ${target_type} = 'Postal Code' ;;
  }

  dimension: postal_code {
    map_layer_name: us_zipcode_tabulation_areas
    type: string
    sql: IF(${is_us_postal_code}, ${name}, NULL) ;;
  }
}
