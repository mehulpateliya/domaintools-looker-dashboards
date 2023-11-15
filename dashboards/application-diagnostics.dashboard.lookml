- dashboard: application_diagnostics
  title: Application Diagnostics
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: elZz8L0ijvZUaXlHS1XrHK
  elements:
  - title: No of Enriched domains based on timestamp
    name: No of Enriched domains based on timestamp
    model: domaintools
    explore: events
    type: looker_column
    fields: [events.event_timestamp_time, events.number_enriched_domain_count]
    filters:
      events.principal__hostname: "-NULL"
    sorts: [events.event_timestamp_time desc]
    limit: 5000
    column_limit: 5000
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
    y_axes: [{label: '', orientation: left, series: [{axisId: events.number_enriched_domain_count,
            id: events.number_enriched_domain_count, name: Domain Count}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    x_axis_label: Time
    x_axis_zoom: true
    y_axis_zoom: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '50000'
    trellis_rows: 2
    series_labels:
      events.number_enriched_domain_count: Domain Count
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Time Range: events.event_timestamp_time
    row: 13
    col: 0
    width: 24
    height: 8
  - title: Domain Enrichment Log
    name: Domain Enrichment Log
    model: domaintools
    explore: events
    type: looker_grid
    fields: [unique_hostname_ingested.events_principal_domain, unique_hostname_ingested.event_timestamp_time,
      unique_hostname_enriched.event_timestamp_time]
    filters:
      unique_hostname_ingested.events_principal_domain: "-NULL,-EMPTY"
    sorts: [unique_hostname_ingested.events_principal_domain]
    limit: 5000
    column_limit: 50
    filter_expression: "${unique_hostname_enriched.events_principal_domain}=${unique_hostname_ingested.events_principal_domain}"
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
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      unique_hostname_ingested.events_principal_domain: Domain
      unique_hostname_ingested.event_timestamp_time: First Ingested
      unique_hostname_enriched.event_timestamp_time: Most Recent Enrichment
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    listen:
      Time Range: unique_hostname_enriched.event_timestamp_time
    row: 3
    col: 0
    width: 24
    height: 10
  - title: View logs for cloud functions
    name: View logs for cloud functions
    model: domaintools
    explore: events
    type: single_value
    fields: [events.cloud_function_url]
    sorts: [events.cloud_function_url]
    limit: 500
    column_limit: 50
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
    row: 0
    col: 0
    width: 24
    height: 3
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
    field: events.event_timestamp_time
