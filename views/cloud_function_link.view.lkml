view: cloud_function_link {
  derived_table: {
    sql: select "link" as cloud_function_url;;
  }
  dimension: cloud_function_url {
    label: "View logs of Cloud function"
    sql: ${TABLE}.cloud_function_url;;
    html: <a href="https://console.cloud.google.com/functions/details/@{GOOGLE_CLOUD_FUNCTION_REGION}/@{GOOGLE_CLOUD_FUNCTION_NAME}?project=@{GOOGLE_CLOUD_PROJECT_ID}&tab=logs" target="_blank">Link</a>;;
  }
}
