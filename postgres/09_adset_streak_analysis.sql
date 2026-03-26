with longest_streak as (
    select
      f.ad_date::date as ad_date,
      coalesce(fa.adset_name, 'facebook_unknown') as adset_name,
      coalesce(f.impressions, 0)::bigint as impressions
    from public.facebook_ads_basic_daily f
    left join public.facebook_adset fa on f.adset_id = fa.adset_id
    union all
    select
      g.ad_date::date as ad_date,
      coalesce(g.adset_name, 'google_unknown') as adset_name,
      coalesce(g.impressions, 0)::bigint as impressions
    from public.google_ads_basic_daily g
),
active_days as (
   select distinct
     ad_date,
     adset_name
   from longest_streak
   where impressions > 0
),
islands as (
    select
      adset_name,
      ad_date,
      (ad_date - (row_number() over (partition by adset_name order by ad_date))::int) as key
    from active_days
),
streaks as (
    select
      adset_name,
      min(ad_date) as streak_start,
      max(ad_date) as streak_end,
      (max(ad_date) - min(ad_date) +1) as streak_days
    from islands
    group by adset_name, key
)
select
  adset_name,
  streak_start,
  streak_end,
  streak_days
from streaks
order by streak_days desc, streak_end desc
limit 1;