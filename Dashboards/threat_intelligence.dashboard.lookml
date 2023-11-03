---
- dashboard: threat_intelligence_dashboard
  title: Threat Intelligence Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: HwIemg8AGwZtZQE3wDQQkW
  elements:
  - title: Young Domains
    name: Young Domains
    model: domaintools
    explore: events
    type: looker_grid
    fields: [events.principal__hostname, events.domain_age, security_result_main_risk_score.events__security_result_risk_score,
      events.min_timestamp, events.max_timestamp, events.event_counts]
    filters:
      events.principal__hostname: "-NULL,-EMPTY"
      security_result_main_risk_score.events__security_result_risk_score: "-NULL"
    sorts: [events.max_timestamp desc]
    limit: 1000
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Time Range: events.event_timestamp_time
      Young Domain Threshold: events.domain_age
    row: 0
    col: 0
    width: 24
    height: 7
  - title: Young Domains
    name: Young Domains (2)
    model: domaintools
    explore: events
    type: looker_grid
    fields: [young_domain_table_panel.events_principal__hostname, young_domain_table_panel.events_domain_age,
      young_domain_table_panel.security_result_main_risk_score_events__security_result_risk_score,
      young_domain_table_panel.events_min_timestamp, young_domain_table_panel.events_max_timestamp,
      young_domain_table_panel.event_counts]
    sorts: [young_domain_table_panel.events_max_timestamp desc]
    limit: 1000
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_pivots: {}
    defaults_version: 1
    listen:
      Time Range: events.event_timestamp_time
      Young Domain Threshold: events.domain_age
    row: 7
    col: 0
    width: 8
    height: 6
  filters:
  - name: Time Range
    title: Time Range
    type: field_filter
    default_value: 15 minute
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: domaintools
    explore: events
    listens_to_filters: []
    field: events.event_timestamp_time
  - name: Young Domain Threshold
    title: Young Domain Threshold
    type: field_filter
    default_value: '11'
    allow_multiple_values: true
    required: false
    ui_config:
      type: slider
      display: inline
      options:
        min: 0
        max: 365
    model: domaintools
    explore: events
    listens_to_filters: []
    field: events.domain_age
