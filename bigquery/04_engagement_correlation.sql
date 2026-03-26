with base as (
  select
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    event_name,
    coalesce(
      (select value.int_value from unnest(event_params) where key = 'session_engaged'),
      0
    ) as session_engaged,
    coalesce(
      (select value.int_value from unnest(event_params) where key = 'engagement_time_msec'),
      0
    ) as engagement_time_msec
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
  where event_date between '20210101' and '20211231'
),
sessions as (
  select
    concat(user_pseudo_id, '-', cast(session_id as string)) as session_key,
    max(cast(session_engaged as int64)) as session_engaged_int,
    sum(engagement_time_msec) as total_engagement_time_msec,
    max(if(event_name = 'purchase', 1, 0)) as has_purchase
  from base
  where session_id is not null
  group by session_key
)
select
  corr(cast(session_engaged_int as float64), cast(has_purchase as float64)) as corr_engaged_vs_purchase,
  corr(cast(total_engagement_time_msec as float64), cast(has_purchase as float64)) as corr_time_vs_purchase
from sessions;
