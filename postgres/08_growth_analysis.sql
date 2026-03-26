with best_record as (
    select
      f.ad_date::date as ad_date,
      coalesce(fc.campaign_name, 'facebook_unknown') as campaign_name,
      coalesce(f.reach, 0)::numeric as reach
    from public.facebook_ads_basic_daily f
    left join public.facebook_campaign fc on f.campaign_id = fc.campaign_id
    union all
    select
      g.ad_date::date as ad_date,
      coalesce(g.campaign_name, 'google_unknown') as campaign_name,
      coalesce(g.reach, 0)::numeric as reach
   from google_ads_basic_daily g
),
monthly as (
   select
     date_trunc('month', ad_date)::date as month_start,
     campaign_name,
     sum(reach) as monthly_reach
   from best_record
   group by 1, 2
),
difference as (
   select
     month_start,
     campaign_name,
     monthly_reach,
     monthly_reach - LAG(monthly_reach) over (
         partition by campaign_name
         order by month_start
     ) as reach_increase
   from monthly
)
select
  month_start,
  campaign_name,
  round(reach_increase, 0) as max_monthly_reach_increase
from difference
where reach_increase is not null
order by reach_increase desc
limit 1;
     