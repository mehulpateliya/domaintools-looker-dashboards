view: cloud_function_link {
  derived_table: {
    sql: select "link" as cloud_function_url;;
  }
  dimension: cloud_function_url {
    label: "View logs of Cloud function"
    sql: ${TABLE}.cloud_function_url;;
    html: <a href="https://console.cloud.google.com/functions/details/@{google_cloud_function_region}/@{google_cloud_function_name}?project=@{google_cloud_project_id}&tab=logs" target="_blank">Link</a>;;
  }
}
