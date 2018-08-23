include: "adset.view"

explore: ad_fb_adapter {
  view_name: ad
  from: ad_fb_adapter
  hidden: yes

  join: adset {
    from: adset_fb_adapter
    type: left_outer
    sql_on: ${ad.adset_id} = ${adset.id} ;;
    relationship: many_to_one
  }

  join: campaign {
    from: campaign_fb_adapter
    type: left_outer
    sql_on: ${adset.campaign_id} = ${campaign.id} ;;
    relationship: many_to_one
  }
}

view: ad_fb_adapter {
  derived_table: {
    sql:
      SELECT
      'NA' as id,
      'NA' as adset_id,
      'NA' as name
    ;;
  }

  dimension: id {
    hidden: yes
    primary_key: yes
    type: string
  }

  dimension: adset_id {
    hidden: yes
    type: string
  }

  dimension: name {
    hidden: yes
    type: string
  }
}
