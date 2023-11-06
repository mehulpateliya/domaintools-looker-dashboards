- dashboard: domain_profiling
  title: Domain Profiling
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: FIQqKhyaWRWNP8UQ8V4Fza
  elements:
  - title: Domain Details
    name: Domain Details
    model: domaintools
    explore: events
    type: looker_grid
    fields: [events.principal__hostname_drill_down, events.domain_age, events.principal__domain__status,
      security_result_main_risk_score.events__security_result_risk_score, events.Event_DateTime_time,
      security_result_proximity.events__security_result_risk_score, thread_type.thread_type,
      all_threat_evidence.events__security_result__detection_fields_evidence, security_result_threat_profile_malware.events__security_result_risk_score,
      security_result_threat_profile_phishing.events__security_result_risk_score,
      security_result_threat_profile_spam.events__security_result_risk_score, events.principal__domain__registrar,
      events__about__labels_registrant_name.value, events.principal__domain__admin__office_address__country_or_region,
      events.iris_redirect]
    sorts: [events.principal__hostname_drill_down desc]
    limit: 1000
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
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
      events.principal__domain__status: Active Status
      events.principal__hostname: Domain
      events__security_result__category_details.events__security_result__category_details: Threat
        Type
      events__security_result__detection_fields_evidence.value: Threat Profile Evidence
      events.domain_age: Age
      security_result_main_risk_score.events__security_result_risk_score: Overall
        Risk Score
      events.Event_DateTime_time: Last Enriched DateTime
      security_result_proximity.events__security_result_risk_score: Proximity Score
      security_result__category_details.security_result__category_details: Threat
        Type
      all_threat_evidence.events__security_result__detection_fields_evidence: Threat
        Profile Evidence
      security_result_threat_profile_malware.events__security_result_risk_score: Threat
        Profile Malware
      security_result_threat_profile_phishing.events__security_result_risk_score: Threat
        Profile Phishing
      security_result_threat_profile_spam.events__security_result_risk_score: Threat
        Profile Spam
      events.principal__domain__registrar: Domain Registered From
      events__about__labels_registrant_name.value: Domain Registered Company
      events.principal__domain__admin__office_address__country_or_region: Domain Registered
        Region
      events.principal__hostname_drill_down: Domain
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
    hidden_pivots: {}
    listen:
      'Risk Score Greater Than ': security_result_main_risk_score.events__security_result_risk_score
      Threat Type: events__security_result__category_details.events__security_result__category_details
      Time Filter: events.Event_DateTime_minute
      Domain: events.principal__hostname
      Age Less Than (days): events.domain_age
      Last Enriched: events.Event_DateTime_time
    row: 0
    col: 0
    width: 24
    height: 12
  - title: No of Domains by _attribute
    name: No of Domains by _attribute
    model: domaintools
    explore: events
    type: looker_pie
    fields: [events.another_fields, events.domain_count]
    filters:
      events.another_fields: "-NULL"
    sorts: [events.another_fields]
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
    hidden_pivots: {}
    listen:
      Time Filter: events.Event_DateTime_minute
      Enrichment Filter Value: events.enrichment_filter_value
    row: 12
    col: 0
    width: 24
    height: 7
  filters:
  - name: Time Filter
    title: Time Filter
    type: field_filter
    default_value: ''
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
  - name: Domain
    title: Domain
    type: field_filter
    default_value: ''
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: domaintools
    explore: events
    listens_to_filters: []
    field: events.principal__hostname
  - name: Age Less Than (days)
    title: Age Less Than (days)
    type: field_filter
    default_value: "[0,999]"
    allow_multiple_values: true
    required: false
    ui_config:
      type: range_slider
      display: inline
      options:
        min: 0
        max: 999
    model: domaintools
    explore: events
    listens_to_filters: []
    field: events.domain_age
  - name: Last Enriched
    title: Last Enriched
    type: field_filter
    default_value: 7 day
    allow_multiple_values: false
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: domaintools
    explore: events
    listens_to_filters: []
    field: events.Event_DateTime_time
  - name: 'Risk Score Greater Than '
    title: 'Risk Score Greater Than '
    type: field_filter
    default_value: "[0,100]"
    allow_multiple_values: true
    required: false
    ui_config:
      type: range_slider
      display: inline
      options: []
    model: domaintools
    explore: events
    listens_to_filters: []
    field: security_result_main_risk_score.events__security_result_risk_score
  - name: Threat Type
    title: Threat Type
    type: field_filter
    default_value: ''
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: domaintools
    explore: events
    listens_to_filters: []
    field: events__security_result__detection_fields_threats_type.value
  - name: Enrichment Filter Value
    title: Enrichment Filter Value
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
