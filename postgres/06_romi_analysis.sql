with top_records as (
    select
      ad_date::date as ad_date,
      spend::numeric as spend,
      value::numeric as value
    from public.facebook_ads_basic_daily
    union all
    select
      ad_date::date as ad_date,
      spend::numeric as spend,
      value::numeric as value
    from public.google_ads_basic_daily
),
daily_totals as (
    select
      ad_date,
      sum(spend) as total_spend,
      sum(value) as total_value
    from top_records
    group by ad_date
)
select
  ad_date,
  round((total_value - total_spend) / nullif(total_spend, 0), 4
  ) as total_romi
from daily_totals
where total_spend > 0
order by total_romi desc
limit 5;