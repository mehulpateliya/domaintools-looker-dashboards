---
- dashboard: demo_dashboard
  title: Demo dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: NvsST4OnyUUnpKNkHAZvX4
  elements:
  - title: Demo dashboard
    name: Demo dashboard
    model: test_domain_tool
    explore: events
    type: looker_column
    fields: [events.principal__hostname, events.event_counts, events.domain_risk_score]
    pivots: [events.domain_risk_score]
    filters:
      events.domain_risk_score: "-NULL"
    sorts: [events.domain_risk_score, events.principal__hostname desc]
    limit: 50
    column_limit: 15
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_pivots: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: []
    listen:
      Metadata Log Type: events.metadata__log_type
    row: 6
    col: 0
    width: 24
    height: 12
  - title: High Risk Domains
    name: High Risk Domains
    model: test_domain_tool
    explore: events
    type: looker_column
    fields: [events.event_counts, events.principal__hostname, events__security_result.risk_score]
    filters: {}
    sorts: [events.event_counts desc 0]
    limit: 30
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    series_colors:
      events.event_counts: "#EA4335"
    series_labels:
      events.event_counts: "#  Of Observations During the Selected Time Period"
    hidden_pivots: {}
    defaults_version: 1
    listen:
      Metadata Log Type: events.metadata__log_type
      High Risk Range: events.risk_score_threshold_for_filter
    row: 0
    col: 0
    width: 12
    height: 6
  - title: Medium Risk Domains
    name: Medium Risk Domains
    model: test_domain_tool
    explore: events
    type: looker_column
    fields: [events.principal__hostname, events.event_counts, events__security_result.risk_score]
    filters:
      events.domain_risk_score: medium
    sorts: [events.event_counts desc 0]
    limit: 30
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      events.event_counts: "#F9AB00"
    series_labels:
      events.event_counts: "#  Of Observations During the Selected Time Period"
    defaults_version: 1
    listen:
      Metadata Log Type: events.metadata__log_type
      Medium Risk Range: events.risk_score_threshold_for_filter
    row: 0
    col: 12
    width: 12
    height: 6
  - title: New Tile
    name: New Tile
    model: test_domain_tool
    explore: events
    type: looker_pie
    fields: [events.another_fields, count_of_principal_hostname]
    filters: {}
    sorts: [count_of_principal_hostname desc 0]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - measure: count_of_principal_hostname
      based_on: events.principal__hostname
      expression: ''
      label: Count of Principal Hostname
      type: count_distinct
      _kind_hint: measure
      _type_hint: number
    value_labels: legend
    label_type: labPer
    defaults_version: 1
    listen:
      Metadata Log Type: events.metadata__log_type
      Medium Risk Range: events.risk_score_threshold_for_filter
      High Risk Range: events.risk_score_threshold_for_filter
      Enrichment Filter Value: events.enrichment_filter_value
    row: 18
    col: 0
    width: 8
    height: 6
  filters:
  - name: High Risk Range
    title: High Risk Range
    type: field_filter
    default_value: "[90,100]"
    allow_multiple_values: true
    required: true
    ui_config:
      type: range_slider
      display: inline
      options:
        min: 0
        max: 100
    model: test_domain_tool
    explore: events
    listens_to_filters: []
    field: events.risk_score_threshold_for_filter
  - name: Medium Risk Range
    title: Medium Risk Range
    type: field_filter
    default_value: "[80,89]"
    allow_multiple_values: true
    required: false
    ui_config:
      type: range_slider
      display: inline
      options:
        min: 0
        max: 100
    model: test_domain_tool
    explore: events
    listens_to_filters: []
    field: events.risk_score_threshold_for_filter
  - name: Enrichment Filter Value
    title: Enrichment Filter Value
    type: field_filter
    default_value: registrar
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: test_domain_tool
    explore: events
    listens_to_filters: []
    field: events.enrichment_filter_value
  - name: Metadata Log Type
    title: Metadata Log Type
    type: field_filter
    default_value: '"REDHAT_SATELLITE"'
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: overflow
    model: test_domain_tool
    explore: events
    listens_to_filters: []
    field: events.metadata__log_type
