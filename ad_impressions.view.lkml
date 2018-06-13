include: "ad.view"
include: "ads_insights_actions_base.view"
include: "ads_insights_base.view"

explore: ad_impressions_base_fb_adapter {
  extension: required
  hidden: yes
  from: ad_impressions
  view_name: fact
  label: "Ad Impressions"
  view_label: "Ad Impressions"

  join: campaign {
    from: campaign_fb_adapter
    type: left_outer
    sql_on: ${fact.campaign_id} = ${campaign.id} ;;
    relationship: many_to_one
  }

  join: adset {
    from: adset_fb_adapter
    type: left_outer
    sql_on: ${fact.adset_id} = ${adset.id} ;;
    relationship: many_to_one
  }

  join: ad {
    from: ad_fb_adapter
    type: left_outer
    sql_on: ${fact.ad_id} = ${ad.id} ;;
    relationship: many_to_one
  }

  join: actions {
    from: actions_fb_adapter
    view_label: "Ad Impressions"
    type: left_outer
    sql_on: ${fact.ad_id} = ${actions.ad_id} AND
      ${fact._date} = ${actions._date} AND
      ${fact.breakdown} = ${actions.breakdown};;
    relationship: many_to_one
  }
}

view: date_base_fb_adapter {
  extension: required

  dimension: _date {
    hidden: yes
    type: date_raw
    sql: CAST(${TABLE}.date AS DATE) ;;
  }

  dimension: breakdown {
    hidden: yes
    sql: "1" ;;
  }
}

explore: ad_impressions_fb_adapter {
  extends: [ad_impressions_base_fb_adapter]
  hidden: yes
  from: ad_impressions_fb_adapter
  view_name: fact
}

view: ad_impressions_fb_adapter {
  extends: [date_base_fb_adapter, ads_insights_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        'NA' as account_id,
        'NA' as account_name,
        'NA' as ad_id,
        'NA' as ad_name,
        'NA' as adset_id,
        'NA' as adset_name,
        'NA' as campaign_id,
        'NA' as campaign_name,
        null as clicks,
        null as frequency,
        null as impressions,
        'NA' as objective,
        null as reach,
        null as spend,
        null as total_action_value,
        null as total_actions,
        CURRENT_DATE() as _date,
        CURRENT_DATE() as date
    ;;
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: concat(${_date}
      , "|", ${account_id}
      , "|", ${campaign_id}
      , "|", ${adset_id}
      , "|", ${ad_id}
      , "|", ${breakdown}
    ) ;;
  }
}

view: age_and_gender_base_fb_adapter {
  extension: required

  dimension: breakdown {
    hidden: yes
    sql: concat(${age}
      ,"|", ${gender_raw}
    ) ;;
  }
  dimension: age {
    type: string
  }

  dimension: gender_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: gender {
    type: string
    case: {
      when: {
        sql: ${gender_raw} = 'male' ;;
        label: "Male"
      }
      when: {
        sql: ${gender_raw} = 'female' ;;
        label: "Female"
      }
      when: {
        sql: ${gender_raw} = 'unknown';;
        label: "Unknown"
      }
      else: "Other"
    }
  }
}

explore: ad_impressions_age_and_gender_fb_adapter {
  extends: [ad_impressions_base_fb_adapter]
  hidden: yes
  from: ad_impressions_age_and_gender_fb_adapter
  view_name: fact

  join: actions {
    from: actions_age_and_gender_fb_adapter
    view_label: "Ad Impressions"
    type: left_outer
    sql_on: ${fact.ad_id} = ${actions.ad_id} AND
      ${fact._date} = ${actions._date} AND
      ${fact.breakdown} = ${actions.breakdown};;
    relationship: many_to_one
  }
}

view: ad_impressions_age_and_gender_fb_adapter {
  extends: [ad_impressions_fb_adapter, age_and_gender_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        'NA' as account_id,
        'NA' as account_name,
        'NA' as ad_id,
        'NA' as ad_name,
        'NA' as adset_id,
        'NA' as adset_name,
        'NA' as campaign_id,
        'NA' as campaign_name,
        null as clicks,
        null as frequency,
        null as impressions,
        'NA' as objective,
        null as reach,
        null as spend,
        null as total_action_value,
        null as total_actions,
        CURRENT_DATE() as _date,
        CURRENT_DATE() as date,

        'NA' as age,
        'NA' as gender
    ;;
  }
}

