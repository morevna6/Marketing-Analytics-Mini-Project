with base as (
  select
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    event_name,
    (select value.string_value from unnest(event_params) where key = 'page_location') as page_location
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201231`
  where event_date between '20200101' and '20201231'
    and event_name in ('session_start', 'purchase')
),
sessions as (
  select
    concat(user_pseudo_id, '-', cast(session_id as string)) as session_key,
    regexp_extract(page_location, r'https?://[^/]+(/[^?#]*)') as page_path
  from base
  where event_name = 'session_start'
    and session_id is not null
),
purchases as (
  select distinct
    concat(user_pseudo_id, '-', cast(session_id as string)) as session_key
  from base
  where event_name = 'purchase'
    and session_id is not null
)
select
  page_path,
  count(distinct s.session_key) as unique_user_sessions_count,
  count(distinct p.session_key) as purchases_count,
  safe_divide(
    count(distinct p.session_key),
    count(distinct s.session_key)
  ) as purchase_conversion_rate
from sessions s
left join purchases p
  on s.session_key = p.session_key
group by page_path
order by unique_user_sessions_count DESC;
