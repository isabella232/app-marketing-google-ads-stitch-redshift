# Google Ads

LookML files for a schema mapping on BigQuery for google Ads compatible with [Stitch's Google Ads ETL](https://www.stitchdata.com/docs/integrations/saas/google-adwords). This is designed to work with a ETL agnostic [Google Ads block](https://github.com/looker/app-marketing-google-ads).

## To use this block, you will need to:

### Include it in your [manifest.lkml](https://docs.looker.com/reference/manifest-reference):

Note: This requires the Project Import feature currently in /admin/labs to be enabled on your Looker instance.

#### Via local projects:

Fork this repo and create a new project named `app-marketing-google-ads-adapter`

manifest.lkml
```LookML
local_dependency: {
  project: "app-marketing-google-ads-adapter"
}


local_dependency: {
  project: "app-marketing-google-ads"
}```

Or remote dependency which don't require a local version.

manifest.lkml
```LookML

remote_dependency: app-marketing-google-ads-adapter {
  url: "git://github.com/looker/app-marketing-google-ads-stitch-redshift"
  ref: "b491583a3ac3a1125e535b5c5855bd56e9aa41a5"
}

remote_dependency: app-marketing-google-ads {
  url: "git://github.com/looker/app-marketing-google-ads"
  ref: "557fa52e9fee322d9a601ee5bf009cf929ef0261"
}```

Note that the `ref:` should point to the latest commit in each respective repo [google-ads-stitch-redshift](https://github.com/looker/app-marketing-google-ads-stitch-redshift/commits/master) and [google-ads](https://github.com/looker/app-marketing-google-ads/commits/master).

2. Create a `google_ads_config` view that is assumed by this project. This configuration requires a  file

For example:

google_ads_config.view.lkml
```LookML
view: google_ads_config {
  extension: required

  dimension: google_ads_schema {
    hidden: yes
    sql:stitch_google_ads;;
  }
}
```

3. Include the view files in your model.

For example:

marketing_analytics.model.lkml
```LookML
include: "/app-marketing-google-ads-adapter/*.view"
include: "/app-marketing-google-ads/*.view"
include: "/app-marketing-google-ads/*.dashboard"
```
