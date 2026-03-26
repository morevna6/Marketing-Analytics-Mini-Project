with daily_spend as (
    select
      ad_date::date as ad_date,
      'Facebook' as platform,
      sum(spend)::numeric as daily_spend
    from public.facebook_ads_basic_daily
    group by ad_date
    having sum(spend) > 0
    union all
    select
      ad_date::date as ad_date,
      'Google' as platform,
      sum(spend)::numeric as daily_spend
    from public.google_ads_basic_daily
    group by ad_date
    having sum(spend) > 0
)
select
  platform,
  round(avg(daily_spend), 2) as avg_daily_spend,
  round(max(daily_spend), 2) as max_daily_spend,
  round(min(daily_spend), 2) as min_daily_spend
from daily_spend
GROUP BY platform
ORDER BY platform;