view: hour_base_fb_adapter {
  extension: required

  dimension: breakdown {
    hidden: yes
    sql: ${hourly_stats_aggregated_by_audience_time_zone} ;;
  }

  dimension: hourly_stats_aggregated_by_audience_time_zone {
    hidden: yes
    type: string
  }

  dimension: hour {
    type: string
    sql: SUBSTR(${hourly_stats_aggregated_by_audience_time_zone}, 0, 2) ;;
  }
}

explore: ad_impressions_hour_fb_adapter {
  extends: [ad_impressions_base_fb_adapter]
  hidden: yes
  from: ad_impressions_hour_fb_adapter
  view_name: fact

  join: actions {
    from: actions_hour_fb_adapter
    view_label: "Ad Impressions"
    type: left_outer
    sql_on: ${fact.ad_id} = ${actions.ad_id} AND
      ${fact._date} = ${actions._date} AND
      ${fact.breakdown} = ${actions.breakdown};;
    relationship: many_to_one
  }
}

view: ad_impressions_hour_fb_adapter {
  extends: [ad_impressions_fb_adapter, hour_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        'NA' as account_id,
        'NA' as account_name,
        'NA' as ad_id,
        'NA' as ad_name,
        'NA' as adset_id,
        'NA' as adset_name,
        'NA' as campaign_id,
        'NA' as campaign_name,
        null as clicks,
        null as frequency,
        null as impressions,
        'NA' as objective,
        null as reach,
        null as spend,
        null as total_action_value,
        null as total_actions,
        CURRENT_DATE() as _date,
        CURRENT_DATE() as date,

        'NA' as hourly_stats_aggregated_by_audience_time_zone
    ;;
  }
}

view: platform_and_device_base_fb_adapter {
  extension: required

  dimension: breakdown {
    hidden: yes
    sql: concat(${impression_device}
      ,"|", ${platform_position_raw}
      ,"|", ${publisher_platform_raw}
    ) ;;
  }

  dimension: impression_device {
    hidden: yes
    type: string
  }

  dimension: device_type {
    type: string
    case: {
      when: {
        sql: ${impression_device} = 'desktop' ;;
        label: "Desktop"
      }
      when: {
        sql: ${impression_device} = 'iphone' OR ${impression_device} = 'android_smartphone' ;;
        label: "Mobile"
      }
      when: {
        sql: ${impression_device} = 'ipad'  OR ${impression_device} = 'android_tablet' ;;
        label: "Tablet"
      }
      else: "Other"
    }
  }

  dimension: platform_position_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.platform_position ;;
  }

  dimension: platform_position {
    type: string
    case: {
      when: {
        sql: ${platform_position_raw} = 'feed' AND ${publisher_platform_raw} = 'instagram' ;;
        label: "Feed"
      }
      when: {
        sql: ${platform_position_raw} = 'feed' ;;
        label: "News Feed"
      }
      when: {
        sql: ${platform_position_raw} = 'an_classic' ;;
        label: "Classic"
      }
      when: {
        sql: ${platform_position_raw} = 'all_placements' ;;
        label: "All"
      }
      when: {
        sql: ${platform_position_raw} = 'instant_article' ;;
        label: "Instant Article"
      }
      when: {
        sql: ${platform_position_raw} = 'right_hand_column' ;;
        label: "Right Column"
      }
      when: {
        sql: ${platform_position_raw} = 'rewarded_video' ;;
        label: "Rewarded Video"
      }
      when: {
        sql: ${platform_position_raw} = 'suggested_video' ;;
        label: "Suggested Video"
      }
      when: {
        sql: ${platform_position_raw} = 'instream_video' ;;
        label: "InStream Video"
      }
      when: {
        sql: ${platform_position_raw} = 'messenger_inbox' ;;
        label: "Messenger Home"
      }
      else: "Other"
    }
  }

  dimension: publisher_platform_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.publisher_platform ;;
  }

  dimension: publisher_platform {
    type: string
    case: {
      when: {
        sql: ${publisher_platform_raw} = 'facebook' ;;
        label: "Facebook"
      }
      when: {
        sql: ${publisher_platform_raw} = 'instagram' ;;
        label: "Instagram"
      }
      when: {
        sql: ${publisher_platform_raw} = 'audience_network';;
        label: "Audience Network"
      }
      when: {
        sql: ${publisher_platform_raw} = 'messenger';;
        label: "Messenger"
      }
      else: "Other"
    }
  }
}

