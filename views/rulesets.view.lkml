view: rulesets {
  sql_table_name: `datalake.rulesets` ;;
  drill_fields: [ruleset_id]

  dimension: ruleset_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ruleset_id ;;
  }
  dimension: alerting_status {
    type: number
    sql: ${TABLE}.alerting_status ;;
  }
  dimension: live_status {
    type: number
    sql: ${TABLE}.live_status ;;
  }
  dimension: ruleset_family_name {
    type: string
    sql: ${TABLE}.ruleset_family_name ;;
  }
  dimension: ruleset_name {
    type: string
    sql: ${TABLE}.ruleset_name ;;
  }
  dimension: uppercase_rule_status {
    type: number
    sql: ${TABLE}.uppercase_rule_status ;;
  }
  measure: count {
    type: count
    drill_fields: [ruleset_id, ruleset_family_name, ruleset_name]
  }
}
