view: job_metadata {
  sql_table_name: `datalake.job_metadata` ;;

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }
  dimension: data_type {
    type: string
    sql: ${TABLE}.data_type ;;
  }
  dimension: event_time_bucket {
    type: number
    sql: ${TABLE}.event_time_bucket ;;
  }
  dimension: export_path {
    type: string
    sql: ${TABLE}.export_path ;;
  }
  dimension: normalization_timestamp__nanos {
    type: number
    sql: ${TABLE}.normalization_timestamp.nanos ;;
    group_label: "Normalization Timestamp"
    group_item_label: "Nanos"
  }
  dimension: normalization_timestamp__seconds {
    type: number
    sql: ${TABLE}.normalization_timestamp.seconds ;;
    group_label: "Normalization Timestamp"
    group_item_label: "Seconds"
  }
  dimension: num_events {
    type: number
    sql: ${TABLE}.num_events ;;
  }
  dimension: partition_name {
    type: string
    sql: ${TABLE}.partition_name ;;
  }
  measure: count {
    type: count
    drill_fields: [partition_name]
  }
}
