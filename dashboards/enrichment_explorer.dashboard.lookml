- dashboard: enrichment_explorer_dashboard
  title: Enrichment Explorer Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: mr7I6ux5zIZWfRF6URsV4J
  elements:
  - title: Enrichment Explorer
    name: Enrichment Explorer
    model: domaintools
    explore: events
    type: looker_grid
    fields: [events.principal__hostname_drill_down, events.domain_age, events.principal__domain__status,
      security_result_main_risk_score.events__security_result_risk_score, events.Event_DateTime_time,
      security_result_proximity.events__security_result_risk_score, thread_type.thread_type,
      all_threat_evidence.events__security_result__detection_fields_evidence, security_result_threat_profile_malware.events__security_result_risk_score,
      security_result_threat_profile_phishing.events__security_result_risk_score,
      security_result_threat_profile_spam.events__security_result_risk_score, events.principal__domain__registrar,
      events__about_registrant_name.events__about__labels__registrant_name__value, events.principal__domain__admin__office_address__country_or_region,
      events.iris_redirect]
    filters:
      events.metadata__log_type: '"DOMAINTOOLS_THREATINTEL"'
    sorts: [events.Event_DateTime_time desc]
    limit: 1000
    column_limit: 50
    filter_expression: "${events.metadata__event_timestamp__seconds}=${unique_hostname_enriched_with_latest_time.events_event_timestamp_time}"
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
      all_threat_evidence.events__security_result__detection_fields_evidence: Threat
        Evidence
      events.domain_age: Age (in days)
      security_result_main_risk_score.events__security_result_risk_score: Overall
        Risk Score
      events.Event_DateTime_time: 'Last Enriched DateTime (UTC)'
      security_result_proximity.events__security_result_risk_score: Proximity Score
      security_result_threat_profile_malware.events__security_result_risk_score: Threat
        Profile Malware
      security_result_threat_profile_phishing.events__security_result_risk_score: Threat
        Profile Phishing
      security_result_threat_profile_spam.events__security_result_risk_score: Threat
        Profile Spam
      events.principal__domain__registrar: Domain Registered From
      events__about_registrant_name.events__about__labels__registrant_name__value: Domain Registered Company
      events.principal__domain__admin__office_address__country_or_region: Domain Registered
        Region
      events.principal__hostname_drill_down: Domain
      thread_type.thread_type: Threat Type
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
    pinned_columns:
      "$$$_row_numbers_$$$": left
      events.principal__hostname_drill_down: left
    column_order: ["$$$_row_numbers_$$$", events.principal__hostname_drill_down, events.domain_age,
      events.principal__domain__status, security_result_main_risk_score.events__security_result_risk_score,
      events.Event_DateTime_time, security_result_proximity.events__security_result_risk_score,
      thread_type.thread_type, all_threat_evidence.events__security_result__detection_fields_evidence,
      security_result_threat_profile_malware.events__security_result_risk_score, security_result_threat_profile_phishing.events__security_result_risk_score,
      security_result_threat_profile_spam.events__security_result_risk_score, events.principal__domain__registrar,
      events__about_registrant_name.events__about__labels__registrant_name__value,
      events.principal__domain__admin__office_address__country_or_region, events.iris_redirect]
    listen:
      Domain: events.principal__hostname_for_filter
      Age: events.domain_age
      Last Enriched: events.Event_DateTime_time
      Threat Type: thread_type.thread_type
      Risk Score: security_result_main_risk_score.events__security_result_risk_score
    row: 0
    col: 0
    width: 24
    height: 12
  filters:
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
    listens_to_filters: ['Last Enriched', 'Age', 'Risk Score', 'Threat Type']
    field: events.principal__hostname_for_filter
  - name: Age
    title: Age
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
  - name: Risk Score
    title: Risk Score
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
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: inline
    model: domaintools
    explore: events
    listens_to_filters: ['Last Enriched', 'Age', 'Risk Score']
    field: events.Threat_type_filter
