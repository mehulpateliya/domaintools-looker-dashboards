---
- dashboard: monitoring_dashboard
  title: Monitoring Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: rFkM2qn7FEjPBKiJy75L3P
  elements:
  - title: Monitored Domain Detections
    name: Monitored Domain Detections
    model: domaintools
    explore: rule_detections
    type: single_value
    fields: [rule_detections.detection_count]
    filters:
      rule_detections.rule_name: '"domain_from_monitoring_list"'
    sorts: [rule_detections.detection_count desc 0]
    limit: 500
    column_limit: 50
    filter_expression: "${rule_detections.version_timestamp__seconds} = ${latest_version_timestamp.version_timestamp__seconds}"
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    hidden_pivots: {}
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
    listen:
      Time Range: rule_detections.detection_timestamp__seconds_time
    row: 0
    col: 16
    width: 8
    height: 6
  - title: Monitored Domain Detections Over Time
    name: Monitored Domain Detections Over Time
    model: domaintools
    explore: rule_detections
    type: looker_area
    fields: [rule_detections__detection__assets.hostname, rule_detections.detection_timestamp__seconds_time,
      rule_detections.count]
    pivots: [rule_detections__detection__assets.hostname]
    filters:
      rule_detections.rule_name: '"domain_from_monitoring_list"'
    sorts: [rule_detections__detection__assets.hostname, rule_detections.detection_timestamp__seconds_time
        desc]
    limit: 500
    column_limit: 50
    filter_expression: "${rule_detections.version_timestamp__seconds} = ${latest_version_timestamp.version_timestamp__seconds}"
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
    legend_position: right
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: ordinal
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Detection Count, orientation: left, series: [{axisId: rule_detections.count,
            id: 00op.ru - rule_detections.count, name: 00op.ru}, {axisId: rule_detections.count,
            id: crestdatasys.com - rule_detections.count, name: crestdatasys.com},
          {axisId: rule_detections.count, id: test.com - rule_detections.count, name: test.com}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_label: Detection Timestamp
    x_axis_zoom: true
    y_axis_zoom: true
    hide_legend: false
    discontinuous_nulls: false
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Time Range: rule_detections.detection_timestamp__seconds_time
    row: 0
    col: 0
    width: 16
    height: 6
  - title: Monitored Tags over Time
    name: Monitored Tags over Time
    model: domaintools
    explore: rule_detections
    type: looker_area
    fields: [rule_detections__detection__assets.hostname, rule_detections.detection_timestamp__seconds_time,
      rule_detections.count]
    pivots: [rule_detections__detection__assets.hostname]
    filters:
      rule_detections.rule_name: '"domain_with_specified_tag"'
    sorts: [rule_detections__detection__assets.hostname, rule_detections.detection_timestamp__seconds_time
        desc]
    limit: 500
    column_limit: 50
    filter_expression: "${rule_detections.version_timestamp__seconds} = ${latest_version_timestamp_for_tags.version_timestamp__seconds}"
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
    legend_position: right
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: ordinal
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Detection Count, orientation: left, series: [{axisId: rule_detections.count,
            id: 00op.ru - rule_detections.count, name: 00op.ru}, {axisId: rule_detections.count,
            id: crestdatasys.com - rule_detections.count, name: crestdatasys.com},
          {axisId: rule_detections.count, id: test.com - rule_detections.count, name: test.com}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_label: Detection Timestamp
    x_axis_zoom: true
    y_axis_zoom: true
    hide_legend: false
    discontinuous_nulls: false
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Time Range: rule_detections.detection_timestamp__seconds_time
    row: 6
    col: 0
    width: 16
    height: 6
  - title: Tagged Domain Detections
    name: Tagged Domain Detections
    model: domaintools
    explore: rule_detections
    type: single_value
    fields: [rule_detections.detection_count]
    filters:
      rule_detections.rule_name: '"domain_with_specified_tag"'
    limit: 500
    column_limit: 50
    filter_expression: "${rule_detections.version_timestamp__seconds} = ${latest_version_timestamp_for_tags.version_timestamp__seconds}"
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: Detection Count, orientation: left, series: [{axisId: rule_detections.count,
            id: 00op.ru - rule_detections.count, name: 00op.ru}, {axisId: rule_detections.count,
            id: crestdatasys.com - rule_detections.count, name: crestdatasys.com},
          {axisId: rule_detections.count, id: test.com - rule_detections.count, name: test.com}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Detection Timestamp
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    x_axis_zoom: true
    y_axis_zoom: true
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    hide_legend: false
    legend_position: right
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: ordinal
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    discontinuous_nulls: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Time Range: rule_detections.detection_timestamp__seconds_time
    row: 6
    col: 16
    width: 8
    height: 6
  - title: Tag List Management
    name: Tag List Management
    model: domaintools
    explore: events
    type: single_value
    fields: [events.monitor_tag_link]
    filters:
      events.metadata__log_type: '"UDM"'
    sorts: [events.monitor_tag_link]
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
    listen: {}
    row: 12
    col: 4
    width: 7
    height: 6
  - title: Monitoring List Management
    name: Monitoring List Management
    model: domaintools
    explore: events
    type: single_value
    fields: [events.monitor_domain_link]
    filters:
      events.metadata__log_type: '"UDM"'
    sorts: [events.monitor_domain_link]
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
    listen: {}
    row: 12
    col: 15
    width: 7
    height: 6
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
    explore: rule_detections
    listens_to_filters: []
    field: rule_detections.detection_timestamp__seconds_time
