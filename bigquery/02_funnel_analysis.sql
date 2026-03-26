with base as (
  select
    date(timestamp_micros(event_timestamp)) as event_date,
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    event_name,
    traffic_source.source as source,
    traffic_source.medium as medium,
    traffic_source.name as campaign
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
  where event_date between '20210101' and '20211231'
    and event_name in (
      'session_start',
      'add_to_cart',
      'begin_checkout',
      'add_shipping_info',
      'add_payment_info',
      'purchase'
    )
),
sessions as (
  select distinct
    event_date,
    user_pseudo_id,
    session_id,
    source,
    medium,
    campaign
  from base
  where event_name = 'session_start'
    and session_id is not null
),
session_flags as (
  select
    s.event_date,
    s.source,
    s.medium,
    s.campaign,
    concat(s.user_pseudo_id, '-', cast(s.session_id as string)) as session_key,
    max(if(b.event_name = 'add_to_cart', 1, 0)) as has_cart,
    max(if(b.event_name in ('begin_checkout','add_shipping_info','add_payment_info'), 1, 0)) as has_checkout,
    max(if(b.event_name = 'purchase', 1, 0)) as has_purchase
  from sessions s
  left join base b
    on b.event_date = s.event_date
   and b.user_pseudo_id = s.user_pseudo_id
   and b.session_id = s.session_id
  group by 1,2,3,4,5
)
select
  event_date,
  source,
  medium,
  campaign,
  count(distinct session_key) as user_sessions_count,
  safe_divide(sum(has_cart), count(distinct session_key)) as visit_to_cart,
  safe_divide(sum(has_checkout), count(distinct session_key)) as visit_to_checkout,
  safe_divide(sum(has_purchase), count(distinct session_key)) as visit_to_purchase
from session_flags
group by 1,2,3,4
order by event_date, source, medium, campaign;































