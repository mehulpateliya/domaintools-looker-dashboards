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
    row: 0
    col: 0
    width: 12
    height: 6
  - title: Young Domains
    name: Young Domains (2)
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
    row: 12
    col: 0
    width: 24
    height: 6
  - title: High Risk Domains
    name: High Risk Domains
    model: domaintools
    explore: events
    type: looker_column
    fields: [events.principal__hostname_young_domains, events.event_counts_risky_domain,
      main_risk_score.events__security_result_risk_score]
    filters:
      events.principal__hostname_young_domains: "-NULL,-EMPTY"
    sorts: [events.event_counts_risky_domain desc]
    limit: 10
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
    y_axes: [{label: '', orientation: left, series: [{axisId: events.event_counts,
            id: events.event_counts, name: "#  Of Observations During the Selected\
              \ Time Period"}], showLabels: true, showValues: true, valueFormat: '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_label: ''
    x_axis_zoom: true
    y_axis_zoom: true
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hide_legend: false
    series_colors:
      events.event_counts: "#EA4335"
      events.event_counts_risky_dmain: "#EA4335"
      events.event_counts_risky_domain: "#EA4335"
    series_labels:
      events.event_counts: "#  Of Observations During the Selected Time Period"
      events.event_counts_risky_dmain: "# of Observations During the Selected Time\
        \ Period"
      events.event_counts_risky_domain: "# of Observations During the Selected Time\
        \ Period"
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Time Range: events.event_timestamp_time
      High Risk Range: main_risk_score.events__security_result_risk_score
    row: 6
    col: 0
    width: 12
    height: 6
  - title: Medium Risk Domains
    name: Medium Risk Domains
    model: domaintools
    explore: events
    type: looker_column
    fields: [events.principal__hostname_young_domains, main_risk_score.events__security_result_risk_score,
      events.event_counts_risky_domain]
    filters:
      events.principal__hostname_young_domains: "-NULL,-EMPTY"
    sorts: [events.event_counts_risky_domain desc]
    limit: 10
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
    y_axes: [{label: '', orientation: left, series: [{axisId: events.event_counts,
            id: events.event_counts, name: "#  Of Observations During the Selected\
              \ Time Period"}], showLabels: true, showValues: true, valueFormat: '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_label: ''
    x_axis_zoom: true
    y_axis_zoom: true
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hide_legend: false
    series_colors:
      events.event_counts: "#EA4335"
      events.event_counts_risky_dmain: "#F9AB00"
      events.event_counts_risky_domain: "#F9AB00"
    series_labels:
      events.event_counts: "#  Of Observations During the Selected Time Period"
      events.event_counts_risky_dmain: "# of Observations During the Selected Time\
        \ Period"
      events.event_counts_risky_domain: "# of Observations During the Selected Time\
        \ Period"
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Time Range: events.event_timestamp_time
      Medium Risk Range: main_risk_score.events__security_result_risk_score
    row: 6
    col: 12
    width: 12
    height: 6
  - title: Suspicious Domains
    name: Suspicious Domains
    model: domaintools
    explore: events
    type: single_value
    fields: [events.event_counts_suspicious_domains]
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
      Suspicious Domain Range: main_risk_score.events__security_result_risk_score
    row: 0
    col: 12
    width: 12
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
  - name: High Risk Range
    title: High Risk Range
    type: field_filter
    default_value: "[90,100]"
    allow_multiple_values: true
    required: false
    ui_config:
      type: range_slider
      display: inline
      options: []
    model: domaintools
    explore: events
    listens_to_filters: []
    field: main_risk_score.events__security_result_risk_score
  - name: Medium Risk Range
    title: Medium Risk Range
    type: field_filter
    default_value: "[75,89]"
    allow_multiple_values: true
    required: false
    ui_config:
      type: range_slider
      display: inline
      options: []
    model: domaintools
    explore: events
    listens_to_filters: []
    field: main_risk_score.events__security_result_risk_score
  - name: Suspicious Domain Range
    title: Suspicious Domain Range
    type: field_filter
    default_value: "[75,100]"
    allow_multiple_values: true
    required: false
    ui_config:
      type: range_slider
      display: inline
      options: []
    model: domaintools
    explore: events
    listens_to_filters: []
    field: main_risk_score.events__security_result_risk_score
