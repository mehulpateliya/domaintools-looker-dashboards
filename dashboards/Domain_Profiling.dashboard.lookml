- dashboard: domain_profiling_dashboard
  title: 'Domain Profiling Dashboard'
  layout: newspaper
  preferred_viewer: dashboards-next
  preferred_slug: uJ73hMCNbImIlZmmW5ZMVq
  elements:
  - title: Domain Profiles
    name: Domain Profiles
    model: domaintools
    explore: events
    type: looker_pie
    fields: [events.another_fields, events.domain_count]
    filters:
      events.another_fields: "-NULL"
      events.metadata__log_type: "DOMAINTOOLS_THREATINTEL"
    sorts: [events.domain_count desc]
    limit: 20
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
    hidden_pivots: {}
    listen:
      Domain Profile Filter Value: events.enrichment_filter_value
      Time Range: events.Event_DateTime_minute
    row: 12
    col: 0
    width: 24
    height: 7
  filters:
  - name: Time Range
    title: Time Range
    type: field_filter
    default_value: 15 minute
    allow_multiple_values: false
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: domaintools
    explore: events
    listens_to_filters: []
    field: events.Event_DateTime_minute
  - name: Domain Profile Filter Value
    title: Domain Profile Filter Value
    type: field_filter
    default_value: IP^_Country^_Code
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: domaintools
    explore: events
    listens_to_filters: []
    field: events.enrichment_filter_value
