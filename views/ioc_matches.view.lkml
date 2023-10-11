view: ioc_matches {
  sql_table_name: `datalake.ioc_matches` ;;

  dimension: asset__asset_ip_address {
    type: string
    sql: ${TABLE}.asset.asset_ip_address ;;
    group_label: "Asset"
    group_item_label: "Asset IP Address"
  }
  dimension: asset__hostname {
    type: string
    sql: ${TABLE}.asset.hostname ;;
    group_label: "Asset"
    group_item_label: "Hostname"
  }
  dimension: asset__is_any_namespace {
    type: yesno
    sql: ${TABLE}.asset.is_any_namespace ;;
    group_label: "Asset"
    group_item_label: "Is Any Namespace"
  }
  dimension: asset__is_namespace_ignored {
    type: yesno
    sql: ${TABLE}.asset.is_namespace_ignored ;;
    group_label: "Asset"
    group_item_label: "Is Namespace Ignored"
  }
  dimension: asset__mac {
    type: string
    sql: ${TABLE}.asset.mac ;;
    group_label: "Asset"
    group_item_label: "Mac"
  }
  dimension: asset__namespace {
    type: string
    sql: ${TABLE}.asset.namespace ;;
    group_label: "Asset"
    group_item_label: "Namespace"
  }
  dimension: asset__product_id {
    type: string
    sql: ${TABLE}.asset.product_id ;;
    group_label: "Asset"
    group_item_label: "Product ID"
  }
  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension: confidence_score {
    type: string
    sql: ${TABLE}.confidence_score ;;
  }
  dimension: day_bucket_seconds {
    type: number
    sql: ${TABLE}.day_bucket_seconds ;;
  }
  dimension: feed_log_type {
    type: string
    sql: ${TABLE}.feed_log_type ;;
  }
  dimension: feed_name {
    type: string
    sql: ${TABLE}.feed_name ;;
  }
  dimension: ioc_ingest_time__nanos {
    type: number
    sql: ${TABLE}.ioc_ingest_time.nanos ;;
    group_label: "Ioc Ingest Time"
    group_item_label: "Nanos"
  }
  dimension: ioc_ingest_time__seconds {
    type: number
    sql: ${TABLE}.ioc_ingest_time.seconds ;;
    group_label: "Ioc Ingest Time"
    group_item_label: "Seconds"
  }
  dimension: ioc_type {
    type: string
    sql: ${TABLE}.ioc_type ;;
  }
  dimension: ioc_value {
    type: string
    sql: ${TABLE}.ioc_value ;;
  }
  dimension: is_global {
    type: yesno
    sql: ${TABLE}.is_global ;;
  }
  dimension: location__city {
    type: string
    sql: ${TABLE}.location.city ;;
    group_label: "Location"
    group_item_label: "City"
  }
  dimension: location__country_or_region {
    type: string
    sql: ${TABLE}.location.country_or_region ;;
    group_label: "Location"
    group_item_label: "Country or Region"
  }
  dimension: location__desk_name {
    type: string
    sql: ${TABLE}.location.desk_name ;;
    group_label: "Location"
    group_item_label: "Desk Name"
  }
  dimension: location__floor_name {
    type: string
    sql: ${TABLE}.location.floor_name ;;
    group_label: "Location"
    group_item_label: "Floor Name"
  }
  dimension: location__name {
    type: string
    sql: ${TABLE}.location.name ;;
    group_label: "Location"
    group_item_label: "Name"
  }
  dimension: location__region_coordinates__latitude {
    type: number
    sql: ${TABLE}.location.region_coordinates.latitude ;;
    group_label: "Location Region Coordinates"
    group_item_label: "Latitude"
  }
  dimension: location__region_coordinates__longitude {
    type: number
    sql: ${TABLE}.location.region_coordinates.longitude ;;
    group_label: "Location Region Coordinates"
    group_item_label: "Longitude"
  }
  dimension: location__region_latitude {
    type: number
    sql: ${TABLE}.location.region_latitude ;;
    group_label: "Location"
    group_item_label: "Region Latitude"
  }
  dimension: location__region_longitude {
    type: number
    sql: ${TABLE}.location.region_longitude ;;
    group_label: "Location"
    group_item_label: "Region Longitude"
  }
  dimension: location__state {
    type: string
    sql: ${TABLE}.location.state ;;
    group_label: "Location"
    group_item_label: "State"
  }
  dimension: severity {
    type: string
    sql: ${TABLE}.severity ;;
  }
  measure: count {
    type: count
    drill_fields: [feed_name, location__name, asset__hostname, location__desk_name, location__floor_name]
  }
}
