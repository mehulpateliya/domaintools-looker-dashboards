view: udm_events_aggregates {
  sql_table_name: `datalake.udm_events_aggregates` ;;

  dimension: action {
    type: number
    sql: ${TABLE}.action ;;
  }
  dimension: event_count {
    type: number
    sql: ${TABLE}.event_count ;;
  }
  dimension_group: event_hour {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.event_hour ;;
  }
  dimension: principal_hostname {
    type: string
    sql: ${TABLE}.principal_hostname ;;
  }
  dimension: principal_ip {
    type: string
    sql: ${TABLE}.principal_ip ;;
  }
  dimension: principal_location__city {
    type: string
    sql: ${TABLE}.principal_location.city ;;
    group_label: "Principal Location"
    group_item_label: "City"
  }
  dimension: principal_location__country_or_region {
    type: string
    sql: ${TABLE}.principal_location.country_or_region ;;
    group_label: "Principal Location"
    group_item_label: "Country or Region"
  }
  dimension: principal_location__desk_name {
    type: string
    sql: ${TABLE}.principal_location.desk_name ;;
    group_label: "Principal Location"
    group_item_label: "Desk Name"
  }
  dimension: principal_location__floor_name {
    type: string
    sql: ${TABLE}.principal_location.floor_name ;;
    group_label: "Principal Location"
    group_item_label: "Floor Name"
  }
  dimension: principal_location__name {
    type: string
    sql: ${TABLE}.principal_location.name ;;
    group_label: "Principal Location"
    group_item_label: "Name"
  }
  dimension: principal_location__region_coordinates__latitude {
    type: number
    sql: ${TABLE}.principal_location.region_coordinates.latitude ;;
    group_label: "Principal Location Region Coordinates"
    group_item_label: "Latitude"
  }
  dimension: principal_location__region_coordinates__longitude {
    type: number
    sql: ${TABLE}.principal_location.region_coordinates.longitude ;;
    group_label: "Principal Location Region Coordinates"
    group_item_label: "Longitude"
  }
  dimension: principal_location__region_latitude {
    type: number
    sql: ${TABLE}.principal_location.region_latitude ;;
    group_label: "Principal Location"
    group_item_label: "Region Latitude"
  }
  dimension: principal_location__region_longitude {
    type: number
    sql: ${TABLE}.principal_location.region_longitude ;;
    group_label: "Principal Location"
    group_item_label: "Region Longitude"
  }
  dimension: principal_location__state {
    type: string
    sql: ${TABLE}.principal_location.state ;;
    group_label: "Principal Location"
    group_item_label: "State"
  }
  dimension: principal_userid {
    type: string
    sql: ${TABLE}.principal_userid ;;
  }
  dimension: target_application {
    type: string
    sql: ${TABLE}.target_application ;;
  }
  dimension: target_hostname {
    type: string
    sql: ${TABLE}.target_hostname ;;
  }
  dimension: target_ip {
    type: string
    sql: ${TABLE}.target_ip ;;
  }
  dimension: target_location__city {
    type: string
    sql: ${TABLE}.target_location.city ;;
    group_label: "Target Location"
    group_item_label: "City"
  }
  dimension: target_location__country_or_region {
    type: string
    sql: ${TABLE}.target_location.country_or_region ;;
    group_label: "Target Location"
    group_item_label: "Country or Region"
  }
  dimension: target_location__desk_name {
    type: string
    sql: ${TABLE}.target_location.desk_name ;;
    group_label: "Target Location"
    group_item_label: "Desk Name"
  }
  dimension: target_location__floor_name {
    type: string
    sql: ${TABLE}.target_location.floor_name ;;
    group_label: "Target Location"
    group_item_label: "Floor Name"
  }
  dimension: target_location__name {
    type: string
    sql: ${TABLE}.target_location.name ;;
    group_label: "Target Location"
    group_item_label: "Name"
  }
  dimension: target_location__region_coordinates__latitude {
    type: number
    sql: ${TABLE}.target_location.region_coordinates.latitude ;;
    group_label: "Target Location Region Coordinates"
    group_item_label: "Latitude"
  }
  dimension: target_location__region_coordinates__longitude {
    type: number
    sql: ${TABLE}.target_location.region_coordinates.longitude ;;
    group_label: "Target Location Region Coordinates"
    group_item_label: "Longitude"
  }
  dimension: target_location__region_latitude {
    type: number
    sql: ${TABLE}.target_location.region_latitude ;;
    group_label: "Target Location"
    group_item_label: "Region Latitude"
  }
  dimension: target_location__region_longitude {
    type: number
    sql: ${TABLE}.target_location.region_longitude ;;
    group_label: "Target Location"
    group_item_label: "Region Longitude"
  }
  dimension: target_location__state {
    type: string
    sql: ${TABLE}.target_location.state ;;
    group_label: "Target Location"
    group_item_label: "State"
  }
  dimension: target_userid {
    type: string
    sql: ${TABLE}.target_userid ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
	target_hostname,
	principal_hostname,
	target_location__name,
	principal_location__name,
	target_location__desk_name,
	target_location__floor_name,
	principal_location__desk_name,
	principal_location__floor_name
	]
  }

}
