include: "campaign.view"

explore: adset_fb_adapter {
  view_name: adset
  from: adset_fb_adapter
  hidden: yes

  join: campaign {
    from: campaign_fb_adapter
    type: left_outer
    sql_on: ${adset.campaign_id} = ${campaign.id} ;;
    relationship: many_to_one
  }
}

view: adset_fb_adapter {
  derived_table: {
    sql:
    SELECT
      'NA' as id,
      'NA' as campaign_id,
      'NA' as name
    ;;
  }

  dimension: id {
    hidden: yes
    primary_key: yes
    type: string
  }

  dimension: campaign_id {
    hidden: yes
    type: string
  }

  dimension: name {
    hidden: yes
    type: string
  }
}
