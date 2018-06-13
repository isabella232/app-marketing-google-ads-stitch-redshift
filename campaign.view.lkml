include: "account.view"

explore: campaign_fb_adapter {
  view_name: campaign
  from: campaign_fb_adapter
  hidden: yes

  join: account {
    from: account_fb_adapter
    type: left_outer
    sql_on: ${campaign.account_id} = ${account.id} ;;
    relationship: many_to_one
  }
}

view: campaign_fb_adapter {
  derived_table: {
    sql:
    SELECT
      'NA' as id,
      'NA' as account_id,
      'NA' as name
    ;;
  }

  dimension: id {
    hidden: yes
    primary_key: yes
    type: string
  }

  dimension: account_id {
    hidden: yes
    type: string
  }

  dimension: name {
    hidden: yes
    type: string
  }
}
