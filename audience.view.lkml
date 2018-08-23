include: "criteria_base.view"

explore: audience_adapter {
  persist_with: adwords_etl_datagroup
  extends: [criteria_joins_base]
  from: audience_adapter
  view_label: "Audience"
  view_name: criteria
  hidden: yes
}

view: audience_adapter {
  extends: [criteria_base]

  derived_table: {
    sql:
        SELECT
          CURRENT_DATE as _DATA_DATE,
          CURRENT_DATE as _LATEST_DATE,
          CAST('NA' as TEXT) as ExternalCustomerId,
          CAST('NA' as TEXT) as AdGroupId,
          CAST('NA' as TEXT) as BaseAdGroupId,
          CAST('NA' as TEXT) as BaseCampaignId,
          0 as BidModifier,
          CAST('NA' as TEXT) as BidType,
          CAST('NA' as TEXT) as CampaignId,
          CAST('NA' as TEXT) as CpcBid,
          CAST('NA' as TEXT) as CpcBidSource,
          0 as CpmBid,
          CAST('NA' as TEXT) as CpmBidSource,
          CAST('NA' as TEXT) as Criteria,
          CAST('NA' as TEXT) as CriteriaDestinationUrl,
          CAST('NA' as TEXT) as CriterionId,
          CAST('NA' as TEXT) as FinalAppUrls,
          CAST('NA' as TEXT) as FinalMobileUrls,
          CAST('NA' as TEXT) as FinalUrls,
          false as IsNegative,
          false as IsRestrict,
          CAST('NA' as TEXT) as Status,
          CAST('NA' as TEXT) as TrackingUrlTemplate,
          CAST('NA' as TEXT) as UrlCustomParameters,
          CAST('NA' as TEXT) as UserListName
        ;;
  }

  dimension: criteria {
    label: "Audience"
  }

  dimension: user_list_name {
    type: string
    sql: ${TABLE}.UserListName ;;
  }
}
