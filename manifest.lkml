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
