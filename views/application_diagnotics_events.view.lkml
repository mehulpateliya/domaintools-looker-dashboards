view: application_diagnotics_events {
  derived_table: {
    sql:
    WITH enrichment_log_all_domains_fields AS (
    SELECT
          REGEXP_EXTRACT(events.principal.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)')  AS events_principal__hostname,
          REGEXP_EXTRACT(events.src.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_src__hostname,
          REGEXP_EXTRACT(events.target.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_target__hostname,
          REGEXP_EXTRACT(events.observer.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_observer__hostname,
          REGEXP_EXTRACT(events__intermediary.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__intermediary_hostname,
          REGEXP_EXTRACT(events.principal.asset.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_principal__asset__hostname,
          REGEXP_EXTRACT(events.src.asset.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_src__asset__hostname,
          REGEXP_EXTRACT(events.target.asset.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_target__asset__hostname,
          REGEXP_EXTRACT(events.network.dns_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_network__dns_domain,
          REGEXP_EXTRACT(events.principal.administrative_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_principal__administrative_domain,
          REGEXP_EXTRACT(events.target.administrative_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_target__administrative_domain,
          REGEXP_EXTRACT(events__about.administrative_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__about_administrative_domain,
          REGEXP_EXTRACT(events__about.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__about_hostname,
          REGEXP_EXTRACT(events.principal.asset.network_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_principal__asset__network_domain,
          REGEXP_EXTRACT(events.target.asset.network_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_target__asset__network_domain,
          REGEXP_EXTRACT(events__about.asset.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__about_asset__hostname,
          REGEXP_EXTRACT(events__about.asset.network_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__about_asset__network_domain,
          REGEXP_EXTRACT(events__about.domain.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__about_domain__name,
          REGEXP_EXTRACT(events__about.network.dns_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__about_network__dns_domain,
          REGEXP_EXTRACT(events__intermediary.administrative_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__intermediary_administrative_domain,
          REGEXP_EXTRACT(events__intermediary.domain.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__intermediary_domain__name,
          REGEXP_EXTRACT(events__intermediary.network.dns_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__intermediary_network__dns_domain,
          REGEXP_EXTRACT(events__intermediary.asset.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__intermediary_asset__hostname,
          REGEXP_EXTRACT(events__intermediary.asset.network_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__intermediary_asset__network_domain,
          REGEXP_EXTRACT(events.observer.administrative_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_observer__administrative_domain,
          REGEXP_EXTRACT(events.observer.domain.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_observer__domain__name,
          REGEXP_EXTRACT(events.observer.network.dns_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_observer__network__dns_domain,
          REGEXP_EXTRACT(events.observer.asset.hostname, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_observer__asset__hostname,
          REGEXP_EXTRACT(events.observer.asset.network_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_observer__asset__network_domain,
          REGEXP_EXTRACT(events.principal.domain.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_principal__domain__name,
          REGEXP_EXTRACT(events.principal.network.dns_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_principal__network__dns_domain,
          REGEXP_EXTRACT(events.src.administrative_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_src__administrative_domain,
          REGEXP_EXTRACT(events.src.domain.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_src__domain__name,
          REGEXP_EXTRACT(events.src.network.dns_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_src__network__dns_domain,
          REGEXP_EXTRACT(events.src.asset.network_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_src__asset__network_domain,
          REGEXP_EXTRACT(events.target.domain.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_target__domain__name,
          REGEXP_EXTRACT(events.target.network.dns_domain, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events_target__network__dns_domain,
          REGEXP_EXTRACT(events__about__network__dns__questions.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__about__network__dns__questions_name,
          REGEXP_EXTRACT(events__network__dns__questions.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__network__dns__questions_name,
          REGEXP_EXTRACT(events__intermediary__network__dns__questions.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__intermediary__network__dns__questions_name,
          REGEXP_EXTRACT(events__observer__network__dns__questions.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__observer__network__dns__questions_name,
          REGEXP_EXTRACT(events__principal__network__dns__questions.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__principal__network__dns__questions_name,
          REGEXP_EXTRACT(events__src__network__dns__questions.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__src__network__dns__questions_name,
          REGEXP_EXTRACT(events__target__network__dns__questions.name, r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)') AS events__target__network__dns__questions_name,
          events.metadata.event_timestamp.seconds as events_timestamp
    FROM `datalake.events`  AS events
    LEFT JOIN UNNEST(events.about) as events__about
    LEFT JOIN UNNEST(events.intermediary) as events__intermediary
    LEFT JOIN UNNEST(events.network.dns.questions) as events__network__dns__questions
    LEFT JOIN UNNEST(events.src.network.dns.questions) as events__src__network__dns__questions
    LEFT JOIN UNNEST(events__about.network.dns.questions) as events__about__network__dns__questions
    LEFT JOIN UNNEST(events.target.network.dns.questions) as events__target__network__dns__questions
    LEFT JOIN UNNEST(events.observer.network.dns.questions) as events__observer__network__dns__questions
    LEFT JOIN UNNEST(events.principal.network.dns.questions) as events__principal__network__dns__questions
    LEFT JOIN UNNEST(events__intermediary.network.dns.questions) as events__intermediary__network__dns__questions
    WHERE  {% condition time_range_filter %} TIMESTAMP_SECONDS(events.metadata.event_timestamp.seconds) {% endcondition %}
    and events.metadata.log_type != "DOMAINTOOLS_THREATINTEL" and
    COALESCE(
          events.principal.hostname,
          events.src.hostname,
          events.target.hostname,
          events.observer.hostname,
          events__intermediary.hostname,
          events.principal.asset.hostname,
          events.src.asset.hostname,
          events.target.asset.hostname,
          events.network.dns_domain,
          events.principal.administrative_domain,
          events.target.administrative_domain,
          events__about.administrative_domain,
          events__about.hostname,
          events.principal.asset.network_domain,
          events.target.asset.network_domain,
          events__about.asset.hostname,
          events__about.asset.network_domain,
          events__about.domain.name,
          events__about.network.dns_domain,
          events__intermediary.administrative_domain,
          events__intermediary.domain.name,
          events__intermediary.network.dns_domain,
          events__intermediary.asset.hostname,
          events__intermediary.asset.network_domain,
          events.observer.administrative_domain,
          events.observer.domain.name,
          events.observer.network.dns_domain,
          events.observer.asset.hostname,
          events.observer.asset.network_domain,
          events.principal.domain.name,
          events.principal.network.dns_domain,
          events.src.administrative_domain,
          events.src.domain.name,
          events.src.network.dns_domain,
          events.src.asset.network_domain,
          events.target.domain.name,
          events.target.network.dns_domain,
          events__about__network__dns__questions.name,
          events__network__dns__questions.name,
          events__intermediary__network__dns__questions.name,
          events__observer__network__dns__questions.name,
          events__principal__network__dns__questions.name,
          events__src__network__dns__questions.name,
          events__target__network__dns__questions.name
    ) is not null
    GROUP BY
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
        37,
        38,
        39,
        40,
        41,
        42,
        43,
        44,
        45 order by 45 desc
    ),
    enriched_domains as (
    select events.principal.hostname as enriched_hostname,
      events.metadata.event_timestamp.seconds as events_timestamp_seconds
      from datalake.events as events where events.metadata.log_type="DOMAINTOOLS_THREATINTEL" and events.principal.hostname is not null
      group by 1,2)
      select  domain_name as domain, min(events_timestamp) as first_observed , max(enriched_domains.events_timestamp_seconds) as recent_enriched from enrichment_log_all_domains_fields
      unpivot (domain_name for domain_name_column in ( events_principal__hostname,
      events_src__hostname,
      events_target__hostname,
      events_observer__hostname,
      events__intermediary_hostname,
      events_principal__asset__hostname,
      events_src__asset__hostname,
      events_target__asset__hostname,
      events_network__dns_domain,
      events_principal__administrative_domain,
      events_target__administrative_domain,
      events__about_administrative_domain,
      events__about_hostname,
      events_principal__asset__network_domain,
      events_target__asset__network_domain,
      events__about_asset__hostname,
      events__about_asset__network_domain,
      events__about_domain__name,
      events__about_network__dns_domain,
      events__intermediary_administrative_domain,
      events__intermediary_domain__name,
      events__intermediary_network__dns_domain,
      events__intermediary_asset__hostname,
      events__intermediary_asset__network_domain,
      events_observer__administrative_domain,
      events_observer__domain__name,
      events_observer__network__dns_domain,
      events_observer__asset__hostname,
      events_observer__asset__network_domain,
      events_principal__domain__name,
      events_principal__network__dns_domain,
      events_src__administrative_domain,
      events_src__domain__name,
      events_src__network__dns_domain,
      events_src__asset__network_domain,
      events_target__domain__name,
      events_target__network__dns_domain,
      events__about__network__dns__questions_name,
      events__network__dns__questions_name,
      events__intermediary__network__dns__questions_name,
      events__observer__network__dns__questions_name,
      events__principal__network__dns__questions_name,
      events__src__network__dns__questions_name,
      events__target__network__dns__questions_name )) as unpvt
      left join enriched_domains on enriched_domains.enriched_hostname = domain_name
      group by 1 order by 2 desc
      ;;
  }
  dimension: domain {
    sql: ${TABLE}.domain;;
    link: {
      label: "View in Chronicle"
      url: "@{chronicle_url}/rawLogScanResults?searchQuery={{ value }}&startTime={{ application_diagnotics_events.first_observed }}&endTime={{ CURRENT_TIMESTAMP_DATE }}&regex=1&selectedList=RawLogScanViewTimeline"
    }
  }
  dimension: CURRENT_TIMESTAMP_DATE {
    hidden: yes
    type: string
    sql: FORMAT_TIMESTAMP("%FT%TZ",current_timestamp );;
  }
  filter: time_range_filter {
    type: date_time
  }
  dimension: recent_enriched {
    label: "Most Recent Enriched (UTC)"
    sql: FORMAT_TIMESTAMP("%FT%TZ", TIMESTAMP_SECONDS(${TABLE}.recent_enriched));;
  }
  dimension: first_observed {
    label: "First Ingested (UTC)"
    sql: FORMAT_TIMESTAMP("%FT%TZ", TIMESTAMP_SECONDS(${TABLE}.first_observed));;
  }
  dimension: iris_redirect {
    label: "View in Iris"
    sql: "link" ;;
    link: {
      label: "View in DomainTools"
      url: "https://iris.domaintools.com/investigate/search/?q={{application_diagnotics_events.domain}}"
    }
    html: <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/svgs/solid/link.svg" width="17" height="17" alt="Chronicle" /> ;;
  }
}
