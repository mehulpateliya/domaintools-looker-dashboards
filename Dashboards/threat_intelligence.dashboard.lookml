---
- dashboard: threat_intelligence_dashboard
  title: Threat Intelligence Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: HwIemg8AGwZtZQE3wDQQkW
  elements:
  - title: Young Domains
    name: Young Domains Single Value
    model: domaintools
    explore: events
    type: single_value
    fields: [alert_hostnames.unique_domains]
    limit: 1000
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Time Range: events.event_timestamp_time
      Young Domain Threshold: alert_hostnames.age_difference
    row:
    col:
    width:
    height:
  - title: Young Domains
    name: Young Domains
    model: domaintools
    explore: events
    type: looker_grid
    fields: [alert_hostnames.events_principal__hostname, events.domain_age, main_risk_score.events__security_result_risk_score,
      events.min_timestamp, events.max_timestamp, events.event_counts]
    filters:
      alert_hostnames.events_principal__hostname: "-NULL,-EMPTY"
    sorts: [events.max_timestamp desc 0]
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
      Young Domain Threshold: alert_hostnames.age_difference

    row: 13
    col: 0
    width: 23
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
    default_value: '7'
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
