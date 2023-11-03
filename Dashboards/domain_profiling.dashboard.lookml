---
- dashboard: domain_profiling_dashboard
  title: Domain Profiling Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: oIXMaOKr786aFPMiHeUmvF
  elements:
  - title: 'No of Domains by '
    name: 'No of Domains by '
    model: test_domain_tool
    explore: events
    type: looker_pie
    fields: [events.another_fields, count_of_principal_hostname]
    filters: {}
    sorts: [count_of_principal_hostname desc 0]
    limit: 50
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
    defaults_version: 1
    title_hidden: true
    listen:
      Metadata Log Type: events.metadata__log_type
      Enrichment Filter Value: events.enrichment_filter_value
    row: 0
    col: 0
    width: 14
    height: 8
  filters:
  - name: Enrichment Filter Value
    title: Enrichment Filter Value
    type: field_filter
    default_value: admin^_contact^_name
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
    default_value: '"REDHAT_IM"'
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: overflow
    model: test_domain_tool
    explore: events
    listens_to_filters: []
    field: events.metadata__log_type
