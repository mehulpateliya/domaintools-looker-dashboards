project_name: "domaintools_dashboard"


constant: CONNECTION_NAME {
  export: override_required
  value: "chronicle"
}
# Enter chronicle url e.g. https://tenant.backstory.chronicle.security
constant: CHRONICLE_URL {
  export: override_required
  value: "https://crestdatasys.backstory.chronicle.security"
}
# specify cloud function name e.g. "domaintools-testing"
constant: GOOGLE_CLOUD_FUNCTION_NAME {
  export: override_required
  value: "domaintools-testing"
}
# specify cloud function region e.g. "us-central1"
# list of regions can be found at https://cloud.google.com/functions/docs/locations
constant: GOOGLE_CLOUD_FUNCTION_REGION {
  value: "us-central1"
  export: override_required
}
# specify google cloud project id region e.g. "domaintools-project"
# https://support.google.com/googleapi/answer/7014113?hl=en
constant: GOOGLE_CLOUD_PROJECT_ID {
  export: override_required
  value: "dtgc-37955"
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
