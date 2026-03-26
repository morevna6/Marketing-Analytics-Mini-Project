with weekly_best as (
    select
      f.ad_date::date as ad_date,
      coalesce(fc.campaign_name, 'facebook_unknown') as campaign_name,
      coalesce(f.value, 0)::numeric as value
      from public.facebook_ads_basic_daily f
      left join public.facebook_campaign fc on f.campaign_id = fc.campaign_id
      union all
      select
        g.ad_date::date as ad_date,
        coalesce(g.campaign_name, 'google_unknown') as campaign_name,
        coalesce(g.value, 0)::numeric as value
      from public.google_ads_basic_daily g
),
weekly as (
    select
      date_trunc('week', ad_date)::date as week_start,
      campaign_name,
      sum(value) as weekly_total_value
    from weekly_best
    group by 1, 2
)
select
  week_start,
  campaign_name,
  round(weekly_total_value, 2) as record_weekly_value
from weekly
order by weekly_total_value desc
limit 1;
