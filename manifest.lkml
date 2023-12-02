project_name: "domaintools"


constant: connection_name {
  value: "chronicle"
  export: override_required
}
constant: chronicle_url {
  value: "https://crestdatasys.backstory.chronicle.security"
  export: override_required
}
# resource.labels.function_name = "domaintools-testing"
constant: function_name {
  value: "domaintools-testing"
  export: override_required
}
# cloud_function_region = "us-central1"
constant: cloud_function_region {
  value: "us-central1"
  export: override_required
}
# google_cloud_project_id value is GCP project id
constant: google_cloud_project_id {
  value: "dtgc-37955"
  export: override_required
}

visualization: {
  id: "custom_pie_chart"
  label: "custom_pie_chart"
  file: "Custom/custom_pie_chart.js"
  dependencies: [
    "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/helpers.min.js"
  ]
}
