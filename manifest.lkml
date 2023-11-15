project_name: "domaintools"

# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }
constant: connection_name {
  value: "chronicle"
  export: override_required
}
constant: chronicle_url {
  value: "https://crestdatasys.backstory.chronicle.security"
  export: override_required
}
# this constancr value contains URL for Cloud function
constant: cloud_function_url {
  value: "https://console.cloud.google.com/logs/query"
  export: override_required
}
# resource.type = "cloud_function"
constant: resource_type_function {
  value: "cloud_function"
  export: override_required
}
# resource.labels.function_name = "domaintools-testing"
constant: resource_labels_function_name {
  value: "domaintools-testing"
  export: override_required
}
# resource.labels.region = "us-central1"
constant: resource_labels_function_region {
  value: "us-central1"
  export: override_required
}
# resource.type = "cloud_run_revision"
constant: resource_type_service {
  value: "cloud_run_revision"
  export: override_required
}
# resource.labels.service_name = "domaintools-testing"
constant: resource_labels_service_name {
  value: "domaintools-testing"
  export: override_required
}
# resource.labels.location = "us-central1"
constant: resource_labels_location {
  value: "us-central1"
  export: override_required
}
#
constant: sevarity {
  value: "DEFAULT"
  export: override_required
}
# cursorTimestamp value must be in Timstamp Format
constant: cursorTimestamp {
  value: "2023-11-10T07:29:58.241554799Z"
  export: override_required
}
# startTime value must be in Timstamp Format
constant: startTime {
  value: "2023-11-10T06:30:35.359Z"
  export: override_required
}
# endTime value must be in Timstamp Format
constant: endTime {
  value: "2023-11-10T07:30:35.359Z"
  export: override_required
}
# cloudshell value must be in true/false
constant: cloudshell {
  value: "false"
  export: override_required
}
# google_cloud_project_id value is GCP project id
constant: google_cloud_project_id {
  value: "dtgc-37955"
  export: override_required
}
