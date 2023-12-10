# DomainTools Block

## Why use the DomainTools Looker Block?
**(1) Threat Hunting** - Provides direct access to DomainTools’ industry-leading threat intelligence data, predictive risk scoring, and critical tactical attributes to gain situational awareness of malicious domains inside your organization. DomainTools enables Security Operations Centers (SOCs) and security analysts to take domain observables from their network and connect them with other active domains on the Internet.

**(2) Centralized Place for Analysis** -  Proactive monitoring of domain indicators and tags originating from DomainTools Iris Investigate and Iris Detect in a centralized location.

**(3) Empowering Enriched Domain Information** - The Domain Profiling dashboard offers a breakdown of enriched domains based on various criteria, including IPs, Registrars, and Server Types.

## Block Structure
For more information on the Block structure and customization, refer to [Looker Marketplace Documnetation](https://docs.looker.com/data-modeling/marketplace/customize-blocks#marketplace_blocks_that_use_refinements)

## Technical installation

### Pre-requisites

- This block works with Chronicle datasets in Google BigQuery.

### Installation steps

1. Install this block from the marketplace
2. Required installation parameters:
  - connection_name: Name of the database connection for the Chronicle dataset in BigQuery.
  - chronicle_url: Enter the base URL of your Chronicle tenant, for e.g. https://tenant.backstory.chronicle.security
  - google_cloud_function_name: Enter the name of the cloud function.
  - google_cloud_function_region : Enter the name of the cloud function region. List of regions can be found at https://cloud.google.com/functions/docs/locations
  - google_cloud_project_id : Enter the name of the cloud function project id. Find Project ID https://support.google.com/googleapi/answer/7014113?hl=en
3. Access the block from Browse - Applications & Tools - DomainTools Block or the LookML dashboards folder (/folders/lookml). You can customize these dashboards by copying them into one of your instances folders.

## What if I find an error? Suggestions for improvements?

Great! Blocks were designed for continuous improvement through the help of the entire DomainTools community and we'd love your input. To report an error or suggest recommendation regarding this block, please reach out to DomainTools support https://domaintools.com/support/.