explore: ad_impressions_platform_and_device_fb_adapter {
  extends: [ad_impressions_base_fb_adapter]
  hidden: yes
  from: ad_impressions_platform_and_device_fb_adapter
  view_name: fact

  join: actions {
    from: actions_platform_and_device_fb_adapter
    view_label: "Ad Impressions"
    type: left_outer
    sql_on: ${fact.ad_id} = ${actions.ad_id} AND
      ${fact._date} = ${actions._date} AND
      ${fact.breakdown} = ${actions.breakdown};;
    relationship: many_to_one
  }
}

view: ad_impressions_platform_and_device_fb_adapter {
  extends: [ad_impressions_fb_adapter, platform_and_device_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        'NA' as account_id,
        'NA' as account_name,
        'NA' as ad_id,
        'NA' as ad_name,
        'NA' as adset_id,
        'NA' as adset_name,
        'NA' as campaign_id,
        'NA' as campaign_name,
        null as clicks,
        null as frequency,
        null as impressions,
        'NA' as objective,
        null as reach,
        null as spend,
        null as total_action_value,
        null as total_actions,
        CURRENT_DATE() as _date,
        CURRENT_DATE() as date,

        'NA' as impression_device,
        'NA' as platform_position,
        'NA' as publisher_platform
    ;;
  }
}

view: region_base_fb_adapter {
  extension: required

  dimension: breakdown {
    hidden: yes
    sql: concat(${country}
      ,"|", ${region}
    ) ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
  }

  dimension: region {
    type: string
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: if(${country} = "US", ${region}, null) ;;
  }
}

explore: ad_impressions_geo_fb_adapter {
  extends: [ad_impressions_base_fb_adapter]
  hidden: yes
  from: ad_impressions_geo_fb_adapter
  view_name: fact

  join: actions {
    from: actions_region_fb_adapter
    view_label: "Ad Impressions"
    type: left_outer
    sql_on: ${fact.ad_id} = ${actions.ad_id} AND
      ${fact._date} = ${actions._date} AND
      ${fact.breakdown} = ${actions.breakdown};;
    relationship: many_to_one
  }
}

view: ad_impressions_geo_fb_adapter {
  extends: [ad_impressions_fb_adapter, region_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        'NA' as account_id,
        'NA' as account_name,
        'NA' as ad_id,
        'NA' as ad_name,
        'NA' as adset_id,
        'NA' as adset_name,
        'NA' as campaign_id,
        'NA' as campaign_name,
        null as clicks,
        null as frequency,
        null as impressions,
        'NA' as objective,
        null as reach,
        null as spend,
        null as total_action_value,
        null as total_actions,
        CURRENT_DATE() as _date,
        CURRENT_DATE() as date,

        'NA' as country,
        'NA' as region
    ;;
  }
}

view: actions_fb_adapter {
  extends: [ads_insights_actions_base_fb_adapter, date_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE() as _date,

        null as _1_d_view,
        null as _28_d_click,
        'NA' as action_type,
        'NA' as ad_id,
        CURRENT_DATE() as date,
        null as index,
        null as value
    ;;
  }
}

view: actions_age_and_gender_fb_adapter {
  extends: [actions_fb_adapter, age_and_gender_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE() as _date,

        null as _1_d_view,
        null as _28_d_click,
        'NA' as action_type,
        'NA' as ad_id,
        CURRENT_DATE() as date,
        null as index,
        null as value,

        'NA' as age,
        'NA' as gender
    ;;
  }
}

view: actions_hour_fb_adapter {
  extends: [actions_fb_adapter, hour_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE() as _date,

        null as _1_d_view,
        null as _28_d_click,
        'NA' as action_type,
        'NA' as ad_id,
        CURRENT_DATE() as date,
        null as index,
        null as value,

        'NA' as hourly_stats_aggregated_by_audience_time_zone
    ;;
  }
}

view: actions_platform_and_device_fb_adapter {
  extends: [actions_fb_adapter, hour_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE() as _date,

        null as _1_d_view,
        null as _28_d_click,
        'NA' as action_type,
        'NA' as ad_id,
        CURRENT_DATE() as date,
        null as index,
        null as value,

        'NA' as impression_device,
        'NA' as platform_position,
        'NA' as publisher_platform,

        'NA' as hourly_stats_aggregated_by_audience_time_zone
    ;;
  }
}

view: actions_region_fb_adapter {
  extends: [actions_fb_adapter, hour_base_fb_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE() as _date,

        null as _1_d_view,
        null as _28_d_click,
        'NA' as action_type,
        'NA' as ad_id,
        CURRENT_DATE() as date,
        null as index,
        null as value,

        'NA' as impression_device,
        'NA' as platform_position,
        'NA' as publisher_platform,

        'NA' as hourly_stats_aggregated_by_audience_time_zone
    ;;
  }
}
