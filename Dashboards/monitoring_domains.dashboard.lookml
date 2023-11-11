---
- dashboard: monitoring_dashboard
  title: Monitoring Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: rFkM2qn7FEjPBKiJy75L3P
  elements:
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
      rule_detections.max_version_timestamp: '1698041918'
    sorts: [rule_detections__detection__assets.hostname, rule_detections.detection_timestamp__seconds_time
        desc]
    limit: 500
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
    legend_position: right
    point_style: circle_outline
    show_value_labels: false
    label_density: 25
    x_axis_scale: ordinal
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      options:
        steps: 5
        reverse: false
    y_axes: [{label: '', orientation: left, series: [{axisId: rule_detections.count,
            id: 00op.ru - rule_detections.count, name: 00op.ru}, {axisId: rule_detections.count,
            id: crestdatasys.com - rule_detections.count, name: crestdatasys.com},
          {axisId: rule_detections.count, id: test.com - rule_detections.count, name: test.com}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_zoom: false
    y_axis_zoom: false
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hidden_series: []
    hide_legend: false
    series_colors: {}
    reference_lines: []
    trend_lines: []
    x_axis_label_rotation: 0
    swap_axes: false
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
    hidden_pivots: {}
    hidden_fields: []
    ordering: none
    show_null_labels: false
    listen:
      Detection Timestamp Seconds Time: rule_detections.detection_timestamp__seconds_time
    row: 0
    col: 0
    width: 16
    height: 6
  - title: Monitored Domain Detections
    name: Monitored Domain Detections
    model: domaintools
    explore: rule_detections
    type: single_value
    fields: [rule_detections.detection_count]
    filters:
      rule_detections.version_timestamp__seconds: '1698041918'
    sorts: [rule_detections.detection_count desc 0]
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
      Detection Timestamp Seconds Time: rule_detections.detection_timestamp__seconds_time
    row: 0
    col: 16
    width: 8
    height: 6
  filters:
  - name: Detection Timestamp Seconds Time
    title: Detection Timestamp Seconds Time
    type: field_filter
    default_value: 3 month
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: domaintools
    explore: rule_detections
    listens_to_filters: []
    field: rule_detections.detection_timestamp__seconds_time
